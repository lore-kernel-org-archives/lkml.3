Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaLCXRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:17:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59782 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaLCXRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:17:02 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: mjg59@srcf.ucam.org, dvhart@infradead.org
Cc: pavel@ucw.cz, pali.rohar@gmail.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 3/3] dell-wmi: Don't report keypresses on keybord illumination change
Date: Thu,  4 Dec 2014 00:16:23 +0100
Message-Id: <1417648583-9336-4-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keyboard illumination level changes are performed by the BIOS, so no
events should be reported on keypress. This is already done on systems
using the legacy keymap, do it also for systems that don't use it.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/platform/x86/dell-wmi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 9d3507c..0344b89 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -211,11 +211,16 @@ static const struct key_entry * __init dell_wmi_prepare_new_keymap(void)
 	for (i = 0; i < hotkey_num; i++) {
 		const struct dell_bios_keymap_entry *bios_entry =
 					&dell_bios_hotkey_table->keymap[i];
-		keymap[i].type = KE_KEY;
-		keymap[i].code = bios_entry->scancode;
-		keymap[i].keycode = bios_entry->keycode < 256 ?
+		u16 keycode = bios_entry->keycode < 256 ?
 				    bios_to_linux_keycode[bios_entry->keycode] :
 				    KEY_RESERVED;
+
+		if (keycode == KEY_KBDILLUMTOGGLE)
+			keymap[i].type = KE_IGNORE;
+		else
+			keymap[i].type = KE_KEY;
+		keymap[i].code = bios_entry->scancode;
+		keymap[i].keycode = keycode;
 	}
 
 	keymap[hotkey_num].type = KE_END;
-- 
2.1.3

