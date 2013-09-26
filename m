Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3IZTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:23:52 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42648 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab3IZTXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:44 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 4/7] mmc: core: use common code path to return error
Date: Thu, 26 Sep 2013 12:22:57 -0700
Message-Id: <1380223380-22451-5-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380223380-22451-1-git-send-email-grundler@chromium.org>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't replicate how the *error is returned by mmc_start_req().

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/core/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 4d5de98..deb0ee5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -538,13 +538,12 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 	if (saved_areq) {
 		saved_err = mmc_wait_for_data_req_done(host, saved_areq->mrq,	areq);
 		if (saved_err == MMC_BLK_NEW_REQUEST) {
-			if (error)
-				*error = saved_err;
 			/*
 			 * The previous request was not completed,
 			 * nothing to return
 			 */
-			return NULL;
+			saved_areq = NULL;
+			goto set_error;
 		}
 		/*
 		 * Check BKOPS urgency for each R1 response
@@ -570,8 +569,10 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 	if (saved_areq)
 		mmc_post_req(host, saved_areq->mrq, 0);
 
+set_error:
 	if (error)
 		*error = saved_err;
+
 	return saved_areq;
 }
 EXPORT_SYMBOL(mmc_start_req);
-- 
1.8.4

