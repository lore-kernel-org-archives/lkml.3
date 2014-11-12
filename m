Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaKLBjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:39:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaKLBjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:39:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 020/203] ASoC: soc-dapm: fix use after free
Date: Wed, 12 Nov 2014 10:14:50 +0900
Message-Id: <20141112011543.634225790@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -689,9 +689,9 @@ static int dapm_create_or_share_mixmux_k
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
@@ -756,15 +756,17 @@ static int dapm_create_or_share_mixmux_k
 
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
@@ -772,17 +774,18 @@ static int dapm_create_or_share_mixmux_k
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


