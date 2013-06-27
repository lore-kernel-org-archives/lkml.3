Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3F0PCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:02:34 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64660 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3F0PCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:02:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,952,1363132800"; 
   d="scan'208";a="33832845"
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>
CC: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH v4 2/5] acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
Date: Thu, 27 Jun 2013 11:02:00 -0400
Message-ID: <1372345323-9266-3-git-send-email-benjamin.guthro@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
References: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
reduced hardware sleep support, and the two changes didn't get
synchronized: The new code doesn't call the hook function (if so
requested). Fix this, requiring a parameter to be added to the
hook function to distinguish "extended" from "legacy" sleep.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Rafaell J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/acpica/hwesleep.c |    7 +++++++
 drivers/acpi/acpica/hwsleep.c  |    2 +-
 include/acpi/acpiosxf.h        |    4 ++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
index 5e5f762..69b3e15 100644
--- a/drivers/acpi/acpica/hwesleep.c
+++ b/drivers/acpi/acpica/hwesleep.c
@@ -128,6 +128,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
 
 	ACPI_FLUSH_CPU_CACHE();
 
+	status = acpi_os_prepare_sleep(sleep_state, acpi_gbl_sleep_type_a,
+				       acpi_gbl_sleep_type_b, TRUE);
+	if (ACPI_SKIP(status))
+		return_ACPI_STATUS(AE_OK);
+	if (ACPI_FAILURE(status))
+		return_ACPI_STATUS(status);
+
 	/*
 	 * Set the SLP_TYP and SLP_EN bits.
 	 *
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 867b947..cf78157 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -152,7 +152,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
 	ACPI_FLUSH_CPU_CACHE();
 
 	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
-				       pm1b_control);
+				       pm1b_control, FALSE);
 	if (ACPI_SKIP(status))
 		return_ACPI_STATUS(AE_OK);
 	if (ACPI_FAILURE(status))
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index c68b779..51d0f78 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -279,7 +279,7 @@ void acpi_os_close_directory(void *dir_handle);
 /*
  * ACPI sleep preparation
  */
-acpi_status acpi_os_prepare_sleep(u8 sleep_state,
-				  u32 pm1a_control, u32 pm1b_control);
+acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
+				  u8 extended);
 
 #endif				/* __ACPIOSXF_H__ */
-- 
1.7.9.5

