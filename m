Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaAFX40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:56:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57668 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932347AbaAFWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:14 -0500
Date: Mon, 6 Jan 2014 22:39:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without
	CONFIG_ARM_PATCH_PHYS_VIRT.
Message-ID: <20140106223906.GH27432@n2100.arm.linux.org.uk>
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3ha9gx63v.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 08:28:20PM +0100, Krzysztof Hałasa wrote:
> Russell, Santosh,
> 
> the unneeded commit causing regression is still in place. Please try to
> compile an ARM kernel without CONFIG_ARM_PATCH_PHYS_VIRT and with
> CONFIG_ZONE_DMA and see for yourself, if you don't believe me.
> 
> Please be aware that this commit fixes nothing, its only function is
> causing the regression - so we don't lose anything by reverting it.
> 
> If the attached wasn't clear, what the defective commit presently does
> is changing a perfectly valid code into a code referencing a variable
> which (without CONFIG_ARM_PATCH_PHYS_VIRT set) doesn't at all exist.
> 
> With CONFIG_ARM_PATCH_PHYS_VIRT set, this commit does precisely nothing.

Right, so, with Assabet, which has CONFIG_DMA_ZONE=y and
CONFIG_ARM_PATCH_PHYS_VIRT=y:

$ make O=../build/assabet arch/arm/mm/init.i

gives:
  arm_dma_limit = __pv_phys_offset + arm_dma_zone_size - 1;

with or without Santosh's patch.  So, with V2P patching in place, there's
absolutely no functional difference.

With CONFIG_ARM_PATCH_PHYS_VIRT=n, before Santosh's patch:

  arm_dma_limit = (0xc0000000UL) + arm_dma_zone_size - 1;

After:

  arm_dma_limit = __pv_phys_offset + arm_dma_zone_size - 1;

and this breaks the build because there is no __pv_phys_offset symbol.

Now, the case which matters for Santosh is the first case - the one
where CONFIG_ARM_PATCH_PHYS_VIRT=y.  We can clearly see that after
preprocessing, the results are 100% identical.

Therefore, I find myself agreeing with Krzysztof that the commit is
bad, has no functional change for the case it was proposed to solve,
and needs to be reverted.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
