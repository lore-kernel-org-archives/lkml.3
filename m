Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaANA2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaANA2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 44/77] sfc: Maintain current frequency adjustment when applying a time offset
Date: Mon, 13 Jan 2014 16:28:05 -0800
Message-Id: <20140114002753.757679605@linuxfoundation.org>
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

[ Upstream commit cd6fe65e923175e4f2e9fb585b1d78c6bf580fc6 ]

There is a single MCDI PTP operation for setting the frequency
adjustment and applying a time offset to the hardware clock.  When
applying a time offset we should not change the frequency adjustment.

These two operations can now be requested separately but this requires
a flash firmware update.  Keep using the single operation, but
remember and repeat the previous frequency adjustment.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ptp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1426,7 +1426,7 @@ static int efx_phc_adjfreq(struct ptp_cl
 	if (rc != 0)
 		return rc;
 
-	ptp_data->current_adjfreq = delta;
+	ptp_data->current_adjfreq = adjustment_ns;
 	return 0;
 }
 
@@ -1441,7 +1441,7 @@ static int efx_phc_adjtime(struct ptp_cl
 
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_ADJUST);
 	MCDI_SET_DWORD(inbuf, PTP_IN_PERIPH_ID, 0);
-	MCDI_SET_QWORD(inbuf, PTP_IN_ADJUST_FREQ, 0);
+	MCDI_SET_QWORD(inbuf, PTP_IN_ADJUST_FREQ, ptp_data->current_adjfreq);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_SECONDS, (u32)delta_ts.tv_sec);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_NANOSECONDS, (u32)delta_ts.tv_nsec);
 	return efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),


