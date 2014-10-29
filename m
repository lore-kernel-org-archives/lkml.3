Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaJ2KMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:12:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45339 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbaJ2KMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com>
	<1414232097-4328-2-git-send-email-marc.zyngier@arm.com>
Date: Wed, 29 Oct 2014 11:12:07 +0100
Message-ID: <CACRpkdZjUPV1eWcJjT587kxJm2zyC+OEYD0Deid4wYPh8A-Z4w@mail.gmail.com>
Subject: Re: [PATCH 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
From: Linus Walleij <linus.walleij@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:14 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> There is a number of cases where a kernel subsystem may want to
> introspect the state of an interrupt at the irqchip level:
>
> - When a peripheral is shared between virtual machines, its interrupt
>   state becomes part of the guest's state, and must be switched accordingly.
>   KVM on arm/arm64 requires this for its guest-visible timer
> - Some GPIO controllers seem to require peeking into the interrupt controller
>   they are connected to to report their internal state

I'd like to know exactly what this means, for GPIO. As mentioned in
conversation with Arnd, there is since before the case where a GPIO
irqchip gets its irqs "stolen" by some other hardware that is in the
always-on domain, and I call these "latent irqs".

There is a third usecase here since ages (pre-git) in
arch/arm/mach-integrator/integrator_cp.c:

/*
 * It seems that the card insertion interrupt remains active after
 * we've acknowledged it.  We therefore ignore the interrupt, and
 * rely on reading it from the SIC.  This also means that we must
 * clear the latched interrupt.
 */
static unsigned int mmc_status(struct device *dev)
{
        unsigned int status = readl(__io_address(0xca000000 + 4));
        writel(8, intcp_con_base + 8);

        return status & 8;
}

static struct mmci_platform_data mmc_data = {
        .ocr_mask       = MMC_VDD_32_33|MMC_VDD_33_34,
        .status         = mmc_status,
        .gpio_wp        = -1,
        .gpio_cd        = -1,
};

This just goes in and peeks around in the Integrator SIC, this
patch would solve also this I think. Or are the added calls good
for clearing the latched IRQ too?

Yours,
Linus Walleij
