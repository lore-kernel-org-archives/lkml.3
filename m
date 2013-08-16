Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3HPRTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:19:31 -0400
Received: from mail.tpi.com ([74.45.170.26]:33669 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3HPRTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:19:17 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCH 3.11-rc5 2/2] ALSA: pcm: Use snd_printd_ratelimit()
Date: Fri, 16 Aug 2013 11:19:00 -0600
Message-Id: <1376673540-2201-2-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376673540-2201-1-git-send-email-tim.gardner@canonical.com>
References: <1376673540-2201-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of snd_printd_ratelimit() supresses superfluous output from
printk_ratelimit() when CONFIG_SND_DEBUG is not defined. For example,

[   43.753692] snd_pcm_update_hw_ptr0: 26 callbacks suppressed
[   48.822131] snd_pcm_update_hw_ptr0: 25 callbacks suppressed
[   53.894953] snd_pcm_update_hw_ptr0: 25 callbacks suppressed
[   58.997761] snd_pcm_update_hw_ptr0: 25 callbacks suppressed
[   64.100952] snd_pcm_update_hw_ptr0: 25 callbacks suppressed

fills the log even when no debug output is actually produced.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Yacine Belkadi <yacine.belkadi.1@gmail.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 sound/core/pcm_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 82bb029..6e03b46 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -184,7 +184,7 @@ static void xrun(struct snd_pcm_substream *substream)
 	do {								\
 		if (xrun_debug(substream, XRUN_DEBUG_BASIC)) {		\
 			xrun_log_show(substream);			\
-			if (printk_ratelimit()) {			\
+			if (snd_printd_ratelimit()) {			\
 				snd_printd("PCM: " fmt, ##args);	\
 			}						\
 			dump_stack_on_xrun(substream);			\
@@ -342,7 +342,7 @@ static int snd_pcm_update_hw_ptr0(struct snd_pcm_substream *substream,
 		return -EPIPE;
 	}
 	if (pos >= runtime->buffer_size) {
-		if (printk_ratelimit()) {
+		if (snd_printd_ratelimit()) {
 			char name[16];
 			snd_pcm_debug_name(substream, name, sizeof(name));
 			xrun_log_show(substream);
-- 
1.7.9.5

