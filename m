Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaGUQPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:15:47 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36130 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbaGUQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:15:31 -0400
X-Auth-Info: sIZJW/uewb2/YVQLdkVGaIzzNLNdXBWYbW7yuSn3PhY=
From: Marek Vasut <marex@denx.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH RFC 1/9] irqchip: gic: Provide support for interrupt grouping
Date: Mon, 21 Jul 2014 18:07:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Harro Haan <hrhaan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org> <1405954040-30399-2-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1405954040-30399-2-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407211807.00119.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 at 04:47:12 PM, Daniel Thompson wrote:
> All GIC hardware except GICv1-without-TrustZone support provides a means
> to group exceptions into group 0 (which can optionally be signally using
> use FIQ) and group 1. The kernel currently provides no means to exploit
> this. This patch alters the initialization of the GIC to place all
> interrupts into group 1 which is the foundational requirement to
> meaningfully use FIQ.

[...]

> @@ -670,7 +753,11 @@ static void gic_raise_softirq(const struct cpumask
> *mask, unsigned int irq) dmb(ishst);
> 
>  	/* this always happens on GIC0 */
> -	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) +
> GIC_DIST_SOFTINT); +	softint = map << 16 | irq;
> +	if (gic_data_fiq_enable(&gic_data[0]))
> +		softint |= 0x8000;

These magic bits here could use some clarification, possibly a comment.

> +	writel_relaxed(softint,
> +		       gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
> 
>  	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
>  }
[...]

Best regards,
Marek Vasut
