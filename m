Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaIPVOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:14:32 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35687 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaIPVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:14:15 -0400
From: Peter Ujfalusi <peter.ujfalusi@gmail.com>
To: dvhart@infradead.org, mjg59@srcf.ucam.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.ujfalusi@gmail.com
Subject: [PATCH 2/2] intel-rst: Clean up ACPI add function
Date: Wed, 17 Sep 2014 00:13:56 +0300
Message-Id: <1410902036-10282-3-git-send-email-peter.ujfalusi@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
References: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to initialize the error since it is going to be assigned
with the return status of at least on of the device_create_file() call.

We can return directly in case the first file creation fails.
All the labels for goto can be removed (along with the gotos) as well.
Tell the compiler that the failures are unlikely so it can create better
binaries.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
---
 drivers/platform/x86/intel-rst.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
index 8c6a8fe..7344d84 100644
--- a/drivers/platform/x86/intel-rst.c
+++ b/drivers/platform/x86/intel-rst.c
@@ -119,21 +119,16 @@ static struct device_attribute irst_timeout_attr = {
 
 static int irst_add(struct acpi_device *acpi)
 {
-	int error = 0;
+	int error;
 
 	error = device_create_file(&acpi->dev, &irst_timeout_attr);
-	if (error)
-		goto out;
+	if (unlikely(error))
+		return error;
 
 	error = device_create_file(&acpi->dev, &irst_wakeup_attr);
-	if (error)
-		goto out_timeout;
+	if (unlikely(error))
+		device_remove_file(&acpi->dev, &irst_timeout_attr);
 
-	return 0;
-
-out_timeout:
-	device_remove_file(&acpi->dev, &irst_timeout_attr);
-out:
 	return error;
 }
 
-- 
2.1.0

