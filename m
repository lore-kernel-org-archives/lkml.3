Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbbAGCrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:47:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbbAGCHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.14 08/52] mmc: dw_mmc: avoid write to CDTHRCTL on older versions
Date: Tue,  6 Jan 2015 18:06:36 -0800
Message-Id: <20150107020556.403045915@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/dw_mmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -632,6 +632,13 @@ static void dw_mci_ctrl_rd_thld(struct d
 
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


