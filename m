Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3KRSsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:48:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3KRSmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 14/24] ALSA: hda - hdmi: Fix reported channel map on common default layouts
Date: Mon, 18 Nov 2013 10:42:24 -0800
Message-Id: <20131118184223.071955996@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 56cac413dd6d43af8355f5d1f90a199b540f73fc upstream.

hdmi_setup_fake_chmap() is supposed to set the reported channel map when
the channel map is not specified by the user.

However, the function indexes channel_allocations[] with a wrong value
and extracts the wrong nibble from hdmi_channel_mapping[], causing wrong
channel maps to be shown.

Fix those issues.

Tested on Intel HDMI to correctly generate various channel maps, for
example 3,4,14,15,7,8,5,6 (instead of incorrect 3,4,8,7,5,6,14,0) for
standard 7.1 channel audio. (Note that the side and rear channels are
reported as RL/RR and RLC/RRC, respectively, as per the CEA-861
standard, instead of the more traditional SL/SR and RL/RR.)

Note that this only fixes the layouts that only contain traditional 7.1
speakers (2.0, 2.1, 4.0, 5.1, 7.1, etc.). E.g. the rear center of 6.1
is still being shown wrongly due to an issue with from_cea_slot()
which will be fixed in a later patch.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -738,9 +738,10 @@ static int hdmi_manual_setup_channel_map
 static void hdmi_setup_fake_chmap(unsigned char *map, int ca)
 {
 	int i;
+	int ordered_ca = get_channel_allocation_order(ca);
 	for (i = 0; i < 8; i++) {
-		if (i < channel_allocations[ca].channels)
-			map[i] = from_cea_slot((hdmi_channel_mapping[ca][i] >> 4) & 0x0f);
+		if (i < channel_allocations[ordered_ca].channels)
+			map[i] = from_cea_slot(hdmi_channel_mapping[ca][i] & 0x0f);
 		else
 			map[i] = 0;
 	}


