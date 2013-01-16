Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3APQWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:22:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:65274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab3APQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:22:42 -0500
Date: Wed, 16 Jan 2013 17:22:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: avoid use after free of a pinctrl context pointer
Message-ID: <Pine.LNX.4.64.1301161720440.19928@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:M2vb3zVPEk92zwpNfXQ4u47B5+NEhlTkXWLHcLauIaF
 iv70GZWxXLDC4UDdKjqAB9ffAwrO3vHFXTmgTAdFHkjHLlXWxW
 ryJRQNNrFa8sULlXRvvelvxq1uCf/h/uy9uO2SxguPz8QnBOGX
 f0VfagS9HyuUfn3Gf9IyTkhD8yJw8nOfr+AVl04Iz4ezkMFiyR
 8sZjcYFH+jbdV/Hw4Fx/mijljduMijT8LfMa6eIuW8IDMeDssq
 KEyImE275nn6f+VaBepCBjVP2wW6W5rcEKujcQd5JJFkvmpf7a
 hUs9OrOGmZyIpCFPUEyY6Wbifc7HVA7YtW7ebbqo3vJ9ZZWTSh
 zeyaZKxl/oOQA61PosZ/2U2pvN2M+gXq7XV5z5F9hwzsvb3cxG
 jrb9VFi8fbmwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probing, pinctrl context is allocated and assigned to the struct
device::pins pointer. If probing fails or if the driver is later unbound
and re-probed again, the memory is freed, but the pointer is not cleared.
On a repeated probing attempt a non-NULL pointer indicates an already
allocated context, which then gets used. To avoid this the pointer must
be cleared.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/base/dd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 65631015..e5c71b5 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -302,6 +302,7 @@ probe_failed:
 	devres_release_all(dev);
 	driver_sysfs_remove(dev);
 	dev->driver = NULL;
+	dev->pins = NULL;
 	dev_set_drvdata(dev, NULL);
 
 	if (ret == -EPROBE_DEFER) {
@@ -505,6 +506,7 @@ static void __device_release_driver(struct device *dev)
 			drv->remove(dev);
 		devres_release_all(dev);
 		dev->driver = NULL;
+		dev->pins = NULL;
 		dev_set_drvdata(dev, NULL);
 		klist_remove(&dev->p->knode_driver);
 		if (dev->bus)
-- 
1.7.2.5

