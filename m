Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161951Ab3LFW3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:29:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161075Ab3LFVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 3.12 60/83] xfrm: Fix null pointer dereference when decoding sessions
Date: Fri,  6 Dec 2013 13:51:50 -0800
Message-Id: <20131206214645.634826443@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 84502b5ef9849a9694673b15c31bd3ac693010ae ]

On some codepaths the skb does not have a dst entry
when xfrm_decode_session() is called. So check for
a valid skb_dst() before dereferencing the device
interface index. We use 0 as the device index if
there is no valid skb_dst(), or at reverse decoding
we use skb_iif as device interface index.

Bug was introduced with git commit bafd4bd4dc
("xfrm: Decode sessions with output interface.").

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/xfrm4_policy.c |    6 +++++-
 net/ipv6/xfrm6_policy.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -104,10 +104,14 @@ _decode_session4(struct sk_buff *skb, st
 	const struct iphdr *iph = ip_hdr(skb);
 	u8 *xprth = skb_network_header(skb) + iph->ihl * 4;
 	struct flowi4 *fl4 = &fl->u.ip4;
+	int oif = 0;
+
+	if (skb_dst(skb))
+		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl4, 0, sizeof(struct flowi4));
 	fl4->flowi4_mark = skb->mark;
-	fl4->flowi4_oif = skb_dst(skb)->dev->ifindex;
+	fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
 
 	if (!ip_is_fragment(iph)) {
 		switch (iph->protocol) {
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -135,10 +135,14 @@ _decode_session6(struct sk_buff *skb, st
 	struct ipv6_opt_hdr *exthdr;
 	const unsigned char *nh = skb_network_header(skb);
 	u8 nexthdr = nh[IP6CB(skb)->nhoff];
+	int oif = 0;
+
+	if (skb_dst(skb))
+		oif = skb_dst(skb)->dev->ifindex;
 
 	memset(fl6, 0, sizeof(struct flowi6));
 	fl6->flowi6_mark = skb->mark;
-	fl6->flowi6_oif = skb_dst(skb)->dev->ifindex;
+	fl6->flowi6_oif = reverse ? skb->skb_iif : oif;
 
 	fl6->daddr = reverse ? hdr->saddr : hdr->daddr;
 	fl6->saddr = reverse ? hdr->daddr : hdr->saddr;


