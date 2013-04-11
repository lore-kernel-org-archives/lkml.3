Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422684Ab3DKUoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:44:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab3DKUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:54 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ejFs5i_SpfEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qKXtviB79OgA:10 a=K33ine3eAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=6UCq8DqREAUA:10 a=o7nkWXKJ22EA:10 a=jeBq3FmKZ4MA:10 a=Wd44rGJ_aIgv1Bxn:21 a=_-AmcQfiGhYET-AD:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.412489729@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marek Lindner <lindner_marek@yahoo.de>,
        Antonio Quartulli <ordex@autistici.org>
Subject: [ 007/171 ] batman-adv: verify tt len does not exceed packet len
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0007-batman-adv-verify-tt-len-does-not-exceed-packet-len.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Marek Lindner <lindner_marek@yahoo.de>

[ Upstream commit b47506d91259c29b9c75c404737eb6525556f9b4 ]

batadv_iv_ogm_process() accesses the packet using the tt_num_changes
attribute regardless of the real packet len (assuming the length check
was done before). Therefore a length check is needed to avoid reading
random memory.

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/batman-adv/bat_iv_ogm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 1476f26..aca451e 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1273,7 +1273,8 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 	batadv_ogm_packet = (struct batadv_ogm_packet *)packet_buff;
 
 	/* unpack the aggregated packets and process them one by one */
-	do {
+	while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
+					 batadv_ogm_packet->tt_num_changes)) {
 		tt_buff = packet_buff + buff_pos + BATADV_OGM_HLEN;
 
 		batadv_iv_ogm_process(ethhdr, batadv_ogm_packet, tt_buff,
@@ -1284,8 +1285,7 @@ static int batadv_iv_ogm_receive(struct sk_buff *skb,
 
 		batadv_ogm_packet = (struct batadv_ogm_packet *)
 						(packet_buff + buff_pos);
-	} while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
-					   batadv_ogm_packet->tt_num_changes));
+	}
 
 	kfree_skb(skb);
 	return NET_RX_SUCCESS;
-- 
1.7.10.4


