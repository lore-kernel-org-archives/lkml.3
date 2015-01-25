Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbAYOrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:47:04 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57331 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbbAYOrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:47:01 -0500
Date: Sun, 25 Jan 2015 16:46:56 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
Message-ID: <20150125144656.GO2555@sapphire.tkos.co.il>
References: <cover.1421821466.git.baruch@tkos.co.il>
 <762d81b2cf12922ba28fb58b3ea4d5b7072abefb.1421821466.git.baruch@tkos.co.il>
 <54C0F30F.9060607@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0F30F.9060607@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Jan 22, 2015 at 01:54:39PM +0100, Daniel Lezcano wrote:
> On 01/21/2015 07:36 AM, Baruch Siach wrote:
> >+ * Based on:
> >+ *	Allwinner SoCs hstimer driver
> 
> If this is based on the Allwinnner driver, may be you can have a look at the
> patchset sent by Maxim to make sure your implementation is complete ?
> 
> https://lkml.org/lkml/2015/1/11/52

Thanks for the tip. I'll take the applicable parts from that series.

[...]

> >+static void __iomem *timer_base;
> >+static u32 ticks_per_jiffy;
> 
> Mind to encapsulate those global variables in a structure and use
> container_of to access those fields like:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/clocksource/mtk_timer.c#n56
> 
> ?

The trouble is that the sched_clock callback (digicolor_timer_sched_read) 
needs a static timer_base to find the timer counter. Do you think adding a 
structure is worth it only for ticks_per_jiffy?

> >+static void digicolor_clkevt_mode(enum clock_event_mode mode,
> >+				  struct clock_event_device *clk)
> >+{
> >+	switch (mode) {
> >+	case CLOCK_EVT_MODE_PERIODIC:
> >+		writeb(0, timer_base + CONTROL(TIMER_C));
> 
> Even if that sounds overkill, please replace '0', '1' with whatever macro
> name (eg. TIMER_DISABLE/ENABLE).

Will do for the entire file.

[...]

> >+static struct irqaction digicolor_timer_irq = {
> >+	.name = "digicolor_timerC",
> >+	.flags = IRQF_TIMER | IRQF_IRQPOLL,
> >+	.handler = digicolor_timer_interrupt,
> >+	.dev_id = &digicolor_clockevent,
> >+};
> 
> The current trend is to use 'request_irq', so no such structure
> declaration/initialization is needed.

Thanks. Will do.

> >+	writel(~0, timer_base + COUNT(TIMER_B));
> 
> s/~0/UINT_MAX/ ?

Ack.

Thanks for reviewing. I'll post an updated series shortly.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
