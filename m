Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161903AbaKNUpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:45:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60794 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbaKNUpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:45:44 -0500
Date: Fri, 14 Nov 2014 12:45:17 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Wang Nan <wangnan0@huawei.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2] x86, mm: set NX across entire PMD at boot
Message-ID: <20141114204517.GA24402@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting up permissions on kernel memory at boot, the end of the
PMD that was split from bss remained executable. It should be NX like
the rest. This performs a PMD alignment instead of a PAGE alignment to
get the correct span of memory, and should be freed.

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
0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
0xffffffff82df5000-0xffffffff82e00000    44K     RW           NX pte
0xffffffff82e00000-0xffffffffc0000000   978M                     pmd

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - added call to free_init_pages(), as suggested by tglx
---
 arch/x86/mm/init_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763868fc..0d498c922668 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1124,6 +1124,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
 	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long pmd_end = roundup(all_end, PMD_SIZE);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -1135,7 +1136,7 @@ void mark_rodata_ro(void)
 	 * The rodata/data/bss/brk section (but not the kernel text!)
 	 * should also be not-executable.
 	 */
-	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (pmd_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
@@ -1147,6 +1148,7 @@ void mark_rodata_ro(void)
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
 
+	free_init_pages("unused kernel", all_end, pmd_end);
 	free_init_pages("unused kernel",
 			(unsigned long) __va(__pa_symbol(text_end)),
 			(unsigned long) __va(__pa_symbol(rodata_start)));
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
