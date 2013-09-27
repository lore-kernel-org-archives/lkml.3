Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3I0Ihe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:37:34 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:54641 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3I0Ihb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:37:31 -0400
Date: Fri, 27 Sep 2013 10:37:30 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <oghorbell@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
Message-ID: <20130927083730.GC28287@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <oghorbell@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1380207108-20030-1-git-send-email-oghorbell@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1380207108-20030-1-git-send-email-oghorbell@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 03:51:48PM +0100, Oussama Ghorbel wrote:
> The (inner) MTU of a ipip6 (IPv4-in-IPv6) tunnel cannot be set below 1280, which is the minimum MTU in IPv6.
> However, there should be no IPv6 on the tunnel interface at all, so the IPv6 rules should not apply.
> More info at https://bugzilla.kernel.org/show_bug.cgi?id=15530
> 
> This patch allows to check the minimum MTU for ipv6 tunnel according to these rules:
>  -In case the tunnel is configured with ipip6 mode the minimum MTU is 68.
>  -In case the tunnel is configured with ip6ip6 or any mode the minimum MTU is 1280.
> 
> Signed-off-by: Oussama Ghorbel <oghorbell@gmail.com>
> ---
>  net/ipv6/ip6_tunnel.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 1e55866..a66ead2 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1423,8 +1423,14 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  static int
>  ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
>  {
> -	if (new_mtu < IPV6_MIN_MTU) {
> -		return -EINVAL;
> +	struct ip6_tnl *t = netdev_priv(dev);
> +
> +	if (t->parms.proto == IPPROTO_IPIP) {
> +		if (new_mtu < 68)
> +			return -EINVAL;

Maybe you could have a look at ip_tunnel_change_mtu in ipv4/ip_tunnel.c,
generalize this check as e.g. ip_tunnel_valid_mtu or something and use it
here? Maybe an af-independent ip_tunnel_max_mtu()?

> +	} else {
> +		if (new_mtu < IPV6_MIN_MTU)
> +			return -EINVAL;

This check could also be used here, then.

>  	}
>  	dev->mtu = new_mtu;
>  	return 0;

Thanks,

  Hannes

