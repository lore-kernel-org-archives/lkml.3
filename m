Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3ASBRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:17:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:56249 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3ASBRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 01/33] ALSA: hda/hdmi - Work around "alsactl restore" errors
Date: Fri, 18 Jan 2013 17:16:26 -0800
Message-Id: <20130119010346.296303386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6f54c361329dbb67dac9de174e938992651d12d7 upstream.

When "alsactl restore" is performed on HDMI codecs, it tries to
restore the channel map value since the channel map controls are
writable.  But hdmi_chmap_ctl_put() returns -EBADFD when no PCM stream
is assigned yet, and this results in an error message from alsactl.
Although the error is harmless, it's certainly ugly and can be
regarded as a regression.

As a workaround, this patch changes the return code in such a case to
be zero for making others happy.  (A slight excuse is: when the chmap
is changed through the proper alsa-lib API, the PCM status is checked
there anyway, so we don't have to be too strict in the kernel side.)

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1499,7 +1499,7 @@ static int hdmi_chmap_ctl_put(struct snd
 	ctl_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	substream = snd_pcm_chmap_substream(info, ctl_idx);
 	if (!substream || !substream->runtime)
-		return -EBADFD;
+		return 0; /* just for avoiding error from alsactl restore */
 	switch (substream->runtime->status->state) {
 	case SNDRV_PCM_STATE_OPEN:
 	case SNDRV_PCM_STATE_SETUP:


