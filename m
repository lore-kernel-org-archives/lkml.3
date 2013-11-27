Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab3K0Bni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:43:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3K0A57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 44/80] ALSA: hda - Fix unbalanced runtime PM notification at resume
Date: Tue, 26 Nov 2013 16:57:13 -0800
Message-Id: <20131127005644.008652001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0fc28fc030a85aa3d6d14e9e9fca0c8237c9ffb5 upstream.

When a codec is resumed, it keeps the power on while the resuming
phase via hda_keep_power_on(), then turns down via
snd_hda_power_down().  At that point, snd_hda_power_down() notifies
the power down to the controller, and this may confuse the refcount if
the codec was already powered up before the resume.

In the end result, the controller goes to runtime suspend even before
the codec is kicked off to the power save, and the communication
stalls happens.

The fix is to add the power-up notification together with
hda_keep_power_on(), and clears the flag appropriately.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -3924,6 +3924,10 @@ static void hda_call_codec_resume(struct
 	 * in the resume / power-save sequence
 	 */
 	hda_keep_power_on(codec);
+	if (codec->pm_down_notified) {
+		codec->pm_down_notified = 0;
+		hda_call_pm_notify(codec->bus, true);
+	}
 	hda_set_power_state(codec, AC_PWRST_D0);
 	restore_shutup_pins(codec);
 	hda_exec_init_verbs(codec);


