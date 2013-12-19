Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3LSPHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:07:51 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55386 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab3LSPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:14 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 27/38] superhyway: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:38 +0100
Message-Id: <1387465429-3568-28-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Also, this makes superhyway_device_release actually used.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/sh/superhyway/superhyway.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/sh/superhyway/superhyway.c b/drivers/sh/superhyway/superhyway.c
index 2d9e7f3..765cf7d 100644
--- a/drivers/sh/superhyway/superhyway.c
+++ b/drivers/sh/superhyway/superhyway.c
@@ -54,6 +54,7 @@ int superhyway_add_device(unsigned long base, struct superhyway_device *sdev,
 			  struct superhyway_bus *bus)
 {
 	struct superhyway_device *dev = sdev;
+	int rc = 0;
 
 	if (!dev) {
 		dev = kzalloc(sizeof(struct superhyway_device), GFP_KERNEL);
@@ -86,8 +87,11 @@ int superhyway_add_device(unsigned long base, struct superhyway_device *sdev,
 	dev_set_name(&dev->dev, "%02x", superhyway_devices);
 
 	superhyway_devices++;
+	rc = device_register(&dev->dev);
+	if (rc)
+		put_device(&dev->dev);
 
-	return device_register(&dev->dev);
+	return rc;
 }
 
 int superhyway_add_devices(struct superhyway_bus *bus,
-- 
1.8.3.1

