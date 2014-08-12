Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaHLMd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:33:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:51231 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHLMdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:33:25 -0400
Date: Tue, 12 Aug 2014 16:33:20 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrey Vagin <avagin@openvz.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tcp: don't use timestamp from repaired skb-s to
 calculate RTT
Message-ID: <20140812123320.GA27421@paralelels.com>
References: <1407836714-26813-1-git-send-email-avagin@openvz.org>
 <1407845701.10122.60.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <1407845701.10122.60.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 05:15:01AM -0700, Eric Dumazet wrote:
> On Tue, 2014-08-12 at 13:45 +0400, Andrey Vagin wrote:
> > We don't know right timestamp for repaired skb-s. Wrong RTT estimations
> > isn't good, because some congestion modules heavily depends on it.
> > 
> > This patch adds the TCPCB_REPAIRED flag, which is included in
> > TCPCB_RETRANS.
> 
> ...
> 
> > +
> > +				/* All packets are restored as if they have
> > +				 * already been sent. skb_mstamp isn't set to
> > +				 * avoid wrong rtt estimation.
> > +				 */
> > +				if (tp->repair) {
> > +					TCP_SKB_CB(skb)->sacked |= TCPCB_REPAIRED;
> > +					TCP_SKB_CB(skb)->when = tcp_time_stamp;
> > +				}
> >  			}
> >  
> >  			/* Try to append data to the end of skb. */
> 
> 
> Are you sure TCP_SKB_CB(skb)->when needs to be set ?

It's used in tcp_rearm_rto() for calculating a retransmit timeout.
...
	const u32 rto_time_stamp = TCP_SKB_CB(skb)->when + rto;
	s32 delta = (s32)(rto_time_stamp - tcp_time_stamp);
...

"when" is used as a start point, so I think it's acceptable here.

I will add a comment. Thanks.

> 
> It should not anymore.
> 
> If yes, I believe a comment would help a lot here.
> 
> Also, please include this tag to ease stable backports (3.15+) :
> 
> Fixes: 431a91242d8d ("tcp: timestamp SYN+DATA messages")
> Fixes: 740b0f1841f6 ("tcp: switch rtt estimations to usec resolution")

Thanks,
Andrew
