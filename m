Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaFEAJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:09:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaFDXWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 165/228] ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()
Date: Wed,  4 Jun 2014 16:23:14 -0700
Message-Id: <20140604232353.334671950@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit ca5106ae3da0179dcee3ae21f3ea94f62e9fdb0c upstream.

For CODEC to CODEC DAI links the paths are created in snd_soc_dapm_new_pcm().
Also for CODEC to CODEC links the widgets are connected cross-over via a DAI
link widget, meaning that the capture widget of one CODEC will be connected to
the playback widget of the other and vice versa. Whereas
snd_soc_dapm_connect_dai_link_widgets() directly connects the playback widget of
the CPU DAI to the playback widget of the CODEC DAI and the capture widget of
the CPU DAI to the capture widget of the CODEC DAI. So not skipping
CODEC<->CODEC links in snd_soc_dapm_connect_dai_link_widgets() will create
incorrect connections between the two CODECs which will cause DAPM to detect
active paths where there are none and unnecessarily power up widgets.

Fixes: b893ea5 ("ASoC: sapm: Automatically connect DAI link widgets in DAPM graph.")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3649,8 +3649,11 @@ void snd_soc_dapm_connect_dai_link_widge
 		cpu_dai = rtd->cpu_dai;
 		codec_dai = rtd->codec_dai;
 
-		/* dynamic FE links have no fixed DAI mapping */
-		if (rtd->dai_link->dynamic)
+		/*
+		 * dynamic FE links have no fixed DAI mapping.
+		 * CODEC<->CODEC links have no direct connection.
+		 */
+		if (rtd->dai_link->dynamic || rtd->dai_link->params)
 			continue;
 
 		/* there is no point in connecting BE DAI links with dummies */


