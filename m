Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEZWN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:13:59 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50473 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaEZWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:13:54 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 01/27] mtd: nand: introduce function to fix a common bug in most nand-drivers not showing a device in sysfs
Date: Tue, 27 May 2014 00:12:26 +0200
Message-Id: <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most nand drivers don't set a parent device for the mtd-device. The result
is that information in sysfs is missing (no folder device).

Comparing the output of

	git grep mtd_device_parse_register drivers/mtd/nand/

with

	git grep parent drivers/mtd/nand/ | cut -f 1 | sort -u

showed that this is a very common error. Looking at some of those drivers
a common pattern is visible which I put into a new inline function to
reduce source code size and to avoid future similiar errors.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 include/linux/mtd/mtd.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index a1b0b4c..2e24afe 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -23,7 +23,7 @@
 #include <linux/types.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
-#include <linux/device.h>
+#include <linux/platform_device.h>
 
 #include <mtd/mtd-abi.h>
 
@@ -366,6 +366,15 @@ static inline int mtd_can_have_bb(const struct mtd_info *mtd)
 struct mtd_partition;
 struct mtd_part_parser_data;
 
+static inline void mtd_setup_common_members(struct mtd_info *mtd, void *priv,
+						struct platform_device *pdev)
+{
+	mtd->priv	= priv;
+	mtd->owner	= pdev->dev.driver->owner;
+	mtd->dev.parent	= &pdev->dev;
+	mtd->name	= pdev->dev.driver->name;
+}
+
 extern int mtd_device_parse_register(struct mtd_info *mtd,
 				     const char * const *part_probe_types,
 				     struct mtd_part_parser_data *parser_data,
-- 
1.8.3.2

