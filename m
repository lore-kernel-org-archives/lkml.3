Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3CSE4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 00:56:03 -0400
Received: from longford.logfs.org ([213.229.74.203]:58729 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3CSEz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 00:55:58 -0400
Date: Mon, 18 Mar 2013 23:31:12 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: [PATCH v4] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319033112.GA11307@logfs.org>
References: <20130318222853.GA9358@logfs.org>
 <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
 <20130318233413.GD9685@logfs.org>
 <20130319015354.GA21045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130319015354.GA21045@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 March 2013 18:53:54 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 18, 2013 at 07:34:13PM -0400, Jörn Engel wrote:
> > ---
> >  drivers/target/target_core_transport.c |   17 +++++++++++------
> >  include/linux/kref.h                   |   26 ++++++++++++++++++++++++++
> >  2 files changed, 37 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 04ec9cb..b98c158 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -2207,21 +2207,19 @@ static void target_release_cmd_kref(struct kref *kref)
> >  {
> >  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
> >  	struct se_session *se_sess = se_cmd->se_sess;
> > -	unsigned long flags;
> >  
> > -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> >  	if (list_empty(&se_cmd->se_cmd_list)) {
> > -		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> > +		spin_unlock(&se_sess->sess_cmd_lock);
> 
> Wait, who has this locked?  You took out the call to spin_lock_* above.

The spinlock needs to be taken atomically wrt. the final kref_put.  So
either the kref_put was not final and we don't end up calling
target_release_cmd_kref() or it was and the spinlock is already taken
when calling the release function.  You could call that the central
bit of the patch. ;)

> And why not _irqstore() anymore?

Because I thought the resulting code would be horrible.  But going
through the excercise, it does seem half as bad as I feared.  In fact,
I rather like it now.

Jörn

--
Happiness isn't having what you want, it's wanting what you have.
-- unknown


It is possible for one thread to to take se_sess->sess_cmd_lock in
core_tmr_abort_task() before taking a reference count on
se_cmd->cmd_kref, while another thread in target_put_sess_cmd() drops
se_cmd->cmd_kref before taking se_sess->sess_cmd_lock.

This introduces kref_put_spinlock_irqsave() and uses it in
target_put_sess_cmd() to close the race window.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/target/target_core_transport.c |    7 +++----
 include/linux/kref.h                   |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 04ec9cb..7e856b9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2203,13 +2203,11 @@ out:
 	return ret;
 }
 
-static void target_release_cmd_kref(struct kref *kref)
+static void target_release_cmd_kref(struct kref *kref, unsigned long flags)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
 	struct se_session *se_sess = se_cmd->se_sess;
-	unsigned long flags;
 
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (list_empty(&se_cmd->se_cmd_list)) {
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 		se_cmd->se_tfo->release_cmd(se_cmd);
@@ -2232,7 +2230,8 @@ static void target_release_cmd_kref(struct kref *kref)
  */
 int target_put_sess_cmd(struct se_session *se_sess, struct se_cmd *se_cmd)
 {
-	return kref_put(&se_cmd->cmd_kref, target_release_cmd_kref);
+	return kref_put_spinlock_irqsave(&se_cmd->cmd_kref, target_release_cmd_kref,
+			&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(target_put_sess_cmd);
 
diff --git a/include/linux/kref.h b/include/linux/kref.h
index 4972e6e..796c4f0 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 struct kref {
 	atomic_t refcount;
@@ -95,6 +96,37 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 	return kref_sub(kref, 1, release);
 }
 
+/**
+ * kref_put_spinlock_irqsave - decrement refcount for object.
+ * @kref: object.
+ * @release: pointer to the function that will clean up the object when the
+ *	     last reference to the object is released.
+ *	     This pointer is required, and it is not acceptable to pass kfree
+ *	     in as this function.
+ * @lock: lock to take in release case
+ *
+ * Behaves identical to kref_put with one exception.  If the reference count
+ * drops to zero, the lock will be taken atomically wrt dropping the reference
+ * count.  The release function then has to call spin_unlock_irqrestore().
+ */
+static inline int kref_put_spinlock_irqsave(struct kref *kref,
+		void (*release)(struct kref *kref, unsigned long flags),
+		spinlock_t *lock)
+{
+	unsigned long flags;
+
+	WARN_ON(release == NULL);
+	if (atomic_add_unless(&kref->refcount, -1, 1))
+		return 0;
+	spin_lock_irqsave(lock, flags);
+	if (atomic_dec_and_test(&kref->refcount)) {
+		release(kref, flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(lock, flags);
+	return 0;
+}
+
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *lock)
-- 
1.7.10.4

