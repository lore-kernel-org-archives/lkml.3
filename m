Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaFXPwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:52:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaFXPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 20/52] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Date: Tue, 24 Jun 2014 11:50:35 -0400
Message-Id: <20140624154714.704789582@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Popov <ixaphire@qrator.net>

[ Upstream commit 2346829e641b804ece9ac9298136b56d9567c278 ]

ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a
tunnel netdevice). It caused wrong route lookup and failure of pmtu update or
redirect. We should use the same ifindex that we use in ip_route_output_* in
*tunnel_xmit code. It is t->parms.link .

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    4 ++--
 net/ipv6/sit.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -149,13 +149,13 @@ static int ipip_err(struct sk_buff *skb,
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPIP, 0);
+				 t->parms.link, 0, IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
 	}
 
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -530,12 +530,12 @@ static int ipip6_err(struct sk_buff *skb
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPV6, 0);
+				 t->parms.link, 0, IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;
 	}
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;


