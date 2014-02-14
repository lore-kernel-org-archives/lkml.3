Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaBNUY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:24:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:44622 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBNUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:24:27 -0500
Date: Fri, 14 Feb 2014 21:24:26 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RT] arm/unwind: fail on unwind in irq disabled regions
Message-ID: <20140214202426.GA14019@linutronix.de>
References: <1390580663-28869-1-git-send-email-bigeasy@linutronix.de>
 <alpine.DEB.2.02.1402132355360.21991@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402132355360.21991@ionos.tec.linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner | 2014-02-13 23:57:45 [+0100]:

>If we really end up with unwinding then the few cycles to follow the
>stack are not that important anymore. We really want that output.

Here you go.

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 2af232d..bbafc67 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -87,7 +87,7 @@ extern const struct unwind_idx __start_unwind_idx[];
 static const struct unwind_idx *__origin_unwind_idx;
 extern const struct unwind_idx __stop_unwind_idx[];
 
-static DEFINE_SPINLOCK(unwind_lock);
+static DEFINE_RAW_SPINLOCK(unwind_lock);
 static LIST_HEAD(unwind_tables);
 
 /* Convert a prel31 symbol to an absolute address */
@@ -195,12 +195,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-		if (irqs_disabled())
-			goto out;
-#endif
-
-		spin_lock_irqsave(&unwind_lock, flags);
+		raw_spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
 			    addr < table->end_addr) {
@@ -212,11 +207,10 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&unwind_lock, flags);
+		raw_spin_unlock_irqrestore(&unwind_lock, flags);
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
-out:
 	return idx;
 }
 
@@ -351,9 +345,7 @@ int unwind_frame(struct stackframe *frame)
 
 	idx = unwind_find_idx(frame->pc);
 	if (!idx) {
-#ifndef CONFIG_PREEMPT_RT_FULL
 		pr_warning("unwind: Index not found %08lx\n", frame->pc);
-#endif
 		return -URC_FAILURE;
 	}
 
@@ -477,9 +469,9 @@ struct unwind_table *unwind_table_add(unsigned long start, unsigned long size,
 	tab->begin_addr = text_addr;
 	tab->end_addr = text_addr + text_size;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_add_tail(&tab->list, &unwind_tables);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	return tab;
 }
@@ -491,9 +483,9 @@ void unwind_table_del(struct unwind_table *tab)
 	if (!tab)
 		return;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_del(&tab->list);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	kfree(tab);
 }
-- 
1.9.0.rc3

>Thanks,
>
>	tglx

Sebastian
