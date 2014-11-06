Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaKFW6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:58:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKFWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/162] ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug
Date: Thu,  6 Nov 2014 14:35:46 -0800
Message-Id: <1415313426-9622-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 6acce400d9daf1353fbf497302670c90a3205e1d upstream.

The ELD ALSA control change event is sent by hdmi_present_sense() when
eld_changed is true.

Currently, it is only true when the ELD buffer contents have been
modified. However, the user-visible ELD controls also change to a
zero-length value and back when eld_valid is unset/set, and no event is
currently sent in such cases (such as when unplugging or replugging a
sink).

Fix the code to always set eld_changed if eld_valid value is changed,
and therefore to always send the change event when the user-visible
value changes.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Cc: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 9c67b07..c2c80ca 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1575,19 +1575,22 @@ static bool hdmi_present_sense(struct hdmi_spec_per_pin *per_pin, int repoll)
 		}
 	}
 
-	if (pin_eld->eld_valid && !eld->eld_valid) {
-		update_eld = true;
+	if (pin_eld->eld_valid != eld->eld_valid)
 		eld_changed = true;
-	}
+
+	if (pin_eld->eld_valid && !eld->eld_valid)
+		update_eld = true;
+
 	if (update_eld) {
 		bool old_eld_valid = pin_eld->eld_valid;
 		pin_eld->eld_valid = eld->eld_valid;
-		eld_changed = pin_eld->eld_size != eld->eld_size ||
+		if (pin_eld->eld_size != eld->eld_size ||
 			      memcmp(pin_eld->eld_buffer, eld->eld_buffer,
-				     eld->eld_size) != 0;
-		if (eld_changed)
+				     eld->eld_size) != 0) {
 			memcpy(pin_eld->eld_buffer, eld->eld_buffer,
 			       eld->eld_size);
+			eld_changed = true;
+		}
 		pin_eld->eld_size = eld->eld_size;
 		pin_eld->info = eld->info;
 
-- 
1.9.1

