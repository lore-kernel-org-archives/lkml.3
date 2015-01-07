Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbbAGCeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:34:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581AbbAGCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 08/73] mfd: tc6393xb: Fail ohci suspend if full state restore is required
Date: Tue,  6 Jan 2015 18:15:29 -0800
Message-Id: <20150107021557.781051241@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/tc6393xb.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -263,6 +263,17 @@ static int tc6393xb_ohci_disable(struct
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
@@ -403,7 +414,7 @@ static struct mfd_cell tc6393xb_cells[]
 		.num_resources = ARRAY_SIZE(tc6393xb_ohci_resources),
 		.resources = tc6393xb_ohci_resources,
 		.enable = tc6393xb_ohci_enable,
-		.suspend = tc6393xb_ohci_disable,
+		.suspend = tc6393xb_ohci_suspend,
 		.resume = tc6393xb_ohci_enable,
 		.disable = tc6393xb_ohci_disable,
 	},


