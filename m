Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3HRUo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:44:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3HRUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [ 20/45] ASoC: dapm: Fix empty list check in dapm_new_mux()
Date: Sun, 18 Aug 2013 13:36:09 -0700
Message-Id: <20130818203622.414435655@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit fe581391147cb3d738d961d0f1233d91a9e1113c upstream.

list_first_entry() will always return a valid pointer, even if the list is
empty. So the check whether path is NULL will always be false. So we end up
calling dapm_create_or_share_mixmux_kcontrol() with a path struct that points
right in the middle of the widget struct and by trying to modify the path the
widgets memory will become corrupted. Fix this by using list_emtpy() to check if
the widget doesn't have any paths.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -682,13 +682,14 @@ static int dapm_new_mux(struct snd_soc_d
 		return -EINVAL;
 	}
 
-	path = list_first_entry(&w->sources, struct snd_soc_dapm_path,
-				list_sink);
-	if (!path) {
+	if (list_empty(&w->sources)) {
 		dev_err(dapm->dev, "ASoC: mux %s has no paths\n", w->name);
 		return -EINVAL;
 	}
 
+	path = list_first_entry(&w->sources, struct snd_soc_dapm_path,
+				list_sink);
+
 	ret = dapm_create_or_share_mixmux_kcontrol(w, 0, path);
 	if (ret < 0)
 		return ret;


