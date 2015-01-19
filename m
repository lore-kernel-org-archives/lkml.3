Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbbASVta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:49:30 -0500
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:41287 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751621AbbASVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:49:29 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2741:2897:3138:3139:3140:3141:3142:3353:3865:3867:3868:3871:3872:3874:4250:4321:4605:5007:6119:6120:6261:7875:9040:9121:10004:10400:10848:11026:11657:11658:11914:12043:12262:12294:12296:12438:12517:12519:12555:12679:12740:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: color47_1854257f9e34b
X-Filterd-Recvd-Size: 2863
Date: Mon, 19 Jan 2015 16:49:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH][v3.2] Revert: x86, 64bit, mm: Mark data/bss/brk to nx
Message-ID: <20150119164926.168e8101@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Testing v3.2-rt I found that after merging the latest v3.2 stable tree,
hotplug stopped working. I tested the latest v3.2 stable, and it was
not working there either. I bisected it down to:

commit e105c8187b7101e8a8a54ac0218c9d9c9463c636
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Thu Jan 24 12:20:13 2013 -0800

    x86, 64bit, mm: Mark data/bss/brk to nx
    
    commit 72212675d1c96f5db8ec6fb35701879911193158 upstream.

Simply doing:

 # echo 0 > /sys/devices/system/cpu/cpu1/online
 # echo 1 > /sys/devices/system/cpu/cpu1/online

caused the system to reboot.

After reverting that commit, hotplug works again on the v3.2 stable
tree.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 266f71719e42..783eba48d00c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -778,7 +778,6 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
-	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -787,8 +786,8 @@ void mark_rodata_ro(void)
 	kernel_set_to_readonly = 1;
 
 	/*
-	 * The rodata/data/bss/brk section (but not the kernel text!)
-	 * should also be not-executable.
+	 * The rodata section (but not the kernel text!) should also be
+	 * not-executable.
 	 *
 	 * We align all_end to PMD_SIZE because the existing mapping
 	 * is a full PMD. If we would align _brk_end to PAGE_SIZE we
@@ -798,8 +797,7 @@ void mark_rodata_ro(void)
 	 * Any PMD which was setup after the one which covers _brk_end
 	 * has been zapped already via cleanup_highmem().
 	 */
-	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
-	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
