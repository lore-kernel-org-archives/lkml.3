Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaJ2Hnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 03:43:35 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52104 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaJ2Hnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 03:43:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: f.fainelli@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use __raw_{readl_writel}
Date: Wed, 29 Oct 2014 08:43:16 +0100
Message-ID: <11255905.1JsQYcArO7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6ediLdvmXOT2etVy9oSrfGaUg4I4e/r15vTCrRHXOoY
 3KBvjUgaMPz3kEZ3R4q41L3mVEjXxkJzFhaTdPRywroYBTxDFn
 ztwALW/Iknj7zr/75cQEaftx53AbiOF/i+Gy/Pxzxl0SnckSUE
 iOddSFBq98Z6m8F5gnP7xAAtyFminHfDwaALyJIoyxe68FSW8C
 RdyXqxjM690M0sWmg0O1Rrx2zLUib8F0+o1ZtPDD8E2a8NpLHp
 7ihx4RCxTbL2JN8CjFCZQpstKvw54Y2kREDck2fvqZle6suoFN
 3KdBvOvw8/02/tKkwrR2jwYNXvM0/iwf7Wv+rcJrgLmlTkstYB
 qVQfxIvLAwwzudYNj1fM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 20:58:48 Kevin Cernekee wrote:
> 
> +#ifdef CONFIG_RAW_IRQ_ACCESSORS
> +
> +#ifndef irq_reg_writel
> +# define irq_reg_writel(val, addr)     __raw_writel(val, addr)
> +#endif
> +#ifndef irq_reg_readl
> +# define irq_reg_readl(addr)           __raw_readl(addr)
> +#endif
> +
> +#else
> +

No, this is just wrong: registers almost always have a fixed endianess
indenpent of CPU endianess, so if you use __raw_writel, it will be
broken on one or the other.

If you have a machine that uses big-endian registers in the interrupt
controller, you need to find a way to use the correct accessors
(e.g. iowrite32be) and use them independent of what endianess the CPU
is running.

As this code is being used on all sorts of platforms, you can't assume
that they all use the same endianess, which makes it rather tricky.

As the first step, you can probably introduce a new Kconfig symbol
GENERIC_IRQ_CHIP_BE, and then make that mutually exclusive with the
existing users that all use little-endian registers:

#if defined(CONFIG_GENERIC_IRQ_CHIP) && !defined(CONFIG_GENERIC_IRQ_CHIP_BE)
#define irq_reg_writel(val, addr)     writel(val, addr)
#else if defined(CONFIG_GENERIC_IRQ_CHIP_BE) && !defined(CONFIG_GENERIC_IRQ_CHIP)
#define irq_reg_writel(val, addr)     iowrite32be(val, addr)
#else
/* provoke a compile error when this is used */
#define irq_reg_writel(val, addr)	irq_reg_writel_unknown_endian(val, addr)
#endif

and

--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,5 +1,6 @@
 
 obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
+obj-$(CONFIG_GENERIC_IRQ_CHIP_BE) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o

Note that you might also have a case where you have more than
one generic irqchip driver built into the kernel, which require
different endianess. We can't really support that case without
changing the generic-chip implementation.

	Arnd
