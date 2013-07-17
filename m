Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3GQXDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:03:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934592Ab3GQW4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/145] ACPICA: Do not use extended sleep registers unless HW-reduced bit is set
Date: Wed, 17 Jul 2013 15:45:54 -0700
Message-Id: <1374101277-7915-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpica/hwxfsleep.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index ae443fe2..fac67f0 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -240,12 +240,14 @@ static acpi_status acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
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
 		status = sleep_functions->extended_function(sleep_state);
 	} else {
 		/* Legacy sleep */
-- 
1.8.1.2

