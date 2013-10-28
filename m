Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab3J1Otz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:49:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3J1Otw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fan Du <fan.du@windriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 56/64] sctp: Perform software checksum if packet has to be fragmented.
Date: Mon, 28 Oct 2013 14:48:15 +0000
Message-Id: <1382971703-17393-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

commit d2dbbba77e95dff4b4f901fee236fef6d9552072 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index a80b310..a1e2a9b 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -524,7 +524,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 */
 	if (!sctp_checksum_disable) {
 		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
-		    (dst_xfrm(dst) != NULL)) {
+		    (dst_xfrm(dst) != NULL) || packet->ipfragok) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the
-- 
1.8.3.2

