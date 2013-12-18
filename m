Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3LRWFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3LRVMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 07/78] ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices
Date: Wed, 18 Dec 2013 13:10:35 -0800
Message-Id: <20131218211112.113340047@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit c9a6338aecdb92f9d015ecc26d203e54250bebbb upstream.

In case a single HDA card has both HDMI and S/PDIF outputs, the S/PDIF
outputs will have their IEC958 controls created starting from index 16
and the HDMI controls will be created starting from index 0.

However, HDMI simple_playback_build_controls() as used by old VIA and
NVIDIA codecs incorrectly requests the IEC958 controls to be created
with an S/PDIF type instead of HDMI.
In case the card has other codecs that have HDMI outputs, the controls
will be created with wrong index=16, causing them to e.g. be unreachable
by the ALSA "hdmi" alias.

Fix that by making simple_playback_build_controls() request controls
with HDMI indexes.

Not many cards have an affected configuration, but e.g. ASUS M3N78-VM
contains an integrated NVIDIA HDA "card" with:
- a VIA codec that has, among others, an S/PDIF pin incorrectly
  labelled as an HDMI pin, and
- an NVIDIA MCP7x HDMI codec.

Reported-by: MysterX on #openelec
Tested-by: MysterX on #openelec
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2001,8 +2001,9 @@ static int simple_playback_build_control
 	int err;
 
 	per_cvt = get_cvt(spec, 0);
-	err = snd_hda_create_spdif_out_ctls(codec, per_cvt->cvt_nid,
-					    per_cvt->cvt_nid);
+	err = snd_hda_create_dig_out_ctls(codec, per_cvt->cvt_nid,
+					  per_cvt->cvt_nid,
+					  HDA_PCM_TYPE_HDMI);
 	if (err < 0)
 		return err;
 	return simple_hdmi_build_jack(codec, 0);


