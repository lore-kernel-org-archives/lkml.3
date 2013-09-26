Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3IZTYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:24:55 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40274 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3IZTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:46 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 5/7] mmc: core: handling polling more gracefully
Date: Thu, 26 Sep 2013 12:22:58 -0700
Message-Id: <1380223380-22451-6-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380223380-22451-1-git-send-email-grundler@chromium.org>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case threads "race" to harvest async req completions, just return.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/core/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index deb0ee5..36cfe91 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -531,6 +531,10 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 	int start_err = 0;
 	struct mmc_async_req *saved_areq = host->areq;
 
+	if (!saved_areq && !areq)
+		/* Nothing to do...some code is polling. */
+		goto set_error;
+
 	/* Prepare a new request */
 	if (areq)
 		mmc_pre_req(host, areq->mrq, !saved_areq);
-- 
1.8.4

