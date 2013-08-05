Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3HEIlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:41:11 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:63678 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813Ab3HEIlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:41:09 -0400
Message-ID: <1375692066.25148.14.camel@x61.thuisdomein>
Subject: Re: [PATCHv3] bridge: disable snooping if there is no querier
From: Paul Bolle <pebolle@tiscali.nl>
To: David Miller <davem@davemloft.net>
Cc: linus.luessing@web.de, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        amwang@redhat.com, linux@baker-net.org.uk
Date: Mon, 05 Aug 2013 10:41:06 +0200
In-Reply-To: <20130731.174037.1794753574143053874.davem@davemloft.net>
References: <20130730.161035.1646022729333223847.davem@davemloft.net>
	 <1375311980-25575-1-git-send-email-linus.luessing@web.de>
	 <20130731.174037.1794753574143053874.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Aug 2013 08:41:07.0259 (UTC) FILETIME=[872318B0:01CE91B7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 17:40 -0700, David Miller wrote:
> > If there is no querier on a link then we won't get periodic reports and
> > therefore won't be able to learn about multicast listeners behind ports,
> > potentially leading to lost multicast packets, especially for multicast
> > listeners that joined before the creation of the bridge.
> > 
> > These lost multicast packets can appear since c5c23260594
> > ("bridge: Add multicast_querier toggle and disable queries by default")
> > in particular.
> > 
> > With this patch we are flooding multicast packets if our querier is
> > disabled and if we didn't detect any other querier.
> > 
> > A grace period of the Maximum Response Delay of the querier is added to
> > give multicast responses enough time to arrive and to be learned from
> > before disabling the flooding behaviour again.
> > 
> > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> 
> Looks good, applied, thanks Linus.

0) This patch is part of v3.11-rc4 as commit b00589af3b0. It introduced
a GCC warning:
    net/bridge/br_multicast.c: In function ‘br_multicast_rcv’:
    net/bridge/br_multicast.c:1081:36: warning: ‘max_delay’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    net/bridge/br_multicast.c:1178:16: note: ‘max_delay’ was declared here

1) Summarized, the code reads:

        unsigned long max_delay;

        if (skb->len == sizeof(*mld))
                max_delay = msecs_to_jiffies(ntohs(mld->mld_maxdelay));
        else if (skb->len >= sizeof(*mld2q))
                max_delay = mld2q->mld2q_mrc ? MLDV2_MRC(ntohs(mld2q->mld2q_mrc)) : 1;

        br_multicast_query_received(br, port, !ipv6_addr_any(&ip6h->saddr),
                                    max_delay);
 
So GCC notices that max_delay is still uninitialized if skb->len is
neither equal to sizeof(*mld) nor equal or bigger than sizeof(*mld2q).
To me it looks GCC is right here. At least, it is not obvious that
max_delay will actually not be used in br_multicast_query_received() if
it still is uninitialized.

2) I'm entirely unfamiliar to this code. So I can't say how this warning
might be silenced.


Paul Bolle

