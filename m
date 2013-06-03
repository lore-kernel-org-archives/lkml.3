Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3FCJrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:47:15 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44238 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab3FCJrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:47:10 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Date: Mon, 3 Jun 2013 11:46:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de> <201306031023.49364.heiko@sntech.de> <9452845.qTGjLPCfXq@wuerfel>
In-Reply-To: <9452845.qTGjLPCfXq@wuerfel>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306031146.57611.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. Juni 2013, 11:22:35 schrieb Arnd Bergmann:
> On Monday 03 June 2013 10:23:49 Heiko Stübner wrote:
> > Am Montag, 3. Juni 2013, 04:15:46 schrieb Arnd Bergmann:
> > > Can't you use
> > > 
> > > 	of_clk_init(NULL);
> > > 	clocksource_of_init();
> > > 
> > > here and change the two drivers to provide the respective macros?
> > 
> > hmm, while this would make a lot of things easier I don't see right now
> > how this would work.
> > 
> > The dw_apb_timer clocksource does not have its own device node, but
> > instead uses two timer devices as clocksource and clockevent.
> > 
> > Hmm ... one idea would be to wrap them in the dt, like
> > 
> > 	clocksource {
> > 	
> > 		compatible = "snps,dw-apb-clocksource"
> > 		
> > 		timer@2003a000 {
> > 		
> > 			compatible = "snps,dw-apb-timer-osc";
> > 			reg = <0x2003a000 0x100>;
> > 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
> > 			clocks = <&clk_gates1 1>, <&clk_gates7 8>;
> > 			clock-names = "timer", "pclk";
> > 		
> > 		};
> > 		
> > 		timer@2000e000 {
> > 		
> > 			compatible = "snps,dw-apb-timer-osc";
> > 			reg = <0x2000e000 0x100>;
> > 			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
> > 			clocks = <&clk_gates1 2>, <&clk_gates7 9>;
> > 			clock-names = "timer", "pclk";
> > 		
> > 		};
> > 	
> > 	};
> 
> Can't you just have multiple CLOCKSOURCE_OF_DECLARE() lines, one
> for each of the nodes?

The timers are of the same type and the clocksource driver just grabs the 
first of them as clockevent and the second as clocksource, so I think two 
CLOCKSOURCE_OF_DECLARE lines won't do.

But I just looked at clocksource_of_init a bit more closely, which does a 
for_each_matching_node_and_match over the nodes. So the init_func could grab 
the device for the clockevent on the first call and the clocksource when it 
gets called for the second matching node.


> > > > +DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
> > > > +       .map_io         = debug_ll_io_init,
> > > > +       .init_machine   = rockchip_dt_init,
> > > > +       .init_time      = rockchip_timer_init,
> > > > +       .dt_compat      = rockchip_board_dt_compat,
> > > > +MACHINE_END
> > > 
> > > The map_io line can already get removed.
> > 
> > Yesterday I did grep thru the linux-next I was using as base looking for
> > the debug_ll_io_init default I read about but was not able to find it
> > ... most likely my linux-next is a tad to old.
> 
> Yes, it only showed up in today's linux-next. I thought it was older.
