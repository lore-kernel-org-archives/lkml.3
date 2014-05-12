Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaELCSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:18:36 -0400
Received: from 1wt.eu ([62.212.114.60]:34394 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaELBln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:43 -0400
Message-Id: <20140512003202.171908279@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fan Du <fan.du@windriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 037/143] sctp: Perform software checksum if packet has to be fragmented.
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit d2dbbba77e95dff4b4f901fee236fef6d9552072 ]

IP/IPv6 fragmentation knows how to compute only TCP/UDP checksum.
This causes problems if SCTP packets has to be fragmented and
ipsummed has been set to PARTIAL due to checksum offload support.
This condition can happen when retransmitting after MTU discover,
or when INIT or other control chunks are larger then MTU.
Check for the rare fragmentation condition in SCTP and use software
checksum calculation in this case.

CC: Fan Du <fan.du@windriver.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 8d4eacf..54bc011 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -507,7 +507,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 */
 	if (!sctp_checksum_disable &&
 	    (!(dst->dev->features & (NETIF_F_NO_CSUM | NETIF_F_SCTP_CSUM)) ||
-	     (dst_xfrm(dst) != NULL))) {
+	     (dst_xfrm(dst) != NULL) || packet->ipfragok)) {
 		__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 		/* 3) Put the resultant value into the checksum field in the
-- 
1.7.12.2.21.g234cd45.dirty



