Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JDNc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:32:27 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:40634 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3JDNcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:32:25 -0400
Date: Fri, 4 Oct 2013 15:32:23 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Oussama Ghorbel <ou.ghorbel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] IPv6: Allow the MTU of ipip6 tunnel to be set below 1280
Message-ID: <20131004133223.GA11410@order.stressinduktion.org>
Mail-Followup-To: Oussama Ghorbel <ou.ghorbel@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1380808166-13280-1-git-send-email-ou.ghorbel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1380808166-13280-1-git-send-email-ou.ghorbel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:49:26PM +0100, Oussama Ghorbel wrote:
> The (inner) MTU of a ipip6 (IPv4-in-IPv6) tunnel cannot be set below 1280, which is the minimum MTU in IPv6.
> However, there should be no IPv6 on the tunnel interface at all, so the IPv6 rules should not apply.
> More info at https://bugzilla.kernel.org/show_bug.cgi?id=15530
> 
> This patch allows to check the minimum MTU for ipv6 tunnel according to these rules:
> -In case the tunnel is configured with ipip6 mode the minimum MTU is 68.
> -In case the tunnel is configured with ip6ip6 or any mode the minimum MTU is 1280.
> 
> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>
> ---
>  net/ipv6/ip6_tunnel.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index 46ba243..4b51b03 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -1429,9 +1429,17 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  static int
>  ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
>  {
> -	if (new_mtu < IPV6_MIN_MTU) {
> -		return -EINVAL;
> +	struct ip6_tnl *tnl = netdev_priv(dev);
> +
> +	if (tnl->parms.proto == IPPROTO_IPIP) {
> +		if (new_mtu < 68)
> +			return -EINVAL;
> +	} else {
> +		if (new_mtu < IPV6_MIN_MTU)
> +			return -EINVAL;
>  	}
> +	if (new_mtu > 0xFFF8 - dev->hard_header_len)
> +		return -EINVAL;
>  	dev->mtu = new_mtu;
>  	return 0;
>  }

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Anytime soon we should replace all the FFF8 with a symbolic constant.

Thanks,

  Hannes

