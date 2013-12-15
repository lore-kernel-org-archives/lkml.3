Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LOTUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:20:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:34047 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab3LOTUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:20:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,490,1384329600"; 
   d="scan'208";a="450411481"
Date: Sun, 15 Dec 2013 11:25:08 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rjw@rjwysocki.net, len.brown@intel.com, sarah.a.sharp@linux.intel.com,
        gregkh@linuxfoundation.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        santosh.shilimkar@ti.com
Subject: Re: [RFC/PATCH 1/3] pm: make PM macros more smart
Message-ID: <20131215192508.GA10514@psi-dev26.jf.intel.com>
References: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
 <1386911905-2366-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131215175112.GA23298@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215175112.GA23298@Nokia-N900>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 06:51:12PM +0100, Pavel Machek wrote:
> On Thu 2013-12-12 21:18:23, David Cohen wrote:
> > This patch makes SET_SYSTEM_SLEEP_PM_OPS() and SET_RUNTIME_PM_OPS() more
> > smart.
> > 
> > Despite those macros check for '#ifdef CONFIG_PM_SLEEP/RUNTIME' to avoid
> > setting the callbacks when such #ifdef's aren't defined, they don't
> > handle compiler to avoid messages like that:
> > 
> > drivers/usb/host/xhci-plat.c:200:12: warning: ???xhci_plat_suspend??? defined but not used [-Wunused-function]
> > drivers/usb/host/xhci-plat.c:208:12: warning: ???xhci_plat_resume??? defined but not used [-Wunused-function]
> > 
> > As result, those macros get rid of #ifdef's when setting callbacks but
> > not when implementing them.
> > 
> > With this patch, drivers using SET_*_PM_OPS() macros don't need to #ifdef
> > the callbacks implementation as well.
> 
> Well... Interesting trickery, but it means that resulting kernel
> will be bigge due to the dead functions no?

Actually, it doesn't get bigger. Before sending the patch I did this
dummy test app:

--------------------------------------------------------------------------------
#include <stdio.h>

#define USE_IT_OR_LOOSE_IT(fn)  ((void *)((unsigned long)(fn) - (unsigned long)(fn)))

#ifdef MAKE_ME_NULL
static int func1(int a)
{
        printf("Hey!!\n");
        return 0;
}
#endif

struct global_data {
        int (*func)(int);
};

static struct global_data gd = {
#ifdef MAKE_ME_NULL
        .func = USE_IT_OR_LOOSE_IT(func1),
#endif
};

int main(void)
{
#ifdef MAKE_ME_NULL
        printf("MAKE_ME_NULL is defined\n");
#else
        printf("MAKE_ME_NULL is NOT defined\n");
#endif
        printf("%p\n", gd.func);
        return 0;
}
--------------------------------------------------------------------------------

Then I compiled 2 .S files:
$ gcc -DMAKE_ME_NULL test1.c -O2 -S -o test_makemenull.S
$ gcc test1.c -O2 -S -o test_no_makemenull.S

This is the diff between both:

--------------------------------------------------------------------------------
--- test_makemenull.S	2013-12-15 11:07:02.635992492 -0800
+++ test_no_makemenull.S	2013-12-15 11:07:10.639992359 -0800
@@ -1,7 +1,7 @@
 	.file	"test1.c"
 	.section	.rodata.str1.1,"aMS",@progbits,1
 .LC0:
-	.string	"MAKE_ME_NULL is defined"
+	.string	"MAKE_ME_NULL is NOT defined"
 .LC1:
 	.string	"%p\n"
 	.section	.text.startup,"ax",@progbits
@@ -9,7 +9,7 @@
 	.globl	main
 	.type	main, @function
 main:
-.LFB12:
+.LFB11:
 	.cfi_startproc
 	subq	$8, %rsp
 	.cfi_def_cfa_offset 16
@@ -24,7 +24,7 @@
 	.cfi_def_cfa_offset 8
 	ret
 	.cfi_endproc
-.LFE12:
+.LFE11:
 	.size	main, .-main
 	.ident	"GCC: (Debian 4.8.2-1) 4.8.2"
 	.section	.note.GNU-stack,"",@progbits
--------------------------------------------------------------------------------

My conclusion is gcc's -O2 handles this situation pretty well, which
makes my patch to have not much actual side effects on kernel binary.

Br, David Cohen

> 
> That may be acceptable tradeoff, but I guess its worth discussing...
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
