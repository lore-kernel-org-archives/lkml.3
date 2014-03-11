Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaCKMY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:24:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62462 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaCKMYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:24:25 -0400
Message-ID: <531F0073.7060103@canonical.com>
Date: Tue, 11 Mar 2014 20:24:19 +0800
From: Shuduo Sang <shuduo.sang@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com,
        ibm-acpi-devel@lists.sourceforge.net,
        paltform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
CC: bruce.ma@canonical.com
Subject: [PATCH] support thinkpad HKEY interface version 0x200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please kindly review following patch. It support new BIOS which shiped
with Thinkpad X1 Carbon 2nd generation. Without it, hotkey mask be
routed to wrong branch and some hot key will not work.

Thanks,
Shuduo

>From 3c67b2731a61539363a62284a43b98fa3e2ba784 Mon Sep 17 00:00:00 2001
From: Shuduo Sang <shuduo.sang@canonical.com>
Date: Tue, 11 Mar 2014 20:13:15 +0800
Subject: [PATCH] support HKEY interface version 0x200

Thinkpad X1 Carbon 2nd generation ships with new BIOS will return HKEY
interface version 0x200. It need thinkpad-acpi support otherwise it
will be routed to wrong branch and hotkey mask is wrong.

Signed-off-by: Bruce Ma <bruce.ma@canonical.com>
Signed-off-by: Shuduo Sang <shuduo.sang@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 39
+++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c
b/drivers/platform/x86/thinkpad_acpi.c
index defb6af..939fc81 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3244,11 +3244,8 @@ static int __init hotkey_init(struct
ibm_init_struct *iibm)
 	   A30, R30, R31, T20-22, X20-21, X22-24.  Detected by checking
 	   for HKEY interface version 0x100 */
 	if (acpi_evalf(hkey_handle, &hkeyv, "MHKV", "qd")) {
-		if ((hkeyv >> 8) != 1) {
-			pr_err("unknown version of the HKEY interface: 0x%x\n",
-			       hkeyv);
-			pr_err("please report this to %s\n", TPACPI_MAIL);
-		} else {
+		switch (hkeyv >> 8) {
+		case 1:
 			/*
 			 * MHKV 0x100 in A31, R40, R40e,
 			 * T4x, X31, and later
@@ -3261,13 +3258,41 @@ static int __init hotkey_init(struct
ibm_init_struct *iibm)
 			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
 					"MHKA", "qd")) {
 				pr_err("missing MHKA handler, "
-				       "please report this to %s\n",
-				       TPACPI_MAIL);
+					"please report this to %s\n",
+					TPACPI_MAIL);
 				/* Fallback: pre-init for FN+F3,F4,F12 */
 				hotkey_all_mask = 0x080cU;
 			} else {
 				tp_features.hotkey_mask = 1;
 			}
+			break;
+
+		case 2:
+			/*
+			 * MHKV 0x200 in X1
+			 */
+			vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
+				"firmware HKEY interface version: 0x%x\n",
+				hkeyv);
+
+			/* Paranoia check AND init hotkey_all_mask */
+			if (!acpi_evalf(hkey_handle, &hotkey_all_mask,
+					"MHKA", "dd", 1)) {
+				pr_err("missing MHKA handler, "
+					"please report this to %s\n",
+					TPACPI_MAIL);
+				/* Fallback: pre-init for FN+F3,F4,F12 */
+				hotkey_all_mask = 0x080cU;
+			} else {
+				tp_features.hotkey_mask = 1;
+			}
+			break;
+
+		default:
+			pr_err("unknown version of the HKEY interface: 0x%x\n",
+			       hkeyv);
+			pr_err("please report this to %s\n", TPACPI_MAIL);
+			break;
 		}
 	}

-- 
1.9.0

