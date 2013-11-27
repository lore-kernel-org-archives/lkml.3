Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab3K0A6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab3K0A56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 43/80] ALSA: hda - Dont clear the power state at snd_hda_codec_reset()
Date: Tue, 26 Nov 2013 16:57:12 -0800
Message-Id: <20131127005643.937338539@linuxfoundation.org>
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

commit d183b4fc463489b6bbe05c99afa0257a6fe578eb upstream.

snd_hda_codec_reset() is called either in resetting the whole setup at
error paths or hwdep clear/reconfig sysfs triggers.  But all of these
don't assume that the power has to be off, rather they want to keep
the power state unchanged (e.g. reconfig_codec() calls the power
up/down by itself).  Thus, unconditionally clearing the power state in
snd_hda_codec_reset() leads to the inconsistency, confuses the further
operation.   This patch gets rid of the lines doing that bad thing.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2517,9 +2517,6 @@ int snd_hda_codec_reset(struct hda_codec
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 #ifdef CONFIG_PM
 	cancel_delayed_work_sync(&codec->power_work);
-	codec->power_on = 0;
-	codec->power_transition = 0;
-	codec->power_jiffies = jiffies;
 	flush_workqueue(bus->workq);
 #endif
 	snd_hda_ctls_clear(codec);


