Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaGQQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:09:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56651 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbaGQQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:09:58 -0400
X-Sasl-enc: 8ssimKQmJ5pEUPeqmQNIlXCfcB7XT/JvKvcSSMS/8rqq 1405613397
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        benchan@chromium.org
Subject: [PATCH] staging: gdm72xx: remove debug code
Date: Thu, 17 Jul 2014 17:09:38 +0100
Message-Id: <1405613379-25338-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed dump_eth_packet() and helper functions called upon packet tx/rx.

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 106 ------------------------------------
 1 file changed, 106 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 726c943..6754463 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -52,108 +52,6 @@ static struct {
 
 static u8 gdm_wimax_macaddr[6] = {0x00, 0x0a, 0x3b, 0xf0, 0x01, 0x30};
 
-static const char *get_protocol_name(u16 protocol)
-{
-	static char buf[32];
-	const char *name = "-";
-
-	switch (protocol) {
-	case ETH_P_ARP:
-		name = "ARP";
-		break;
-	case ETH_P_IP:
-		name = "IP";
-		break;
-	case ETH_P_IPV6:
-		name = "IPv6";
-		break;
-	}
-
-	sprintf(buf, "0x%04x(%s)", protocol, name);
-	return buf;
-}
-
-static const char *get_ip_protocol_name(u8 ip_protocol)
-{
-	static char buf[32];
-	const char *name = "-";
-
-	switch (ip_protocol) {
-	case IPPROTO_TCP:
-		name = "TCP";
-		break;
-	case IPPROTO_UDP:
-		name = "UDP";
-		break;
-	case IPPROTO_ICMP:
-		name = "ICMP";
-		break;
-	}
-
-	sprintf(buf, "%u(%s)", ip_protocol, name);
-	return buf;
-}
-
-static const char *get_port_name(u16 port)
-{
-	static char buf[32];
-	const char *name = "-";
-
-	switch (port) {
-	case 67:
-		name = "DHCP-Server";
-		break;
-	case 68:
-		name = "DHCP-Client";
-		break;
-	case 69:
-		name = "TFTP";
-		break;
-	}
-
-	sprintf(buf, "%u(%s)", port, name);
-	return buf;
-}
-
-static void dump_eth_packet(struct net_device *dev, const char *title,
-			    u8 *data, int len)
-{
-	struct iphdr *ih = NULL;
-	struct udphdr *uh = NULL;
-	u16 protocol = 0;
-	u8 ip_protocol = 0;
-	u16 port = 0;
-
-	protocol = (data[12]<<8) | data[13];
-	ih = (struct iphdr *)(data+ETH_HLEN);
-
-	if (protocol == ETH_P_IP) {
-		uh = (struct udphdr *)((char *)ih + sizeof(struct iphdr));
-		ip_protocol = ih->protocol;
-		port = ntohs(uh->dest);
-	} else if (protocol == ETH_P_IPV6) {
-		struct ipv6hdr *i6h = (struct ipv6hdr *)data;
-
-		uh = (struct udphdr *)((char *)i6h + sizeof(struct ipv6hdr));
-		ip_protocol = i6h->nexthdr;
-		port = ntohs(uh->dest);
-	}
-
-	netdev_dbg(dev, "[%s] len=%d, %s, %s, %s\n", title, len,
-		   get_protocol_name(protocol),
-		   get_ip_protocol_name(ip_protocol),
-		   get_port_name(port));
-
-	if (!(data[0] == 0xff && data[1] == 0xff)) {
-		if (protocol == ETH_P_IP)
-			netdev_dbg(dev, "     src=%pI4\n", &ih->saddr);
-		else if (protocol == ETH_P_IPV6)
-			netdev_dbg(dev, "     src=%pI6\n", &ih->saddr);
-	}
-
-	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, data, len, false);
-}
-
 static inline int gdm_wimax_header(struct sk_buff **pskb)
 {
 	u16 buf[HCI_HEADER_SIZE / sizeof(u16)];
@@ -361,8 +259,6 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
 
-	dump_eth_packet(dev, "TX", skb->data, skb->len);
-
 	ret = gdm_wimax_header(&skb);
 	if (ret < 0) {
 		skb_pull(skb, HCI_HEADER_SIZE);
@@ -708,8 +604,6 @@ static void gdm_wimax_netif_rx(struct net_device *dev, char *buf, int len)
 	struct sk_buff *skb;
 	int ret;
 
-	dump_eth_packet(dev, "RX", buf, len);
-
 	skb = dev_alloc_skb(len + 2);
 	if (!skb) {
 		netdev_err(dev, "%s: dev_alloc_skb failed!\n", __func__);
-- 
1.8.4

