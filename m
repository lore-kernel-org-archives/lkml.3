Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3G0Pyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:54:41 -0400
Received: from mout.web.de ([212.227.15.14]:50370 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3G0Pyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:54:39 -0400
Date: Sat, 27 Jul 2013 17:54:30 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Adam Baker <linux@baker-net.org.uk>
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>
Subject: Re: [PATCHv2] bridge: disable snooping if there is no querier
Message-ID: <20130727155429.GE11914@Linus-Debian>
References: <1374757046-12463-1-git-send-email-linus.luessing@web.de>
 <1374760580-12920-1-git-send-email-linus.luessing@web.de>
 <51F2F5D4.50409@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51F2F5D4.50409@baker-net.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:6aia9Ntxb7r938IO0j5yqnk6uXpLwanKFiZxdqCdLitlrQac0MI
 exkXavAEoQzhARgmgCSWqpy+TDLHK/1qdpDbGHPdBKBR7vWKExDq4ZcUJTzLCrV6RhCWlLt
 HSHq20uj2QGm4Y0+YLizlUnJEVuEL+a40IF2iUjUsEvz4hAdfXdTeqhAj4BDMXgrTn492Ic
 WPdBELjHjWOaHp1NWTFFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:19:00PM +0100, Adam Baker wrote:
> On 25/07/13 14:56, Linus Lüssing wrote:
> >If there is no querier on a link then we won't get periodic reports and
> >therefore won't be able to learn about multicast listeners behind ports,
> >potentially leading to lost multicast packets, especially for multicast
> >listeners that joined before the creation of the bridge.
> >
> >These lost multicast packets can appear since c5c23260594
> >("bridge: Add multicast_querier toggle and disable queries by default")
> >in particular.
> >
> >With this patch we are flooding multicast packets if our querier is
> >disabled and if we didn't detect any other querier.
> >
> >A grace period of the Maximum Response Delay of the querier is added to
> >give multicast responses enough time to arrive and to be learned from
> >before disabling the flooding behaviour again.
> >
> >Signed-off-by: Linus Lüssing<linus.luessing@web.de>
> 
> If the lack of queries if there is no other querier is unacceptable
> to the majority of users (and I believe it is) then surely the
> sensible option is to have the multicast querier toggle enabled by
> default.
> 
> The toggle was added in the first place because the queries were
> reported to be generating issues with certain other equipment. This
> may have been because the queries by default have an invalid IP
> address (although I have been unable to identify what equipment they
> caused problems with so can't verify this).
> 
> If the only reason to turn the querier off is because it interferes
> with other equipment then the solution to it being off by default
> isn't to generate queries in some instances even if it is off but
> rather to turn it on by default and only turn it off if it causes
> problems. If multicast_query_use_ifaddr was also enabled by default
> the the likelihood of the querier causing problems elsewhere should
> be reduced.
> 
> Regards
> 
> Adam

One more, general disadvantage I could see is, that in a network
with multiple bridges basically a random one would become the querier
and the according network segment would get hit by all the
according multicast traffic. If the available bandwidth of links
on your network varies, then you however usually want to have the
querier in a "good" position of your network. Which might be a
little harder to control if the querier is on by default.

Also this specific, current querier implementation has two more
disadvantages: 
* It's doing MLDv1/IGMPv2 queries, so it downgrades our whole
  network to MLDv1/IGMPv2, no MLDv2/IGMPv3 and source specific
  multicast could be used.
* The querier selection is not RFC compliant (we should refrain
  from sending queries if our address is higher, not if we hear
  any query)

Cheers, Linus
