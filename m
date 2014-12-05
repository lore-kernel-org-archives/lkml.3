Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaLEWp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:45:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaLEWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.17 016/122] x86, mm: Set NX across entire PMD at boot
Date: Fri,  5 Dec 2014 14:43:10 -0800
Message-Id: <20141205223307.991743169@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init_64.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1111,7 +1111,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -1122,7 +1122,16 @@ void mark_rodata_ro(void)
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


