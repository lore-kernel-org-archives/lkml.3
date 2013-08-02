Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab3HBKBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:01:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48521 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179Ab3HBKBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:01:12 -0400
Date: Fri, 2 Aug 2013 11:01:08 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lgirdwood@gmail.com
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ASoC: core: init delayed_work for codec-codec links
Message-ID: <20130802100108.GA17936@opensource.wolfsonmicro.com>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731131627.GA32631@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must init the delayed_work for codec-codec links
otherwise shutting down the DAI chain will fault when
calling flush_delayed_work_sync() on the linked DAI.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/soc-core.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 4489c5b..e649efe 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -199,6 +199,14 @@ static ssize_t pmdown_time_set(struct device *dev,
 	return count;
 }
 
+static void codec2codec_close_delayed_work(struct work_struct *work)
+{
+	/* No action required.
+	 * C2C links only represent a hardware connection and currently
+	 * we assume that we don't have to explicitly start or stop them
+	 */
+}
+
 static DEVICE_ATTR(pmdown_time, 0644, pmdown_time_show, pmdown_time_set);
 
 #ifdef CONFIG_DEBUG_FS
@@ -1428,6 +1436,9 @@ static int soc_probe_link_dais(struct snd_soc_card *card, int num, int order)
 				return ret;
 			}
 		} else {
+			INIT_DELAYED_WORK(&rtd->delayed_work,
+						codec2codec_close_delayed_work);
+
 			/* link the DAI widgets */
 			play_w = codec_dai->playback_widget;
 			capture_w = cpu_dai->capture_widget;
-- 
1.7.2.5
