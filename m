Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaKSDUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:20:04 -0500
Received: from irl-smtp01.263.net ([54.76.167.174]:39912 "EHLO
	irl-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaKSDUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:20:03 -0500
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <3ee82631d5641be171dae78ba51aa3f5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun Xu <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, huangtao@rock-chips.com
Cc: Jianqun Xu <jay.xu@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output clock to codec
Date: Wed, 19 Nov 2014 11:07:48 +0800
Message-Id: <1416366468-4744-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com>
References: <1416366365-4632-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to claim the clock which is driving the codec so that when we enable
clock gating, we continue to clock the codec when needed.  I make this an
optional clock since there might be some applications where we don't need it
but can still use the I2S block.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index c74ba37..2820ade 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -28,6 +28,7 @@ struct rk_i2s_dev {
 
 	struct clk *hclk;
 	struct clk *mclk;
+	struct clk *oclk;
 
 	struct snd_dmaengine_dai_dma_data capture_dma_data;
 	struct snd_dmaengine_dai_dma_data playback_dma_data;
@@ -439,6 +440,14 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 		return PTR_ERR(i2s->mclk);
 	}
 
+	i2s->oclk = devm_clk_get(&pdev->dev, "i2s_clk_out");
+	if (IS_ERR(i2s->oclk)) {
+		dev_dbg(&pdev->dev, "Didn't find output clock\n");
+		i2s->oclk = NULL;
+	}
+	if (i2s->oclk)
+		ret = clk_prepare_enable(i2s->oclk);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs))
@@ -505,6 +514,8 @@ static int rockchip_i2s_remove(struct platform_device *pdev)
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		i2s_runtime_suspend(&pdev->dev);
 
+	if (i2s->oclk)
+		clk_disable_unprepare(i2s->oclk);
 	clk_disable_unprepare(i2s->mclk);
 	clk_disable_unprepare(i2s->hclk);
 	snd_dmaengine_pcm_unregister(&pdev->dev);
-- 
1.9.1

