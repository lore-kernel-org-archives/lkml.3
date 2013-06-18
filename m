Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3FRP3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:29:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3FRP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:29:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH] ARM: clocksource: add support for MOXA ART SoCs
Date: Tue, 18 Jun 2013 17:28:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de
References: <1371549604-7201-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1371549604-7201-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181728.58869.arnd@arndb.de>
X-Provags-ID: V02:K0:yXsSYVQrfELc1ndlN2P68deI57xlT1/FLKNiukCQVUA
 jps0fnJuUTPclwGCK/x01TzuWGjV2Swk0tnHa2U3d4Z1QF3oGW
 LCMKLoTJjes9hzSvBRfm/qIUSYtRmVrNdCiL9Lx6r93/5UgEPh
 Dp9RGfh+q6nzLAYM0pnrQE9Bd0DHAN4GunlUW94LV/6e5SjkkX
 XLe2dL4uqIhiIZNpNC3sB/aGJ/7iK4ko0fqYz0+Uj3sNTuW6rT
 egUSOL/DFT0Dk4wPdMQCExa5xFKIYj5DPtR9URq2HExE67Cb7t
 Gp0pdPA00Ti9L2+JArIoLkCmGrHzqYciM2qtFQgOT+RgENX6gA
 tjAB6fJ75+iInI/fNMw4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Jonas Jensen wrote:
> This patch adds an clocksource driver for the main timer found
> on MOXA ART SoCs.
> 
> Applies to 3.10-rc1 and arm-soc/for-next (2013-06-15)
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

I didn't look closely before but I agree with Thomas Petazzoni, this should
be converted to clocksource/clockevent.

A few other things I noticed now:

> +#define APB_CLK 48000000

You are hardcoding the clock rate above, which makes it less portable
than it should be. Ideally you would use clk_get_rate() on
the default clock, but you don't actually implement a clk
driver for your platform and probably don't need one.

I don't know what others think about this, but I'd suggest just
using a "clock-frequency" property in the device node to read
the clock rate.

> +#define TIMER_1_COUNT(base_addr)        (base_addr + 0x00)
> +#define TIMER_1_LOAD(base_addr)         (base_addr + 0x04)
> +#define TIMER_1_MATCH1(base_addr)       (base_addr + 0x08)
> +#define TIMER_1_MATCH2(base_addr)       (base_addr + 0x0C)
> +
> +#define TIMER_2_COUNT(base_addr)        (base_addr + 0x10)
> +#define TIMER_2_LOAD(base_addr)         (base_addr + 0x14)
> +#define TIMER_2_MATCH1(base_addr)       (base_addr + 0x18)
> +#define TIMER_2_MATCH2(base_addr)       (base_addr + 0x1C)
> +
> +#define TIMER_3_COUNT(base_addr)        (base_addr + 0x20)
> +#define TIMER_3_LOAD(base_addr)         (base_addr + 0x24)
> +#define TIMER_3_MATCH1(base_addr)       (base_addr + 0x28)
> +#define TIMER_3_MATCH2(base_addr)       (base_addr + 0x2C)
> +

You actually seem to have three independent timers here, which
means you can use one as the clock source and one for clock
events.

> +#define TIMER1_COUNT                0x0
> +#define TIMER1_LOAD                 0x4
> +#define TIMER1_MATCH1               0x8
> +#define TIMER1_MATCH2               0xC
> +#define TIMER2_COUNT                0x10
> +#define TIMER2_LOAD                 0x14
> +#define TIMER2_MATCH1               0x18
> +#define TIMER2_MATCH2               0x1C
> +#define TIMER3_COUNT                0x20
> +#define TIMER3_LOAD                 0x24
> +#define TIMER3_MATCH1               0x28
> +#define TIMER3_MATCH2               0x2C
> +#define TIMER_INTR_MASK     0x38

These look like duplicates from above. I'd prefer the second syntax, just
do the addition of base_addr where you need it.

	Arnd
