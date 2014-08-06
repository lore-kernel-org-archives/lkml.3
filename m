Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaHFIE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:04:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41827 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaHFIEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:04:51 -0400
Message-ID: <53E1E140.1090605@huawei.com>
Date: Wed, 6 Aug 2014 16:03:12 +0800
From: chenweilong <chenweilong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Sabrina Dubroca <sd@queasysnail.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 19/19] ipv6: reallocate addrconf router for ipv6 address
 when lo device up
References: <20140805182934.022406678@linuxfoundation.org> <20140805182934.619752104@linuxfoundation.org>
In-Reply-To: <20140805182934.619752104@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.37.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch get a compile warn.
I'll resend one.

Thanks

On 2014/8/6 2:29, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Gao feng <gaofeng@cn.fujitsu.com>
> 
> commit 33d99113b1102c2d2f8603b9ba72d89d915c13f5 upstream.
> 
> commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f
> "net IPv6 : Fix broken IPv6 routing table after loopback down-up"
> allocates addrconf router for ipv6 address when lo device up.
> but commit a881ae1f625c599b460cc8f8a7fcb1c438f699ad
> "ipv6:don't call addrconf_dst_alloc again when enable lo" breaks
> this behavior.
> 
> Since the addrconf router is moved to the garbage list when
> lo device down, we should release this router and rellocate
> a new one for ipv6 address when lo device up.
> 
> This patch solves bug 67951 on bugzilla
> https://bugzilla.kernel.org/show_bug.cgi?id=67951
> 
> change from v1:
> use ip6_rt_put to repleace ip6_del_rt, thanks Hannes!
> change code style, suggested by Sergei.
> 
> CC: Sabrina Dubroca <sd@queasysnail.net>
> CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Reported-by: Weilong Chen <chenweilong@huawei.com>
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [weilong: s/ip6_rt_put/dst_release]
> Signed-off-by: Chen Weilong <chenweilong@huawei.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  net/ipv6/addrconf.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -2438,8 +2438,18 @@ static void init_loopback(struct net_dev
>  			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
>  				continue;
>  
> -			if (sp_ifa->rt)
> -				continue;
> +			if (sp_ifa->rt) {
> +				/* This dst has been added to garbage list when
> +				 * lo device down, release this obsolete dst and
> +				 * reallocate a new router for ifa.
> +				 */
> +				if (sp_ifa->rt->dst.obsolete > 0) {
> +					dst_release(sp_ifa->rt);
> +					sp_ifa->rt = NULL;
> +				} else {
> +					continue;
> +				}
> +			}
>  
>  			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
>  
> 
> 
> 
> .
> 

