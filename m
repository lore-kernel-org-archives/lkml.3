Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaEMKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60801 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760057AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/182] mfd: kempld-core: Fix potential hang-up during boot
Date: Tue, 13 May 2014 11:26:36 +0200
Message-Id: <ed94d830921131d29932ffe0ae0b1d5f592f43a8.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/kempld-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/kempld-core.c b/drivers/mfd/kempld-core.c
index d3e23278d299..38917a822335 100644
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
1.9.3

