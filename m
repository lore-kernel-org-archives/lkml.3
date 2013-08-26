Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3HZMH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:07:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3HZMHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:07:25 -0400
Date: Mon, 26 Aug 2013 14:07:16 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
Message-ID: <20130826120716.GB24795@pengutronix.de>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
 <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
 <20130823073250.GB30135@pengutronix.de>
 <521B38BF.6040400@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <521B38BF.6040400@monstr.eu>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:49:55 up 1 day, 21:20, 43 users,  load average: 0,00, 0,02, 0,06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal!

On Mon, Aug 26, 2013 at 01:15:11PM +0200, Michal Simek wrote:
> On 08/23/2013 09:32 AM, Steffen Trumtrar wrote:
> > Hi!
> > 
> > On Thu, Aug 22, 2013 at 05:59:36PM -0700, Sören Brinkmann wrote:
> >> On Thu, Aug 22, 2013 at 05:26:47PM -0700, Sören Brinkmann wrote:
> >>> Hi Sebastian,
> >>>
> >>> On Tue, Aug 20, 2013 at 04:04:31AM +0200, Sebastian Hesselbarth wrote:
> >>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> >>>> remove it from corresponding drivers/clk code.
> >>>
> >>> I think that would break Zynq.
> >>> If I see this correctly you call of_clk_init() from common code,
> >>> _before_ the SOC specific time init function is called.
> >>> The problem is, that we have code setting up a global pointer which is
> >>> required by zynq_clk_setup() which is triggered when of_clk_init() is
> >>> called.
> >>>
> >>> Let me try to illustrate the current call graph:
> >>>
> >>> time_init()
> >>> 	zynq_timer_init()		// this machines init_time()
> >>> 		zynq_slcr_init()	// setup System Level Control Registers including a global pointer
> >>> 			zynq_clock_init()
> >>> 				of_clk_init()
> >>> 					zynq_clk_setup()   // requires pointer setup in zynq_slcr_init()
> >>> 					...
> >>>
> >>> IIUC, your series would change this to:
> >>> time_init()
> >>> 	of_clk_init()
> >>> 		zynq_clk_setup()	// SLCR pointer is not setup/NULL
> >>> 		...
> >>> 	zynq_timer_init()
> >>> 		zynq_slcr_init()	// now the pointer becomes valid
> >>
> >> I guess we could move zynq_slcr_init() into init_irq(). I'll give that a
> >> shot tomorrow.
> >>
> > 
> > I propose getting rid of the whole global pointer and let the clkc map the
> > address itself instead.
> > 
> > Then there is no need to shuffle stuff around in the initcalls.
> > I have some WIP patches (not rebased on next and not even tested with it,
> > but with v3.11-rc4)
> > 
> > The dtsi would be something like:
> > 
> >        control-register@f8000000 {
> 
> This name is incorrect - it still should be slcr (system level control registers)
> 

Agreed. I actually already changed it back...

> > 	       compatible = "simple-bus";
> 
> I expect that syscon compatible should be here not in the lock part because
> you want to map the whole reg space.
> 

and have done this...

> >                #address-cells = <1>;
> >                #size-cells = <1>;
> >                reg = <0xf8000000 0x1000>;
> >                ranges;
> > 
> >                slcr: slcr@f8000000 {
> 
> we should use different name here - lock/locks/etc.
> 

and this actually, too.

> >                        compatible = "xlnx,zynq-slcr", "syscon";
> >                        reg = <0xf8000000 0x10>;
> >                };
> 
> 
> 
> > 
> >                clkc: clkc@f8000100 {
> >                        #clock-cells = <1>;
> >                        compatible = "xlnx,ps7-clkc";
> >                        reg = <0xf8000100 0x100>;
> >                        ps-clk-frequency = <33333333>;
> > 		       xlnx,slcr = <&slcr>;
> 
> Currently there is no code which handles locks that's why I think at least
> for now it is not necessary to extend binding which feature which is not used.
> 

Sure. You are right.

> >                        clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
> >                                        "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
> >                                        "dci", "lqspi", "smc", "pcap", "gem0", "gem1",
> >                                        "fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1",
> >                                        "sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1",
> >                                        "dma", "usb0_aper", "usb1_aper", "gem0_aper",
> >                                        "gem1_aper", "sdio0_aper", "sdio1_aper",
> >                                        "spi0_aper", "spi1_aper", "can0_aper", "can1_aper",
> >                                        "i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper",
> >                                        "gpio_aper", "lqspi_aper", "smc_aper", "swdt",
> >                                        "dbg_trc", "dbg_apb";
> >                };
> > 
> >                mio: pinmux@f8000700 {
> >                        compatible = "xlnx,ps7-pinctrl";
> 
> Have you created any driver for pinmuxing stuff?
> 

At the moment it is just a regmap. That means one could hammer the values directly
into /sys/kernel/debug/regmap/pinmux@...

I first opted for the pinctrl-single driver, but the MIO has three (?) extra registers
which do not map very well to the "one pin one register" setup of that driver.

> I agree with Soren - let's fix the current problem and then when Steffen has patches with syscon
> we can look at them.
> 
> If there is any discussion about early syscon registration please let me know.
> 

Where I'm stuck at the moment is: if I map the whole register space to the
parent node, how do I get its mapped address in the clkc?
AFAIK the phandle is pretty useless in this early stage. In the pinmuxing
case I should be able to find the registered driver for the lock via the
phandle.
If I remember correctly, there where some patches floating around for exactly
this problem. At the moment, I think the global pointer has to stay, until
those patches are mainline, if ever. Or I'm missing some obvious way of how
to get the base address of the slcr, that I can pass to the clock framework.
It doesn't need to be syscon, as the clock framework can't use it anyway.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
