Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786AbaLLGhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759306AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yinghai Lu" <yinghai@kernel.org>,
        "Wang Nan" <wangnan0@huawei.com>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Toshi Kani" <toshi.kani@hp.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Kees Cook" <keescook@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Yasuaki Ishimatsu" <isimatu.yasuaki@jp.fujitsu.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.306335513@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 134/164] x86, mm: Set NX across entire PMD at boot
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 45e2a9d4701d8c624d4a4bcdd1084eae31e92f58 upstream.

When setting up permissions on kernel memory at boot, the end of the
PMD that was split from bss remained executable. It should be NX like
the rest. This performs a PMD alignment instead of a PAGE alignment to
get the correct span of memory.

Before:
---[ High Kernel Mapping ]---
...
0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
0xffffffff82df5000-0xffffffff82e00000    44K     RW       GLB x  pte
0xffffffff82e00000-0xffffffffc0000000   978M                     pmd

After:
---[ High Kernel Mapping ]---
...
0xffffffff8202d000-0xffffffff82200000  1868K     RW       GLB NX pte
0xffffffff82200000-0xffffffff82e00000    12M     RW   PSE GLB NX pmd
0xffffffff82e00000-0xffffffffc0000000   978M                     pmd

[ tglx: Changed it to roundup(_brk_end, PMD_SIZE) and added a comment.
        We really should unmap the reminder along with the holes
        caused by init,initdata etc. but thats a different issue ]

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20141114194737.GA3091@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: BAckported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/mm/init_64.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -778,7 +778,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
-	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -789,7 +789,16 @@ void mark_rodata_ro(void)
 	/*
 	 * The rodata/data/bss/brk section (but not the kernel text!)
 	 * should also be not-executable.
+	 *
+	 * We align all_end to PMD_SIZE because the existing mapping
+	 * is a full PMD. If we would align _brk_end to PAGE_SIZE we
+	 * split the PMD and the reminder between _brk_end and the end
+	 * of the PMD will remain mapped executable.
+	 *
+	 * Any PMD which was setup after the one which covers _brk_end
+	 * has been zapped already via cleanup_highmem().
 	 */
+	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
 	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();

