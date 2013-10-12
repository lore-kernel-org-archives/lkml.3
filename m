Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3JLWWJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:22:09 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:60200 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3JLWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:22:08 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] sound: soc: fsl: Fix memory leak in imx-audmux.c
Date: Sat, 12 Oct 2013 19:22:34 -0300
Message-Id: <1381616554-18654-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When audmux_clk is used and clk_prepare_enable function succeed,
the memory alloc'd to buf variable is leaked

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 sound/soc/fsl/imx-audmux.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/imx-audmux.c b/sound/soc/fsl/imx-audmux.c
index d3bf71a..977759a 100644
--- a/sound/soc/fsl/imx-audmux.c
+++ b/sound/soc/fsl/imx-audmux.c
@@ -66,19 +66,20 @@ static ssize_t audmux_read_file(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
 {
 	ssize_t ret;
-	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	char *buf;
 	int port = (int)file->private_data;
 	u32 pdcr, ptcr;
 
-	if (!buf)
-		return -ENOMEM;
-
 	if (audmux_clk) {
 		ret = clk_prepare_enable(audmux_clk);
 		if (ret)
 			return ret;
 	}
 
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ptcr = readl(audmux_base + IMX_AUDMUX_V2_PTCR(port));
 	pdcr = readl(audmux_base + IMX_AUDMUX_V2_PDCR(port));
 
-- 
1.7.10.4

