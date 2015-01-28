Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764208AbbA2DYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:24:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964863AbbA2Cff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 053/139] mfd: tc6393xb: Fail ohci suspend if full state restore is required
Date: Wed, 28 Jan 2015 14:19:56 -0800
Message-Id: <1422483682-15393-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 1a5fb99de4850cba710d91becfa2c65653048589 upstream.

Some boards with TC6393XB chip require full state restore during system
resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
tosa is one of them). Failing to do so would result in ohci Oops on
resume due to internal memory contentes being changed. Fail ohci suspend
on tc6393xb is full state restore is required.

Recommended workaround is to unbind tmio-ohci driver before suspend and
rebind it after resume.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.9.1

