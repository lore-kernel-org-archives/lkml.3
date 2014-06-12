Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbaFLPsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:48:17 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:6213
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752950AbaFLPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:48:15 -0400
Date: Thu, 12 Jun 2014 08:44:38 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jongsung Kim <neidhard.kim@lge.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayun Hwang <hwang.hayun@lge.com>,
        Youngkyu Choi <youngkyu7.choi@lge.com>
Subject: Re: [PATCH] net/cadence/macb: clear interrupts simply and correctly
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(199002)(189002)(377424004)(51704005)(19580395003)(87936001)(83506001)(80022001)(85182001)(4396001)(74502001)(74662001)(33646001)(74316001)(20776003)(23676002)(46102001)(83322001)(79102001)(50466002)(47776003)(64706001)(85202002)(53416003)(6806004)(81542001)(44976005)(76482001)(19580405001)(50986999)(92726001)(85852003)(1496007)(86362001)(99396002)(83072002)(31696002)(54356999)(76176999)(81342001)(70736001)(77982001)(102836001)(104016001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB035;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:3;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jongsung,

On Thu, 2014-06-12 at 05:50PM +0900, Jongsung Kim wrote:
> The "Rx used bit read" interrupt is enabled but not cleared for some
> systems with the ISR (Interrupt Status Register) configured as clear-
> on-write.
Does this interrupt need to be enabled? There is nothing checking
that bit and handling this IRQ in the handler, AFAICT. And you solve
this by simply clearing the bit. So, I wonder whether not enabling this
IRQ in the first place would solve things too.

> This interrupt may be asserted when the CPU does not handle
> Rx-complete interrupts for a long time. (e.g., if the CPU is stopped
> by debugger) Once asserted, it'll not be cleared, and the CPU will
> loop infinitly in the interrupt handler.
> 
> This patch forces to use a dedicated function for reading the ISR,
> and the function clears it if clear-on-write. So the ISR is always
> cleared after read, regardless of clear-on-write configuration.
> 
> Reported-by: Hayun Hwang <hwang.hayun@lge.com>
> Signed-off-by: Youngkyu Choi <youngkyu7.choi@lge.com>
> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
> Tested-by: Hayun Hwang <hwang.hayun@lge.com>
> ---
>  drivers/net/ethernet/cadence/macb.c |   37 ++++++++++++++--------------------
>  1 files changed, 15 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index e9daa07..21cc022 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -98,6 +98,16 @@ static void *macb_rx_buffer(struct macb *bp, unsigned int index)
>  	return bp->rx_buffers + bp->rx_buffer_size * macb_rx_ring_wrap(index);
>  }
>  
> +static u32 macb_read_isr(struct macb *bp)
> +{
> +	u32 status = macb_readl(bp, ISR);
> +
> +	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +		macb_writel(bp, ISR, status);
> +
> +	return status;
> +}
> +
>  void macb_set_hwaddr(struct macb *bp)
>  {
>  	u32 bottom;
> @@ -552,9 +562,6 @@ static void macb_tx_interrupt(struct macb *bp)
>  	status = macb_readl(bp, TSR);
>  	macb_writel(bp, TSR, status);
>  
> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -		macb_writel(bp, ISR, MACB_BIT(TCOMP));
> -
>  	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
>  		(unsigned long)status);
>  
> @@ -883,13 +890,10 @@ static int macb_poll(struct napi_struct *napi, int budget)
>  
>  		/* Packets received while interrupts were disabled */
>  		status = macb_readl(bp, RSR);
This is now clearing all IRQ flags which is probably not what we want
here. This is handling RX only. We still want the non-RX interrupts to go to
the actual interrupt service routing.

	Sören
