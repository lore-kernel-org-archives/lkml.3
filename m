Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaCDJGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:06:30 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:38604 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbaCDJGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:06:16 -0500
Date: Tue, 4 Mar 2014 10:06:14 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Subject: Re: [PATCH] bridge: multicast: add sanity check for query source addresses
Message-ID: <20140304090614.GA3952@order.stressinduktion.org>
Mail-Followup-To: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>,
	netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
	Florian Westphal <fwestpha@redhat.com>
References: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393901855-18231-1-git-send-email-linus.luessing@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 03:57:35AM +0100, Linus Lüssing wrote:
> MLD queries are supposed to have an IPv6 link-local source address
> according to RFC2710, section 4 and RFC3810, section 5.1.14. This patch
> adds a sanity check to ignore such broken MLD queries.
> 
> Without this check, such malformed MLD queries can result in a
> denial of service: The queries are ignored by any MLD listener
> therefore they will not respond with an MLD report. However,
> without this patch these malformed MLD queries would enable the
> snooping part in the bridge code, potentially shutting down the
> according ports towards these hosts for multicast traffic as the
> bridge did not learn about these listeners.
> 
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>
> ---
>  net/bridge/br_multicast.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index ef66365..fb0e36f 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1235,6 +1235,12 @@ static int br_ip6_multicast_query(struct net_bridge *br,
>  	    (port && port->state == BR_STATE_DISABLED))
>  		goto out;
>  
> +	/* RFC2710+RFC3810 (MLDv1+MLDv2) require link-local source addresses */
> +	if (!(ipv6_addr_type(&ip6h->saddr) & IPV6_ADDR_LINKLOCAL)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +

Shouldn't we allow empty source address, here?

Routers are supposed to drop them but bridges care. Linux uses ::
as source address as long as no valid LL addresses are available,
e.g. at boot-up (RFC3810 5.2.13.).

Greetings,

  Hannes

