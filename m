Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbaGDI4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:56:45 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40768 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaGDI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:56:41 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, tiwai@suse.de, perex@perex.cz,
        broonie@kernel.org, lgirdwood@gmail.com, galak@codeaurora.org,
        kgene.kim@samsung.com, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        trblinux@gmail.com
Subject: [PATCH 2/2] ASoC: core: Fix possible NULL pointer dereference
Date: Fri,  4 Jul 2014 14:23:00 +0530
Message-Id: <1404463980-25027-2-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
References: <1404463980-25027-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_soc_of_parse_card_name() may be called before card->dev has been
set, which results in a kernel panic.

Unable to handle kernel NULL pointer dereference at virtual address 00000210
PC is at snd_soc_of_parse_card_name+0x18/0x54
LR is at snow_probe+0x5c/0xd4

Add an error check in snd_soc_of_parse_card_name() to take care of this
case and print out a message in case of error.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 sound/soc/soc-core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c4db07f..2e4bdc0 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4391,9 +4391,16 @@ EXPORT_SYMBOL_GPL(snd_soc_unregister_codec);
 int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 			       const char *propname)
 {
-	struct device_node *np = card->dev->of_node;
+	struct device_node *np;
 	int ret;
 
+	if (!card->dev) {
+		pr_err("card->dev is not set before calling %s\n", __func__);
+		return -EINVAL;
+	}
+
+	np = card->dev->of_node;
+
 	ret = of_property_read_string_index(np, propname, 0, &card->name);
 	/*
 	 * EINVAL means the property does not exist. This is fine providing
-- 
1.7.9.5

