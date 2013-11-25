Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3KYO0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:26:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab3KYNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:40 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vlad Yasevich" <vyasevich@gmail.com>,
        "Fan Du" <fan.du@windriver.com>, "Neil Horman" <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.661980042@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 16/87] sctp: Perform software checksum if packet has
 to be  fragmented.
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index d957fe1..cf3e22c 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -519,7 +519,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 */
 	if (!sctp_checksum_disable) {
 		if (!(dst->dev->features & NETIF_F_SCTP_CSUM) ||
-		    (dst_xfrm(dst) != NULL)) {
+		    (dst_xfrm(dst) != NULL) || packet->ipfragok) {
 			__u32 crc32 = sctp_start_cksum((__u8 *)sh, cksum_buf_len);
 
 			/* 3) Put the resultant value into the checksum field in the

