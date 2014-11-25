Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaKYKlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbaKYKlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <daniel@zonque.org>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 076/254] ASoC: soc-dapm: fix use after free
Date: Tue, 25 Nov 2014 10:37:06 +0000
Message-Id: <1416912004-5928-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <daniel@zonque.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/soc-dapm.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index cdc837ed144d..8065fd81b40c 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -566,9 +566,9 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
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
@@ -631,15 +631,17 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
 
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
@@ -647,17 +649,18 @@ static int dapm_create_or_share_mixmux_kcontrol(struct snd_soc_dapm_widget *w,
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
2.1.0

