Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaANAmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:42:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaANA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 42/77] sfc: Rate-limit log message for PTP packets without a matching timestamp event
Date: Mon, 13 Jan 2014 16:28:03 -0800
Message-Id: <20140114002753.700753586@linuxfoundation.org>
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

[ Upstream commit 35f9a7a380728a94d417e5824a866f969423ac83 ]

In case of a flood of PTP packets, the timestamp peripheral and MC
firmware on the SFN[56]322F boards may not be able to provide
timestamp events for all packets.  Don't complain too much about this.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ptp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -717,8 +717,9 @@ static bool efx_ptp_process_events(struc
 			__skb_queue_tail(q, skb);
 		} else if (time_after(jiffies, match->expiry)) {
 			match->state = PTP_PACKET_STATE_TIMED_OUT;
-			netif_warn(efx, rx_err, efx->net_dev,
-				   "PTP packet - no timestamp seen\n");
+			if (net_ratelimit())
+				netif_warn(efx, rx_err, efx->net_dev,
+					   "PTP packet - no timestamp seen\n");
 			__skb_queue_tail(q, skb);
 		} else {
 			/* Replace unprocessed entry and stop */


