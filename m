Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3EJORU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:17:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35333 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3EJORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:17:18 -0400
Date: Fri, 10 May 2013 16:17:10 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: versatile: Make able to use UART ports for
 KGDB FIQ debugger
Message-ID: <20130510161710.45b18866@skate>
In-Reply-To: <1368144651-11250-4-git-send-email-john.stultz@linaro.org>
References: <1368144651-11250-1-git-send-email-john.stultz@linaro.org>
	<1368144651-11250-4-git-send-email-john.stultz@linaro.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear John Stultz,

On Thu,  9 May 2013 17:10:51 -0700, John Stultz wrote:

> +static void kgdb_fiq_select(bool on)
> +{
> +	void __iomem *sel = kgdb_irq_base + VIC_INT_SELECT;
> +	u32 msk = 1 << kgdb_irq;
> +	u32 val;
> +
> +	pr_debug("rerouting VIC vector %d to %s\n", kgdb_irq,
> +		 on ? "FIQ" : "IRQ");
> +
> +	val = readl(sel);
> +	val &= ~msk;
> +	if (on)
> +		val |= msk;
> +	writel(val, sel);
> +}
> +
> +static bool kgdb_is_fiq_rised(void)

Shouldn't this function be kgdb_is_fiq_raised() ?

> +{
> +	return readl(kgdb_irq_base + VIC_FIQ_STATUS) & (1 << kgdb_irq);
> +}
> +
> +static int __init kgdb_fiq_init(void)
> +{
> +	kgdb_irq_base = __io_address(VERSATILE_VIC_BASE);
> +	kgdb_irq += INT_UARTINT0;
> +	WARN_ON(kgdb_irq > INT_UARTINT2);
> +
> +	return kgdb_register_fiq(kgdb_fiq_select, kgdb_is_fiq_rised);
> +}
> +console_initcall(kgdb_fiq_init);

Also, this code that uses hardcoded addresses and IRQ numbers doesn't
seem to play really well with the DT. I was considering toying around
with this thing on the mach-mvebu platform, but don't have those
hardcoded addresses and IRQs, and the register offsets of the IRQ
controller driver are not exposed in an header file. Shouldn't IRQ
controller driver be exposing a the fiq_select() functionality instead?
Like a new flag for irq_chip->irq_set_type(), or a completely new hook
irq_chip->irq_set_mode() or something like that?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
