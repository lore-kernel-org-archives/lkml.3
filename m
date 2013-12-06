Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162241Ab3LFXSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162192Ab3LFXSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 116/152] ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
Date: Fri,  6 Dec 2013 15:10:40 -0800
Message-Id: <1386371476-2477-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_codec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index d048204..3f242b5 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2338,9 +2338,6 @@ int snd_hda_codec_reset(struct hda_codec *codec)
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 #ifdef CONFIG_PM
 	cancel_delayed_work_sync(&codec->power_work);
-	codec->power_on = 0;
-	codec->power_transition = 0;
-	codec->power_jiffies = jiffies;
 	flush_workqueue(bus->workq);
 #endif
 	snd_hda_ctls_clear(codec);
-- 
1.8.3.2

