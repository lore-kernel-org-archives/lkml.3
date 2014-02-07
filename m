Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaBGN1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:27:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41392 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaBGLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/233] sfc: Add length checks to efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
Date: Fri,  7 Feb 2014 11:43:43 +0000
Message-Id: <1391773652-25214-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit e5a498e943fbc497f236ab8cf31366c75f337ce6 upstream.

efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
have invalid IPv4 and UDP headers.

Add checks that:
- the transport header has been found
- there is enough space between network and transport header offset
  for an IPv4 header
- there is enough space after the transport header offset for a
  UDP header

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index b495394..6ddec68 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -982,7 +982,11 @@ bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
 		skb->len >= PTP_MIN_LENGTH &&
 		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
 		likely(skb->protocol == htons(ETH_P_IP)) &&
+		skb_transport_header_was_set(skb) &&
+		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
 		ip_hdr(skb)->protocol == IPPROTO_UDP &&
+		skb_headlen(skb) >=
+		skb_transport_offset(skb) + sizeof(struct udphdr) &&
 		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
 }
 
-- 
1.8.3.2

