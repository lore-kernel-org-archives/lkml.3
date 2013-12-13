Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3LMQsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:48:43 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:44617 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3LMQsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:48:41 -0500
Message-ID: <52AB3A63.6050609@gmail.com>
Date: Fri, 13 Dec 2013 11:48:35 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: davem@davemloft.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, jpirko@redhat.com
Subject: Re: [patch net-next v3] ipv6: log autoconfiguration failures
References: <1386949547-23457-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1386949547-23457-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 10:45 AM, Denys Vlasenko wrote:
> If ipv6 auto-configuration does not work, currently it's hard
> to track what's going on. This change adds log messages
> (at debug level) on every code path where ipv6 autoconf fails.
> 
> v3: changed pr_debug's to pr_warn's.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> ---
>  net/ipv6/addrconf.c | 45 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3c3425e..0b354f0 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1694,8 +1694,11 @@ static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
>  
>  static int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
>  {
> -	if (dev->addr_len != ETH_ALEN)
> +	if (dev->addr_len != ETH_ALEN) {
> +		pr_warn("IPv6 addrconf: %s: address length %d != %s\n",
> +			dev->name, dev->addr_len, "ETH_ALEN");
>  		return -1;
> +	}
>  	memcpy(eui, dev->dev_addr, 3);
>  	memcpy(eui + 5, dev->dev_addr + 3, 3);
>  
> @@ -1725,8 +1728,11 @@ static int addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
>  
>  static int addrconf_ifid_eui64(u8 *eui, struct net_device *dev)
>  {
> -	if (dev->addr_len != IEEE802154_ADDR_LEN)
> +	if (dev->addr_len != IEEE802154_ADDR_LEN) {
> +		pr_warn("IPv6 addrconf: %s: address length %d != %s\n",
> +			dev->name, dev->addr_len, "IEEE802154_ADDR_LEN");
>  		return -1;
> +	}
>  	memcpy(eui, dev->dev_addr, 8);
>  	eui[0] ^= 2;
>  	return 0;
> @@ -1736,8 +1742,11 @@ static int addrconf_ifid_ieee1394(u8 *eui, struct net_device *dev)
>  {
>  	union fwnet_hwaddr *ha;
>  
> -	if (dev->addr_len != FWNET_ALEN)
> +	if (dev->addr_len != FWNET_ALEN) {
> +		pr_warn("IPv6 addrconf: %s: address length %d != %s\n",
> +			dev->name, dev->addr_len, "FWNET_ALEN");
>  		return -1;
> +	}
>  
>  	ha = (union fwnet_hwaddr *)dev->dev_addr;
>  
> @@ -1749,8 +1758,11 @@ static int addrconf_ifid_ieee1394(u8 *eui, struct net_device *dev)
>  static int addrconf_ifid_arcnet(u8 *eui, struct net_device *dev)
>  {
>  	/* XXX: inherit EUI-64 from other interface -- yoshfuji */
> -	if (dev->addr_len != ARCNET_ALEN)
> +	if (dev->addr_len != ARCNET_ALEN) {
> +		pr_warn("IPv6 addrconf: %s: address length %d != %s\n",
> +			dev->name, dev->addr_len, "ARCNET_ALEN");
>  		return -1;
> +	}
>  	memset(eui, 0, 7);
>  	eui[7] = *(u8 *)dev->dev_addr;
>  	return 0;
> @@ -1758,17 +1770,25 @@ static int addrconf_ifid_arcnet(u8 *eui, struct net_device *dev)
>  
>  static int addrconf_ifid_infiniband(u8 *eui, struct net_device *dev)
>  {
> -	if (dev->addr_len != INFINIBAND_ALEN)
> +	if (dev->addr_len != INFINIBAND_ALEN) {
> +		pr_warn("IPv6 addrconf: %s: address length %d != %s\n",
> +			dev->name, dev->addr_len, "INFINIBAND_ALEN");
>  		return -1;
> +	}
>  	memcpy(eui, dev->dev_addr + 12, 8);
>  	eui[0] |= 2;
>  	return 0;
>  }
>  
> -static int __ipv6_isatap_ifid(u8 *eui, __be32 addr)
> +static int __ipv6_isatap_ifid(u8 *eui, struct net_device *dev)
>  {
> -	if (addr == 0)
> +	__be32 addr = *(__be32 *)dev->dev_addr;
> +
> +	if (addr == 0) {
> +		pr_warn("IPv6 addrconf: %s: bad dev_addr %pM\n",
> +			dev->name, dev->dev_addr);
>  		return -1;
> +	}
>  	eui[0] = (ipv4_is_zeronet(addr) || ipv4_is_private_10(addr) ||
>  		  ipv4_is_loopback(addr) || ipv4_is_linklocal_169(addr) ||
>  		  ipv4_is_private_172(addr) || ipv4_is_test_192(addr) ||
> @@ -1785,13 +1805,14 @@ static int __ipv6_isatap_ifid(u8 *eui, __be32 addr)
>  static int addrconf_ifid_sit(u8 *eui, struct net_device *dev)
>  {
>  	if (dev->priv_flags & IFF_ISATAP)
> -		return __ipv6_isatap_ifid(eui, *(__be32 *)dev->dev_addr);
> +		return __ipv6_isatap_ifid(eui, dev);
> +	pr_warn("IPv6 addrconf: %s: IFF_ISATAP is unset\n", dev->name);
>  	return -1;
>  }
>  
>  static int addrconf_ifid_gre(u8 *eui, struct net_device *dev)
>  {
> -	return __ipv6_isatap_ifid(eui, *(__be32 *)dev->dev_addr);
> +	return __ipv6_isatap_ifid(eui, dev);
>  }
>  
>  static int addrconf_ifid_ip6tnl(u8 *eui, struct net_device *dev)
> @@ -1825,6 +1846,8 @@ static int ipv6_generate_eui64(u8 *eui, struct net_device *dev)
>  	case ARPHRD_TUNNEL6:
>  		return addrconf_ifid_ip6tnl(eui, dev);
>  	}
> +	pr_warn("IPv6 addrconf: %s: dev->type %d is not supported\n",
> +		dev->name, dev->type);
>  	return -1;
>  }

This one should probably be a pr_debug or counter.  This is not a
critical issue and it makes no sense to spam the log if IPv6 is not
supported on a particular interface.

>  
> @@ -1842,6 +1865,10 @@ static int ipv6_inherit_eui64(u8 *eui, struct inet6_dev *idev)
>  		}
>  	}
>  	read_unlock_bh(&idev->lock);
> +	if (err)
> +		pr_warn("IPv6 addrconf: "
> +			"%s: no link-local address to inherit\n",
> +			idev->dev->name);
>  	return err;
>  }

This shouldn't be a warning either.  This is called if
ipv6_generate_eui64() fails and we'd know if it failed for a good
reason.  If that failed, we very likely do not have any other link-local
addresses and would know of any error conditions.

If by some chance, there are unsolicited RAs on the link, you'd end up
spamming the log.

-vlad


