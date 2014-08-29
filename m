Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaH2DdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:33:18 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41621 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaH2DdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:33:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,422,1406617200"; 
   d="scan'208";a="43978403"
Subject: Re: [PATCH net v4 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
From: Prashant Sreedharan <prashant@broadcom.com>
To: Benjamin Poirier <bpoirier@suse.de>
CC: Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1409187858-7698-4-git-send-email-bpoirier@suse.de>
References: <1409187858-7698-1-git-send-email-bpoirier@suse.de>
	 <1409187858-7698-4-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Aug 2014 20:24:28 -0700
Message-ID: <1409282668.12635.21.camel@prashant>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> -	for (i = 0; i < tp->irq_max; i++)
> -		tp->napi[i].tx_pending = ering->tx_pending;
> +	dev->gso_max_segs = TG3_TX_SEG_PER_DESC(ering->tx_pending - 1);
> +	for (i = 0; i < tp->irq_max; i++) {
> +		struct tg3_napi *tnapi = &tp->napi[i];
> +
> +		tnapi->tx_pending = ering->tx_pending;
> +		if (netif_tx_queue_stopped(netdev_get_tx_queue(dev, i)) &&

Need to limit the number of TX queues to tp->txq_cnt instead of
tp->irq_max as txq_cnt can be less than irq_max.

netif_set_real_num_tx_queues(tp->dev, tp->txq_cnt);

> +		    tnapi->wakeup_thresh >= ering->tx_pending)
> +			tnapi->wakeup_thresh = MAX_SKB_FRAGS + 1;
> +	}
>  



