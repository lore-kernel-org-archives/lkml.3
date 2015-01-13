Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbbAMUDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:03:40 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:58392 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbAMUDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:03:38 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] ASoC: simple-card: Fix crash in asoc_simple_card_unref()
Date: Tue, 13 Jan 2015 21:03:37 +0100
Message-Id: <1421179417-23698-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If asoc_simple_card_probe() fails, asoc_simple_card_unref() may be
called before dev_set_drvdata(), causing a NULL pointer dereference in
asoc_simple_card_unref():

    Unable to handle kernel NULL pointer dereference at virtual address 000000d4
    ...
    PC is at asoc_simple_card_unref+0x14/0x48
    LR is at asoc_simple_card_probe+0x3d4/0x40c

This typically happens because asoc_simple_card_parse_of() returns
-EPROBE_DEFER, but other failure modes are possible.
devm_snd_soc_register_card()/snd_soc_register_card() may fail either
before or after dev_set_drvdata().

Pass a snd_soc_card pointer instead of a platform_device pointer to
asoc_simple_card_unref() to fix this.

Note that if CONFIG_OF_DYNAMIC=n, of_node_put() is a dummy, and gcc may
optimize away the loop over card->dai_link, never actually dereferencing
card, and thus avoiding the crash...

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: e512e001dafa54e5 ("ASoC: simple-card: Fix the reference count of device nodes")
---
Seen on sh73a0/kzm9g-multiplatform and r8a7740/armadillo-multiplatform,
first with CONFIG_OF_DYNAMIC=y, later with extra debug code that caused
the loop not to be optimized away. It took me a while to understand what
was really happening...

I think this should be applied to -stable.

In v3.15 and v3.16, only 8xx, pseries, and wsp selected OF_DYNAMIC,
and I believe they don't use aSoC?
In v3.17 and later, OF_DYNAMIC is selected by OF_SELFTEST/OF_UNITTEST.
---
 sound/soc/generic/simple-card.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index fb9240fdc9b70095..7fe3009b1c43c63c 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -452,9 +452,8 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 }
 
 /* Decrease the reference count of the device nodes */
-static int asoc_simple_card_unref(struct platform_device *pdev)
+static int asoc_simple_card_unref(struct snd_soc_card *card)
 {
-	struct snd_soc_card *card = platform_get_drvdata(pdev);
 	struct snd_soc_dai_link *dai_link;
 	int num_links;
 
@@ -556,7 +555,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		return ret;
 
 err:
-	asoc_simple_card_unref(pdev);
+	asoc_simple_card_unref(&priv->snd_card);
 	return ret;
 }
 
@@ -572,7 +571,7 @@ static int asoc_simple_card_remove(struct platform_device *pdev)
 		snd_soc_jack_free_gpios(&simple_card_mic_jack, 1,
 					&simple_card_mic_jack_gpio);
 
-	return asoc_simple_card_unref(pdev);
+	return asoc_simple_card_unref(card);
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
-- 
1.9.1

