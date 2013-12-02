Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3LBTTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:19:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3LBTTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nanno Langstraat <langstr@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 212/212] HID: apple: option to swap the Option ("Alt") and Command ("Flag") keys.
Date: Mon,  2 Dec 2013 11:16:43 -0800
Message-Id: <20131202191313.236626507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nanno Langstraat <langstr@gmail.com>

commit 43c831468b3d26dbe8f2e061ccaf1abaf9cc1b8b upstream.

Use case: people who use both Apple and PC keyboards regularly, and desire to
keep&use their PC muscle memory.

A particular use case: an Apple compact external keyboard connected to a PC
laptop. (This use case can't be covered well by X.org key remappings etc.)

Signed-off-by: Nanno Langstraat <langstr@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-apple.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

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
@@ -150,6 +156,14 @@ static const struct apple_key_translatio
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
@@ -242,6 +256,14 @@ static int hidinput_apple_event(struct h
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
 


