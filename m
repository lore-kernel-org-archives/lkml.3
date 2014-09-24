Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaIXAYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:24:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50449 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIXAYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:24:44 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 3/4] toshiba_acpi: Change HCI/SCI functions return code type
Date: Tue, 23 Sep 2014 18:24:27 -0600
Message-Id: <1411518268-2773-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the HCI/SCI read/write functions are returning
the status of the ACPI call and also assigning the
returned value of the HCI/SCI function.

This patch changes such functions, returning the value
of the HCI/SCI function instead of the ACPI call status.

The next patch will change all the HCI/SCI functions
to reflect the change made in this patch.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 51 ++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 5b16d11..43385f7 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -316,47 +316,49 @@ static acpi_status tci_raw(struct toshiba_acpi_dev *dev,
  * may be useful (such as "not supported").
  */
 
-static acpi_status hci_write1(struct toshiba_acpi_dev *dev, u32 reg,
-			      u32 in1, u32 *result)
+static u32 hci_write1(struct toshiba_acpi_dev *dev, u32 reg, u32 in1)
 {
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
-static acpi_status hci_read1(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 *out1, u32 *result)
+static u32 hci_read1(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1)
 {
 	u32 in[HCI_WORDS] = { HCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
-static acpi_status hci_write2(struct toshiba_acpi_dev *dev, u32 reg,
-			      u32 in1, u32 in2, u32 *result)
+static u32 hci_write2(struct toshiba_acpi_dev *dev, u32 reg, u32 in1, u32 in2)
 {
 	u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
-static acpi_status hci_read2(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 *out1, u32 *out2, u32 *result)
+static u32 hci_read2(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1, u32 *out2)
 {
 	u32 in[HCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
 	*out2 = out[3];
-	*result = (status == AE_OK) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
 /* common sci tasks
@@ -406,25 +408,26 @@ static void sci_close(struct toshiba_acpi_dev *dev)
 		pr_info("Toshiba SCI is not present\n");
 }
 
-static acpi_status sci_read(struct toshiba_acpi_dev *dev, u32 reg,
-			    u32 *out1, u32 *result)
+static u32 sci_read(struct toshiba_acpi_dev *dev, u32 reg, u32 *out1)
 {
 	u32 in[HCI_WORDS] = { SCI_GET, reg, 0, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
+	if (ACPI_FAILURE(status))
+		return TOS_FAILURE;
+
 	*out1 = out[2];
-	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return out[0];
 }
 
-static acpi_status sci_write(struct toshiba_acpi_dev *dev, u32 reg,
-			     u32 in1, u32 *result)
+static u32 sci_write(struct toshiba_acpi_dev *dev, u32 reg, u32 in1)
 {
 	u32 in[HCI_WORDS] = { SCI_SET, reg, in1, 0, 0, 0 };
 	u32 out[HCI_WORDS];
 	acpi_status status = tci_raw(dev, in, out);
-	*result = (ACPI_SUCCESS(status)) ? out[0] : TOS_FAILURE;
-	return status;
+
+	return ACPI_SUCCESS(status) ? out[0] : TOS_FAILURE;
 }
 
 /* Illumination support */
-- 
2.0.0

