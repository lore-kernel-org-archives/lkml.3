Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3GIXTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:19:38 -0400
Received: from mail-ye0-f201.google.com ([209.85.213.201]:58695 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3GIXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:19:32 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Olof Johansson <olof@lixom.net>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] mmc: dw_mmc: Set timeout to max upon resume
Date: Tue,  9 Jul 2013 16:19:21 -0700
Message-Id: <1373411961-23812-6-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1373411961-23812-1-git-send-email-dianders@chromium.org>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
 <1373411961-23812-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMOUT register is initted to 0xffffffff at probe time but isn't
initted after suspend/resume.  Add an init of this value.

No problems were observed without this (it will also get initted in
__dw_mci_start_request if there is data to send), but it makes the
register dump before and after suspend clean.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2: None

 drivers/mmc/host/dw_mmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index be095b7..d2c5db3 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2482,6 +2482,9 @@ int dw_mci_resume(struct dw_mci *host)
 	/* Restore the old value at FIFOTH register */
 	mci_writel(host, FIFOTH, host->fifoth_val);
 
+	/* Put in max timeout */
+	mci_writel(host, TMOUT, 0xFFFFFFFF);
+
 	mci_writel(host, RINTSTS, 0xFFFFFFFF);
 	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
 		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |
-- 
1.8.3

