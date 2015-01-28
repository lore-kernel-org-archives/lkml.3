Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764048AbbA2DTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:19:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977AbbA2CgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:01 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Hogan <james.hogan@imgtec.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 055/139] mmc: dw_mmc: avoid write to CDTHRCTL on older versions
Date: Wed, 28 Jan 2015 14:19:58 -0800
Message-Id: <1422483682-15393-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mmc/host/dw_mmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 4bce0de..47f96c5 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -631,6 +631,13 @@ static void dw_mci_ctrl_rd_thld(struct dw_mci *host, struct mmc_data *data)
 
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
1.9.1

