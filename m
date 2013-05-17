Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3EQI0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:26:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41151 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3EQI0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:26:01 -0400
MIME-Version: 1.0
Date: Fri, 17 May 2013 16:26:00 +0800
Message-ID: <CAPgLHd_ScFPt5iYoFv++Bn-0cbwBXRX4YXJWqyyNzhQQkTsHXQ@mail.gmail.com>
Subject: [PATCH] ARM: etm: add missing misc_deregister() on probe error and remove
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org,
        jovi.zhangwei@huawei.com, gregkh@linuxfoundation.org,
        rdunlap@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing misc_deregister() on probe error and remove.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/kernel/etm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8ff0ecd..d0b7426 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -365,7 +365,8 @@ static int etb_probe(struct amba_device *dev, const struct amba_id *id)
 	t->emu_clk = clk_get(&dev->dev, "emu_src_ck");
 	if (IS_ERR(t->emu_clk)) {
 		dev_dbg(&dev->dev, "Failed to obtain emu_src_ck.\n");
-		return -EFAULT;
+		ret = PTR_ERR(t->emu_clk);
+		goto out_dereg;
 	}
 
 	clk_enable(t->emu_clk);
@@ -384,6 +385,8 @@ static int etb_probe(struct amba_device *dev, const struct amba_id *id)
 out:
 	return ret;
 
+out_dereg:
+	misc_deregister(&etb_miscdev);
 out_unmap:
 	amba_set_drvdata(dev, NULL);
 	iounmap(t->etb_regs);
@@ -398,6 +401,7 @@ static int etb_remove(struct amba_device *dev)
 {
 	struct tracectx *t = amba_get_drvdata(dev);
 
+	misc_deregister(&etb_miscdev);
 	amba_set_drvdata(dev, NULL);
 
 	iounmap(t->etb_regs);

