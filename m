Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab3GKO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42936 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3GKOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/98] ACPICA: Do not use extended sleep registers unless HW-reduced bit is set
Date: Thu, 11 Jul 2013 15:23:56 +0100
Message-Id: <1373552708-15235-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 7cec7048fe22e3e92389da2cd67098f6c4284e7f upstream.

Previous implementation incorrectly used the ACPI 5.0 extended
sleep registers if they were simply populated. This caused
problems on some non-HW-reduced machines. As per the ACPI spec,
they should only be used if the HW-reduced bit is set.  Lv Zheng,
ACPICA BZ 1020.

References: https://bugzilla.kernel.org/show_bug.cgi?id=54181
References: https://bugs.acpica.org/show_bug.cgi?id=1020
Reported-by: Daniel Rowe <bart@fathom13.com>
Bisected-by: Brint E. Kriebel <kernel@bekit.net>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpica/hwxfsleep.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 762d059..a8af0ba 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -242,12 +242,14 @@ acpi_hw_sleep_dispatch(u8 sleep_state, u8 flags, u32 function_id)
 	    &acpi_sleep_dispatch[function_id];
 
 #if (!ACPI_REDUCED_HARDWARE)
-
 	/*
 	 * If the Hardware Reduced flag is set (from the FADT), we must
-	 * use the extended sleep registers
+	 * use the extended sleep registers (FADT). Note: As per the ACPI
+	 * specification, these extended registers are to be used for HW-reduced
+	 * platforms only. They are not general-purpose replacements for the
+	 * legacy PM register sleep support.
 	 */
-	if (acpi_gbl_reduced_hardware || acpi_gbl_FADT.sleep_control.address) {
+	if (acpi_gbl_reduced_hardware) {
 		status = sleep_functions->extended_function(sleep_state, flags);
 	} else {
 		/* Legacy sleep */
-- 
1.8.1.2

