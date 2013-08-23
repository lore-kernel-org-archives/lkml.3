Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3HWXi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:38:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40696 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3HWXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:38:57 -0400
Date: Sat, 24 Aug 2013 01:38:51 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
Message-ID: <20130823233851.GH30135@pengutronix.de>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
 <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
 <20130823073250.GB30135@pengutronix.de>
 <bf33d6fc-a28b-410a-aa75-be7b584aadd8@CO9EHSMHS025.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf33d6fc-a28b-410a-aa75-be7b584aadd8@CO9EHSMHS025.ehs.local>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 01:23:38 up 24 days,  8:27, 39 users,  load average: 0.06, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 09:00:23AM -0700, Sören Brinkmann wrote:
> Hi Steffen,
> 
> On Fri, Aug 23, 2013 at 09:32:50AM +0200, Steffen Trumtrar wrote:
> > Hi!
> > 
> > On Thu, Aug 22, 2013 at 05:59:36PM -0700, Sören Brinkmann wrote:
> > > On Thu, Aug 22, 2013 at 05:26:47PM -0700, Sören Brinkmann wrote:
> [ ... ]
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
> > 	       compatible = "simple-bus";
> >                #address-cells = <1>;
> >                #size-cells = <1>;
> >                reg = <0xf8000000 0x1000>;
> >                ranges;
> > 
> >                slcr: slcr@f8000000 {
> >                        compatible = "xlnx,zynq-slcr", "syscon";
> >                        reg = <0xf8000000 0x10>;
> >                };
> > 
> >                clkc: clkc@f8000100 {
> >                        #clock-cells = <1>;
> >                        compatible = "xlnx,ps7-clkc";
> >                        reg = <0xf8000100 0x100>;
> 
> This is splitting the SLCR into multiple regions. I just heard about the
> syscon the first time, but wouldn't it be more correct to leave the SLCR
> region in one piece in the slcr node and then pass the slcr phandle to
> the clkc and later also pinmux etc. nodes? This way the SLCR is in
> charge of the lock and all registers protected by the lock.
> That wouldn't get rid of the dependency that SLCR has to be initialized
> before any of its users, but seems to reflect actual HW better since the
> whole region is protected by the same SLCR lock which makes them kinda
> inseparable.
> 

Actually I agree. What I was struggeling with, was the correct mapping of the
ranges. But maybe I have to take another look at the "ranges = <..>" property.

> Anyway, after all we more or less agree, that syscon/slcr has to be
> initialized before any SLCR user. So, no matter whether we do this
> through current code and a global pointer or DT phandles, the effect
> stays the same, IIUC.
> So, in order to not mix stuff around too much, I'd rather make sure that
> zynq_slcr_init() is called early enough (put it in init_irq() or some
> init_call() whatever works best), and keep the global pointer for now.
> That way most code can stay as is and we don't have to change the DT
> bindings.
> And then you can finish your work on this and we can revisit the topic
> of migrating to use the slcr through a phandle later?
> 

Agreed.

Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
