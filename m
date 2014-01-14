Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaANAmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:42:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaANA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 40/77] sfc: Add length checks to efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
Date: Mon, 13 Jan 2014 16:28:01 -0800
Message-Id: <20140114002753.640936297@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit e5a498e943fbc497f236ab8cf31366c75f337ce6 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ptp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -989,7 +989,11 @@ bool efx_ptp_is_ptp_tx(struct efx_nic *e
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
 


