Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaCDLOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:14:04 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57195 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaCDLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:14:01 -0500
Message-ID: <5315B572.1000403@canonical.com>
Date: Tue, 04 Mar 2014 19:13:54 +0800
From: Shuduo Sang <shuduo.sang@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>, bjorn@mork.no,
        ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ibm-acpi@hmh.eng.br,
        matthew.garrett@nebula.net, platform-driver-x86@vger.kernel.org,
        bruce.ma@canonical.com
Subject: [PATCH V3] support Thinkpad X1 Carbon 2nd generation's adaptive keyboard
References: <5314AE4C.4090502@canonical.com> <20140304091916.GE1883@distanz.ch>
In-Reply-To: <20140304091916.GE1883@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Submit patch V3 to support Adaptive Keyboard on Thinkpad X1 Carbon 2nd
generation according to Tobias's comments.

Thanks,
Shuduo

>From 2b8175e69deee661d97d371b2422a9c192fefd52 Mon Sep 17 00:00:00 2001
From: Shuduo Sang <sangshuduo@gmail.com>
Date: Mon, 3 Mar 2014 14:29:32 +0800
Subject: [PATCH] support thinkpad X1 Carbon's adaptive keyboard

Thinkpad X1 Carbon's adaptive keyboard has five modes including Home
mode, Web browser mode, Web conference mode, Function mode and Lay-flat
mode. We support Home mode and Function mode currently.

Signed-off-by: Bruce Ma <bruce.ma@canonical.com>
Signed-off-by: Shuduo Sang <shuduo.sang@canonical.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 102
+++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c
b/drivers/platform/x86/thinkpad_acpi.c
index defb6af..6664dcd 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3437,6 +3437,106 @@ err_exit:
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
+static bool adaptive_keyboard_mode_is_saved;
+static int adaptive_keyboard_prev_mode;
+
+static int adaptive_keyboard_get_next_mode(int mode)
+{
+	int i;
+	size_t max_mode = ARRAY_SIZE(adaptive_keyboard_modes) - 1;
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
+			new_mode = adaptive_keyboard_prev_mode;
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
+		if (!acpi_evalf(hkey_handle, NULL, "STRW", "vd", new_mode)) {
+			pr_err("Cannot set adaptive keyboard mode\n");
+			return false;
+		}
+
+		return true;
+
+	case DFR_SHOW_QUICKVIEW_ROW:
+		if (!acpi_evalf(hkey_handle,
+				&adaptive_keyboard_prev_mode,
+				"GTRW", "dd", 0)) {
+			pr_err("Cannot read adaptive keyboard mode\n");
+			return false;
+		} else {
+			adaptive_keyboard_mode_is_saved = true;
+
+			if (!acpi_evalf(hkey_handle,
+					NULL, "STRW", "vd", FUNCTION_MODE)) {
+				pr_err("Cannot set adaptive keyboard mode\n");
+				return false;
+			}
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
@@ -3456,6 +3556,8 @@ static bool hotkey_notify_hotkey(const u32 hkey,
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

