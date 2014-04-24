Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaDXKKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:10:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaDXIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 085/182] mfd: kempld-core: Fix potential hang-up during boot
Date: Thu, 24 Apr 2014 09:50:10 +0100
Message-Id: <1398329507-5911-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 204747c970c0d568721c76ab8a57dde0e5dcf0d5 upstream.

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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/kempld-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index 686a456..1b1b462 100644
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
1.9.1

