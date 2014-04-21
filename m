Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaDUOXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:23:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26530 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDUOXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:23:07 -0400
MIME-Version: 1.0
Message-ID: <5e9e32bb-b60e-44d1-82be-28c4d6ec82d5@default>
Date: Mon, 21 Apr 2014 07:23:04 -0700 (PDT)
From: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Sergey Linetskiy <sergey.linetskiy@oracle.com>,
        Vadim Makhervaks <vadim.makhervaks@oracle.com>,
        Guangyu Sun <guangyu.sun@oracle.com>
Subject: Performance problem with bond interface
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.8  (707110) [OL
 12.0.6691.5000 (x86)]
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see a performance problem when the slaves of the bond 
don't support checksum offload features. What we see is
tcp_sendmsg's skb_add_data_nocache ending up not using the
csum_and_copy_from_user which would have computed the
checksum while copying from user buffer to kernel buffer.
Instead it computes later in dev_hard_start_xmit when it
figures out the slave doesn't support checksum offload and
ends up expensive . 

The bonding interface's "features" has †NETIF_F_HW_CSUM 
(or NETIF_F_NO_CSUM in 2.6.39) set which makes the 
stack think checksum need not be computed in software.
/*
* Check whether we can use HW checksum.
*/
if (sk->sk_route_caps & NETIF_F_ALL_CSUM)
†††† skb->ip_summed = CHECKSUM_PARTIAL;

But later in dev_hard_start_xmit it finds out the slave does not
support checksumming and decides to compute in software.

/* If packet is not checksummed and device does not
* support checksumming for this protocol, complete
* checksumming here.
*/
if (skb->ip_summed == CHECKSUM_PARTIAL) {
†††††† ††skb_set_transport_header(skb,
†††††† †††††††skb_checksum_start_offset(skb));
††††††††if (!(features & NETIF_F_ALL_CSUM) &&
††††††† †††††skb_checksum_help(skb))
†††††††† ††††††goto out_kfree_skb;
}

We see this problem after this commit:
commit 1742f183fc218798dab6fcf0ded25b6608fc0a48
Author: Micha≈<82> Miros≈<82>aw <mirq-linux@rere.qmqm.pl>
Date:†† Fri Apr 22 06:31:16 2011 +0000

††† net: fix netdev_increment_features()

††† Simplify and fix netdev_increment_features() to conform to what is
††† stated in netdevice.h comments about NETIF_F_ONE_FOR_ALL.
††† Include FCoE segmentation and VLAN-challedged flags in computation.

††† Signed-off-by: Micha≈<82> Miros≈<82>aw <mirq-linux@rere.qmqm.pl>
††† Signed-off-by: David S. Miller <davem@davemloft.net>

Prior to that the below code in netdev_increment_features was helping in
turning off NETIF_F_NO_CSUM on bond when the slaves don't support it: 
/* If device needs checksumming, downgrade to it. */
if (all & NETIF_F_NO_CSUM && !(one & NETIF_F_NO_CSUM))
††††††† all ^= NETIF_F_NO_CSUM | (one & NETIF_F_ALL_CSUM);

The slaves are Mellanox IB adapters. This is on x86_64 platform.

Please let us know if you need any additional information.

Thanks.

Venkat
