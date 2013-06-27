Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3F0Jjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:39:52 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56874 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0Jjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:39:51 -0400
Date: Thu, 27 Jun 2013 11:39:17 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: module_alloc: check if size is 0
Message-ID: <20130627093917.GQ7171@linux-mips.org>
References: <1330631119-10059-1-git-send-email-veli-pekka.peltola@bluegiga.com>
 <1331125768-25454-1-git-send-email-veli-pekka.peltola@bluegiga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331125768-25454-1-git-send-email-veli-pekka.peltola@bluegiga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warming up an ancient thread because the discussion seems to have just
stalled at some point and I still have this patch bitrotting in patchwork.

The original thread can be found at:

  http://www.linux-mips.org/archives/linux-mips/2012-03/msg00006.html
  http://www.linux-mips.org/archives/linux-mips/2012-03/msg00028.html

On Wed, Mar 07, 2012 at 03:09:28PM +0200, Veli-Pekka Peltola wrote:

> After commit de7d2b567d040e3b67fe7121945982f14343213d (mm/vmalloc.c: report
> more vmalloc failures) users will get a warning if vmalloc_node_range() is
> called with size 0. This happens if module's init size equals to 0. This
> patch changes ARM, MIPS and x86 module_alloc() to return NULL before calling
> vmalloc_node_range() that would also return NULL and print a warning.
> 
> Signed-off-by: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> ---
> I found this with ARM but after checking out various implementations of
> module_alloc() I thought it would be better to fix all at once.
> 
> One way to replicate the warning:
> compile kernel with CONFIG_KALLSYMS=n
> insmod a module without init, I used usb-common.ko

I didn't try to reproduce the issue but the code in question doesn't seem
to have changed so the issue should still persist.

Imho de7d2b567d040e3b67fe7121945982f14343213d [mm/vmalloc.c: report more
vmalloc failures] is overly strict in that it also reports zero-sized
allocations.  I consider such allocations stupid but legitimiate and often
better preferrable over having to scatter checks for zero size all over
place.  So maybe something like below patch?

Thanks,

  Ralf
---

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 mm/vmalloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d365724..e58ca10 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1679,7 +1679,10 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
-	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
+	if (unlikely(!size))
+		return NULL;
+
+	if ((size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
@@ -1711,6 +1714,7 @@ fail:
 	warn_alloc_failed(gfp_mask, 0,
 			  "vmalloc: allocation failure: %lu bytes\n",
 			  real_size);
+
 	return NULL;
 }
 
