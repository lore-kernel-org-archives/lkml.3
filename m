Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3IZTXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:23:49 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43650 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IZTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:42 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 3/7] mmc: core: restructure error handling for start req
Date: Thu, 26 Sep 2013 12:22:56 -0700
Message-Id: <1380223380-22451-4-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380223380-22451-1-git-send-email-grundler@chromium.org>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an intermediate step to fixing the locking around the
access to host->areq. Reduce the number of "if (saved_areq) vs
"if (areq)" tests in the main code path since I'm going to add
references to "host->lock" in the next patch.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/core/core.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 675139e..4d5de98 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -556,21 +556,20 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 			mmc_start_bkops(host->card, true);
 	}
 
-	if (!saved_err && areq)
+	/* Don't start something new if previous one failed. */
+	if (!saved_err && areq) {
 		start_err = __mmc_start_data_req(host, areq->mrq);
+		/* Cancel a prepared request if it was not started. */
+		if (start_err) {
+			mmc_post_req(host, areq->mrq, -EINVAL);
+			host->areq = NULL;
+		} else 
+			host->areq = areq;
+	}
 
 	if (saved_areq)
 		mmc_post_req(host, saved_areq->mrq, 0);
 
-	 /* Cancel a prepared request if it was not started. */
-	if ((saved_err || start_err) && areq)
-		mmc_post_req(host, areq->mrq, -EINVAL);
-
-	if (saved_err)
-		host->areq = NULL;
-	else
-		host->areq = areq;
-
 	if (error)
 		*error = saved_err;
 	return saved_areq;
-- 
1.8.4

