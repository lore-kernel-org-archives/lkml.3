Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaEBPo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:44:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaEBPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 085/151] mfd: kempld-core: Fix potential hang-up during boot
Date: Fri,  2 May 2014 08:37:53 -0700
Message-Id: <1399045139-4531-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/kempld-core.c | 7 +++++--
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
1.9.1

