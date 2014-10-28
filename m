Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaJ1DjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:39:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaJ1DjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:39:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.17 076/146] ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug
Date: Tue, 28 Oct 2014 11:33:38 +0800
Message-Id: <20141028033346.683768416@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1577,19 +1577,22 @@ static bool hdmi_present_sense(struct hd
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
 


