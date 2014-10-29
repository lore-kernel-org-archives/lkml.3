Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaJ2LSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:18:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53141 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaJ2LSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:18:04 -0400
Message-ID: <5450CCE7.7010803@arm.com>
Date: Wed, 29 Oct 2014 11:17:59 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com> <1414232097-4328-2-git-send-email-marc.zyngier@arm.com> <CACRpkdZjUPV1eWcJjT587kxJm2zyC+OEYD0Deid4wYPh8A-Z4w@mail.gmail.com>
In-Reply-To: <CACRpkdZjUPV1eWcJjT587kxJm2zyC+OEYD0Deid4wYPh8A-Z4w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 29 Oct 2014 11:18:00.0385 (UTC) FILETIME=[FFAFA310:01CFF369]
X-MC-Unique: 114102911180204701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/14 10:12, Linus Walleij wrote:
> On Sat, Oct 25, 2014 at 12:14 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
>> There is a number of cases where a kernel subsystem may want to
>> introspect the state of an interrupt at the irqchip level:
>>
>> - When a peripheral is shared between virtual machines, its interrupt
>>   state becomes part of the guest's state, and must be switched accordingly.
>>   KVM on arm/arm64 requires this for its guest-visible timer
>> - Some GPIO controllers seem to require peeking into the interrupt controller
>>   they are connected to to report their internal state
> 
> I'd like to know exactly what this means, for GPIO. As mentioned in
> conversation with Arnd, there is since before the case where a GPIO
> irqchip gets its irqs "stolen" by some other hardware that is in the
> always-on domain, and I call these "latent irqs".

It looks like a slightly different issue:
http://patchwork.ozlabs.org/patch/397657/

Basically, the GPIO chip cannot report its own state, and has to
introspect the parent irqchip to find out.

> There is a third usecase here since ages (pre-git) in
> arch/arm/mach-integrator/integrator_cp.c:
> 
> /*
>  * It seems that the card insertion interrupt remains active after
>  * we've acknowledged it.  We therefore ignore the interrupt, and
>  * rely on reading it from the SIC.  This also means that we must
>  * clear the latched interrupt.
>  */
> static unsigned int mmc_status(struct device *dev)
> {
>         unsigned int status = readl(__io_address(0xca000000 + 4));
>         writel(8, intcp_con_base + 8);
> 
>         return status & 8;
> }
> 
> static struct mmci_platform_data mmc_data = {
>         .ocr_mask       = MMC_VDD_32_33|MMC_VDD_33_34,
>         .status         = mmc_status,
>         .gpio_wp        = -1,
>         .gpio_cd        = -1,
> };
> 
> This just goes in and peeks around in the Integrator SIC, this
> patch would solve also this I think. Or are the added calls good
> for clearing the latched IRQ too?

Pretty funky. You could also use this to clear the pending bit (assuming
there is one on the CP). I'm amazed at the number of similar hacks that
are coming out of the wood now...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

