Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3J1Vnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:43:46 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:50864
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab3J1Vno convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:43:44 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Mon, 28 Oct 2013 14:43:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
References: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
 <1592656.1ojHcSlzVh@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1592656.1ojHcSlzVh@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b7840a0d-ac49-4c2d-beaa-9f79748c70d0@CH1EHSMHS006.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:13:28PM +0100, Tomasz Figa wrote:
> Hi Soren,
> 
> On Thursday 10 of October 2013 10:10:17 Soren Brinkmann wrote:
> > In some use cases Zynq's FPGA clocks are used as static clock
> > generators for IP in the FPGA part of the SOC for which no Linux driver
> > exists and would control those clocks. To avoid automatic
> > gating of these clocks in such cases a new property - fclk-enable - is
> > added to the clock controller's DT description to accomodate such use
> > cases. It's value is a bitmask, where a set bit results in enabling
> > the corresponding FCLK through the clkc.
> > 
> > FPGA clocks are handled following the rules below:
> > 
> > If an FCLK is not enabled by bootloaders, that FCLK will be disabled in
> > Linux. Drivers can enable and control it through the CCF as usual.
> > 
> > If an FCLK is enabled by bootloaders AND the corresponding bit in the
> > 'fclk-enable' DT property is set, that FCLK will be enabled by the clkc,
> > resulting in an off by one reference count for that clock. Ensuring it
> > will always be running.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > v2:
> >  - change default value for fclk-enable to '0'
> > ---
> >  Documentation/devicetree/bindings/clock/zynq-7000.txt |  4 ++++
> >  drivers/clk/zynq/clkc.c                               | 18
> > +++++++++++++++--- 2 files changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt
> > b/Documentation/devicetree/bindings/clock/zynq-7000.txt index
> > d99af878f5d7..11fdd146ec83 100644
> > --- a/Documentation/devicetree/bindings/clock/zynq-7000.txt
> > +++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
> > @@ -22,6 +22,10 @@ Required properties:
> >  Optional properties:
> >   - clocks : as described in the clock bindings
> >   - clock-names : as described in the clock bindings
> > + - fclk-enable : Bit mask to enable FCLKs in cases no proper CCF
> 
> Since it's a vendor specific property, it should include vendor prefix.
The whole driver is vendor specific. Should there really be another
prefix for that property?

> 
> Also CCF is a Linux-specific implementation detail, which DT bindings
> should not be involved into. If you really need to implement this using
> this way, then at least property description should say something like 
> this:
> 
> xlnx,fclk-enable : Bit mask of bits of fclk enable register that must
> be statically enabled at boot-up time.
Fair enough. I'll change the description

> 
> However, I wonder why you can't simply define an FPGA block using a single 
> node, which would be a consumer to all the fclk clocks you need to enable 
> and then make a driver for it that would simply enable all clocks 
> specified in clocks property.
Well, then we'd have a dummy driver that wouldn't fit into any subsystem
and wouldn't do anything but enabling clocks. Seems much easier to
handle it in this driver. Especially, since I hope that this is just a
workaround and that the majority of use cases involves drivers for their
soft-IP that simply uses the CCF.

	Sören


