Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbaHHSJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:09:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44508 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034AbaHHSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:09:11 -0400
Date: Fri, 8 Aug 2014 19:09:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140808180900.GG30282@n2100.arm.linux.org.uk>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk> <20140627112151.GF32514@n2100.arm.linux.org.uk> <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int> <20140627163108.GP32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int> <20140806095012.GN30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int> <20140806125550.GO30282@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int> <20140807121248.GY30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807121248.GY30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 01:12:48PM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 07, 2014 at 11:11:06AM +0000, Mattis Lorentzon wrote:
> > Russell,
> > 
> > > Can you ascertain whether these stalls are a result of some failure of the
> > > receive side or the transmit side - you should be able to tell that if you watch
> > > the packet counts via ifconfig on the stalled card.  Also, it would be useful to
> > > know whether the FEC interrupt was firing.
> > 
> > grep eth /proc/interrupts
> > 151:          0          0          0          0       GIC 151  2188000.ethernet
> > 166:    1205661          0          0          0  gpio-mxc   6  2188000.ethernet
> > 
> > The interrupt counter 166 increases regularly during the stalls.
> > Ifconfig indicates that the RX and TX  counters do not increase.
> 
> Hmm, I'm slightly confused.  On my iMX6Q, I have:
> 
> 150:     581754          0          0          0       GIC 150  2188000.ethernet
> 151:          0          0          0          0       GIC 151  2188000.ethernet
> 
> In the DT file, we have:
> 
>                         fec: ethernet@02188000 {
>                                 compatible = "fsl,imx6q-fec";
>                                 reg = <0x02188000 0x4000>;
>                                 interrupts-extended =
>                                         <&intc 0 118 IRQ_TYPE_LEVEL_HIGH>,
>                                         <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
>                                 clocks = <&clks 117>, <&clks 117>, <&clks 190>;
>                                 clock-names = "ipg", "ahb", "ptp";
>                                 status = "disabled";
>                         };
> 
> which, for the gic, would be 118 + 32 (first SPI) = 150, 119 + 32 = 151.
> Yet you seem to have nothing registered against GIC 150, instead having
> an interrupt against GPIO 6.
> 
> This seems very odd, and as this is an on-SoC device, I don't see why
> you would want to bind the interrupts for the FEC device any differently
> to standard platforms.
> 
> This could well be the cause of your stalls.
> 
> What's GPIO 6 used for on your board?

We have a second report of instability with the FEC today, and the
problem board (wanboard) is also using GPIO1 6 for the ethernet IRQ.
We have confirmation from the reporter that reverting the change
(thus making the FEC use the standard interrupt) fixes their problem.

Therefore, it seems that the workaround for ERR006687 is itself buggy.

I'd be interested to hear whether removing the 

	interrupts-extended = ...

property from your board's DT file, thereby causing you to revert back
to the default I list above, also fixes the instability you are seeing.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
