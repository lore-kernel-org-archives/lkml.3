Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3EFNLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:11:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:17595 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3EFNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:11:32 -0400
Message-ID: <5187ABF9.4000903@huawei.com>
Date: Mon, 6 May 2013 21:11:21 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <wsa@the-dreams.de>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/2] i2c: pxa: no need release_mem_region before request_mem_region
 successful
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move release_mem_region above kfree(i2c) && below clk_put(i2c->clk)

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/i2c/busses/i2c-pxa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index ea6d45d..3188cd0 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1129,7 +1129,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	i2c->clk = clk_get(&dev->dev, NULL);
 	if (IS_ERR(i2c->clk)) {
 		ret = PTR_ERR(i2c->clk);
-		goto eclk;
+		goto emm;
 	}

 	i2c->reg_base = ioremap(res->start, resource_size(res));
@@ -1206,10 +1206,11 @@ ereqirq:
 	iounmap(i2c->reg_base);
 eremap:
 	clk_put(i2c->clk);
+emm:
+	release_mem_region(res->start, resource_size(res));
 eclk:
 	kfree(i2c);
 emalloc:
-	release_mem_region(res->start, resource_size(res));
 	return ret;
 }

-- 
1.7.1

