Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab3GaNY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:24:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab3GaNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:24:55 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 09:24:55 EDT
Date: Wed, 31 Jul 2013 14:16:44 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: core: init delayed_work for codec-codec links
Message-ID: <20130731131627.GA32631@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If soc_probe_link_dais() finds a codec-codec link it
skips creating a compress or pcm stream and links the
DAIs together. But it must also init the delayed_work
otherwise shutting down the DAI chain will fault when
calling flush_delayed_work_sync() on the linked DAI.

Pointing it to a dummy work callback is cleaner than taking
special cases in the code to bypass the flush_delayed_work_sync().

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/soc-core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 4489c5b..bbe136c 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -199,6 +199,10 @@ static ssize_t pmdown_time_set(struct device *dev,
 	return count;
 }
 
+static void dummy_delayed_work(struct work_struct *work)
+{
+}
+
 static DEVICE_ATTR(pmdown_time, 0644, pmdown_time_show, pmdown_time_set);
 
 #ifdef CONFIG_DEBUG_FS
@@ -1428,6 +1432,8 @@ static int soc_probe_link_dais(struct snd_soc_card *card, int num, int order)
 				return ret;
 			}
 		} else {
+			INIT_DELAYED_WORK(&rtd->delayed_work, dummy_delayed_work);
+
 			/* link the DAI widgets */
 			play_w = codec_dai->playback_widget;
 			capture_w = cpu_dai->capture_widget;
-- 
1.7.2.5

