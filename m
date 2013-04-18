Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967823Ab3DRRBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:01:15 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:63743 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967752Ab3DRQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:59:23 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: sameo@linux.intel.com
Cc: mchehab@redhat.com, andrew.smirnov@gmail.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/12] si476x: Fix some config dependencies and a compile warnings
Date: Thu, 18 Apr 2013 09:58:37 -0700
Message-Id: <1366304318-29620-12-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

radio-si476x depends on SND and SND_SOC, the mfd driver should select
REGMAP_I2C.

Also fix a small compile warning in a debug message:

drivers/mfd/si476x-i2c.c: In function ‘si476x_core_drain_rds_fifo’:
drivers/mfd/si476x-i2c.c:391:4: warning: field width specifier ‘*’ expects argument of type ‘int’, but argument 4 has type ‘long unsigned int’ [-Wformat]

Acked-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig |    2 +-
 drivers/mfd/Kconfig         |    1 +
 drivers/mfd/si476x-i2c.c    |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 170460d..181a25f 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -20,7 +20,7 @@ source "drivers/media/radio/si470x/Kconfig"
 
 config RADIO_SI476X
 	tristate "Silicon Laboratories Si476x I2C FM Radio"
-	depends on I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2 && SND && SND_SOC
 	select MFD_CORE
 	select MFD_SI476X_CORE
 	select SND_SOC_SI476X
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3cd8f21..606e549 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -974,6 +974,7 @@ config MFD_SI476X_CORE
 	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
 	depends on I2C
 	select MFD_CORE
+	select REGMAP_I2C
 	help
 	  This is the core driver for the SI476x series of AM/FM
 	  radio. This MFD driver connects the radio-si476x V4L2 module
diff --git a/drivers/mfd/si476x-i2c.c b/drivers/mfd/si476x-i2c.c
index 118c6b1..f5bc8e4 100644
--- a/drivers/mfd/si476x-i2c.c
+++ b/drivers/mfd/si476x-i2c.c
@@ -389,7 +389,7 @@ static void si476x_core_drain_rds_fifo(struct work_struct *work)
 			kfifo_in(&core->rds_fifo, report.rds,
 				 sizeof(report.rds));
 			dev_dbg(&core->client->dev, "RDS data:\n %*ph\n",
-				sizeof(report.rds), report.rds);
+				(int)sizeof(report.rds), report.rds);
 		}
 		dev_dbg(&core->client->dev, "Drrrrained!\n");
 		wake_up_interruptible(&core->rds_read_queue);
-- 
1.7.10.4

