Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaBZLIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:08:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:61981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaBZLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/16] swim3: fix interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:44 +0100
Message-Id: <1393412516-3762435-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rA7EnyqV2LXWqbvB3EOSY+GIhCPocorjvgfjR0jVIsP
 7JBXdr8hVi05sk3ZzYHfzlFONj2JtnfWGVeXMsrkJM4C16yzgF
 Tj46SqVxNhSSR3FA6HmsjonFz8MG7Lk+CdXIEqruNjYjEHqNmb
 YegM2Lw9KfAsWxryPp6AOocRgyNchY5JBs7tqw/IJndvSWhVIO
 XmP5ErLd288+RSoBGOiqz7twPUtUAhM147nJQYBwUXdIwpB/Ba
 GB0qdhmvs+8uZBs1IIswSwDTaDo8H7izjwaaF+UomFmyjO518W
 BEiUWw/6e5qYTzPG8soARpnRRSpeqV0Nl0OyyWMTM0ZM4SxTZY
 Ps8hlzufewZ8h7VwUsxI9DaWzGCDNvvYWWaS9mxVF
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

