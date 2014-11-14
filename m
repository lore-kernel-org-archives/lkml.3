Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161822AbaKNTsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:48:30 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57681 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304AbaKNTs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:48:29 -0500
Date: Fri, 14 Nov 2014 11:47:37 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: set NX across entire PMD at boot
Message-ID: <20141114194737.GA3091@www.outflux.net>
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

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/mm/init_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763868fc..7da7a4ab46f7 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1123,7 +1123,9 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-	unsigned long all_end = PFN_ALIGN(&_end);
+	/* End of kernel memory will span a PMD, so align to PMD. */
+	unsigned long all_end = (((unsigned long)(&_end) + (PMD_SIZE - 1))
+				 & PMD_MASK);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
