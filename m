Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128AbaFCV3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:29:44 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54699 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965105AbaFCV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:29:42 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>, Daniel Drake <dsd@laptop.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc
Date: Tue,  3 Jun 2014 23:30:34 +0200
Message-Id: <1401831034-30255-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for possible null pointer dereferenc, and there is a risk
for memory leak in when something unexpected happens and the
function returns.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/i2c/busses/i2c-pxa.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index bbe6dfb..948a3c7 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1142,10 +1142,8 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	int ret, irq;
 
 	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
-	if (!i2c) {
-		ret = -ENOMEM;
-		goto emalloc;
-	}
+	if (!i2c)
+		return -ENOMEM;
 
 	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
 	i2c->adap.nr = dev->id;
@@ -1154,11 +1152,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
 	if (ret < 0)
-		goto eclk;
+		goto emalloc;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		ret = -ENODEV;
+		goto emalloc;
+	}
+
 	irq = platform_get_irq(dev, 0);
-	if (res == NULL || irq < 0) {
+	if (irq < 0) {
 		ret = -ENODEV;
 		goto eclk;
 	}
@@ -1267,9 +1270,9 @@ ereqirq:
 eremap:
 	clk_put(i2c->clk);
 eclk:
-	kfree(i2c);
-emalloc:
 	release_mem_region(res->start, resource_size(res));
+emalloc:
+	kfree(i2c);
 	return ret;
 }
 
-- 
1.7.10.4

