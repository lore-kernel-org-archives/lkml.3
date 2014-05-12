Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaELJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:38:19 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56778 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaELJiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:38:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] clocksource: Add support for the Mediatek SoCs
Date: Mon, 12 May 2014 11:37:27 +0200
Message-ID: <4169260.qB0vPmmJCY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399772463-859-2-git-send-email-matthias.bgg@gmail.com>
References: <1399772463-859-1-git-send-email-matthias.bgg@gmail.com> <1399772463-859-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Kqp29icMY2FugOE5/8YGwOuPkm3vuWvemF+TyhMWZuv
 emFV3ehEWI82vKgvCU+CQI4mPdURT2ZOfp9oCTbOtubvXE8rEG
 9UgK42lpVU87JAMyKtPb+du268X7D3Fr8Oyi8xKPy3syvMMFu7
 Cb+MvwVx25cPUWlHxU5p8vHpZy+oGZB+vMnVJtKWpgqx+GaqS8
 /R4JT2BACukMTmEta7E/wBNT9TnZATE2nwyLKORnQEshE+EOsz
 0UG8t8ut7oFV4h5Ok0VuVx+IS5lU1kyPTdYiClTGjkzcYt+VAg
 93UV0aE9g1juNQkuXQAb63Tltqe8tPHZ6ijWslmXEvx2VxZ8Z3
 8b6PavqqKv2sVji7YbnQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2014 03:41:00 Matthias Brugger wrote:
> +
> +static void __iomem *gpt_base;
> +static u32 ticks_per_jiffy;
> +

This is not wrong, because there will only be one timer, but the
preferred way to express this in general would be to add it to the
clock_event_device pointer:

struct mtk_clock_event_device {
	void __iomem *gpt_base;
	u32 ticks_per_jiffy;
	struct clock_event_device dev;
};

static inline struct mtk_clock_event_device *to_mtk_clock(struct clock_event_device *c)
{
	return container_of(c, struct mtk_clock_event_device, dev);
}

static irqreturn_t mtk_timer_interrupt(int irq, void *dev_id)
{
       struct mtk_clock_event_device *evt = dev_id;

       /* Acknowledge timer0 irq */
       writel(GPT_IRQ_ACK(GPT_CLK_EVT), evt->gpt_base + GPT_IRQ_ACK_REG);
       evt->dev.event_handler(evt);

       return IRQ_HANDLED;
}

static void mtk_clkevt_mode(enum clock_event_mode mode,
                             struct clock_event_device *clk)
{
	struct mtk_clock_event_device *evt = to_mtk_clock(clk);

        mtk_clkevt_time_stop(GPT_CLK_EVT);

        switch (mode) {
        case CLOCK_EVT_MODE_PERIODIC:
               mtk_clkevt_time_setup(evt->ticks_per_jiffy, GPT_CLK_EVT);
               mtk_clkevt_time_start(true, GPT_CLK_EVT);
               break;
        case CLOCK_EVT_MODE_ONESHOT:
               mtk_clkevt_time_start(false, GPT_CLK_EVT);
               break;
        case CLOCK_EVT_MODE_UNUSED:
        case CLOCK_EVT_MODE_SHUTDOWN:
        default:
               /* No more interrupts will occur as source is disabled */
               break;
        }
}

	Arnd
