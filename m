Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaANA2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaANA2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 47/77] sfc: Poll for MCDI completion once before timeout occurs
Date: Mon, 13 Jan 2014 16:28:08 -0800
Message-Id: <20140114002753.839164305@linuxfoundation.org>
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

From: Robert Stonehouse <rstonehouse@solarflare.com>

[ Upstream commit 6b294b8efedaa7cf7507154148e2c79766ad6f96 ]

There is an as-yet unexplained bug that sometimes prevents (or delays)
the driver seeing the completion event for a completed MCDI request on
the SFC9120.  The requested configuration change will have happened
but the driver assumes it to have failed, and this can result in
further failures.  We can mitigate this by polling for completion
after unsuccessfully waiting for an event.

Fixes: 8127d661e77f ('sfc: Add support for Solarflare SFC9100 family')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -630,6 +630,16 @@ int efx_mcdi_rpc_finish(struct efx_nic *
 		rc = efx_mcdi_await_completion(efx);
 
 	if (rc != 0) {
+		netif_err(efx, hw, efx->net_dev,
+			  "MC command 0x%x inlen %d mode %d timed out\n",
+			  cmd, (int)inlen, mcdi->mode);
+
+		if (mcdi->mode == MCDI_MODE_EVENTS && efx_mcdi_poll_once(efx)) {
+			netif_err(efx, hw, efx->net_dev,
+				  "MCDI request was completed without an event\n");
+			rc = 0;
+		}
+
 		/* Close the race with efx_mcdi_ev_cpl() executing just too late
 		 * and completing a request we've just cancelled, by ensuring
 		 * that the seqno check therein fails.
@@ -638,11 +648,9 @@ int efx_mcdi_rpc_finish(struct efx_nic *
 		++mcdi->seqno;
 		++mcdi->credits;
 		spin_unlock_bh(&mcdi->iface_lock);
+	}
 
-		netif_err(efx, hw, efx->net_dev,
-			  "MC command 0x%x inlen %d mode %d timed out\n",
-			  cmd, (int)inlen, mcdi->mode);
-	} else {
+	if (rc == 0) {
 		size_t hdr_len, data_len;
 
 		/* At the very least we need a memory barrier here to ensure


