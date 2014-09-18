Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbaIRVqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:46:39 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34437 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaIRVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:46:38 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches\@linaro.org" <patches@linaro.org>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 3.17-rc4 v7 4/6] irqchip: gic: Add support for IPI FIQ
In-Reply-To: <20140917185138.GX12361@n2100.arm.linux.org.uk> (Russell King's
	message of "Wed, 17 Sep 2014 19:51:38 +0100")
Organization: ARM Ltd
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org>
	<1410970218-28847-5-git-send-email-daniel.thompson@linaro.org>
	<20140917185138.GX12361@n2100.arm.linux.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 18 Sep 2014 22:46:22 +0100
Message-ID: <867g10vbyp.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17 2014 at 07:51:38 PM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

Hi Russell,

> On Wed, Sep 17, 2014 at 09:10:16AM -0700, Daniel Thompson wrote:
>> This patch provides support for arm's newly added IPI FIQ. It works
>> by placing all interrupt sources *except* IPI FIQ in group 1 and
>> then flips a configuration bit in the GIC such that group 1
>> interrupts use IRQ and group 0 interrupts use FIQ.
>>
>> All GIC hardware except GICv1-without-TrustZone support provides a means
>> to group exceptions into group 0 and group 1. However the hardware
>> functionality is unavailable to the kernel when a secure monitor is
>> present because access to the grouping registers are prohibited outside
>> "secure world" (a feature that allows grouping to be used to allow
>> hardware peripherals to send interrupts into the secure world). However
>> when grouping is not available we can rely on the GIC's RAZ/WI semantics
>> and avoid conditional code.
>
> I've been chasing a bug with this on the Versatile Express CT9x4.  It
> seems that the GIC there is a GICv1, with secure extensions.  It seems
> to support interrupt grouping.
>
> However, setting SPIs to group 1, with the control registers enabling
> both group 0 and group 1 (such that both groups are treated as IRQs)
> results in no SPIs being delivered to the kernel.  In other words,
> setting GIC_DIST_IGROUP for SPIs, and setting both GIC_CPU_CTRL and
> GIC_DIST_CTRL to 3.
>
> This is rather worrying, because we seem to have a GIC which for all
> intents and purposes appears to be compatible with what we want to do,
> appears to conform with the GIC architecture specifications, but doesn't
> actually work.
>
> I suspect that running the Versatile Express CT9x4 in non-secure mode
> wouldn't work (because in non-secure mode, the GIC only allows access
> to group 1 interrupts.)
>
> I've added Will and Mark to this to see whether they have any comment.

I'm rather far away from my VE-A9 board (and won't be to get back to it
for another two weeks), so this is all a shot in the dark...

Can you have a look at the GICC_AIAR register (located at GICC_IAR +
0x14)? It *shouldn't* exist on this HW, assuming this is a real
GICv1. But what you describe makes me think of something like this.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
