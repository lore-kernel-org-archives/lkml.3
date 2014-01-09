Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaAIKDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:03:08 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60185 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751321AbaAIKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:02:55 -0500
Date: Thu, 9 Jan 2014 10:02:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: viresh.linux@gmail.com, patches@linaro.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH CFT] ARM:REALVIEW: Enable AUTO_ZRELADDR by default
Message-ID: <20140109100238.GW27432@n2100.arm.linux.org.uk>
References: <1389242654-3925-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389242654-3925-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 10:14:14AM +0530, panchaxari wrote:
> Below lkml link is a quoting by Russell, which explains more on concept of
> PHYS_VIRT and ZRELADDR
> -------------------------------------------------
> 
> https://lkml.org/lkml/2011/10/14/434
> 
> -------------------------------------------------

Okay, so you're just going around changing stuff, basing it on an old mail,
and not testing the results of it.  Stop this please.

Note that the result of the above email was this:

commit c1becedc8871645278832fabdc6fe138082a495b
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Wed Aug 10 10:23:45 2011 +0100

    ARM: enable ARM_PATCH_PHYS_VIRT by default

    Enable virtual to physical translation patching by default in all
    kernels.  Hide the option behind EMBEDDED.

    This can still be turned off if people desire, and they know what
    they're doing, to shrink the size of the kernel to a minimum.

    Acked-by: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5ebc5d922ea1..8882a535cf44 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -195,7 +195,8 @@ config VECTORS_BASE
          The base address of exception vectors.

 config ARM_PATCH_PHYS_VIRT
-       bool "Patch physical to virtual translations at runtime"
+       bool "Patch physical to virtual translations at runtime" if EMBEDDED
+       default y
        depends on !XIP_KERNEL && MMU
        depends on !ARCH_REALVIEW || !SPARSEMEM
        help
@@ -207,6 +208,10 @@ config ARM_PATCH_PHYS_VIRT
          of physical memory is at a 16MB boundary, or theoretically 64K
          for the MSM machine class.

+         Only disable this option if you know that you do not require
+         this feature (eg, building a kernel for a single machine) and
+         you need to shrink the kernel to the minimal size.


which means that ARM_PATCH_PHYS_VIRT is enabled for virtually everything
unless you decide that you want to enable EMBEDDED mode, in which case
you get the chance to manually disable it.

In fact, all those select ARM_PATCH_PHYS_VIRT are wrong, and add reverse
dependencies that make maintanence of the Kconfig harder.  I'd rather kill
all those select statements rather than introduce yet more of them.

Hence, all your recent patches adding "select ARM_PATCH_PHYS_VIRT" I say
a very strong NAK to.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
