Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3DXMXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:23:43 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:45720 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3DXMXm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:23:42 -0400
Date: Wed, 24 Apr 2013 14:23:37 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>
cc: netdev@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: gre: Support GRE over IPv6
In-Reply-To: <20121002205219.7C3BD340556@ra.kernel.org>
Message-ID: <alpine.DEB.2.00.1304241417570.21513@ayla.of.borg>
References: <20121002205219.7C3BD340556@ra.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=c12b395a46646bab69089ce7016ac78177f6001f
> Commit:     c12b395a46646bab69089ce7016ac78177f6001f
> Parent:     b7bc2a5b5bd99b216c3e5fe68c7f45c684ab5745
> Author:     xeb@mail.ru <xeb@mail.ru>
> AuthorDate: Fri Aug 10 00:51:50 2012 +0000
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Tue Aug 14 14:28:32 2012 -0700
> 
>     gre: Support GRE over IPv6
>     
>     GRE over IPv6 implementation.
>     
>     Signed-off-by: Dmitry Kozlov <xeb@mail.ru>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

> --- /dev/null
> +++ b/net/ipv6/ip6_gre.c

> +static netdev_tx_t ip6gre_xmit2(struct sk_buff *skb,
> +			 struct net_device *dev,
> +			 __u8 dsfield,
> +			 struct flowi6 *fl6,
> +			 int encap_limit,
> +			 __u32 *pmtu)
> +{
> +	struct net *net = dev_net(dev);
> +	struct ip6_tnl *tunnel = netdev_priv(dev);
> +	struct net_device *tdev;    /* Device to other host */
> +	struct ipv6hdr  *ipv6h;     /* Our new IP header */
> +	unsigned int max_headroom;  /* The extra header space needed */

max_headroom is not initialized

> +	mtu = dst_mtu(dst) - sizeof(*ipv6h);
> +	if (encap_limit >= 0) {
> +		max_headroom += 8;

Hence gcc (4.1.2) rightfully complains:

net/ipv6/ip6_gre.c: In function ‘ip6gre_xmit2’:
net/ipv6/ip6_gre.c:713: warning: ‘max_headroom’ is used uninitialized in this function

However, initializing max_headroom to zero at the top, or replacing the line
above by "max_headroom = 8" doesn't seem to be the right fix...

> +		mtu -= 8;
> +	}
> +	if (mtu < IPV6_MIN_MTU)
> +		mtu = IPV6_MIN_MTU;
> +	if (skb_dst(skb))
> +		skb_dst(skb)->ops->update_pmtu(skb_dst(skb), NULL, skb, mtu);
> +	if (skb->len > mtu) {
> +		*pmtu = mtu;
> +		err = -EMSGSIZE;
> +		goto tx_err_dst_release;
> +	}
> +
> +	if (tunnel->err_count > 0) {
> +		if (time_before(jiffies,
> +				tunnel->err_time + IP6TUNNEL_ERR_TIMEO)) {
> +			tunnel->err_count--;
> +
> +			dst_link_failure(skb);
> +		} else
> +			tunnel->err_count = 0;
> +	}
> +
> +	max_headroom = LL_RESERVED_SPACE(tdev) + gre_hlen + dst->header_len;

... as max_headroom is overwritten here anyway?

So something is really wrong here. What is the right fix?

This issue is present in current mainline as of v3.7.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
