Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbbANDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:09:58 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:51108 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751427AbbANDJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:09:56 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E39Vx7009481, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <ulf.hansson@linaro.org>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 2/2] mmc: rtsx: check sg_count before long data xfer
Date: Wed, 14 Jan 2015 11:09:12 +0800
Message-ID: <55d9f11a9338acd70f820673d4548ac9939dabc6.1421204431.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421204431.git.micky_ching@realsil.com.cn>
References: <cover.1421204431.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Check sg_count before sending long data xfer.
Because dma_map_sg() return int, and sg_count may be negative,
so using int instead of unsigned.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index b435806..1d3d6c4 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -54,9 +54,9 @@ struct realtek_pci_sdmmc {
 #define SDMMC_POWER_ON		1
 #define SDMMC_POWER_OFF		0
 
-	unsigned int		sg_count;
+	int			sg_count;
 	s32			cookie;
-	unsigned int		cookie_sg_count;
+	int			cookie_sg_count;
 	bool			using_cookie;
 };
 
@@ -557,6 +557,13 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 {
 	struct mmc_data *data = mrq->data;
 
+	if (host->sg_count < 0) {
+		data->error = host->sg_count;
+		dev_dbg(sdmmc_dev(host), "%s: sg_count = %d is invalid\n",
+			__func__, host->sg_count);
+		return data->error;
+	}
+
 	if (data->flags & MMC_DATA_READ)
 		return sd_read_long_data(host, mrq);
 
-- 
1.9.1

