Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3HEWlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:41:10 -0400
Received: from mout.web.de ([212.227.15.4]:50166 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab3HEWlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:41:09 -0400
Date: Tue, 6 Aug 2013 00:40:59 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Miller <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        amwang@redhat.com, linux@baker-net.org.uk, linus.luessing@web.de
Subject: Re: [PATCHv3] bridge: disable snooping if there is no querier
Message-ID: <20130805224059.GG25436@Linus-Debian>
References: <20130730.161035.1646022729333223847.davem@davemloft.net>
 <1375311980-25575-1-git-send-email-linus.luessing@web.de>
 <20130731.174037.1794753574143053874.davem@davemloft.net>
 <1375692066.25148.14.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375692066.25148.14.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:rwkTRBzDOC6URNrX0rO0Y/SMr3MpkRlW5JLCowAYfXSQTiEPSIz
 LNWaLO0Q3vF2q85ZrwQE91SOGd6VreNPqLOyhHu4LQ2RquY74tHbER+7Tm3xlQd0177Ca+B
 BHT428ZyF4uGDcrDH0rd2G6xyGsHm6tAHSA32jPJ2/djnlyp7oPiDx/mLzR1CcA3DZIqlyi
 v5bs/kYNH2OrawtRDGYzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the very quick reporting! Looks like my gcc was and still
isn't as supportive... You and the lists should have received a patch
to fix that.

Cheers, Linus


On Mon, Aug 05, 2013 at 10:41:06AM +0200, Paul Bolle wrote:
> On Wed, 2013-07-31 at 17:40 -0700, David Miller wrote:
> > > If there is no querier on a link then we won't get periodic reports and
> > > therefore won't be able to learn about multicast listeners behind ports,
> > > potentially leading to lost multicast packets, especially for multicast
> > > listeners that joined before the creation of the bridge.
> > > 
> > > These lost multicast packets can appear since c5c23260594
> > > ("bridge: Add multicast_querier toggle and disable queries by default")
> > > in particular.
> > > 
> > > With this patch we are flooding multicast packets if our querier is
> > > disabled and if we didn't detect any other querier.
> > > 
> > > A grace period of the Maximum Response Delay of the querier is added to
> > > give multicast responses enough time to arrive and to be learned from
> > > before disabling the flooding behaviour again.
> > > 
> > > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> > 
> > Looks good, applied, thanks Linus.
> 
> 0) This patch is part of v3.11-rc4 as commit b00589af3b0. It introduced
> a GCC warning:
>     net/bridge/br_multicast.c: In function ‘br_multicast_rcv’:
>     net/bridge/br_multicast.c:1081:36: warning: ‘max_delay’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     net/bridge/br_multicast.c:1178:16: note: ‘max_delay’ was declared here
> 
> 1) Summarized, the code reads:
> 
>         unsigned long max_delay;
> 
>         if (skb->len == sizeof(*mld))
>                 max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
>         else if (skb->len >= sizeof(*mld2q))
>                 max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(ntohs(mld2q->mld2q_mrc)) : 1;
> 
>         br_multicast_query_received(br, port, !ipv6_addr_any(&ip6h->saddr),
>                                     max_delay);
>  
> So GCC notices that max_delay is still uninitialized if skb->len is
> neither equal to sizeof(*mld) nor equal or bigger than sizeof(*mld2q).
> To me it looks GCC is right here. At least, it is not obvious that
> max_delay will actually not be used in br_multicast_query_received() if
> it still is uninitialized.
> 
> 2) I'm entirely unfamiliar to this code. So I can't say how this warning
> might be silenced.
> 
> 
> Paul Bolle
> 
