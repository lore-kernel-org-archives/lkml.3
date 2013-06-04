Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3FDPGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:06:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60644 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3FDPGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:06:44 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH v2 4/4] clocksource: dw_apb_timer_of: use clocksource_of_init
Date: Tue, 4 Jun 2013 17:06:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de> <201306041138.42639.heiko@sntech.de> <20130604142120.GD5308@maple>
In-Reply-To: <20130604142120.GD5308@maple>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306041706.30112.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 4. Juni 2013, 16:21:20 schrieb Jamie Iles:
> Hi Heiko,
> 
> On Tue, Jun 04, 2013 at 11:38:42AM +0200, Heiko Stübner wrote:
> > dw_apb_timer_init used to search the devicetree for matching timer
> > devices, making calls to it from board files necessary.
> > 
> > Change the dw_apb_timer_init to work with CLOCKSOURCE_OF_DECLARE.
> > With this change the function gets called once for each timer node
> > and tracks these number of calls to attach clockevent and clocksource
> > devices to the nodes.
> > 
> > Also remove the calls to dw_apb_timer_init from all previous users, as
> > clocksource_of_init is the default for init_time now.
> > 
> > Tested on the upcoming rk3066 code.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Acked-by: Rob Herring <rob.herring@calxeda.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> ...
> 
> > -void __init dw_apb_timer_init(void)
> > +static int num_called;
> > +static void __init dw_apb_timer_init(struct device_node *timer)
> > 
> >  {
> > 
> > -	struct device_node *event_timer, *source_timer;
> > -
> > -	event_timer = of_find_matching_node(NULL, osctimer_ids);
> > -	if (!event_timer)
> > -		panic("No timer for clockevent");
> > -	add_clockevent(event_timer);
> > -
> > -	source_timer = of_find_matching_node(event_timer, osctimer_ids);
> > -	if (!source_timer)
> > -		panic("No timer for clocksource");
> > -	add_clocksource(source_timer);
> > -
> > -	of_node_put(source_timer);
> > +	switch (num_called) {
> > +	case 0:
> > +		pr_debug("%s: found clockevent timer\n", __func__);
> > +		add_clockevent(timer);
> > +		of_node_put(timer);
> > +		break;
> > +	case 1:
> > +		pr_debug("%s: found clocksource timer\n", __func__);
> > +		add_clocksource(timer);
> > +		of_node_put(timer);
> > +		init_sched_clock();
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > 
> > -	init_sched_clock();
> > +	num_called++;
> > 
> >  }
> > 
> > +CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer",
> > dw_apb_timer_init); +CLOCKSOURCE_OF_DECLARE(apb_timer,
> > "snps,dw-apb-timer-osc", dw_apb_timer_init);
> 
> I think maybe we also want CLOCKSOURCE_OF_DECLARE() instances for the
> contents of sptimer_ids for completeness, otherwise looks good.

Hmm ... difficult.

As you can see, currently we call init_sched_clock when the second timer is 
found, which then tries to find the sptimer or uses the clocksource as 
sched_clock.

So to use CLOCKSOURCE_OF_DECLARE for the sptimer the init_sched_clock call 
would need to move to its init function. So on system without sptimer (like 
mine) this third call would never happen, and the system would be missing a 
sched_clock.

Or I just don't see the solution currently. In any case this could probably be 
handled by someone with the relevant hardware to test ;-) .


> Acked-by: Jamie Iles <jamie@jamieiles.com>

thanks
