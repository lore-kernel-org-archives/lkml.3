Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab3FLUpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FLUpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:45:39 -0400
Date: Wed, 12 Jun 2013 13:45:32 -0700
From: Tejun Heo <theo@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu/for-3.11 1/2] percpu-refcount: cosmetic updates
Message-ID: <20130612204532.GB15092@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 49d1e1a6561f1e4b190695f36d2594c7c04b8e76 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 12 Jun 2013 13:37:42 -0700

* s/percpu_ref_release/percpu_ref_func_t/ as it's customary to have _t
  postfix for types and the type is gonna be used for a different type
  of callback too.

* Add @ARG to function comments.

* Drop unnecessary and unaligned indentation from percpu_ref_init()
  function comment.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

These two patches implement percpu_ref_tryget() along with
percpu_ref_kill_and_confirm().  The first one is a prep.  The second
implements both.  This is on top of

 percpu/for-3.11 c1ae6e9b4d ("percpu-refcount: Don't use silly cmpxchg()")
+[1] "[PATCH percpu/for-3.11] percpu-refcount: consistently use plain (non-sched) RCU"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-percpu-ref-tryget 

Thanks.

[1] http://article.gmane.org/gmane.linux.kernel/1507256

 include/linux/percpu-refcount.h | 8 +++++---
 lib/percpu-refcount.c           | 7 ++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index abe1411..b61bd6f 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -51,7 +51,7 @@
 #include <linux/rcupdate.h>
 
 struct percpu_ref;
-typedef void (percpu_ref_release)(struct percpu_ref *);
+typedef void (percpu_ref_func_t)(struct percpu_ref *);
 
 struct percpu_ref {
 	atomic_t		count;
@@ -62,11 +62,11 @@ struct percpu_ref {
 	 * percpu_ref_kill_rcu())
 	 */
 	unsigned __percpu	*pcpu_count;
-	percpu_ref_release	*release;
+	percpu_ref_func_t	*release;
 	struct rcu_head		rcu;
 };
 
-int percpu_ref_init(struct percpu_ref *, percpu_ref_release *);
+int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release);
 void percpu_ref_kill(struct percpu_ref *ref);
 
 #define PCPU_STATUS_BITS	2
@@ -78,6 +78,7 @@ void percpu_ref_kill(struct percpu_ref *ref);
 
 /**
  * percpu_ref_get - increment a percpu refcount
+ * @ref: percpu_ref to get
  *
  * Analagous to atomic_inc().
   */
@@ -99,6 +100,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 
 /**
  * percpu_ref_put - decrement a percpu refcount
+ * @ref: percpu_ref to put
  *
  * Decrement the refcount, and if 0, call the release function (which was passed
  * to percpu_ref_init())
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 1a17399..9a78e55 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -33,8 +33,8 @@
 
 /**
  * percpu_ref_init - initialize a percpu refcount
- * @ref:	ref to initialize
- * @release:	function which will be called when refcount hits 0
+ * @ref: percpu_ref to initialize
+ * @release: function which will be called when refcount hits 0
  *
  * Initializes the refcount in single atomic counter mode with a refcount of 1;
  * analagous to atomic_set(ref, 1).
@@ -42,7 +42,7 @@
  * Note that @release must not sleep - it may potentially be called from RCU
  * callback context by percpu_ref_kill().
  */
-int percpu_ref_init(struct percpu_ref *ref, percpu_ref_release *release)
+int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
 {
 	atomic_set(&ref->count, 1 + PCPU_COUNT_BIAS);
 
@@ -98,6 +98,7 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 /**
  * percpu_ref_kill - safely drop initial ref
+ * @ref: percpu_ref to kill
  *
  * Must be used to drop the initial ref on a percpu refcount; must be called
  * precisely once before shutdown.
-- 
1.8.2.1

