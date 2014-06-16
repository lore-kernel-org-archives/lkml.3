Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaFPV2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:28:54 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:2043
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755880AbaFPV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:28:52 -0400
Date: Mon, 16 Jun 2014 14:28:47 -0700
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
Message-ID: <7e888b59-d27b-49dc-9ffc-1c7d56f11773@BN1AFFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(199002)(189002)(51704005)(24454002)(50986999)(99396002)(102836001)(85852003)(83072002)(76176999)(80022001)(54356999)(87936001)(85182001)(85202002)(1496007)(33646001)(83506001)(70736001)(64706001)(47776003)(31966008)(20776003)(74662001)(74502001)(81342001)(79102001)(76482001)(6806004)(50466002)(53416004)(77096002)(44976005)(19580395003)(81542001)(19580405001)(83322001)(23676002)(77982001)(46102001)(21056001)(86362001)(31696002)(92726001)(92566001)(74316001)(4396001)(85306003)(104016002)(95666004)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB051;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 05:50PM +0900, Jongsung Kim wrote:
> The "Rx used bit read" interrupt is enabled but not cleared for some
> systems with the ISR (Interrupt Status Register) configured as clear-
> on-write. This interrupt may be asserted when the CPU does not handle
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
[...]
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
> -		if (status) {
> -			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -				macb_writel(bp, ISR, MACB_BIT(RCOMP));
> +		if (status)
>  			napi_reschedule(napi);
> -		} else {
> +		else
>  			macb_writel(bp, IER, MACB_RX_INT_FLAGS);
> -		}
>  	}
>  
>  	/* TODO: Handle errors */
> @@ -903,7 +907,7 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  	struct macb *bp = netdev_priv(dev);
>  	u32 status;
>  
> -	status = macb_readl(bp, ISR);
> +	status = macb_read_isr(bp);
>  
>  	if (unlikely(!status))
>  		return IRQ_NONE;
> @@ -928,8 +932,6 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  			 * now.
>  			 */
>  			macb_writel(bp, IDR, MACB_RX_INT_FLAGS);
> -			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> -				macb_writel(bp, ISR, MACB_BIT(RCOMP));
Shouldn't it be sufficient to replace 'MACB_BIT(RCOMP) with 'MACB_RX_INT_FLAGS'
to clear all the RX IRQ flags.

	Sören
