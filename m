Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3IIN1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:27:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3IIN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:54 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=LDl5kCb-hiwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Hnuq-vIbuuYA:10 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=w8BJI1sPhz2j7JtBdEEA:9 a=XNN-oNMjSfgA:10 a=2e6ZYRoF4I4A:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124556.627732109@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:45:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH RT 05/16] list_bl.h: fix it for for !SMP && !DEBUG_SPINLOCK
References: <20130909124531.445392664@goodmis.org>
Content-Disposition: inline; filename=0005-list_bl.h-fix-it-for-for-SMP-DEBUG_SPINLOCK.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

The patch "list_bl.h: make list head locking RT safe" introduced
an unconditional

	__set_bit(0, (unsigned long *)b);

in void hlist_bl_lock(struct hlist_bl_head *b). This clobbers the value
of b->first. When the value of b->first is retrieved using
hlist_bl_first the clobbering is undone using

	(unsigned long)h->first & ~LIST_BL_LOCKMASK

and so depending on LIST_BL_LOCKMASK being one. But LIST_BL_LOCKMASK is
only one if at least on of CONFIG_SMP and CONFIG_DEBUG_SPINLOCK are
defined. Without these the value returned by hlist_bl_first has the
zeroth bit set which likely results in a crash.

So only do the clobbering in the cases where LIST_BL_LOCKMASK is one.
An alternative would be to always define LIST_BL_LOCKMASK to one with
CONFIG_PREEMPT_RT_BASE.

Cc: stable-rt@vger.kernel.org
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/list_bl.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index ddfd46a..becd7a6 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -131,8 +131,10 @@ static inline void hlist_bl_lock(struct hlist_bl_head *b)
 	bit_spin_lock(0, (unsigned long *)b);
 #else
 	raw_spin_lock(&b->lock);
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__set_bit(0, (unsigned long *)b);
 #endif
+#endif
 }
 
 static inline void hlist_bl_unlock(struct hlist_bl_head *b)
@@ -140,7 +142,9 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 #ifndef CONFIG_PREEMPT_RT_BASE
 	__bit_spin_unlock(0, (unsigned long *)b);
 #else
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	__clear_bit(0, (unsigned long *)b);
+#endif
 	raw_spin_unlock(&b->lock);
 #endif
 }
-- 
1.7.10.4


