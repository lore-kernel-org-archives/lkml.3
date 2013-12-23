Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3LWIdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:33:55 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63404 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3LWIdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:33:53 -0500
Message-ID: <1387787627.1797.10.camel@localhost.localdomain>
Subject: Re: [PATCH 12/21] bridge: slight optimization of addr compare
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 17:33:47 +0900
In-Reply-To: <52B7C5D5.2040202@huawei.com>
References: <52B7C5D5.2040202@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 13:10 +0800, Ding Tianhong wrote:
> Use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp.
> 
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: bridge@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>  net/bridge/br_stp_if.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
> index 656a6f3..04217d1 100644
> --- a/net/bridge/br_stp_if.c
> +++ b/net/bridge/br_stp_if.c
> @@ -229,7 +229,7 @@ bool br_stp_recalculate_bridge_id(struct net_bridge *br)
>  
>  	list_for_each_entry(p, &br->port_list, list) {
>  		if (addr == br_mac_zero ||
> -		    memcmp(p->dev->dev_addr, addr, ETH_ALEN) < 0)
> +		    !ether_addr_equal_unaligned(p->dev->dev_addr, addr) < 0)
>  			addr = p->dev->dev_addr;
>  
>  	}

We cannot do this change.
!ether_addr_equal() isn't identical to memcmp().
memcmp() can return negative value but ether_addr_equal() cannot.
br_stp_recalculate_bridge_id() is searching the smallest address among
its ports. This change breaks it.

Thanks,
Toshiaki Makita

