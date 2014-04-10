Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393AbaDJDqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935024AbaDJDWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 103/134] ALSA: usb-audio: skip UAC2 EFFECT_UNIT
Date: Wed,  9 Apr 2014 20:23:39 -0700
Message-Id: <20140410032312.984536104@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   13 ++++++++++++-
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


