Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3FMDwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:52:40 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49503 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3FMDwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:52:39 -0400
Date: Wed, 12 Jun 2013 20:52:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu/for-3.11 2/2] percpu-refcount: implement
 percpu_ref_cancel_init()
Message-ID: <20130613035235.GE9451@mtj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613035201.GD9451@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, percpu_ref_init() initializes and percpu_ref_kill*()
initiates destruction which completes asynchronously.  The
asynchronous destruction can be problematic in init failure path where
the caller wants to destroy half-constructed object - distinguishing
half-constructed objects from the usual release method can be painful
for complex objects.

This patch implements percpu_ref_cancel_init() which synchronously
destroys the percpu_ref without invoking release.  To avoid
unintentional misuses, the function requires the ref to have finished
percpu_ref_init() but never used and triggers WARN otherwise.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu-refcount.h |    1 +
 lib/percpu-refcount.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -69,6 +69,7 @@ struct percpu_ref {
 
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release);
+void percpu_ref_cancel_init(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
 
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -54,6 +54,33 @@ int percpu_ref_init(struct percpu_ref *r
 	return 0;
 }
 
+/**
+ * percpu_ref_cancel_init - cancel percpu_ref_init()
+ * @ref: percpu_ref to cancel init for
+ *
+ * Once a percpu_ref is initialized, its destruction is initiated by
+ * percpu_ref_kill*() and completes asynchronously, which can be painful to
+ * do when destroying a half-constructed object in init failure path.
+ *
+ * This function destroys @ref without invoking @ref->release and the
+ * memory area containing it can be freed immediately on return.  To
+ * prevent accidental misuse, it's required that @ref has finished
+ * percpu_ref_init(), whether successful or not, but never used.
+ */
+void percpu_ref_cancel_init(struct percpu_ref *ref)
+{
+	unsigned __percpu *pcpu_count = ref->pcpu_count;
+	int cpu;
+
+	WARN_ON_ONCE(atomic_read(&ref->count) != 1 + PCPU_COUNT_BIAS);
+
+	if (pcpu_count) {
+		for_each_possible_cpu(cpu)
+			WARN_ON_ONCE(*per_cpu_ptr(pcpu_count, cpu));
+		free_percpu(ref->pcpu_count);
+	}
+}
+
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
 	struct percpu_ref *ref = container_of(rcu, struct percpu_ref, rcu);
