Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162618Ab3LFN3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:29:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44430 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161798Ab3LFNDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nanno Langstraat <langstr@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 185/272] HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.
Date: Fri,  6 Dec 2013 12:57:54 +0000
Message-Id: <1386334761-25517-186-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nanno Langstraat <langstr@gmail.com>

commit 43c831468b3d26dbe8f2e061ccaf1abaf9cc1b8b upstream.

Use case: people who use both Apple and PC keyboards regularly, and desire to
keep&use their PC muscle memory.

A particular use case: an Apple compact external keyboard connected to a PC
laptop. (This use case can't be covered well by X.org key remappings etc.)

Signed-off-by: Nanno Langstraat <langstr@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-apple.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index c7710b5..d54e1d0 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -46,6 +46,12 @@ module_param(iso_layout, uint, 0644);
 MODULE_PARM_DESC(iso_layout, "Enable/Disable hardcoded ISO-layout of the keyboard. "
 		"(0 = disabled, [1] = enabled)");
 
+static unsigned int swap_opt_cmd = 0;
+module_param(swap_opt_cmd, uint, 0644);
+MODULE_PARM_DESC(swap_opt_cmd, "Swap the Option (\"Alt\") and Command (\"Flag\") keys. "
+		"(For people who want to keep Windows PC keyboard muscle memory. "
+		"[0] = as-is, Mac layout. 1 = swapped, Windows layout.)");
+
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
@@ -150,6 +156,14 @@ static const struct apple_key_translation apple_iso_keyboard[] = {
 	{ }
 };
 
+static const struct apple_key_translation swapped_option_cmd_keys[] = {
+	{ KEY_LEFTALT,	KEY_LEFTMETA },
+	{ KEY_LEFTMETA,	KEY_LEFTALT },
+	{ KEY_RIGHTALT,	KEY_RIGHTMETA },
+	{ KEY_RIGHTMETA,KEY_RIGHTALT },
+	{ }
+};
+
 static const struct apple_key_translation *apple_find_translation(
 		const struct apple_key_translation *table, u16 from)
 {
@@ -242,6 +256,14 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
+	if (swap_opt_cmd) {
+		trans = apple_find_translation(swapped_option_cmd_keys, usage->code);
+		if (trans) {
+			input_event(input, usage->type, trans->to, value);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2

