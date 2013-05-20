Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3ETOv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:51:57 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1050 "EHLO
	smtp-out-206.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756482Ab3ETOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:51:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6266
From: Lars-Peter Clausen <lars@metafoo.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH 1/7] input: ep93xx_keypad: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 16:51:20 +0200
Message-Id: <1369061486-28226-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_irq() expects the same pointer that was passed to request_irq(), otherwise
the IRQ is not freed.

The issue was found using the following coccinelle script:

<smpl>
@r1@
type T;
T devid;
@@
request_irq(..., devid)

@r2@
type r1.T;
T devid;
position p;
@@
free_irq@p(..., devid)

@@
position p != r2.p;
@@
*free_irq@p(...)
</smpl>

Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/input/keyboard/ep93xx_keypad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/ep93xx_keypad.c b/drivers/input/keyboard/ep93xx_keypad.c
index a8d5aac..47206bd 100644
--- a/drivers/input/keyboard/ep93xx_keypad.c
+++ b/drivers/input/keyboard/ep93xx_keypad.c
@@ -329,7 +329,7 @@ static int ep93xx_keypad_probe(struct platform_device *pdev)
 	return 0;
 
 failed_free_irq:
-	free_irq(keypad->irq, pdev);
+	free_irq(keypad->irq, keypad);
 failed_free_dev:
 	input_free_device(input_dev);
 failed_put_clk:
@@ -350,7 +350,7 @@ static int ep93xx_keypad_remove(struct platform_device *pdev)
 	struct ep93xx_keypad *keypad = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	free_irq(keypad->irq, pdev);
+	free_irq(keypad->irq, keypad);
 
 	if (keypad->enabled)
 		clk_disable(keypad->clk);
-- 
1.8.0

