Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab3BNL2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:28:10 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:58851 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab3BNL2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:28:09 -0500
Date: Thu, 14 Feb 2013 12:28:18 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] i2c: busses/i2c-pxa.c: fix potential null pointer
 dereference error
Message-ID: <20130214112818.GA18774@gmail.com>
References: <1360015899-13706-1-git-send-email-dinggnu@gmail.com>
 <CAH9JG2XSpFJeUvv7cw-JWadmi=X0-4EsN5FFKuDkwo=-mmzHSQ@mail.gmail.com>
 <20130205000517.GB9969@gmail.com>
 <CAN1soZwM6qNTJn3vvMdc6TR1eJHc=K+_c0WuWOBBuFYMWB_oCA@mail.gmail.com>
 <20130205102540.GC9969@gmail.com>
 <CAN1soZyDLtdjyOFWyVVXN-_ABrChcCR=QbifAo7cz9pYV-nHww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZyDLtdjyOFWyVVXN-_ABrChcCR=QbifAo7cz9pYV-nHww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If it goes to eclk through line 1107, the variable res would be NULL. It will
cause a null pointer dereference error if we call release_mem_region. The
correct way should be using devm_kzalloc rather than kzalloc to allocate
memory.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/i2c/busses/i2c-pxa.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 1034d93..dd2d640 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1094,29 +1094,23 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	struct resource *res = NULL;
 	int ret, irq;
 
-	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
-	if (!i2c) {
-		ret = -ENOMEM;
-		goto emalloc;
-	}
+	i2c = devm_kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
 
 	ret = i2c_pxa_probe_dt(dev, i2c, &i2c_type);
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
 	if (ret < 0)
-		goto eclk;
+		return ret;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(dev, 0);
-	if (res == NULL || irq < 0) {
-		ret = -ENODEV;
-		goto eclk;
-	}
+	if (res == NULL || irq < 0)
+		return -ENODEV;
 
-	if (!request_mem_region(res->start, resource_size(res), res->name)) {
-		ret = -ENOMEM;
-		goto eclk;
-	}
+	if (!request_mem_region(res->start, resource_size(res), res->name))
+		return -ENOMEM;
 
 	i2c->adap.owner   = THIS_MODULE;
 	i2c->adap.retries = 5;
-- 
1.7.9.5

