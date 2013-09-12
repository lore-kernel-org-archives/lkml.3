Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3ILSNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:13:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3ILR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/46] packet: restore packet statistics tp_packets to include drops
Date: Thu, 12 Sep 2013 10:58:34 -0700
Message-Id: <20130912175723.537651001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8bcdeaff5ed544704a9a691d4aef0adb3f9c5b8f ]

getsockopt PACKET_STATISTICS returns tp_packets + tp_drops. Commit
ee80fbf301 ("packet: account statistics only in tpacket_stats_u")
cleaned up the getsockopt PACKET_STATISTICS code.
This also changed semantics. Historically, tp_packets included
tp_drops on return. The commit removed the line that adds tp_drops
into tp_packets.

This patch reinstates the old semantics.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3259,9 +3259,11 @@ static int packet_getsockopt(struct sock
 
 		if (po->tp_version == TPACKET_V3) {
 			lv = sizeof(struct tpacket_stats_v3);
+			st.stats3.tp_packets += st.stats3.tp_drops;
 			data = &st.stats3;
 		} else {
 			lv = sizeof(struct tpacket_stats);
+			st.stats1.tp_packets += st.stats1.tp_drops;
 			data = &st.stats1;
 		}
 


