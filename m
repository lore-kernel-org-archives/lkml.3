Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbbAZKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:18:17 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57371 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbbAZKPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:15:18 -0500
Date: Mon, 26 Jan 2015 12:15:11 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
Message-ID: <20150126101511.GC3148@tarshish>
References: <cover.1422256855.git.baruch@tkos.co.il>
 <d2d06d04f8ee8acb62e7748b42c3177229de478a.1422256855.git.baruch@tkos.co.il>
 <54C60C4F.50507@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C60C4F.50507@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Jan 26, 2015 at 10:43:43AM +0100, Daniel Lezcano wrote:
[...]
> >+static struct dc_dev_t {
> >+	void __iomem *timer_base;
> >+	u32 ticks_per_jiffy;
> >+} dc_dev;
> 
> Hi Baruch,
> 
> your code is valid but I think there is a misunderstanding when we talked
> about the encapsulation.
> 
> I was expecting something like:
> 
> static struct digicolor_timer {
> 	void __iomem *base;
> 	u32 ticks_per_jiffy;
> 	int channel;
> 	struct clock_event_device ce;
> };
> 
> struct digicolor_timer *dg_timer(struct clock_event_device *ce)
> {
> 	return container_of(ce, struct digicolor_timer, ce);
> }
> 
> So the timer could be accessed directly from the clock_event_device
> structure. The exception is the 'sched_read' and the init function where you
> will have to address directly the global variable.
> 
> Perhaps, that would be nice if you take the opportunity to encapsulate the
> enable/disable functions.
> 
> static inline void dg_timer_disable(struct clock_event_device *ce)
> {
> 	struct digital_timer *dt = dg_timer(ce);
> 	writeb(CONTROL_DISABLE, dt->base + CONTROL(dt->channel));	
> }
> 
> static inline void dg_timer_enable(struct clock_event_device *ce, int mode)
> {
> 	struct digital_timer *dt = dg_timer(ce);
> 	writeb(CONTROL_ENABLE | mode, dt->base, CONTROL(dt->channel));
> }
> 
> >+
> >+static void digicolor_clkevt_mode(enum clock_event_mode mode,
> >+				  struct clock_event_device *clk)
> 
> IMO, 'clk' argument name is confusing. I would suggest to use 'ce' or
> whatever.
> 
> >+{
> >+	switch (mode) {
> >+	case CLOCK_EVT_MODE_PERIODIC:
> >+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
> >+		writel(dc_dev.ticks_per_jiffy,
> >+		       dc_dev.timer_base + COUNT(TIMER_C));
> >+		writeb(CONTROL_ENABLE | CONTROL_MODE_PERIODIC,
> >+		       dc_dev.timer_base + CONTROL(TIMER_C));
> 
> Becomes:
> 
> 		dg_timer_disable(ce);
> 		dg_timer_enable(ce, CONTROL_MODE_PERIODIC);
> 
> ...
> 
> >+		break;
> >+	case CLOCK_EVT_MODE_ONESHOT:
> >+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
> >+		writeb(CONTROL_ENABLE | CONTROL_MODE_ONESHOT,
> >+		       dc_dev.timer_base + CONTROL(TIMER_C));
> 
> 
> Becomes:
> 		dg_timer_disable(ce);
> 		dg_timer_enable(ce, CONTROL_MODE_ONESHOT);
> 	
> 
> >+		break;
> >+	case CLOCK_EVT_MODE_UNUSED:
> >+	case CLOCK_EVT_MODE_SHUTDOWN:
> >+	default:
> >+		writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
> 
> Becomes:
> 		dg_timer_disable(ce);
> 
> >+		break;
> >+	}
> >+}
> >+
> >+static int digicolor_clkevt_next_event(unsigned long evt,
> >+				       struct clock_event_device *unused)
> >+{
> >+	writeb(CONTROL_DISABLE, dc_dev.timer_base + CONTROL(TIMER_C));
> >+	writel(evt, dc_dev.timer_base + COUNT(TIMER_C));
> >+	writeb(CONTROL_ENABLE | CONTROL_MODE_ONESHOT,
> >+	       dc_dev.timer_base + CONTROL(TIMER_C));
> 
> Becomes:
> 	dg_timer_disable(ce);
> 	writel(evt, dg_timer(ce)->base + COUNT(dg_timer(ce)->base));
> 	dg_timer_enable(ce, CONTROL_MODE_ONESHOT);
> >+	return 0;
> >+}
> >+
> >+static struct clock_event_device digicolor_clockevent = {
> >+	.name = "digicolor_tick",
> >+	.rating = 340,
> >+	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
> >+	.set_mode = digicolor_clkevt_mode,
> >+	.set_next_event = digicolor_clkevt_next_event,
> >+};
> 
> 
> struct digicolor_timer dg_timer = {
> 	
> 	.ce = {
> 		.name = "digicolor_tick",
> 		.rating = 340,
> 		.features = CLOCK_EVT_FEAT_PERIODIC |
> 				CLOCK_EVT_FEAT_ONESHOT,
> 		.set_mode = digicolor_clkevt_mode,
> 		.set_next_event = digicolor_clkevt_next_event,
> 	},
> 	.channel = TIMER_C,
> };
> 
> What do you think ?

OK. I'll give it a try.

Thanks for your prompt response and thorough review.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
