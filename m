Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaARLbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 06:31:12 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42387 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaARLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 06:31:07 -0500
Message-ID: <52DA65F4.5070501@gmail.com>
Date: Sat, 18 Jan 2014 19:31:00 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com
CC: David Miller <davem@davemloft.net>, b.a.t.m.a.n@lists.open-mesh.org,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-metag@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH linux-next] net: batman-adv: use "__packed __aligned(2)" for
 each structure instead of "__packed(2)" region
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, not all compilers assumes the structures within a pack
region also need be packed (e.g. metag), so need add a pack explicitly
to satisfy all compilers.

The related error (under metag with allmodconfig):

    MODPOST 2952 modules
  ERROR: "__compiletime_assert_431" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_432" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_429" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_428" [net/batman-adv/batman-adv.ko] undefined!
  ERROR: "__compiletime_assert_423" [net/batman-adv/batman-adv.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 net/batman-adv/packet.h | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/batman-adv/packet.h b/net/batman-adv/packet.h
index 0a381d1..9206b48 100644
--- a/net/batman-adv/packet.h
+++ b/net/batman-adv/packet.h
@@ -154,7 +154,6 @@ enum batadv_tvlv_type {
 	BATADV_TVLV_ROAM	= 0x05,
 };
 
-#pragma pack(2)
 /* the destination hardware field in the ARP frame is used to
  * transport the claim type and the group id
  */
@@ -162,8 +161,7 @@ struct batadv_bla_claim_dst {
 	uint8_t magic[3];	/* FF:43:05 */
 	uint8_t type;		/* bla_claimframe */
 	__be16 group;		/* group id */
-};
-#pragma pack()
+} __packed __aligned(2);
 
 /**
  * struct batadv_ogm_packet - ogm (routing protocol) packet
@@ -281,7 +279,6 @@ struct batadv_icmp_packet_rr {
  * misalignment of the payload after the ethernet header. It may also lead to
  * leakage of information when the padding it not initialized before sending.
  */
-#pragma pack(2)
 
 /**
  * struct batadv_unicast_packet - unicast packet for network payload
@@ -300,7 +297,7 @@ struct batadv_unicast_packet {
 	/* "4 bytes boundary + 2 bytes" long to make the payload after the
 	 * following ethernet header again 4 bytes boundary aligned
 	 */
-};
+}  __packed __aligned(2);
 
 /**
  * struct batadv_unicast_4addr_packet - extended unicast packet
@@ -316,7 +313,7 @@ struct batadv_unicast_4addr_packet {
 	/* "4 bytes boundary + 2 bytes" long to make the payload after the
 	 * following ethernet header again 4 bytes boundary aligned
 	 */
-};
+}  __packed __aligned(2);
 
 /**
  * struct batadv_frag_packet - fragmented packet
@@ -347,7 +344,7 @@ struct batadv_frag_packet {
 	uint8_t orig[ETH_ALEN];
 	__be16  seqno;
 	__be16  total_size;
-};
+}  __packed __aligned(2);
 
 /**
  * struct batadv_bcast_packet - broadcast packet for network payload
@@ -368,7 +365,7 @@ struct batadv_bcast_packet {
 	/* "4 bytes boundary + 2 bytes" long to make the payload after the
 	 * following ethernet header again 4 bytes boundary aligned
 	 */
-};
+}  __packed __aligned(2);
 
 /**
  * struct batadv_coded_packet - network coded packet
@@ -404,9 +401,8 @@ struct batadv_coded_packet {
 	uint8_t  second_orig_dest[ETH_ALEN];
 	__be32   second_crc;
 	__be16   coded_len;
-};
+}  __packed __aligned(2);
 
-#pragma pack()
 
 /**
  * struct batadv_unicast_tvlv - generic unicast packet with tvlv payload
-- 
1.7.11.7
