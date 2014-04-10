Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934377AbaDJAtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:49:07 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:29584
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932996AbaDJAtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:49:06 -0400
Message-ID: <1397090916.20280.36.camel@snotra.buserror.net>
Subject: Re: [PATCH RT 2/2] net: gianfar: do not try to cleanup TX packets
 if they are not done
From: Scott Wood <scottwood@freescale.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Claudiu Manoil" <claudiu.manoil@freescale.com>
Date: Wed, 9 Apr 2014 19:48:36 -0500
In-Reply-To: <1396004220-5711-2-git-send-email-bigeasy@linutronix.de>
References: <1396004220-5711-1-git-send-email-bigeasy@linutronix.de>
	 <1396004220-5711-2-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR04CA006.namprd04.prod.outlook.com (10.141.96.16) To
 BLUPR03MB389.namprd03.prod.outlook.com (10.141.78.11)
X-Forefront-PRVS: 0177904E6B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(377424004)(24454002)(81342001)(33646001)(50986999)(76176999)(81542001)(50466002)(77156001)(31966008)(74662001)(74502001)(4396001)(87286001)(89996001)(50226001)(88136002)(85852003)(46102001)(83072002)(87976001)(76482001)(42186004)(23676002)(80022001)(92566001)(19580395003)(86362001)(19580405001)(80976001)(83322001)(92726001)(62966002)(93916002)(20776003)(47776003)(79102001)(99396002)(77982001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:BCB6FA4E.2D3AAD28.69EB9BB5.86405164.202D4;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 11:57 +0100, Sebastian Andrzej Siewior wrote:
> What I observe is that the TX queue is not empty and does not make any
> progress. gfar_clean_tx_ring() does not clean up the packet because it
> is not completed yet.
> The root cause is that the DMA engine did not start yet (it was
> preempted before doing so) and that dumb loop, loops until that packet
> is gone.
> This is broken since c233cf4 ("gianfar: Fix tx napi polling").
> 
> What remains are spurious interrupts if CPU0 cleans up TX packages and
> CPU1 returns with IRQ_NONE.
> 
> Cc: stable-rt@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Why is this only being sent to RT and not to netdev for mainline?

> ---
>  drivers/net/ethernet/freescale/gianfar.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 8f1afda..091945c 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -134,7 +134,6 @@ static int gfar_poll_sq(struct napi_struct *napi, int budget);
>  static void gfar_netpoll(struct net_device *dev);
>  #endif
>  int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit);
> -static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue);
>  static void gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
>  			       int amount_pull, struct napi_struct *napi);
>  void gfar_halt(struct net_device *dev);
> @@ -2516,7 +2515,7 @@ static void gfar_align_skb(struct sk_buff *skb)
>  }
>  
>  /* Interrupt Handler for Transmit complete */
> -static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
> +static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
>  {
>  	struct net_device *dev = tx_queue->dev;
>  	struct netdev_queue *txq;
> @@ -2939,10 +2938,14 @@ static int gfar_poll(struct napi_struct *napi, int budget)

You changed the return from void to int, but you never added any return
statement.  GCC should have warned you about this...

-Scott


