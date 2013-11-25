Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3KYOL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58925 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab3KYNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlad Yasevich" <vyasevich@gmail.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        "Neil Horman" <nhorman@tuxdriver.com>, "Fan Du" <fan.du@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.158091140@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/87] sctp: Use software crc32 checksum when xfrm
 transform  will happen.
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 32ba8d0..d957fe1 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -518,7 +518,8 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 * by CRC32-C as described in <draft-ietf-tsvwg-sctpcsum-02.txt>.
 	 */
 	if (!sctp_checksum_disable) {
-		if (!(dst->dev->features & NETIF_F_SCTP_CSUM)) {
+		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
+		    (dst_xfrm(dst) != NULL)) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the

