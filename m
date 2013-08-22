Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3HVLis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:38:48 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45295 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3HVLiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <1374361670-3214-1-git-send-email-andrea.adami@gmail.com>
References: <1374361670-3214-1-git-send-email-andrea.adami@gmail.com>
Date: Thu, 22 Aug 2013 13:38:42 +0200
Message-ID: <CAAQYJAsfc61um70=gM0v06c0X=FSd_9J6geB07auEbRgE9B_eA@mail.gmail.com>
Subject: Re: [PATCH] pxa: sharpsl_param: fix invalid memory access in sharpsl_save_param()
From: Andrea Adami <andrea.adami@gmail.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marko Katic <dromede@gmail.com>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm bumping this after one month.
Will, I put you in copy because you did some observations about the
patch last time and you seemingly committe the change which broke boot
of sharpsl devices.

Is there something wrong with it?

Thanks

Andrea


Was:

Devices that call sharpsl_save_param() will hang on boot due to
a memcpy call that uses physical addresses that are no longer
valid. This is caused by the following commit:

commit 72662e01088394577be4a3f14da94cf87bea2591
Author: Will Deacon <will.deacon at arm.com>
Date:   Wed Nov 23 12:03:27 2011 +0000

ARM: head.S: only include __turn_mmu_on in the initial identity mapping




---------- Forwarded message ----------
From: Andrea Adami <andrea.adami@gmail.com>
Date: Sun, Jul 21, 2013 at 1:07 AM
Subject: [PATCH] pxa: sharpsl_param: fix invalid memory access in
sharpsl_save_param()
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
linux-kernel@vger.kernel.org, Marko Katic <dromede@gmail.com>


From: Marko Katic <dromede@gmail.com>

Unbreak kernel boot (tested with kexecboot)

Patch was sent twice upstrream:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137284.html
Devices that call sharpsl_save_param() will hang on boot due to
a memcpy call that uses a physical address that is no longer * accessible. Fix
his by converting the physical address into a virtual one.

Signed-off-by: Marko Katic <dromede@gmail.com>
[andrea.adami@gmail.com: checkpatch.pl dislikes void * param_start]
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/common/sharpsl_param.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index d56c932..b70b13a 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <asm/memory.h>
 #include <asm/mach/sharpsl_param.h>

 /*
@@ -41,7 +42,8 @@ EXPORT_SYMBOL(sharpsl_param);

 void sharpsl_save_param(void)
 {
-       memcpy(&sharpsl_param, (void *)PARAM_BASE, sizeof(struct
sharpsl_param_info));
+       void *param_start = phys_to_virt(PARAM_BASE);
+       memcpy(&sharpsl_param, param_start, sizeof(struct sharpsl_param_info));

        if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
                sharpsl_param.comadj=-1;
--
1.8.1.5
