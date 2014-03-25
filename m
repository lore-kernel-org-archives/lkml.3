Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaCYXtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:49:18 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:53590 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaCYXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:49:12 -0400
From: Gwendal Grignou <gwendal@chromium.org>
To: axboe@kernel.dk, ulf.hansson@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 3/4] Limit max_discard_sectors to UINT_MAX>>9
Date: Tue, 25 Mar 2014 16:48:25 -0700
Message-Id: <1395791307-23727-4-git-send-email-gwendal@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
References: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_discard_sectors can not be larger than UINT_MAX>>9,
otherwise, there is a risk that discard requests would be merged
into a request larger than 4GB.
Ensure that max_discard_sectors is in unit of sectors.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/mmc/core/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 57a2b40..46e7ced 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2153,7 +2153,7 @@ static unsigned int mmc_do_calc_max_discard(struct mmc_card *card,
 	if (qty == 1)
 		return 1;
 
-	/* Convert qty to sectors */
+	/* Convert qty to bytes */
 	if (card->erase_shift)
 		max_discard = --qty << card->erase_shift;
 	else if (mmc_card_sd(card))
@@ -2170,7 +2170,7 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
 	unsigned int max_discard, max_trim;
 
 	if (!host->max_discard_to)
-		return UINT_MAX;
+		return UINT_MAX >> 9;
 
 	/*
 	 * Without erase_group_def set, MMC erase timeout depends on clock
@@ -2188,6 +2188,8 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
 	} else if (max_discard < card->erase_size) {
 		max_discard = 0;
 	}
+	/* convert max_discard to sectors */
+	max_discard >>= 9;
 	pr_debug("%s: calculated max. discard sectors %u for timeout %u ms\n",
 		 mmc_hostname(host), max_discard, host->max_discard_to);
 	return max_discard;
-- 
1.9.1.423.g4596e3a

