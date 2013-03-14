Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab3CNKhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab3CNKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 38/88] asus-laptop: Do not call HWRS on init
Date: Thu, 14 Mar 2013 10:35:31 +0000
Message-Id: <1363257381-15900-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit cb7da022450cdaaebd33078b6b32fb7dd2aaf6db upstream.

Since commit 8871e99f89b7 ('asus-laptop: HRWS/HWRS typo'), module
initialisation is very slow on the Asus UL30A.  The HWRS method takes
about 12 seconds to run, and subsequent initialisation also seems to
be delayed.  Since we don't really need the result, don't bother
calling it on init.  Those who are curious can still get the result
through the 'infos' device attribute.

Update the comment about HWRS in show_infos().

Reported-by: ryan <draziw+deb@gmail.com>
References: http://bugs.debian.org/692436
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/asus-laptop.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 110c777..12da810 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -860,8 +860,10 @@ static ssize_t show_infos(struct device *dev,
 	/*
 	 * The HWRS method return informations about the hardware.
 	 * 0x80 bit is for WLAN, 0x100 for Bluetooth.
+	 * 0x40 for WWAN, 0x10 for WIMAX.
 	 * The significance of others is yet to be found.
-	 * If we don't find the method, we assume the device are present.
+	 * We don't currently use this for device detection, and it
+	 * takes several seconds to run on some systems.
 	 */
 	rv = acpi_evaluate_integer(asus->handle, "HWRS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
@@ -1682,7 +1684,7 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *model = NULL;
-	unsigned long long bsts_result, hwrs_result;
+	unsigned long long bsts_result;
 	char *string = NULL;
 	acpi_status status;
 
@@ -1744,17 +1746,6 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	if (*string)
 		pr_notice("  %s model detected\n", string);
 
-	/*
-	 * The HWRS method return informations about the hardware.
-	 * 0x80 bit is for WLAN, 0x100 for Bluetooth,
-	 * 0x40 for WWAN, 0x10 for WIMAX.
-	 * The significance of others is yet to be found.
-	 */
-	status =
-	    acpi_evaluate_integer(asus->handle, "HWRS", NULL, &hwrs_result);
-	if (!ACPI_FAILURE(status))
-		pr_notice("  HWRS returned %x", (int)hwrs_result);
-
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;
 
-- 
1.8.1.2

