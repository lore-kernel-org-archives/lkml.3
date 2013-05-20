Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3ETOvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:51:55 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1094 "EHLO
	smtp-out-206.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756276Ab3ETOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:51:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6266
From: Lars-Peter Clausen <lars@metafoo.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] input: pxa27x_keypad: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 16:51:21 +0200
Message-Id: <1369061486-28226-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1369061486-28226-1-git-send-email-lars@metafoo.de>
References: <1369061486-28226-1-git-send-email-lars@metafoo.de>
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

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/input/keyboard/pxa27x_keypad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 74e30cc..b674e7a 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -582,7 +582,7 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	return 0;
 
 failed_free_irq:
-	free_irq(irq, pdev);
+	free_irq(irq, keypad);
 failed_put_clk:
 	clk_put(keypad->clk);
 failed_free_io:
@@ -600,7 +600,7 @@ static int pxa27x_keypad_remove(struct platform_device *pdev)
 	struct pxa27x_keypad *keypad = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	free_irq(keypad->irq, pdev);
+	free_irq(keypad->irq, keypad);
 	clk_put(keypad->clk);
 
 	input_unregister_device(keypad->input_dev);
-- 
1.8.0

