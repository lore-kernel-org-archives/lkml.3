Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979AbaKLD4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:56:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbaKLD4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:56:09 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Wed, 12 Nov 2014 14:55:19 +1100
Subject: [PATCH 2/2] mmc: core: reset sdio card properly on resume.
Cc: GTA04 owners <gta04-owner@goldelico.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141112035519.18267.37985.stgit@notabene.brown>
In-Reply-To: <20141112035217.18267.43304.stgit@notabene.brown>
References: <20141112035217.18267.43304.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_sdio_power_restore() calls
	mmc_send_if_cond(host, host->card->ocr);

	ret = mmc_send_io_op_cond(host, 0, NULL);

between mmc_go_idle() and mmc_sdio_init_card().
mmc_sdio_resume() needs to as well, else my libertas sdio wifi
device doesn't resume properly from suspend.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/core/sdio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3c0f07961fab..da927c61bf47 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -981,8 +981,12 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	if (mmc_card_is_removable(host) || !mmc_card_keep_power(host)) {
 		sdio_reset(host);
 		mmc_go_idle(host);
-		err = mmc_sdio_init_card(host, host->card->ocr, host->card,
-					mmc_card_keep_power(host));
+		mmc_send_if_cond(host, host->card->ocr);
+		err = mmc_send_io_op_cond(host, 0, NULL);
+		if (!err)
+			err = mmc_sdio_init_card(host, host->card->ocr,
+						 host->card,
+						 mmc_card_keep_power(host));
 	} else if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host)) {
 		/* We may have switched to 1-bit mode during suspend */
 		err = sdio_enable_4bit_bus(host->card);


