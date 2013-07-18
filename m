Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3GRHVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:21:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39330 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3GRHVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:21:12 -0400
Date: Thu, 18 Jul 2013 09:21:06 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] arm: zynq: slcr: Use read-modify-write for
 register writes
Message-ID: <20130718072106.GB15514@pengutronix.de>
References: <1374081015-31431-1-git-send-email-soren.brinkmann@xilinx.com>
 <1374081015-31431-4-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374081015-31431-4-git-send-email-soren.brinkmann@xilinx.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:15 up 34 days, 19:29, 24 users,  load average: 0.07, 0.04,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:10:15AM -0700, Sören Brinkmann wrote:
> zynq_slcr_cpu_start/stop() ignored the current register state when
> writing to a register. Fixing this by implementing proper
> read-modify-write.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/mach-zynq/slcr.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
> index 44a4ab6..1836d5a 100644
> --- a/arch/arm/mach-zynq/slcr.c
> +++ b/arch/arm/mach-zynq/slcr.c
> @@ -61,11 +61,11 @@ void zynq_slcr_system_reset(void)
>   */
>  void zynq_slcr_cpu_start(int cpu)
>  {
> -	/* enable CPUn */
> -	writel(SLCR_A9_CPU_CLKSTOP << cpu,
> -	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> -	/* enable CLK for CPUn */
> -	writel(0x0 << cpu, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> +	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> +	reg &= ~(SLCR_A9_CPU_RST << cpu);
> +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> +	reg &= ~(SLCR_A9_CPU_CLKSTOP << cpu);
> +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
>  }
>  
>  /**
> @@ -74,9 +74,9 @@ void zynq_slcr_cpu_start(int cpu)
>   */
>  void zynq_slcr_cpu_stop(int cpu)
>  {
> -	/* stop CLK and reset CPUn */
> -	writel((SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu,
> -	       zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> +	u32 reg = readl(zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
> +	reg |= (SLCR_A9_CPU_CLKSTOP | SLCR_A9_CPU_RST) << cpu;
> +	writel(reg, zynq_slcr_base + SLCR_A9_CPU_RST_CTRL_OFFSET);
>  }
>  

Hi!

Why do you also remove the comments? In my opinion they can stay.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
