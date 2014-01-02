Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaABMRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:17:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaABMIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH, RFC 04/30] swim3: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:28 +0100
Message-Id: <1388664474-1710039-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:aHw5RgM1BHIKCO+N/US3nDvq0zLw9YxKXZ6/cXeC4yk
 WgpxXd3VryLRfFDc4S9AcQfipaIfmI97ON8rCnlKqGMoDktyEQ
 4xnki6RVHfAhr8s1YN6tmVq7Y7xUKFGfqJAUT7TAW0uWNTON5Y
 Jvei8FSmmnb6LIrFfcyByNFNl4JrOi3NKFqfGfz1f3tKqx72vi
 rxUwpgMSPhNXTT2MAUnh8CcOwJwxn9ziRPUIBFCYOZO3c9CVrh
 P0yVtUipOJLQpi1LYdP3vR+i1EEFEDbYUlycZEoIkN/YTuYSas
 b0yPIIqwGTdJ45PM4zXo8OGi+ILhaSeFBwrgJgsdnFGv/xIj9Q
 OyhHSTvqP8CWT9N2UgglwUuZrlK33AhZ/gF09kDM0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces the one
caller in the swim3 driver with the equivalent race-free
wait_event_interruptible call. Since we're here already, this
also fixes the case where we get interrupted from atomic context,
which used to just spin in the loop.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/swim3.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 20e061c..c74f7b5 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -30,6 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 #include <asm/io.h>
 #include <asm/dbdma.h>
 #include <asm/prom.h>
@@ -840,14 +841,17 @@ static int grab_drive(struct floppy_state *fs, enum swim_state state,
 	spin_lock_irqsave(&swim3_lock, flags);
 	if (fs->state != idle && fs->state != available) {
 		++fs->wanted;
-		while (fs->state != available) {
+		/* this will enable irqs in order to sleep */
+		if (!interruptible)
+			wait_event_lock_irq(fs->wait,
+                                        fs->state == available,
+                                        swim3_lock);
+		else if (wait_event_interruptible_lock_irq(fs->wait,
+					fs->state == available,
+					swim3_lock)) {
+			--fs->wanted;
 			spin_unlock_irqrestore(&swim3_lock, flags);
-			if (interruptible && signal_pending(current)) {
-				--fs->wanted;
-				return -EINTR;
-			}
-			interruptible_sleep_on(&fs->wait);
-			spin_lock_irqsave(&swim3_lock, flags);
+			return -EINTR;
 		}
 		--fs->wanted;
 	}
-- 
1.8.3.2

