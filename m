Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbaELCVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:21:38 -0400
Received: from 1wt.eu ([62.212.114.60]:34362 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaELBle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:34 -0400
Message-Id: <20140512003202.130174040@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Fan Du <fan.du@windriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 036/143] sctp: Use software crc32 checksum when xfrm transform will happen.
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Du <fan.du@windriver.com>

[ Upstream commit 27127a82561a2a3ed955ce207048e1b066a80a2a ]

igb/ixgbe have hardware sctp checksum support, when this feature is enabled
and also IPsec is armed to protect sctp traffic, ugly things happened as
xfrm_output checks CHECKSUM_PARTIAL to do checksum operation(sum every thing
up and pack the 16bits result in the checksum field). The result is fail
establishment of sctp communication.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index d494100..8d4eacf 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -506,7 +506,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
 	if (!sctp_checksum_disable &&
-	    !(dst->dev->features & (NETIF_F_NO_CSUM | NETIF_F_SCTP_CSUM))) {
+	    (!(dst->dev->features & (NETIF_F_NO_CSUM | NETIF_F_SCTP_CSUM)) ||
+	     (dst_xfrm(dst) != NULL))) {
 		__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 		/* 3) Put the resultant value into the checksum field in the
-- 
1.7.12.2.21.g234cd45.dirty



