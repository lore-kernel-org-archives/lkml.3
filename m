Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3ETOwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:52:02 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1081 "EHLO
	smtp-out-206.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757069Ab3ETOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:51:59 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6266
From: Lars-Peter Clausen <lars@metafoo.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 7/7] input: navpoint: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 16:51:26 +0200
Message-Id: <1369061486-28226-7-git-send-email-lars@metafoo.de>
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
 drivers/input/mouse/navpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/navpoint.c b/drivers/input/mouse/navpoint.c
index 8e1b98e..0b8d335 100644
--- a/drivers/input/mouse/navpoint.c
+++ b/drivers/input/mouse/navpoint.c
@@ -287,7 +287,7 @@ static int navpoint_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_irq:
-	free_irq(ssp->irq, &pdev->dev);
+	free_irq(ssp->irq, navpoint);
 err_free_mem:
 	input_free_device(input);
 	kfree(navpoint);
-- 
1.8.0

