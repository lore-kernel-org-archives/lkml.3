Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbbA0MWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:22:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741AbbA0MUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Baker <tyler.baker@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 118/126] reset: sunxi: fix spinlock initialization
Date: Tue, 27 Jan 2015 12:17:03 +0000
Message-Id: <1422361031-19364-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Baker <tyler.baker@linaro.org>

commit 41544f9f38f19cb46dc9a8fa37c58677a0300899 upstream.

Call spin_lock_init() before the spinlocks are used, both in early init
and probe functions preventing a lockdep splat.

I have been observing lockdep complaining [1] during boot on my a80 optimus [2]
when CONFIG_PROVE_LOCKING has been enabled. This patch resolves the splat,
and has been tested on a few other sunxi platforms without issue.

[1] http://storage.kernelci.org/next/next-20150107/arm-multi_v7_defconfig+CONFIG_PROVE_LOCKING=y/lab-tbaker/boot-sun9i-a80-optimus.html
[2] http://kernelci.org/boot/?a80-optimus

Signed-off-by: Tyler Baker <tyler.baker@linaro.org>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/reset/reset-sunxi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/reset/reset-sunxi.c b/drivers/reset/reset-sunxi.c
index a94e7a7820b4..51272b5d7552 100644
--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -102,6 +102,8 @@ static int sunxi_reset_init(struct device_node *np)
 		goto err_alloc;
 	}
 
+	spin_lock_init(&data->lock);
+
 	data->rcdev.owner = THIS_MODULE;
 	data->rcdev.nr_resets = size * 32;
 	data->rcdev.ops = &sunxi_reset_ops;
@@ -157,6 +159,8 @@ static int sunxi_reset_probe(struct platform_device *pdev)
 	if (IS_ERR(data->membase))
 		return PTR_ERR(data->membase);
 
+	spin_lock_init(&data->lock);
+
 	data->rcdev.owner = THIS_MODULE;
 	data->rcdev.nr_resets = resource_size(res) * 32;
 	data->rcdev.ops = &sunxi_reset_ops;
-- 
2.1.4

