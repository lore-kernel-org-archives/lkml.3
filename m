Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaEDQum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:50:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaEDPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 049/158] mfd: kempld-core: Fix potential hang-up during boot
Date: Sun,  4 May 2014 11:39:18 -0400
Message-Id: <20140504154036.653789527@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/kempld-core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -322,9 +322,12 @@ static int kempld_detect_device(struct k
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
 


