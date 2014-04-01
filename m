Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaDAQJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:09:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaDAQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 19/86] sfc: check for NULL efx->ptp_data in efx_ptp_event
Date: Tue,  1 Apr 2014 09:07:32 -0700
Message-Id: <1396368519-12728-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 8f355e5cee63c2c0c145d8206c4245d0189f47ff ]

If we receive a PTP event from the NIC when we haven't set up PTP state
in the driver, we attempt to read through a NULL pointer efx->ptp_data,
triggering a panic.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Acked-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 3f93624..53fd765 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1311,6 +1311,13 @@ void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev)
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
 
-- 
1.8.3.2

