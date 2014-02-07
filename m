Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaBGNZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:25:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBGLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/233] sfc: Maintain current frequency adjustment when applying a time offset
Date: Fri,  7 Feb 2014 11:43:47 +0000
Message-Id: <1391773652-25214-9-git-send-email-luis.henriques@canonical.com>
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

commit cd6fe65e923175e4f2e9fb585b1d78c6bf580fc6 upstream.

There is a single MCDI PTP operation for setting the frequency
adjustment and applying a time offset to the hardware clock.  When
applying a time offset we should not change the frequency adjustment.

These two operations can now be requested separately but this requires
a flash firmware update.  Keep using the single operation, but
remember and repeat the previous frequency adjustment.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[ luis: backported to 3.11:
  - replaced MCDI_SET_QWORD() by 2x MCDI_SET_DWORD() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index b24d3be..11d979d 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1420,7 +1420,7 @@ static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	if (rc != 0)
 		return rc;
 
-	ptp_data->current_adjfreq = delta;
+	ptp_data->current_adjfreq = adjustment_ns;
 	return 0;
 }
 
@@ -1434,8 +1434,9 @@ static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	u8 inbuf[MC_CMD_PTP_IN_ADJUST_LEN];
 
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_ADJUST);
-	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_LO, 0);
-	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_HI, 0);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_LO, (u32)ptp_data->current_adjfreq);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_HI,
+		       (u32)(ptp_data->current_adjfreq >> 32));
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_SECONDS, (u32)delta_ts.tv_sec);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_NANOSECONDS, (u32)delta_ts.tv_nsec);
 	return efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-- 
1.8.3.2

