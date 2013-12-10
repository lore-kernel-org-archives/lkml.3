Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3LJISe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:18:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3LJIBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 05/62] ALSA: hda - Fix bad EAPD setup for HP machines with AD1984A
Date: Tue, 10 Dec 2013 00:00:36 -0800
Message-Id: <20131210080057.825511111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1cd9b2f78bf29d5282e02b32f9b3ecebc5842a7c upstream.

It seems that EAPD on NID 0x16 is the only control over all outputs on
HP machines with AD1984A while turning EAPD on NID 0x12 breaks the
output.  Thus we need to avoid fiddling EAPD on NID.  As a quick
workaround, just set own_eapd_ctrl flag for the wrong EAPD, then
implement finer EAPD controls.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66321
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -964,6 +964,7 @@ static void ad1884_fixup_hp_eapd(struct
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		spec->gen.vmaster_mute.hook = ad1884_vmaster_hp_gpio_hook;
+		spec->gen.own_eapd_ctl = 1;
 		snd_hda_sequence_write_cache(codec, gpio_init_verbs);
 		break;
 	case HDA_FIXUP_ACT_PROBE:


