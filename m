Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaCCHVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:21:00 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41883 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaCCHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:20:57 -0500
Message-ID: <53142D51.3010403@canonical.com>
Date: Mon, 03 Mar 2014 15:20:49 +0800
From: Shuduo Sang <shuduo.sang@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ibm-acpi@hmh.eng.br,
        matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org
CC: bruce.ma@canonical.com
Subject: [RFC PATCH] support Thinkpad X1 Carbon's adaptive keyboard
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We are working together with Lenovo to enable thinkpad X1 Carbon's
fancy feature, Adaptive Keyboard[1] for Linux. Adaptive keyboard has
five modes on Windows including Home mode, Web browser mode, Web
conference mode, Function mode and Lay-flat mode. We enabled Home
mode and Function mode currently. Will try to find out how to enable
other modes later. Please review and comment attached patch.

Thanks,
Shuduo

[1]:http://shop.lenovo.com/us/en/laptops/thinkpad/x-series/x1-carbon/#features


>From da9d43beaa23071558a8031950cc21cc93946ec6 Mon Sep 17 00:00:00 2001
From: Shuduo Sang <sangshuduo@gmail.com>
Date: Mon, 3 Mar 2014 14:29:32 +0800
Subject: [PATCH] support thinkpad X1 Carbon's adaptive keyboard

Thinkpad X1 Carbon's adaptive keyboard has five modes including Home
mode, Web browser mode, Web conference mode, Function mode and Lay-flat
mode. We support Home mode and Function mode currently.

Signed-off-by: Bruce Ma <bruce.ma@canonical.com>
Signed-off-by: Shuduo Sang <shuduo.sang@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 97
++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c
b/drivers/platform/x86/thinkpad_acpi.c
index defb6af..fcb738e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3437,6 +3437,101 @@ err_exit:
 	return (res < 0)? res : 1;
 }

+/* Thinkpad X1 Carbon support 5 modes including Home mode, Web browser
+ * mode, Web conference mode, Function mode and Lay-flat mode.
+ * We support Home mode and Function mode currently.
+ *
+ * Will consider support rest of modes in future.
+ *
+ */
+enum ADAPTIVE_KEY_MODE {
+	HOME_MODE,
+	WEB_BROWSER_MODE,
+	WEB_CONFERENCE_MODE,
+	FUNCTION_MODE,
+	LAYFLAT_MODE
+};
+
+int adaptive_keyboard_modes[] = {
+	HOME_MODE,
+/*	WEB_BROWSER_MODE = 2,
+	WEB_CONFERENCE_MODE = 3, */
+	FUNCTION_MODE
+};
+
+#define DFR_CHANGE_ROW			0x101
+#define DFR_SHOW_QUICKVIEW_ROW		0x102
+
+/* press Fn key a while second, it will switch to Function Mode. Then
+ * release Fn key, previous mode be restored.
+ */
+bool adaptive_keyboard_mode_is_saved;
+int adaptive_keybarod_prev_mode;
+
+static int adaptive_keyboard_get_next_mode(int mode)
+{
+	int i;
+	int max_mode = sizeof(adaptive_keyboard_modes)/sizeof(int) - 1;
+
+	for (i = 0; i <= max_mode; i++) {
+		if (adaptive_keyboard_modes[i] == mode)
+			break;
+	}
+
+	if (i >= max_mode)
+		i = 0;
+	else
+		i++;
+
+	return adaptive_keyboard_modes[i];
+}
+
+static bool adaptive_keyboard_hotkey_notify_hotkey(unsigned int scancode)
+{
+	u32 current_mode = 0;
+	int new_mode = 0;
+
+	switch (scancode) {
+	case DFR_CHANGE_ROW:
+		if (adaptive_keyboard_mode_is_saved) {
+			new_mode = adaptive_keybarod_prev_mode;
+			adaptive_keyboard_mode_is_saved = false;
+		} else {
+			if (!acpi_evalf(
+					hkey_handle, &current_mode,
+					"GTRW", "dd", 0)) {
+				pr_err("Cannot read adaptive keyboard mode\n");
+				return false;
+			} else {
+				new_mode = adaptive_keyboard_get_next_mode(
+						current_mode);
+			}
+		}
+
+		if (!acpi_evalf(hkey_handle, NULL, "STRW", "vd", new_mode))
+			pr_err("Cannot set adaptive keyboard mode\n");
+
+		return true;
+
+	case DFR_SHOW_QUICKVIEW_ROW:
+		if (!acpi_evalf(hkey_handle,
+				&adaptive_keybarod_prev_mode,
+				"GTRW", "dd", 0)) {
+			pr_err("Cannot read adaptive keyboard mode\n");
+		} else {
+			adaptive_keyboard_mode_is_saved = true;
+
+			if (!acpi_evalf(hkey_handle,
+					NULL, "STRW", "vd", FUNCTION_MODE))
+				pr_err("Cannot set adaptive keyboard mode\n");
+		}
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 static bool hotkey_notify_hotkey(const u32 hkey,
 				 bool *send_acpi_ev,
 				 bool *ignore_acpi_ev)
@@ -3456,6 +3551,8 @@ static bool hotkey_notify_hotkey(const u32 hkey,
 			*ignore_acpi_ev = true;
 		}
 		return true;
+	} else {
+		return adaptive_keyboard_hotkey_notify_hotkey(scancode);
 	}
 	return false;
 }
-- 
1.9.0

