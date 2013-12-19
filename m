Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3LSL5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44813 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3LSL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/208] ALSA: hda - Fix headset mic input after muted internal mic (Dell/Realtek)
Date: Thu, 19 Dec 2013 11:53:02 +0000
Message-Id: <1387454106-19326-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit d59915d0655c5864b514f21daaeac98c047875dc upstream.

By trial and error, I found this patch could work around an issue
where the headset mic would stop working if you switch between the
internal mic and the headset mic, and the internal mic was muted.

It still takes a second or two before the headset mic actually starts
working, but still better than nothing.

Information update from Kailang:
  The verb was ADC digital mute(bit 6 default 1).
  Switch internal mic and headset mic will run alc_headset_mode_default.
  The coef index 0x11 will set to 0x0041.
  Because headset mode was fixed type. It doesn't need to run
  alc_determine_headset_type.
  So, the value still keep 0x0041. ADC was muted.

BugLink: https://bugs.launchpad.net/bugs/1256840
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9eace98..40407f4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3149,6 +3149,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 		alc_write_coef_idx(codec, 0x18, 0x7388);
 		break;
 	case 0x10ec0668:
+		alc_write_coef_idx(codec, 0x11, 0x0001);
 		alc_write_coef_idx(codec, 0x15, 0x0d60);
 		alc_write_coef_idx(codec, 0xc3, 0x0000);
 		break;
@@ -3171,6 +3172,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 		alc_write_coef_idx(codec, 0x18, 0x7388);
 		break;
 	case 0x10ec0668:
+		alc_write_coef_idx(codec, 0x11, 0x0001);
 		alc_write_coef_idx(codec, 0x15, 0x0d50);
 		alc_write_coef_idx(codec, 0xc3, 0x0000);
 		break;
-- 
1.8.3.2

