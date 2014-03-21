Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967147AbaCUB1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:27:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272AbaCUADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>,
        Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 016/149] sfc: check for NULL efx->ptp_data in efx_ptp_event
Date: Thu, 20 Mar 2014 17:02:59 -0700
Message-Id: <20140321000437.510046389@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 8f355e5cee63c2c0c145d8206c4245d0189f47ff ]

If we receive a PTP event from the NIC when we haven't set up PTP state
in the driver, we attempt to read through a NULL pointer efx->ptp_data,
triggering a panic.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Acked-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ptp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1360,6 +1360,13 @@ void efx_ptp_event(struct efx_nic *efx,
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	int code = EFX_QWORD_FIELD(*ev, MCDI_EVENT_CODE);
 
+	if (!ptp) {
+		if (net_ratelimit())
+			netif_warn(efx, drv, efx->net_dev,
+				   "Received PTP event but PTP not set up\n");
+		return;
+	}
+
 	if (!ptp->enabled)
 		return;
 


