Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab3IHDTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56098 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab3IHDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Eldad Zack" <eldad@fogrefinery.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.164888580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [018/121] ALSA: usb-audio: skip UAC2 EFFECT_UNIT
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eldad Zack <eldad@fogrefinery.com>

commit 5dae5fd24071319bb67d3375217d5b0b6d16cb0b upstream.

Current code mishandles the case where the device is a UAC2
and the bDescriptorSubtype is a UAC2 Effect Unit (0x07).
It tries to parse it as a Processing Unit (which is similar to two
other UAC1 units with overlapping subtypes), but since the structure
is different (See: 4.7.2.10, 4.7.2.11 in UAC2 standard), the parsing
is done incorrectly and prevents the device from initializing.
For now, just ignore the unit.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/mixer.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -720,8 +720,19 @@ static int check_input_term(struct mixer
 			return 0;
 		}
 		case UAC1_PROCESSING_UNIT:
-		case UAC1_EXTENSION_UNIT: {
+		case UAC1_EXTENSION_UNIT:
+		/* UAC2_PROCESSING_UNIT_V2 */
+		/* UAC2_EFFECT_UNIT */ {
 			struct uac_processing_unit_descriptor *d = p1;
+
+			if (state->mixer->protocol == UAC_VERSION_2 &&
+				hdr[2] == UAC2_EFFECT_UNIT) {
+				/* UAC2/UAC1 unit IDs overlap here in an
+				 * uncompatible way. Ignore this unit for now.
+				 */
+				return 0;
+			}
+
 			if (d->bNrInPins) {
 				id = d->baSourceID[0];
 				break; /* continue to parse */

