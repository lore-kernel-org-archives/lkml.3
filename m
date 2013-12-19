Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3LSPGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:06:10 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43635 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3LSPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:25 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 30/38] vlynq: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:41 +0100
Message-Id: <1387465429-3568-31-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
This will result in vlynq_device_release being called making the kfree()
in the errorpath unneccessary.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/vlynq/vlynq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index 7b07135..71d5905 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -748,11 +748,14 @@ static int vlynq_probe(struct platform_device *pdev)
 	return 0;
 
 fail_register:
+	put_device(&dev->dev);
+	dev->dev = 0;
 	iounmap(dev->local);
 fail_remap:
 fail_request:
 	release_mem_region(regs_res->start, len);
-	kfree(dev);
+	if(dev)
+		kfree(dev);
 	return result;
 }
 
-- 
1.8.3.1

