Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaFIPmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:42:01 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54882 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaFIPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:41:58 -0400
Date: Mon, 9 Jun 2014 11:41:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [GIT PULL] percpu changes for v3.16-rc1
Message-ID: <20140609154155.GB22540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing too exciting.  percpu_ref is going through some interface
changes and getting new features with more changes in the pipeline but
given its young age and few users, it's very low impact.

Thanks.

The following changes since commit 0c36b390a546055b6815d4b93a2c9fed4d980ffb:

  percpu-refcount: fix usage of this_cpu_ops (2014-06-04 12:12:29 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.16

for you to fetch changes up to 315c5554c406fdad404a99dfefc931db0df80692:

  Merge branch 'for-3.15-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git into for-3.16 (2014-06-04 12:50:47 -0400)

----------------------------------------------------------------

Christoph Lameter (1):
      percpu: Replace __get_cpu_var with this_cpu_ptr

Tejun Heo (3):
      percpu-refcount: rename percpu_ref_tryget() to percpu_ref_tryget_live()
      percpu-refcount: implement percpu_ref_tryget()
      Merge branch 'for-3.15-fixes' of git://git.kernel.org/.../tj/percpu.git into for-3.16

 include/linux/cgroup.h          |  2 +-
 include/linux/percpu-refcount.h | 34 +++++++++++++++++++++++++++++++++-
 include/linux/percpu.h          |  2 +-
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c251585..549aed8 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -101,7 +101,7 @@ static inline bool css_tryget(struct cgroup_subsys_state *css)
 {
 	if (css->flags & CSS_ROOT)
 		return true;
-	return percpu_ref_tryget(&css->refcnt);
+	return percpu_ref_tryget_live(&css->refcnt);
 }
 
 /**
diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 0afb48f..5d8920e 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -121,6 +121,36 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  * percpu_ref_tryget - try to increment a percpu refcount
  * @ref: percpu_ref to try-get
  *
+ * Increment a percpu refcount unless its count already reached zero.
+ * Returns %true on success; %false on failure.
+ *
+ * The caller is responsible for ensuring that @ref stays accessible.
+ */
+static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count;
+	int ret = false;
+
+	rcu_read_lock_sched();
+
+	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
+
+	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
+		this_cpu_inc(*pcpu_count);
+		ret = true;
+	} else {
+		ret = atomic_inc_not_zero(&ref->count);
+	}
+
+	rcu_read_unlock_sched();
+
+	return ret;
+}
+
+/**
+ * percpu_ref_tryget_live - try to increment a live percpu refcount
+ * @ref: percpu_ref to try-get
+ *
  * Increment a percpu refcount unless it has already been killed.  Returns
  * %true on success; %false on failure.
  *
@@ -128,8 +158,10 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
  * will fail.  For such guarantee, percpu_ref_kill_and_confirm() should be
  * used.  After the confirm_kill callback is invoked, it's guaranteed that
  * no new reference will be given out by percpu_ref_tryget().
+ *
+ * The caller is responsible for ensuring that @ref stays accessible.
  */
-static inline bool percpu_ref_tryget(struct percpu_ref *ref)
+static inline bool percpu_ref_tryget_live(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count;
 	int ret = false;
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e7a0b95..539b3ca 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -29,7 +29,7 @@
  */
 #define get_cpu_var(var) (*({				\
 	preempt_disable();				\
-	&__get_cpu_var(var); }))
+	this_cpu_ptr(&var); }))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be
