Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaBGN01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:26:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBGLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/233] sfc: Rate-limit log message for PTP packets without a matching timestamp event
Date: Fri,  7 Feb 2014 11:43:45 +0000
Message-Id: <1391773652-25214-7-git-send-email-luis.henriques@canonical.com>
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

commit 35f9a7a380728a94d417e5824a866f969423ac83 upstream.

In case of a flood of PTP packets, the timestamp peripheral and MC
firmware on the SFN[56]322F boards may not be able to provide
timestamp events for all packets.  Don't complain too much about this.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index d5a5192..e7d7010 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -710,8 +710,9 @@ static bool efx_ptp_process_events(struct efx_nic *efx, struct sk_buff_head *q)
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
-- 
1.8.3.2

