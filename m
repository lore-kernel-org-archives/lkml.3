Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbaLLGrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:47:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51787 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758829AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yinghai Lu" <yinghai@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.254394238@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 133/164] x86, 64bit, mm: Mark data/bss/brk to nx
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 72212675d1c96f5db8ec6fb35701879911193158 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/init_64.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -778,6 +778,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
+	unsigned long all_end = PFN_ALIGN(&_end);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -786,10 +787,10 @@ void mark_rodata_ro(void)
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
 

