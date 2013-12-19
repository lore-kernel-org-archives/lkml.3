Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3LSPPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:15:34 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51477 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3LSPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:27 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/38] arm: mach-integrator: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:22 +0100
Message-Id: <1387465429-3568-12-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Calling put_device on the failed device will allow lm_device_release to be
called which will kfree() the struct lm_device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/arm/mach-integrator/lm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-integrator/lm.c b/arch/arm/mach-integrator/lm.c
index f52c7af..1199f38 100644
--- a/arch/arm/mach-integrator/lm.c
+++ b/arch/arm/mach-integrator/lm.c
@@ -89,8 +89,10 @@ int lm_device_register(struct lm_device *dev)
 	ret = request_resource(&iomem_resource, &dev->resource);
 	if (ret == 0) {
 		ret = device_register(&dev->dev);
-		if (ret)
+		if (ret) {
 			release_resource(&dev->resource);
+			put_device(&dev->dev);
+		}
 	}
 	return ret;
 }
-- 
1.8.3.1

