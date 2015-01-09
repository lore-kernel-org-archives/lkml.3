Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbbAIBzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:55:04 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:46918 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbAIBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:55:01 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: lgirdwood@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <3b8634f1e7b144c623b17c8c1f2d0ded>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, heiko@sntech.de, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, sonnyrao@chromium.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: rockchip: i2s: add rockchip_dmaengine_pcm_config
Date: Fri,  9 Jan 2015 09:52:49 +0800
Message-Id: <1420768369-6681-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes snd_dmaengine_pcm_register with rockchip_dmaengine_pcm_config,
which configure the parameters of period and buffer match to rockchip DMAC.

=======================
without rockchip_dmaengine_pcm_config, and test with command -
aplay -D hw:0,0 /tmp/a, there are the error dump:
[  134.899396] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(7)
[  134.906270] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(8)
[  134.913141] dma-pl330 ffb20000.dma-controller: fill_queue:2251 Bad Desc(9)

And bellow sound from DMA debugger:
"I debugged it a little and it looks like what is happening is that requests
which aren't a multiple of burst size * burst length are coming in.  Right
now the i2s block is setting a burst size of 4 and burst length of 4, but
the dmaengine code has no idea about this restriction.  I was able to
eliminate the messages by changing burst length to 1 in the i2s driver.
This fix would always work as long as we're sending a multiple of 4 bytes
(which so far seems to be the case)"

This patch can make the length of dma buffer is aligned to a multiple of burst size
and burst length.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index c74ba37..bdd1021 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -408,6 +408,24 @@ static const struct regmap_config rockchip_i2s_regmap_config = {
 	.cache_type = REGCACHE_FLAT,
 };
 
+static const struct snd_pcm_hardware rockchip_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_MMAP |
+				  SNDRV_PCM_INFO_MMAP_VALID |
+				  SNDRV_PCM_INFO_INTERLEAVED,
+	.period_bytes_min	= 1024,
+	.period_bytes_max	= PAGE_SIZE,
+	.periods_min		= 3,
+	.periods_max		= 8,
+	.buffer_bytes_max	= 8 * PAGE_SIZE,
+	.fifo_size		= 16,
+};
+
+static const struct snd_dmaengine_pcm_config rockchip_dmaengine_pcm_config = {
+	.pcm_hardware = &rockchip_pcm_hardware,
+	.prepare_slave_config = snd_dmaengine_pcm_prepare_slave_config,
+	.prealloc_buffer_size = PAGE_SIZE * 8,
+};
+
 static int rockchip_i2s_probe(struct platform_device *pdev)
 {
 	struct rk_i2s_dev *i2s;
@@ -478,7 +496,8 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
 		goto err_suspend;
 	}
 
-	ret = snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+	ret = snd_dmaengine_pcm_register(&pdev->dev,
+					 &rockchip_dmaengine_pcm_config, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not register PCM\n");
 		goto err_pcm_register;
-- 
1.9.1


