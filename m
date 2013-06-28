Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3F1Mny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:43:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:46047 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3F1Mnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:43:53 -0400
Date: Fri, 28 Jun 2013 14:43:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.8.13-rt13
Message-ID: <20130628124351.GA19732@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.13-rt13 release.

changes since v3.8.13-rt12:
- added a patch from Paul Gortmaker to use raw_spin_lock instead of bit
  spinlocks list_bl.h

The delta patch against v3.8.13-rt12 is appended below and can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13-rt12-rt13.patch.xz

The RT patch against 3.8.13 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13-rt13.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.13-rt13.tar.xz

Sebastian

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 31f9d75..ddfd46a 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -2,6 +2,7 @@
 #define _LINUX_LIST_BL_H
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <linux/bit_spinlock.h>
 
 /*
@@ -32,13 +33,22 @@
 
 struct hlist_bl_head {
 	struct hlist_bl_node *first;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spinlock_t lock;
+#endif
 };
 
 struct hlist_bl_node {
 	struct hlist_bl_node *next, **pprev;
 };
-#define INIT_HLIST_BL_HEAD(ptr) \
-	((ptr)->first = NULL)
+
+static inline void INIT_HLIST_BL_HEAD(struct hlist_bl_head *h)
+{
+	h->first = NULL;
+#ifdef CONFIG_PREEMPT_RT_BASE
+	raw_spin_lock_init(&h->lock);
+#endif
+}
 
 static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
 {
@@ -117,12 +127,22 @@ static inline void hlist_bl_del_init(struct hlist_bl_node *n)
 
 static inline void hlist_bl_lock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	bit_spin_lock(0, (unsigned long *)b);
+#else
+	raw_spin_lock(&b->lock);
+	__set_bit(0, (unsigned long *)b);
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 {
+#ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
+#else
+	__clear_bit(0, (unsigned long *)b);
+	raw_spin_unlock(&b->lock);
+#endif
 }
 
 /**
diff --git a/localversion-rt b/localversion-rt
index 6e44e54..9f7d0bd 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt12
+-rt13
