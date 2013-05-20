Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3ETOwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:52:49 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1080 "EHLO
	smtp-out-206.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757180Ab3ETOv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:51:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6266
From: Lars-Peter Clausen <lars@metafoo.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: [PATCH 6/7] input: pmic8xxx-pwrkey: Pass correct pointer to free_irq()
Date: Mon, 20 May 2013 16:51:25 +0200
Message-Id: <1369061486-28226-6-git-send-email-lars@metafoo.de>
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

Cc: Trilok Soni <tsoni@codeaurora.org>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index afd0af9..b49b738 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -175,7 +175,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	return 0;
 
 free_press_irq:
-	free_irq(key_press_irq, NULL);
+	free_irq(key_press_irq, pwrkey);
 unreg_input_dev:
 	input_unregister_device(pwr);
 	pwr = NULL;
-- 
1.8.0

