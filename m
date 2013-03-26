Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3CZRjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:39:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3CZRge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KU2ukz1aYrcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lhL6zpkMSF0A:10 a=pGLkceISAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=ViW7gs5_O6Mpccgb:21 a=Juc6dParvGanpd3O:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.350974233@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Duan Jiong <djduanjiong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 59/86] ipv6: Change skb->data before using icmpv6_notify() to propagate
 redirect
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0059-ipv6-Change-skb-data-before-using-icmpv6_notify-to-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Duan Jiong <djduanjiong@gmail.com>

[ Upstream commit 7801a085efab5f1d7cc54fa1f80b0c69b457db68 ]

In function ndisc_redirect_rcv(), the skb->data points to the transport
header, but function icmpv6_notify() need the skb->data points to the
inner IP packet. So before using icmpv6_notify() to propagate redirect,
change skb->data to point the inner IP packet that triggered the sending
of the Redirect, and introduce struct rd_msg to make it easy.

Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/ndisc.h |    7 +++++++
 net/ipv6/ndisc.c    |   17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 96a3b5c..826a541 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -77,6 +77,13 @@ struct ra_msg {
 	__be32			retrans_timer;
 };
 
+struct rd_msg {
+	struct icmp6hdr icmph;
+	struct in6_addr	target;
+	struct in6_addr	dest;
+	__u8		opt[0];
+};
+
 struct nd_opt_hdr {
 	__u8		nd_opt_type;
 	__u8		nd_opt_len;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 2edce30..89dab79 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1333,6 +1333,12 @@ out:
 
 static void ndisc_redirect_rcv(struct sk_buff *skb)
 {
+	u8 *hdr;
+	struct ndisc_options ndopts;
+	struct rd_msg *msg = (struct rd_msg *)skb_transport_header(skb);
+	u32 ndoptlen = skb->tail - (skb->transport_header +
+				    offsetof(struct rd_msg, opt));
+
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	switch (skb->ndisc_nodetype) {
 	case NDISC_NODETYPE_HOST:
@@ -1349,6 +1355,17 @@ static void ndisc_redirect_rcv(struct sk_buff *skb)
 		return;
 	}
 
+	if (!ndisc_parse_options(msg->opt, ndoptlen, &ndopts))
+		return;
+
+	if (!ndopts.nd_opts_rh)
+		return;
+
+	hdr = (u8 *)ndopts.nd_opts_rh;
+	hdr += 8;
+	if (!pskb_pull(skb, hdr - skb_transport_header(skb)))
+		return;
+
 	icmpv6_notify(skb, NDISC_REDIRECT, 0, 0);
 }
 
-- 
1.7.10.4


