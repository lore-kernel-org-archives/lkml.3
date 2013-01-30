Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3A3Bx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:53:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3A3Bx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:53:56 -0500
Date: Tue, 29 Jan 2013 17:53:45 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-d27807b9bfd6315a93a051e4e6d9961d6e4467d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-33-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-33-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit, mm: Mark data/bss/brk to nx
Git-Commit-ID: d27807b9bfd6315a93a051e4e6d9961d6e4467d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:53:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d27807b9bfd6315a93a051e4e6d9961d6e4467d3
Gitweb:     http://git.kernel.org/tip/d27807b9bfd6315a93a051e4e6d9961d6e4467d3
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:13 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:34:36 -0800

x86, 64bit, mm: Mark data/bss/brk to nx

HPA said, we should not have RW and +x set at the time.

for kernel layout:
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x021434f8]
[    0.000000] .rodata: [0x02200000-0x02a13fff]
[    0.000000]   .data: [0x02c00000-0x02dc763f]
[    0.000000]   .init: [0x02dc9000-0x0312cfff]
[    0.000000]    .bss: [0x0313b000-0x03dd6fff]
[    0.000000]    .brk: [0x03dd7000-0x03dfffff]

before the patch, we have
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82dc9000        1828K     RW             GLB x  pte
0xffffffff82dc9000-0xffffffff82e00000         220K     RW             GLB NX pte
0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
0xffffffff83000000-0xffffffff8313a000        1256K     RW             GLB NX pte
0xffffffff8313a000-0xffffffff83200000         792K     RW             GLB x  pte
0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB x  pmd
0xffffffff83e00000-0xffffffffa0000000         450M                           pmd

after patch,, we get
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82e00000           2M     RW             GLB NX pte
0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
0xffffffff83000000-0xffffffff83200000           2M     RW             GLB NX pte
0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB NX pmd
0xffffffff83e00000-0xffffffffa0000000         450M                           pmd

so data, bss, brk get NX ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-33-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index dc67337..e2fcbc3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -810,6 +810,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
+	unsigned long all_end = PFN_ALIGN(&_end);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -818,10 +819,10 @@ void mark_rodata_ro(void)
 	kernel_set_to_readonly = 1;
 
 	/*
-	 * The rodata section (but not the kernel text!) should also be
-	 * not-executable.
+	 * The rodata/data/bss/brk section (but not the kernel text!)
+	 * should also be not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
