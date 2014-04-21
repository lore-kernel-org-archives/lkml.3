Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaDUPrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:47:24 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49259 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaDUPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:47:21 -0400
Message-ID: <1398095238.19600.36.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Performance problem with bond interface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Sergey Linetskiy <sergey.linetskiy@oracle.com>,
        Vadim Makhervaks <vadim.makhervaks@oracle.com>,
        Guangyu Sun <guangyu.sun@oracle.com>
Date: Mon, 21 Apr 2014 08:47:18 -0700
In-Reply-To: <5e9e32bb-b60e-44d1-82be-28c4d6ec82d5@default>
References: <5e9e32bb-b60e-44d1-82be-28c4d6ec82d5@default>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-21 at 07:23 -0700, Venkat Venkatsubra wrote:
> We see a performance problem when the slaves of the bond 
> don't support checksum offload features. What we see is
> tcp_sendmsg's skb_add_data_nocache ending up not using the
> csum_and_copy_from_user which would have computed the
> checksum while copying from user buffer to kernel buffer.
> Instead it computes later in dev_hard_start_xmit when it
> figures out the slave doesn't support checksum offload and
> ends up expensive . 
> 
> The bonding interface's "features" has  NETIF_F_HW_CSUM 
> (or NETIF_F_NO_CSUM in 2.6.39) set which makes the 
> stack think checksum need not be computed in software.
> /*
> * Check whether we can use HW checksum.
> */
> if (sk->sk_route_caps & NETIF_F_ALL_CSUM)
>      skb->ip_summed = CHECKSUM_PARTIAL;
> 
> But later in dev_hard_start_xmit it finds out the slave does not
> support checksumming and decides to compute in software.
> 
> /* If packet is not checksummed and device does not
> * support checksumming for this protocol, complete
> * checksumming here.
> */
> if (skb->ip_summed == CHECKSUM_PARTIAL) {
>          skb_set_transport_header(skb,
>               skb_checksum_start_offset(skb));
>         if (!(features & NETIF_F_ALL_CSUM) &&
>              skb_checksum_help(skb))
>                goto out_kfree_skb;
> }
> 
> We see this problem after this commit:
> commit 1742f183fc218798dab6fcf0ded25b6608fc0a48
> Author: MichaÅ<82> MirosÅ<82>aw <mirq-linux@rere.qmqm.pl>
> Date:   Fri Apr 22 06:31:16 2011 +0000
> 
>     net: fix netdev_increment_features()
> 
>     Simplify and fix netdev_increment_features() to conform to what is
>     stated in netdevice.h comments about NETIF_F_ONE_FOR_ALL.
>     Include FCoE segmentation and VLAN-challedged flags in computation.
> 
>     Signed-off-by: MichaÅ<82> MirosÅ<82>aw <mirq-linux@rere.qmqm.pl>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Prior to that the below code in netdev_increment_features was helping in
> turning off NETIF_F_NO_CSUM on bond when the slaves don't support it: 
> /* If device needs checksumming, downgrade to it. */
> if (all & NETIF_F_NO_CSUM && !(one & NETIF_F_NO_CSUM))
>         all ^= NETIF_F_NO_CSUM | (one & NETIF_F_ALL_CSUM);
> 
> The slaves are Mellanox IB adapters. This is on x86_64 platform.
> 
> Please let us know if you need any additional information.

Please CC patch author (I did), instead of sending this to hundred of
people (linux-kernel ??? netdev is more appropriate...)

Do these NIC really not support TX checksum ?

You did not provide kernel version you use.

Please also provide : (using a recent ethtool to get extended offload
info)

ethtool -k bond0 # or the bonding device name

ethtool -k eth1  # or the slave name

ethtool -i eth1

Thanks !


