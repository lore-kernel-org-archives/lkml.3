Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbbAIKy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:54:57 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44506 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757340AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 40/78] mfd: tc6393xb: Fail ohci suspend if full state restore is required
Date: Fri,  9 Jan 2015 11:31:49 +0100
Message-Id: <5e5e43db1e1a87168db5e5f2692dd78845f89caf.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/tc6393xb.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 11c19e538551..48579e5ef02c 100644
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
2.2.1

