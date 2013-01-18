Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3ARJR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 04:17:27 -0500
Received: from mx16.lb01.inode.at ([62.99.145.18]:34900 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751011Ab3ARJRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 04:17:24 -0500
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 04:17:24 EST
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: tiwai@suse.de, perex@perex.cz
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com,
        Michal Bachraty <michal.bachraty@streamunlimited.com>
Subject: [PATCH v2] ALSA: ASoC: McASP: Fix data rotation for playback. Enables 24bit audio playback
Date: Fri, 18 Jan 2013 10:17:00 +0100
Message-Id: <1358500620-24480-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u32 rotate = (32 - word_length) / 4;
This implementation is wrong, but it works only for 16, or 32 bit audio data.
(rotation for 16 or 32 bit is same as in code I present) Mcasp rotated data in
4 bits (max value 0x7)and then masks them . That data are sended to i2s bus.
For 24 bit or 20 bit or other data formats, this code rotates data badly and
you hear somethink like noise.  You need to use
u32 rotate = (word_length / 4) & 0x7;
to proper data rotation.
Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
---

changes v2: add commit log.

 sound/soc/davinci/davinci-mcasp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 13f8d73..a03bece 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -626,7 +626,7 @@ static int davinci_config_channel_size(struct davinci_audio_dev *dev,
 				       int word_length)
 {
 	u32 fmt;
-	u32 rotate = (32 - word_length) / 4;
+	u32 rotate = (word_length / 4) & 0x7;
 	u32 mask = (1ULL << word_length) - 1;
 
 	/*
-- 
1.7.9.5

