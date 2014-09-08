Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaIHCMw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:12:52 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53433 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaIHCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:12:34 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] percpu-refcount: implement percpu_ref_set_killed()
Date: Mon,  8 Sep 2014 11:12:21 +0900
Message-Id: <1410142342-8185-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410142342-8185-1-git-send-email-tj@kernel.org>
References: <1410142342-8185-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent addition of percpu_ref_reinit(), percpu_ref now can be
used as a persistent switch which can be turned on and off repeatedly
where turning off maps to killing the ref and waiting for it to drain;
however, there currently isn't a way to initialize a percpu_ref in its
off (killed and drained) state, which can be inconvenient for certain
persistent switch use cases.

This patch adds percpu_ref_set_killed() which forces the percpu_ref
into its killed and drained state.  The caller is responsible for
ensuring that no one else is using the ref.  This can be used to force
the percpu_ref into its off state after initialization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h |  1 +
 lib/percpu-refcount.c           | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index ee83251..97a7d2a 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -69,6 +69,7 @@ struct percpu_ref {
 int __must_check percpu_ref_init(struct percpu_ref *ref,
 				 percpu_ref_func_t *release, gfp_t gfp);
 void percpu_ref_reinit(struct percpu_ref *ref);
+void percpu_ref_set_killed(struct percpu_ref *ref);
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 70d28c9..a6768f6 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -98,6 +98,20 @@ void percpu_ref_reinit(struct percpu_ref *ref)
 EXPORT_SYMBOL_GPL(percpu_ref_reinit);
 
 /**
+ * percpu_ref_set_killed - force a percpu refcount to the killed state
+ * @ref: percpu_ref to set killed for
+ *
+ * Set @ref's state to killed.  This function doesn't care about the
+ * current state or in-progress operations on @ref and the caller is
+ * responsible for ensuring that @ref isn't being used by anyone else.
+ */
+void percpu_ref_set_killed(struct percpu_ref *ref)
+{
+	ref->pcpu_count_ptr |= PCPU_REF_DEAD;
+	atomic_set(&ref->count, 0);
+}
+
+/**
  * percpu_ref_exit - undo percpu_ref_init()
  * @ref: percpu_ref to exit
  *
-- 
1.9.3

