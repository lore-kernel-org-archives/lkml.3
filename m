Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaHZTZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:25:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaHZTZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:25:35 -0400
Date: Tue, 26 Aug 2014 12:25:21 -0700
From: Benjamin Poirier <bpoirier@suse.de>
To: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] tg3: Fix tx_pending checks for tg3_tso_bug
Message-ID: <20140826192521.GA4745@f1.synalogic.ca>
References: <1408658240-6811-1-git-send-email-bpoirier@suse.de>
 <1408658240-6811-3-git-send-email-bpoirier@suse.de>
 <1408749447.8268.53.camel@prashant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408749447.8268.53.camel@prashant>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/08/22 16:17, Prashant Sreedharan wrote:
> Benjamin, thanks for the patch. Broadcom QA will be testing the changes.
> Couple of comments below.
> >  	segs = skb_gso_segment(skb, tp->dev->features &
> >  				    ~(NETIF_F_TSO | NETIF_F_TSO6));
> > -	if (IS_ERR(segs) || !segs)
> > +	if (IS_ERR_OR_NULL(segs))
> >  		goto tg3_tso_bug_end;
> >  
> >  	do {
> > +		unsigned int desc_cnt = skb_shinfo(segs)->nr_frags + 1;
> > +
> >  		nskb = segs;
> >  		segs = segs->next;
> >  		nskb->next = NULL;
> > -		tg3_start_xmit(nskb, tp->dev);
> > +
> > +		if (tg3_tx_avail(tnapi) <= segs_remaining - 1 + desc_cnt &&
> > +		    skb_linearize(nskb)) {
> > +			nskb->next = segs;
> > +			segs = nskb;
> > +			do {
> > +				nskb = segs->next;
> > +
> > +				dev_kfree_skb_any(segs);
> > +				segs = nskb;
> > +			} while (segs);
> 
> If skb_linearize() fails need to increment the tp->tx_dropped count

Sorry for the delay, while testing this error path I noticed a potential
problem. There should be an additional check here to stop the queue with
the default threshold. Otherwise, the netdev_err message at the start of
__tg3_start_xmit() could be triggered when the next frame is
transmitted. That is because the previous calls to __tg3_start_xmit() in
tg3_tso_bug() may have been using a stop_thresh=segs_remaining that is <
MAX_SKB_FRAGS + 1.

> 
> > +			goto tg3_tso_bug_end;
> > +		}
> > +		segs_remaining--;
> > +		if (segs_remaining)
> > +			__tg3_start_xmit(nskb, tp->dev, segs_remaining);
> 
> To clarify passing segs_remaining will make sure the queue is never
> stopped correct ?

It makes sure the queue is not stopped before we are finished submitting
all gso segments.

This is what's alluded to in this part of the commit message:
	This puts us in the exceptional situation that a single skb that
	triggers tg3_tso_bug() may require the entire tx ring. [...]
	Likewise, usually the tx queue is stopped as soon as an skb with
	max frags may overrun it. Since the skbs submitted from
	tg3_tso_bug() use a controlled number of descriptors, the tx
	queue stop threshold may be lowered.

> 
> > +		else
> > +			tg3_start_xmit(nskb, tp->dev);
> >  	} while (segs);
> >  
> 
> 
