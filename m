Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3CZXts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3CZWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Lindner <lindner_marek@yahoo.de>,
        Antonio Quartulli <ordex@autistici.org>
Subject: [ 06/98] batman-adv: verify tt len does not exceed packet len
Date: Tue, 26 Mar 2013 15:41:55 -0700
Message-Id: <20130326224243.114216891@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Marek Lindner <lindner_marek@yahoo.de>

[ Upstream commit b47506d91259c29b9c75c404737eb6525556f9b4 ]

batadv_iv_ogm_process() accesses the packet using the tt_num_changes
attribute regardless of the real packet len (assuming the length check
was done before). Therefore a length check is needed to avoid reading
random memory.

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1298,7 +1298,8 @@ static int batadv_iv_ogm_receive(struct
 	batadv_ogm_packet = (struct batadv_ogm_packet *)packet_buff;
 
 	/* unpack the aggregated packets and process them one by one */
-	do {
+	while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
+					 batadv_ogm_packet->tt_num_changes)) {
 		tt_buff = packet_buff + buff_pos + BATADV_OGM_HLEN;
 
 		batadv_iv_ogm_process(ethhdr, batadv_ogm_packet, tt_buff,
@@ -1309,8 +1310,7 @@ static int batadv_iv_ogm_receive(struct
 
 		packet_pos = packet_buff + buff_pos;
 		batadv_ogm_packet = (struct batadv_ogm_packet *)packet_pos;
-	} while (batadv_iv_ogm_aggr_packet(buff_pos, packet_len,
-					   batadv_ogm_packet->tt_num_changes));
+	}
 
 	kfree_skb(skb);
 	return NET_RX_SUCCESS;


