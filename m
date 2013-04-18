Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966678Ab3DROOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:14:42 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:55999 "HELO
	mail-ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965346Ab3DROOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:14:40 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2013 10:14:40 EDT
Message-ID: <516FFCB5.7080900@keymile.com>
Date: Thu, 18 Apr 2013 16:01:25 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ralf Baechle <ralf@linux-mips.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Simon Guinot <sguinot@lacie.com>
Subject: Re: [PATCH v3b 0/9] refactoring for mask_cache
References: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
In-Reply-To: <1363885931-20571-1-git-send-email-gerlando.falauto@keymile.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2013 14:01:25.0827 (UTC) FILETIME=[37451930:01CE3C3D]
X-ESAFE-STATUS: [srvchber1306.keymile.net] Mail allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

any chance we could move this pachset to the next level (at least for 
mainline)?

Thanks a lot!
Gerlando

On 03/21/2013 06:12 PM, Gerlando Falauto wrote:
> This patchset addresses a regression found with the Orion GPIO controller
> when both Edge- and Level- based interrupts are requested within the same
> GPIO chip. The regression was introduced by e59347a
> "arm: orion: Use generic irq chip"
>
> thereby affecting all kernel releases since 3.0.x.
>
> The reason behind it is that the Orion GPIO controller uses separate
> mask registers for the two types of interrupts (one for edge and one
> for level), whereas in other cases the same register would be shared.
> Since this mask register is cached, we need to have (potentially)
> separate register caches.
> We do that by adding a per-chip-type mask register cache, and a mask cache
> pointer (which will point either to that or the shared one).
>
> So we proceed with incremental stages:
> a) we introduce the new fields and pointer (though only the shared one is used)
> b) we convert all drivers to use it
> c) we rename the field so to force the use of the per-ct pointer
> d) we add per-ct mask cache, provided the new flag
>     IRQ_GC_SEPARATE_MASK_REGISTERS is enabled
> e) we enable the flag for orion-gpio and mvebu drivers
>
> The changes were tested by Simon Guinot to be effective on Kirkwood chipsets,
> on both the legacy orion-gpio and the new gpio-mvebu drivers.
> The bug should also affect the other two Marvell variants handled by
> the gpio-mvebu driver.
>
> Changes from v3: cover letter and SOB lines.
>
> Gerlando Falauto (9):
>    genirq: cosmetic: remove cur_regs
>    genirq: add mask_cache and pmask_cache into struct irq_chip_type
>    gpio: mvebu: convert to usage of *pmask_cache within irq_chip_type
>    MIPS: JZ4740: convert to usage of *pmask_cache within irq_chip_type
>    ARM: SAMSUNG: convert to usage of *pmask_cache within irq_chip_type
>    genirq: rename mask_cache to shared_mask_cache
>    genirq: handle separate mask registers
>    orion-gpio: enable IRQ_GC_SEPARATE_MASK_REGISTERS
>    gpio: mvebu: enable IRQ_GC_SEPARATE_MASK_REGISTERS
>
>   arch/arm/plat-orion/gpio.c            |    3 +-
>   arch/arm/plat-samsung/irq-vic-timer.c |    6 ++--
>   arch/mips/jz4740/irq.c                |    3 +-
>   drivers/gpio/gpio-mvebu.c             |   23 ++++++++------
>   include/linux/irq.h                   |    9 ++++--
>   kernel/irq/generic-chip.c             |   55 +++++++++++++++++++++------------
>   6 files changed, 64 insertions(+), 35 deletions(-)
>

