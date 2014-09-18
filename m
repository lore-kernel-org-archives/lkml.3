Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaIRIRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:17:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:32932 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751316AbaIRIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:17:47 -0400
Date: Thu, 18 Sep 2014 09:17:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 3.17-rc4 v7 4/6] irqchip: gic: Add support for IPI FIQ
Message-ID: <20140918081739.GA5182@n2100.arm.linux.org.uk>
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <1410970218-28847-5-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410970218-28847-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:10:16AM -0700, Daniel Thompson wrote:
> @@ -604,8 +731,19 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  {
>  	int cpu;
>  	unsigned long flags, map = 0;
> +	unsigned long softint;
>  
> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
> +	/*
> +	 * The locking in this function ensures we don't use stale cpu mappings
> +	 * and thus we never route an IPI to the wrong physical core during a
> +	 * big.LITTLE switch. The switch code takes both of these locks meaning
> +	 * we can choose whichever lock is safe to use from our current calling
> +	 * context.
> +	 */
> +	if (in_nmi())
> +		raw_spin_lock(&fiq_safe_migration_lock);
> +	else
> +		raw_spin_lock_irqsave(&irq_controller_lock, flags);

BTW, I see this code is still here...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
