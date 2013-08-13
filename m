Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab3HMQeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:34:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab3HMQ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:49 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2ET7TFgAcM4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oPBXkIRz290A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=kJC4T8hCAAAA:8 a=VombwVNeAAAA:8 a=MrTmtc5YAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=dGJ0OcVc7YAA:10 a=Jvc2nfQ_i4UA:10 a=Sz6uTlPSQQkA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155835.844535033@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Rowe <bart@fathom13.com>, Lv Zheng <lv.zheng@intel.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [77/88] ACPICA: Do not use extended sleep registers unless HW-reduced bit is
 set
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0077-ACPICA-Do-not-use-extended-sleep-registers-unless-HW.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

[ Upstream commit 7cec7048fe22e3e92389da2cd67098f6c4284e7f ]

Previous implementation incorrectly used the ACPI 5.0 extended
sleep registers if they were simply populated. This caused
problems on some non-HW-reduced machines. As per the ACPI spec,
they should only be used if the HW-reduced bit is set.  Lv Zheng,
ACPICA BZ 1020.

References: https://bugzilla.kernel.org/show_bug.cgi?id=54181
References: https://bugs.acpica.org/show_bug.cgi?id=1020
Reported-by: Daniel Rowe <bart@fathom13.com>
Bisected-by: Brint E. Kriebel <kernel@bekit.net>
Cc: 3.4+ <stable@vger.kernel.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/acpica/hwxfsleep.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
index 1f165a7..c92753b 100644
--- a/drivers/acpi/acpica/hwxfsleep.c
+++ b/drivers/acpi/acpica/hwxfsleep.c
@@ -242,12 +242,14 @@ acpi_hw_sleep_dispatch(u8 sleep_state, u32 function_id)
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
1.7.10.4


