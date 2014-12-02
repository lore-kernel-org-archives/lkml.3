Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaLBTpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:45:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46756 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbaLBTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:45 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 111/121] x86, mm: Set NX across entire PMD at boot
Date: Tue,  2 Dec 2014 11:19:50 -0800
Message-Id: <1417548000-1794-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/mm/init_64.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 104d56a..b599241 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1110,7 +1110,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -1121,7 +1121,16 @@ void mark_rodata_ro(void)
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
-- 
1.9.1

