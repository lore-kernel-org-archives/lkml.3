Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab3CNBXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:23:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49446 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3CNBXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:23:23 -0400
From: Sergey Yanovich <ynvich@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Sergey Yanovich <ynvich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH v2] wait while adding MMC host to ensure root mounts
Date: Thu, 14 Mar 2013 05:23:13 +0400
Message-Id: <1363224194-7366-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC hosts are added asynchronously. We need to wait until detect returns to
avoid failed root filesystem mounts.
---8<---
VFS: Cannot open root device "mmcblk0p1" or unknown-block(0,0): error -6
Please append a correct "root=" boot option; here are the available partitions:
mmc0: host does not support reading read-only switch. assuming write-enable.
1f00             256 mtdblock0  (driver?)
1f01             256 mtdblock1  (driver?)
1f02            2560 mtdblock2 mmc0: new SDHC card at address b368
 (driver?)
1f03           29696 mtdblock3  (driver?)
1f04           16384 mtdblock4 mmcblk0: mmc0:b368 USD   3.72 GiB
 (driver?)
 mmcblk0: p1
b300         3910656 mmcblk0  driver: mmcblk
  b301         3906560 mmcblk0p1 00000000-01
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
---8<---

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
changes for v2:
- removed exporting as symbol is in the same file

 drivers/mmc/core/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..7196888 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2225,6 +2225,7 @@ void mmc_start_host(struct mmc_host *host)
 	host->rescan_disable = 0;
 	mmc_power_up(host);
 	mmc_detect_change(host, 0);
+	mmc_flush_scheduled_work();
 }
 
 void mmc_stop_host(struct mmc_host *host)
-- 
1.7.10.4

