Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3LERhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3LERhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 30/90] ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
Date: Thu,  5 Dec 2013 17:35:12 +0000
Message-Id: <1386264972-5399-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_codec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f33bb78..0948888 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2312,9 +2312,6 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	cancel_delayed_work_sync(&codec->power_work);
-	codec->power_on = 0;
-	codec->power_transition = 0;
-	codec->power_jiffies = jiffies;
 	flush_workqueue(bus->workq);
 #endif
 	snd_hda_ctls_clear(codec);
-- 
1.8.3.2

