Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaANAkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:40:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaANA2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 46/77] sfc: Refactor efx_mcdi_poll() by introducing efx_mcdi_poll_once()
Date: Mon, 13 Jan 2014 16:28:07 -0800
Message-Id: <20140114002753.812046359@linuxfoundation.org>
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

[ Upstream commit 5731d7b35e5b87157a9b9973cc2eff70c50aec58 ]

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -50,6 +50,7 @@ struct efx_mcdi_async_param {
 static void efx_mcdi_timeout_async(unsigned long context);
 static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 			       bool *was_attached_out);
+static bool efx_mcdi_poll_once(struct efx_nic *efx);
 
 static inline struct efx_mcdi_iface *efx_mcdi(struct efx_nic *efx)
 {
@@ -237,6 +238,21 @@ static void efx_mcdi_read_response_heade
 	}
 }
 
+static bool efx_mcdi_poll_once(struct efx_nic *efx)
+{
+	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
+
+	rmb();
+	if (!efx->type->mcdi_poll_response(efx))
+		return false;
+
+	spin_lock_bh(&mcdi->iface_lock);
+	efx_mcdi_read_response_header(efx);
+	spin_unlock_bh(&mcdi->iface_lock);
+
+	return true;
+}
+
 static int efx_mcdi_poll(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
@@ -272,18 +288,13 @@ static int efx_mcdi_poll(struct efx_nic
 
 		time = jiffies;
 
-		rmb();
-		if (efx->type->mcdi_poll_response(efx))
+		if (efx_mcdi_poll_once(efx))
 			break;
 
 		if (time_after(time, finish))
 			return -ETIMEDOUT;
 	}
 
-	spin_lock_bh(&mcdi->iface_lock);
-	efx_mcdi_read_response_header(efx);
-	spin_unlock_bh(&mcdi->iface_lock);
-
 	/* Return rc=0 like wait_event_timeout() */
 	return 0;
 }


