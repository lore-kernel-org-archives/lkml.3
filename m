Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbaCTPMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:12:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49943 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCTPMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:12:42 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Michael Brunner <michael.brunner@kontron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: kempld-core: Fix potential hang-up during boot
Date: Thu, 20 Mar 2014 08:12:28 -0700
Message-Id: <1395328348-20661-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PXT and COMe-cPC2 boards it is observed that the hardware
mutex is acquired but not being released during initialization.
This can result in a hang-up during boot if the driver is built
into the kernel.

Releasing the mutex twice if it was acquired fixes the problem.
Subsequent request/release cycles work as expected, so the fix is
only needed during initialization.

Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
Tested-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/kempld-core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index d3e2327..38917a8 100644
--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -322,9 +322,12 @@ static int kempld_detect_device(struct kempld_device_data *pld)
 		return -ENODEV;
 	}
 
-	/* Release hardware mutex if aquired */
-	if (!(index_reg & KEMPLD_MUTEX_KEY))
+	/* Release hardware mutex if acquired */
+	if (!(index_reg & KEMPLD_MUTEX_KEY)) {
 		iowrite8(KEMPLD_MUTEX_KEY, pld->io_index);
+		/* PXT and COMe-cPC2 boards may require a second release */
+		iowrite8(KEMPLD_MUTEX_KEY, pld->io_index);
+	}
 
 	mutex_unlock(&pld->lock);
 
-- 
1.7.9.7

