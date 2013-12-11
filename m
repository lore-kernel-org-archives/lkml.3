Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3LKHzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:55:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3LKHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:55:33 -0500
Date: Wed, 11 Dec 2013 07:55:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 2/3] batman-adv: Use seq_overflow
Message-ID: <20131211075526.GR10323@ZenIV.linux.org.uk>
References: <cover.1386738050.git.joe@perches.com>
 <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:12:43PM -0800, Joe Perches wrote:

> diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
> index 2449afa..dfa5d2d 100644
> --- a/net/batman-adv/gateway_client.c
> +++ b/net/batman-adv/gateway_client.c
> @@ -517,29 +517,28 @@ static int batadv_write_buffer_text(struct batadv_priv *bat_priv,
>  {
>  	struct batadv_gw_node *curr_gw;
>  	struct batadv_neigh_node *router;
> -	int ret = -1;
>  
>  	router = batadv_orig_node_get_router(gw_node->orig_node);
>  	if (!router)
> -		goto out;
> +		return -1;

This (as well as the original) means "fail read(2) with -EINVAL", which
might or might not be correct behaviour.

>  	curr_gw = batadv_gw_get_selected_gw_node(bat_priv);
>  
> -	ret = seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %u.%u/%u.%u MBit\n",
> -			 (curr_gw == gw_node ? "=>" : "  "),
> -			 gw_node->orig_node->orig,
> -			 router->bat_iv.tq_avg, router->addr,
> -			 router->if_incoming->net_dev->name,
> -			 gw_node->bandwidth_down / 10,
> -			 gw_node->bandwidth_down % 10,
> -			 gw_node->bandwidth_up / 10,
> -			 gw_node->bandwidth_up % 10);
> +	seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %u.%u/%u.%u MBit\n",
> +		   (curr_gw == gw_node ? "=>" : "  "),
> +		   gw_node->orig_node->orig,
> +		   router->bat_iv.tq_avg, router->addr,
> +		   router->if_incoming->net_dev->name,
> +		   gw_node->bandwidth_down / 10,
> +		   gw_node->bandwidth_down % 10,
> +		   gw_node->bandwidth_up / 10,
> +		   gw_node->bandwidth_up % 10);
>  
>  	batadv_neigh_node_free_ref(router);
>  	if (curr_gw)
>  		batadv_gw_node_free_ref(curr_gw);
> -out:
> -	return ret;
> +
> +	return seq_overflow(seq);

... and this is utter junk.

This sucker should return 0.  Insufficiently large buffer will be handled
by caller, TYVM, if you give that caller a chance to do so.  Returning 1
from ->show() is a bug in almost all cases, and definitely so in this one.

Just in case somebody decides that above is worth copying: It Is Not.
Original code is buggy, plain and simple.  This one trades the older
bug ("fail with -EINVAL whenever the buffer is too small") with just as buggy
"silently skip an entry entirely whenever the buffer is too small".

Don't Do That.
