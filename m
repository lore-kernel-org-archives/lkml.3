Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318Ab3GSFWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:22:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab3GSFWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Rowe <bart@fathom13.com>, Lv Zheng <lv.zheng@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 20/38] ACPICA: Do not use extended sleep registers unless HW-reduced bit is set
Date: Thu, 18 Jul 2013 22:21:36 -0700
Message-Id: <20130719052049.265705240@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 7cec7048fe22e3e92389da2cd67098f6c4284e7f upstream.

Previous implementation incorrectly used the ACPI 5.0 extended
sleep registers if they were simply populated. This caused
problems on some non-HW-reduced machines. As per the ACPI spec,
they should only be used if the HW-reduced bit is set.  Lv Zheng,
ACPICA BZ 1020.

Reported-by: Daniel Rowe <bart@fathom13.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=54181
References: https://bugs.acpica.org/show_bug.cgi?id=1020
Bisected-by: Brint E. Kriebel <kernel@bekit.net>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/hwxfsleep.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -240,12 +240,14 @@ static acpi_status acpi_hw_sleep_dispatc
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


