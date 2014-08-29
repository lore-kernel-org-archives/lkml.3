Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaH2RUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:20:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbaH2RUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:20:54 -0400
Date: Fri, 29 Aug 2014 10:20:45 -0700
From: Benjamin Poirier <bpoirier@suse.de>
To: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
Message-ID: <20140829172045.GA1245@f1.synalogic.ca>
References: <1409187858-7698-1-git-send-email-bpoirier@suse.de>
 <1409187858-7698-4-git-send-email-bpoirier@suse.de>
 <1409282668.12635.21.camel@prashant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409282668.12635.21.camel@prashant>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/08/28 20:24, Prashant Sreedharan wrote:
> >  
> > -	for (i = 0; i < tp->irq_max; i++)
> > -		tp->napi[i].tx_pending = ering->tx_pending;
> > +	dev->gso_max_segs = TG3_TX_SEG_PER_DESC(ering->tx_pending - 1);
> > +	for (i = 0; i < tp->irq_max; i++) {
> > +		struct tg3_napi *tnapi = &tp->napi[i];
> > +
> > +		tnapi->tx_pending = ering->tx_pending;
> > +		if (netif_tx_queue_stopped(netdev_get_tx_queue(dev, i)) &&
> 
> Need to limit the number of TX queues to tp->txq_cnt instead of
> tp->irq_max as txq_cnt can be less than irq_max.
> 
> netif_set_real_num_tx_queues(tp->dev, tp->txq_cnt);

Thanks for your careful review, I'll resubmit shortly.

> 
> > +		    tnapi->wakeup_thresh >= ering->tx_pending)
> > +			tnapi->wakeup_thresh = MAX_SKB_FRAGS + 1;
> > +	}
> >  
> 
> 
> 
