Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3EII2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:28:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26494 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3EII2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:28:07 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <Sonic.Zhang@analog.com>, <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <lizefan@huawei.com>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH v2 2/2] i2c: pxa: no need release_mem_region before request_mem_region successful
Date: Thu, 9 May 2013 16:27:24 +0800
Message-ID: <1368088044-20408-3-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
References: <1368088044-20408-1-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kzalloc fail, there is no reason to release_mem_region

fix confuse tag, add new tag: emem, eirq, edt and make it cleanly

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/i2c/busses/i2c-pxa.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index ea6d45d..a9da954 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1104,18 +1104,18 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
 	if (ret < 0)
-		goto eclk;
+		goto edt;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(dev, 0);
 	if (res == NULL || irq < 0) {
 		ret = -ENODEV;
-		goto eclk;
+		goto eirq;
 	}
 
 	if (!request_mem_region(res->start, resource_size(res), res->name)) {
 		ret = -ENOMEM;
-		goto eclk;
+		goto emem;
 	}
 
 	i2c->adap.owner   = THIS_MODULE;
@@ -1207,9 +1207,12 @@ ereqirq:
 eremap:
 	clk_put(i2c->clk);
 eclk:
-	kfree(i2c);
-emalloc:
 	release_mem_region(res->start, resource_size(res));
+emem:
+eirq:
+edt:
+	kfree(i2c);
+emalloc:	
 	return ret;
 }
 
-- 
1.7.1


