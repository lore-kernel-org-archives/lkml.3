Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3HFAch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:32:37 -0400
Received: from mout.web.de ([212.227.17.11]:64035 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab3HFAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:32:36 -0400
Date: Tue, 6 Aug 2013 02:32:27 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>, linus.luessing@web.de
Subject: Re: [PATCH] bridge: don't try to update timers in case of broken MLD
 queries
Message-ID: <20130806003227.GH25436@Linus-Debian>
References: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
 <20130805154222.58361734@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130805154222.58361734@nehalam.linuxnetplumber.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:iRVjPVB2Fi8uFSjhq+MSjUWNoxEzLniqPFgEwgZPk8kzx/HxIAt
 P5QaEAiGGlow410aiKF4byxEpZyiuifLcjhlCfSZk5Of8W/LaIHmqF9P0KIVB+F/JzMgbPZ
 4KLDeFXeYJghwdGQag5Z74j0petjcZM601a5Gs7cZRGpgMXveyDlUE/P8CEhr6A84dBKt8R
 XIcdNmMSA4UMrTdzGH9kw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:42:22PM -0700, Stephen Hemminger wrote:
> On Tue,  6 Aug 2013 00:32:05 +0200
> Linus Lüssing <linus.luessing@web.de> wrote:
> 
> > Currently we are reading an uninitialized value for the max_delay
> > variable when snooping an MLD query message of invalid length and would
> > update our timers with that.
> > 
> > Fixing this by simply ignoring such broken MLD queries (just like we do
> > for IGMP already).
> > 
> > This is a regression introduced by:
> > "bridge: disable snooping if there is no querier" (b00589af3b04)
> > 
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> > ---
> >  net/bridge/br_multicast.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index 61c5e81..08e576a 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -1195,7 +1195,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
> >  		max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
> >  		if (max_delay)
> >  			group = &mld->mld_mca;
> > -	} else if (skb->len >= sizeof(*mld2q)) {
> > +	} else {
> >  		if (!pskb_may_pull(skb, sizeof(*mld2q))) {
> >  			err = -EINVAL;
> >  			goto out;
> 
> Why not use else if here, other than that looks great.

Because it isn't really necessary, it is basically included
in the pskb_may_pull() already, just like it is in the according IGMP
code path.

And I thought it'd be nicer to handle it the same way as in the
IGMP code path to avoid diverging too much.

Cheers, Linus
