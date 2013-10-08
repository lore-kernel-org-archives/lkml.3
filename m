Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab3JHGcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:32:08 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2441 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3JHGbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:31:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 Oct 2013 23:27:42 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <treding@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        <mkulkarni@nvidia.com>
Subject: [PATCHv4 1/5] drm/tegra: Fix gr2d initialisation clean up
Date: Tue, 8 Oct 2013 09:27:24 +0300
Message-ID: <1381213648-5931-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
References: <1381213648-5931-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gr2d initialisation clean up had missing steps (i.e. host1x channel
was not released if we could not register gr2d as a host1x client)
that could have lead to weird issues. This patch reworks the
initialisation sequence to do clean up correctly.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/drm/gr2d.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 27ffcf1..60150ad 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -282,13 +282,15 @@ static int gr2d_probe(struct platform_device *pdev)
 	}
 
 	gr2d->channel = host1x_channel_request(dev);
-	if (!gr2d->channel)
-		return -ENOMEM;
+	if (!gr2d->channel) {
+		err = -ENOMEM;
+		goto err_channel_request;
+	}
 
 	*syncpts = host1x_syncpt_request(dev, false);
 	if (!(*syncpts)) {
-		host1x_channel_free(gr2d->channel);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_syncpt_request;
 	}
 
 	gr2d->client.ops = &gr2d_client_ops;
@@ -300,7 +302,7 @@ static int gr2d_probe(struct platform_device *pdev)
 	err = host1x_register_client(host1x, &gr2d->client);
 	if (err < 0) {
 		dev_err(dev, "failed to register host1x client: %d\n", err);
-		return err;
+		goto err_register_client;
 	}
 
 	gr2d_init_addr_reg_map(dev, gr2d);
@@ -308,6 +310,15 @@ static int gr2d_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gr2d);
 
 	return 0;
+
+err_register_client:
+	host1x_syncpt_free(*gr2d->client.syncpts);
+err_syncpt_request:
+	host1x_channel_free(gr2d->channel);
+err_channel_request:
+	clk_disable_unprepare(gr2d->clk);
+
+	return err;
 }
 
 static int __exit gr2d_remove(struct platform_device *pdev)
-- 
1.8.1.5

