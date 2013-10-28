Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab3J1Owp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:52:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3J1Oty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Fan Du <fan.du@windriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 55/64] sctp: Use software crc32 checksum when xfrm transform will happen.
Date: Mon, 28 Oct 2013 14:48:14 +0000
Message-Id: <1382971703-17393-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Du <fan.du@windriver.com>

commit 27127a82561a2a3ed955ce207048e1b066a80a2a upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 83dddb9..a80b310 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -523,7 +523,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
 	if (!sctp_checksum_disable) {
-		if (!(dst->dev->features & NETIF_F_SCTP_CSUM)) {
+		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
+		    (dst_xfrm(dst) != NULL)) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the
-- 
1.8.3.2

