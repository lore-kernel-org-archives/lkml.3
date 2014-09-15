Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaIOR4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:56:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57125 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaIOR4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:56:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <kbuild@01.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>,
        Julia Lawal <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] Input: palmas-pwrbutton: Fix IRQ flags for using threaded handler alone.
Date: Mon, 15 Sep 2014 12:55:58 -0500
Message-ID: <1410803758-26906-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make C=2 CHECK="scripts/coccicheck" MODE=report COCCI=scripts/coccinelle/misc/irqf_oneshot.cocci ./drivers/input/misc/palmas-pwrbutton.o
Reports:
drivers/input/misc/palmas-pwrbutton.c:213:9-29: ERROR: Threaded IRQ with no primary handler requested without IRQF_ONESHOT

Palmas powerbutton just needs threaded IRQ handler since I2C
operations are involved and there is nothing in non-threaded primary
handler we could do.

So mark the request with ONESHOT as it should have been done in these
cases.

Cc: Julia Lawal <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: adff5962fdd2 ("Input: introduce palmas-pwrbutton")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/input/misc/palmas-pwrbutton.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
index 4ed6f78..c0c4636 100644
--- a/drivers/input/misc/palmas-pwrbutton.c
+++ b/drivers/input/misc/palmas-pwrbutton.c
@@ -211,8 +211,8 @@ static int palmas_pwron_probe(struct platform_device *pdev)
 
 	pwron->irq = platform_get_irq(pdev, 0);
 	error = request_threaded_irq(pwron->irq, NULL, pwron_irq,
-				     IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW,
-				     dev_name(dev), pwron);
+				     IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW |
+				     IRQF_ONESHOT, dev_name(dev), pwron);
 	if (error) {
 		dev_err(dev, "Can't get IRQ for pwron: %d\n", error);
 		goto err_free_input;
-- 
1.7.9.5

