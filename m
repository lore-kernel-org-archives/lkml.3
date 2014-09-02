Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaIBSEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:04:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbaIBSEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:04:48 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] platform/x86: toshiba: re-enable acpi hotkeys after suspend to disk
Date: Tue,  2 Sep 2014 14:04:19 -0400
Message-Id: <1409681059-6493-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Toshiba Tecra Z40, after a suspend-to-disk, some FN hotkeys
driven by toshiba_acpi are not functional.

Calling the ACPI object ENAB on resume makes them back alive.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi guys,

we noticed this problem on a Toshiba Z40. I kind of brute-forced the thing, and
I ended up that calling "ENAB" was making the keys working again (rmmod/insmod 
the driver was sufficient, and the only command which was different from the
resume was this ACPI call).

I am really surprised some toshiba laptops do not need this, so I'd prefer that
an ACPI expert (Matthew???) gives its wisdom regarding that.

Cheers,
Benjamin

 drivers/platform/x86/toshiba_acpi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index b062d3d..ba75701 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1857,9 +1857,16 @@ static int toshiba_acpi_resume(struct device *device)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(to_acpi_device(device));
 	u32 result;
+	acpi_status status;
+
+	if (dev->hotkey_dev) {
+		status = acpi_evaluate_object(dev->acpi_dev->handle, "ENAB",
+				NULL, NULL);
+		if (ACPI_FAILURE(status))
+			pr_info("Unable to re-enable hotkeys\n");
 
-	if (dev->hotkey_dev)
 		hci_write1(dev, HCI_HOTKEY_EVENT, HCI_HOTKEY_ENABLE, &result);
+	}
 
 	return 0;
 }
-- 
2.1.0

