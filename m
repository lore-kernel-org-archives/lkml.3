Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab3GRPpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:45:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:8491 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162Ab3GRPpV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:45:21 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432Idf9Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Thu, 18 Jul 2013 08:45:03 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] arm: zynq: slcr: Use read-modify-write for register
 writes
References: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
 <1374081015-31431-4-git-send-email-soren.brinkmann@xilinx.com>
 <20130718072106.GB15514@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130718072106.GB15514@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <a57f684c-8983-48d2-8e99-8c9712383091@TX2EHSMHS024.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 09:21:06AM +0200, Steffen Trumtrar wrote:
> On Wed, Jul 17, 2013 at 10:10:15AM -0700, Sören Brinkmann wrote:
> > zynq_slcr_cpu_start/stop() ignored the current register state when
> > writing to a register. Fixing this by implementing proper
> > read-modify-write.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/mach-zynq/slcr.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> > index 44a4ab6..1836d5a 100644
> > --- a/arch/arm/mach-zynq/slcr.c
> > +++ b/arch/arm/mach-zynq/slcr.c
> > @@ -61,11 +61,11 @@ void zynq_slcr_system_reset(void)
> >   */
> >  void zynq_slcr_cpu_start(int cpu)
> >  {
> > -	/* enable CPUn */
> > -	writel(SLCR_A9_CPU_CLKSTOP << cpu,
> > -	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > -	/* enable CLK for CPUn */
> > -	writel(0x0 << cpu, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > +	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > +	reg &= ~(SLCR_A9_CPU_RST << cpu);
> > +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > +	reg &= ~(SLCR_A9_CPU_CLKSTOP << cpu);
> > +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> >  }
> >  
> >  /**
> > @@ -74,9 +74,9 @@ void zynq_slcr_cpu_start(int cpu)
> >   */
> >  void zynq_slcr_cpu_stop(int cpu)
> >  {
> > -	/* stop CLK and reset CPUn */
> > -	writel((SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu,
> > -	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > +	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> > +	reg |= (SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu;
> > +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> >  }
> >  
> 
> Hi!
> 
> Why do you also remove the comments? In my opinion they can stay.
I found the #defines descriptive enough

	Sören


