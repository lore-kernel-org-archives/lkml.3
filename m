Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab3FMDwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:52:08 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:38330 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab3FMDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:52:06 -0400
Date: Wed, 12 Jun 2013 20:52:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu/for-3.11 1/2] percpu-refcount: add __must_check to
 percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
Message-ID: <20130613035201.GD9451@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small changes.

* Unlike most init functions, percpu_ref_init() allocates memory and
  may fail.  Let's mark it with __must_check in case the caller
  forgets.

* percpu_ref_kill_rcu() is unnecessarily using ACCESS_ONCE() to
  dereference @ref->pcpu_count, which can be misleading.  The pointer
  is guaranteed to be valid and visible and can't change underneath
  the function.  Drop ACCESS_ONCE().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu-refcount.h |    3 ++-
 lib/percpu-refcount.c           |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -67,7 +67,8 @@ struct percpu_ref {
 	struct rcu_head		rcu;
 };
 
-int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release);
+int __must_check percpu_ref_init(struct percpu_ref *ref,
+				 percpu_ref_func_t *release);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
 
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -57,12 +57,10 @@ int percpu_ref_init(struct percpu_ref *r
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
 	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
-	unsigned __percpu *pcpu_count;
+	unsigned __percpu *pcpu_count = ref->pcpu_count;
 	unsigned count = 0;
 	int cpu;
 
-	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
-
 	/* Mask out PCPU_REF_DEAD */
 	pcpu_count = (unsigned __percpu *)
 		(((unsigned long) pcpu_count) & ~PCPU_STATUS_MASK);
