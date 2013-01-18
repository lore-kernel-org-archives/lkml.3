Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3ARHY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:24:57 -0500
Received: from norkia.v3.sk ([91.210.183.14]:46614 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3ARHYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:24:55 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Harro Haan <hrhaan@gmail.com>, Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] libertas sdio: remove CMD_FUNC_INIT call
Date: Fri, 18 Jan 2013 08:24:43 +0100
Message-Id: <1358493883-28433-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It actually times out on a 8688 present in GuruPlug with sd8688.bin
(md5=7233401e9687f8c880da547beed4324e) firmware (that's present in
linux-firmware tree), but the adapter works fine.

For that firmware times out with libertas_uap [1] as well, though it succeeds
with sd8688_ap.bin (md5=52cd8f8296b9a7e1d3835d57416256b2) that was originally
shipped with GuruPlug. That firmware is not in linux-firmware tree and btmrvl
driver might win the race programming the 8688 with sd8688.bin anyway.

[1] https://github.com/lkundrak/linux/tree/libertas_uap
---
 drivers/net/wireless/libertas/if_sdio.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 2ecab49..3c4c555 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -825,20 +825,6 @@ static void if_sdio_finish_power_on(struct if_sdio_card *card)
 
 	sdio_release_host(func);
 
-	/*
-	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
-	 */
-	if (card->model == MODEL_8688) {
-		struct cmd_header cmd;
-
-		memset(&cmd, 0, sizeof(cmd));
-
-		lbs_deb_sdio("send function INIT command\n");
-		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
-				lbs_cmd_copyback, (unsigned long) &cmd))
-			netdev_alert(priv->dev, "CMD_FUNC_INIT cmd failed\n");
-	}
-
 	priv->fw_ready = 1;
 	wake_up(&card->pwron_waitq);
 
-- 
1.7.1

