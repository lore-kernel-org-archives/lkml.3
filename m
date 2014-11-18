Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaKRPOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:14:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbaKROJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/206] ASoC: soc-dapm: fix use after free
Date: Tue, 18 Nov 2014 15:06:52 +0100
Message-Id: <9e5e18105b8ac7f8e5167f396c0eeb2aaef6e003.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e5092c96c9c28f4d12811edcd02ca8eec16e748e upstream.

Coverity spotted the following possible use-after-free condition in
dapm_create_or_share_mixmux_kcontrol():

If kcontrol is NULL, and (wname_in_long_name && kcname_in_long_name)
validates to true, 'name' will be set to an allocated string, and be
freed a few lines later via the 'long_name' alias. 'name', however,
is used by dev_err() in case snd_ctl_add() fails.

Fix this by adding a jump label that frees 'long_name' at the end of
the function.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/soc-dapm.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 4136cc25154e..d3fa7b76a21b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -675,9 +675,9 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
 	int shared;
 	struct snd_kcontrol *kcontrol;
 	bool wname_in_long_name, kcname_in_long_name;
-	char *long_name;
+	char *long_name = NULL;
 	const char *name;
-	int ret;
+	int ret = 0;
 
 	if (dapm->codec)
 		prefix = dapm->codec->name_prefix;
@@ -742,15 +742,17 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
 
 		kcontrol = snd_soc_cnew(&w->kcontrol_news[kci], NULL, name,
 					prefix);
-		kfree(long_name);
-		if (!kcontrol)
-			return -ENOMEM;
+		if (!kcontrol) {
+			ret = -ENOMEM;
+			goto exit_free;
+		}
+
 		kcontrol->private_free = dapm_kcontrol_free;
 
 		ret = dapm_kcontrol_data_alloc(w, kcontrol);
 		if (ret) {
 			snd_ctl_free_one(kcontrol);
-			return ret;
+			goto exit_free;
 		}
 
 		ret = snd_ctl_add(card, kcontrol);
@@ -758,17 +760,18 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
 			dev_err(dapm->dev,
 				"ASoC: failed to add widget %s dapm kcontrol %s: %d\n",
 				w->name, name, ret);
-			return ret;
+			goto exit_free;
 		}
 	}
 
 	ret = dapm_kcontrol_add_widget(kcontrol, w);
-	if (ret)
-		return ret;
+	if (ret == 0)
+		w->kcontrols[kci] = kcontrol;
 
-	w->kcontrols[kci] = kcontrol;
+exit_free:
+	kfree(long_name);
 
-	return 0;
+	return ret;
 }
 
 /* create new dapm mixer control */
-- 
2.1.3

