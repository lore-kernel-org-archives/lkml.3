Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaJXRUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:20:12 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65139 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaJXRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:20:10 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] mfd: tc6393xb fail ohci suspend if full state restore is required
Date: Fri, 24 Oct 2014 21:19:57 +0400
Message-Id: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards with TC6393XB chip require full state restore during system
resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
tosa is one of them). Failing to do so would result in ohci Oops on
resume due to internal memory contentes being changed. Fail ohci suspend
on tc6393xb is full state restore is required.

Recommended workaround is to unbind tmio-ohci driver before suspend and
rebind it after resume.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/tc6393xb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 11c19e5..48579e5 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -263,6 +263,17 @@ static int tc6393xb_ohci_disable(struct platform_device *dev)
 	return 0;
 }
 
+static int tc6393xb_ohci_suspend(struct platform_device *dev)
+{
+	struct tc6393xb_platform_data *tcpd = dev_get_platdata(dev->dev.parent);
+
+	/* We can't properly store/restore OHCI state, so fail here */
+	if (tcpd->resume_restore)
+		return -EBUSY;
+
+	return tc6393xb_ohci_disable(dev);
+}
+
 static int tc6393xb_fb_enable(struct platform_device *dev)
 {
 	struct tc6393xb *tc6393xb = dev_get_drvdata(dev->dev.parent);
@@ -403,7 +414,7 @@ static struct mfd_cell tc6393xb_cells[] = {
 		.num_resources = ARRAY_SIZE(tc6393xb_ohci_resources),
 		.resources = tc6393xb_ohci_resources,
 		.enable = tc6393xb_ohci_enable,
-		.suspend = tc6393xb_ohci_disable,
+		.suspend = tc6393xb_ohci_suspend,
 		.resume = tc6393xb_ohci_enable,
 		.disable = tc6393xb_ohci_disable,
 	},
-- 
2.1.1

