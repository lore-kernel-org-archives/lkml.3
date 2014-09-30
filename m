Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaI3Bau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:30:50 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:60656 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaI3Bat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:30:49 -0400
From: Yunlei He <heyunlei@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tony@atomide.com>, <grant.likely@linaro.org>, <robh+dt@kernel.org>
CC: <liguozhu@hisilicon.com>, <kong.kongxinwei@hisilicon.com>,
        <bintian.wang@huawei.com>, heyunlei <heyunlei@huawei.com>
Subject: [PATCH] pinctrl: pinctrl-single.c: init pinctrl single at arch_initcall time
Date: Tue, 30 Sep 2014 09:29:50 +0800
Message-ID: <1412040590-10764-1-git-send-email-heyunlei@huawei.com>
X-Mailer: git-send-email 1.9.4.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.111.64.99]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.542A07BA.0025,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 6ee4c1d2f6ddb5c57ab74e291b81405f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: heyunlei <heyunlei@huawei.com>

On our arm platform, some modules (e.g. I2C bus driver) use the
pinctrl-single driver to configure the SoC pin, but pinctrl-single
driver uses module_init time, that makes some modules initialize ahead
the pinctrl-single and fail to register.

This patch changes the initialization priority of pinctrl-single from
module_init time to arch_initcall time.

Signed-off-by: Yunlei He <heyunlei@huawei.com>
Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
---
 drivers/pinctrl/pinctrl-single.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 95dd9cf..4b9e5b9 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -2012,7 +2012,18 @@ static struct platform_driver pcs_driver = {
 #endif
 };
 
-module_platform_driver(pcs_driver);
+static int __init pinctrl_single_init(void)
+{
+		return platform_driver_register(&pcs_driver);
+}
+
+static void __exit pinctrl_single_exit(void)
+{
+		platform_driver_unregister(&pcs_driver);
+}
+
+arch_initcall(pinctrl_single_init);
+module_exit(pinctrl_single_exit);
 
 MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
 MODULE_DESCRIPTION("One-register-per-pin type device tree based pinctrl driver");
-- 
1.7.9.5


