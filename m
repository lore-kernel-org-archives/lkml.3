Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaH2CyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:54:17 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:46107 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaH2CyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:54:15 -0400
X-IronPort-AV: E=Sophos;i="5.04,422,1406617200"; 
   d="scan'208";a="43786758"
Subject: Re: [PATCH net v4 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: Prashant Sreedharan <prashant@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1409187858-7698-4-git-send-email-bpoirier@suse.de>
References: <1409187858-7698-1-git-send-email-bpoirier@suse.de>
	 <1409187858-7698-4-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Aug 2014 19:45:43 -0700
Message-ID: <1409280343.12635.16.camel@prashant>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  	if (netif_running(dev)) {
> @@ -12346,8 +12380,15 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
>  	if (tg3_flag(tp, JUMBO_RING_ENABLE))
>  		tp->rx_jumbo_pending = ering->rx_jumbo_pending;
>  
> -	for (i = 0; i < tp->irq_max; i++)
> -		tp->napi[i].tx_pending = ering->tx_pending;
> +	dev->gso_max_segs = TG3_TX_SEG_PER_DESC(ering->tx_pending - 1);
> +	for (i = 0; i < tp->irq_max; i++) {
> +		struct tg3_napi *tnapi = &tp->napi[i];
> +
> +		tnapi->tx_pending = ering->tx_pending;
> +		if (netif_tx_queue_stopped(netdev_get_tx_queue(dev, i)) &&
> +		    tnapi->wakeup_thresh >= ering->tx_pending)
> +			tnapi->wakeup_thresh = MAX_SKB_FRAGS + 1;

To maintain consistency wakeup_thresh can be set to TG3_TX_WAKEUP_THRESH
similar to other parts of the code, except the special handling of
tg3_tso_bug() estimate.
 
> +	}
>  
>  	if (netif_running(dev)) {
>  		tg3_halt(tp, RESET_KIND_SHUTDOWN, 1);
> @@ -17822,6 +17863,7 @@ static int tg3_init_one(struct pci_dev *pdev,
>  		else
>  			sndmbx += 0xc;
>  	}


