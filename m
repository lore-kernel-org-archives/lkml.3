Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaG3AyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:54:17 -0400
Received: from m12-18.163.com ([220.181.12.18]:44406 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaG3AyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:54:15 -0400
X-Coremail-DSSMTP: 180.110.163.205
From: weiyj_lk@163.com
To: Sebastian Reichel <sre@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Carlos Chinea <carlos.chinea@nokia.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH] HSI: omap_ssi: Fix return value check in ssi_debug_add_ctrl()
Date: Wed, 30 Jul 2014 08:53:41 +0800
Message-Id: <1406681621-23265-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EsCowEBJu0cWQthTknZ3Cg--.444S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF17Jryfuw48WFW8Ar15XFb_yoW8Xr4Dpa
	1DWay7Kr18tF43AryFy3y8JFyav3Z7Jryxu397uwnxZw1fu3ySv347JFyF9F93u3saq3WU
	A3s5W3WkGF18JF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bY0eLUUUUU=
X-Originating-IP: [180.110.163.205]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiNQPY1lHZXoh8ugAAsg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function debugfs_create_*() returns NULL
pointer not ERR_PTR() if debugfs is enabled. The IS_ERR() test
in the return value check should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hsi/controllers/omap_ssi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi.c b/drivers/hsi/controllers/omap_ssi.c
index 0fc7a7f..cee6ec2 100644
--- a/drivers/hsi/controllers/omap_ssi.c
+++ b/drivers/hsi/controllers/omap_ssi.c
@@ -148,14 +148,14 @@ static int __init ssi_debug_add_ctrl(struct hsi_controller *ssi)
 
 	/* SSI controller */
 	omap_ssi->dir = debugfs_create_dir(dev_name(&ssi->device), NULL);
-	if (IS_ERR(omap_ssi->dir))
-		return PTR_ERR(omap_ssi->dir);
+	if (!omap_ssi->dir)
+		return -ENOMEM;
 
 	debugfs_create_file("regs", S_IRUGO, omap_ssi->dir, ssi,
 								&ssi_regs_fops);
 	/* SSI GDD (DMA) */
 	dir = debugfs_create_dir("gdd", omap_ssi->dir);
-	if (IS_ERR(dir))
+	if (!dir)
 		goto rback;
 	debugfs_create_file("regs", S_IRUGO, dir, ssi, &ssi_gdd_regs_fops);
 
@@ -163,7 +163,7 @@ static int __init ssi_debug_add_ctrl(struct hsi_controller *ssi)
 rback:
 	debugfs_remove_recursive(omap_ssi->dir);
 
-	return PTR_ERR(dir);
+	return -ENOMEM;
 }
 
 static void ssi_debug_remove_ctrl(struct hsi_controller *ssi)

