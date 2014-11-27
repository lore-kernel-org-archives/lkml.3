Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaK0VDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:03:30 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:38972 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0VD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:03:29 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Subject: [PATCH] ASoC: Augment existing card DAPM routes in snd_soc_of_parse_audio_routing
Date: Thu, 27 Nov 2014 22:02:42 +0100
Message-Id: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

If a snd_soc_card has any DAPM routes when it calls
snd_soc_of_parse_audio_routing, those are clobbered without this change.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/soc-core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index b60ff56ebc0f..377db486852e 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4585,7 +4585,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname)
 {
 	struct device_node *np = card->dev->of_node;
-	int num_routes;
+	int num_routes, old_routes;
 	struct snd_soc_dapm_route *routes;
 	int i, ret;
 
@@ -4603,7 +4603,9 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 		return -EINVAL;
 	}
 
-	routes = devm_kzalloc(card->dev, num_routes * sizeof(*routes),
+	old_routes = card->num_dapm_routes;
+	routes = devm_kzalloc(card->dev,
+			      (old_routes + num_routes) * sizeof(*routes),
 			      GFP_KERNEL);
 	if (!routes) {
 		dev_err(card->dev,
@@ -4611,9 +4613,11 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 		return -EINVAL;
 	}
 
+	memcpy(routes, card->dapm_routes, old_routes * sizeof(*routes));
+
 	for (i = 0; i < num_routes; i++) {
 		ret = of_property_read_string_index(np, propname,
-			2 * i, &routes[i].sink);
+			2 * i, &routes[old_routes + i].sink);
 		if (ret) {
 			dev_err(card->dev,
 				"ASoC: Property '%s' index %d could not be read: %d\n",
@@ -4621,7 +4625,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 			return -EINVAL;
 		}
 		ret = of_property_read_string_index(np, propname,
-			(2 * i) + 1, &routes[i].source);
+			(2 * i) + 1, &routes[old_routes + i].source);
 		if (ret) {
 			dev_err(card->dev,
 				"ASoC: Property '%s' index %d could not be read: %d\n",
@@ -4630,7 +4634,7 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 		}
 	}
 
-	card->num_dapm_routes = num_routes;
+	card->num_dapm_routes += num_routes;
 	card->dapm_routes = routes;
 
 	return 0;
-- 
1.7.10.4

