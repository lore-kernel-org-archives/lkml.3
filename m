Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3CDOJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:09:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60885 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3CDOJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:09:08 -0500
From: Zang MingJie <zealot0630@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Zang MingJie <zealot0630@gmail.com>
Subject: [PATCH 1/1] reset nf before xmit vxlan encapsulated packet
Date: Mon,  4 Mar 2013 22:08:59 +0800
Message-Id: <1362406139-29135-1-git-send-email-zealot0630@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should reset nf settings bond to the skb as ipip/ipgre do.

If not, the conntrack/nat info bond to the origin packet may continually
redirect the packet to vxlan interface causing a routing loop.

this is the scenario:

     VETP     VXLAN Gateway
    /----\  /---------------\
    |    |  |               |
    |  vx+--+vx --NAT-> eth0+--> Internet
    |    |  |               |
    \----/  \---------------/

when there are any packet coming from internet to the vetp, there will be lots
of garbage packets coming out the gateway's vxlan interface, but none actually
sent to the physical interface, because they are redirected back to the vxlan
interface in the postrouting chain of NAT rule, and dmesg complains:

    Mar  1 21:52:53 debian kernel: [ 8802.997699] Dead loop on virtual device vxlan0, fix it urgently!
    Mar  1 21:52:54 debian kernel: [ 8804.004907] Dead loop on virtual device vxlan0, fix it urgently!
    Mar  1 21:52:55 debian kernel: [ 8805.012189] Dead loop on virtual device vxlan0, fix it urgently!
    Mar  1 21:52:56 debian kernel: [ 8806.020593] Dead loop on virtual device vxlan0, fix it urgently!

the patch should fix the problem

Signed-off-by: Zang MingJie <zealot0630@gmail.com>
---
 drivers/net/vxlan.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index f10e58a..c3e3d29 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -961,6 +961,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	iph->ttl	= ttl ? : ip4_dst_hoplimit(&rt->dst);
 	tunnel_ip_select_ident(skb, old_iph, &rt->dst);
 
+	nf_reset(skb);
+
 	vxlan_set_owner(dev, skb);
 
 	/* See iptunnel_xmit() */
-- 
1.7.10.4

