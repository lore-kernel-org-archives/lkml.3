Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3BSEAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:00:21 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:33620 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3BSEAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:00:10 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, broonie@opensource.wolfsonmicro.com,
        mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] sound/soc/codecs: Convert SI476X codec to use regmap
Date: Mon, 18 Feb 2013 19:59:34 -0800
Message-Id: <1361246375-8848-7-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Smirnov <andreysm@charmander.(none)>

The latest radio and MFD drivers for SI476X radio chips use regmap API
to provide access to the registers and allow for caching of their
values when the actual chip is powered off. Convert the codec driver
to do the same, so it would not loose the settings when the radio
driver powers the chip down.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 sound/soc/codecs/si476x.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/si476x.c b/sound/soc/codecs/si476x.c
index f2d61a1..30aebbe 100644
--- a/sound/soc/codecs/si476x.c
+++ b/sound/soc/codecs/si476x.c
@@ -45,13 +45,23 @@ static unsigned int si476x_codec_read(struct snd_soc_codec *codec,
 				      unsigned int reg)
 {
 	int err;
+	unsigned int val;
 	struct si476x_core *core = codec->control_data;
 
 	si476x_core_lock(core);
-	err = si476x_core_cmd_get_property(core, reg);
+	if (!si476x_core_is_powered_up(core))
+		regcache_cache_only(core->regmap, true);
+
+	err = regmap_read(core->regmap, reg, &val);
+
+	if (!si476x_core_is_powered_up(core))
+		regcache_cache_only(core->regmap, false);
 	si476x_core_unlock(core);
 
-	return err;
+	if (err < 0)
+		return err;
+
+	return val;
 }
 
 static int si476x_codec_write(struct snd_soc_codec *codec,
@@ -61,7 +71,13 @@ static int si476x_codec_write(struct snd_soc_codec *codec,
 	struct si476x_core *core = codec->control_data;
 
 	si476x_core_lock(core);
-	err = si476x_core_cmd_set_property(core, reg, val);
+	if (!si476x_core_is_powered_up(core))
+		regcache_cache_only(core->regmap, true);
+
+	err = regmap_write(core->regmap, reg, val);
+
+	if (!si476x_core_is_powered_up(core))
+		regcache_cache_only(core->regmap, false);
 	si476x_core_unlock(core);
 
 	return err;
-- 
1.7.10.4

