Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796Ab3LFWav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:30:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3LFVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 64/83] usb: musb: davinci: fix resources passed to MUSB driver for DM6467
Date: Fri,  6 Dec 2013 13:51:54 -0800
Message-Id: <20131206214646.006158320@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit ea78201e2e08f8a91e30100c4c4a908b5cf295fc upstream.

After commit 09fc7d22b024692b2fe8a943b246de1af307132b (usb: musb: fix incorrect
usage of  resource pointer), CPPI DMA driver on DaVinci DM6467 can't detect its
dedicated IRQ and so the MUSB IRQ  is erroneously used instead. This is because
only 2 resources are passed to the MUSB driver from the DaVinci glue layer,  so
fix  this by always copying 3 resources (it's  safe since a placeholder for the
3rd resource is always  there) and passing 'pdev->num_resources' instead of the
size of musb_resources[] to platform_device_add_resources().

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/musb/davinci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -509,7 +509,7 @@ static u64 davinci_dmamask = DMA_BIT_MAS
 
 static int davinci_probe(struct platform_device *pdev)
 {
-	struct resource musb_resources[2];
+	struct resource			musb_resources[3];
 	struct musb_hdrc_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct platform_device		*musb;
 	struct davinci_glue		*glue;
@@ -567,6 +567,15 @@ static int davinci_probe(struct platform
 	musb_resources[1].end = pdev->resource[1].end;
 	musb_resources[1].flags = pdev->resource[1].flags;
 
+	/*
+	 * For DM6467 3 resources are passed. A placeholder for the 3rd
+	 * resource is always there, so it's safe to always copy it...
+	 */
+	musb_resources[2].name = pdev->resource[2].name;
+	musb_resources[2].start = pdev->resource[2].start;
+	musb_resources[2].end = pdev->resource[2].end;
+	musb_resources[2].flags = pdev->resource[2].flags;
+
 	ret = platform_device_add_resources(musb, musb_resources,
 			ARRAY_SIZE(musb_resources));
 	if (ret) {


