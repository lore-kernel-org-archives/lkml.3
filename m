Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbbALSYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:24:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbbALSGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Hogan <james.hogan@imgtec.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 057/216] mmc: dw_mmc: avoid write to CDTHRCTL on older versions
Date: Mon, 12 Jan 2015 18:02:54 +0000
Message-Id: <1421085933-32536-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit 66dfd10173159cafa9cb0d39936b8daeaab8e3e0 upstream.

Commit f1d2736c8156 (mmc: dw_mmc: control card read threshold) added
dw_mci_ctrl_rd_thld() with an unconditional write to the CDTHRCTL
register at offset 0x100. However before version 240a, the FIFO region
started at 0x100, so the write messes with the FIFO and completely
breaks the driver.

If the version id < 240A, return early from dw_mci_ctl_rd_thld() so as
not to hit this problem.

Fixes: f1d2736c8156 (mmc: dw_mmc: control card read threshold)
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/dw_mmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 1ac227c603b7..609f0ab6891f 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -625,6 +625,13 @@ static void dw_mci_ctrl_rd_thld(struct dw_mci *host, struct mmc_data *data)
 
 	WARN_ON(!(data->flags & MMC_DATA_READ));
 
+	/*
+	 * CDTHRCTL doesn't exist prior to 240A (in fact that register offset is
+	 * in the FIFO region, so we really shouldn't access it).
+	 */
+	if (host->verid < DW_MMC_240A)
+		return;
+
 	if (host->timing != MMC_TIMING_MMC_HS200 &&
 	    host->timing != MMC_TIMING_UHS_SDR104)
 		goto disable;
-- 
2.1.4

