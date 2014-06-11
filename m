Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaFKKR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:17:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFKKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:17:56 -0400
Date: Wed, 11 Jun 2014 13:17:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] mfd: vexpress: fix error handling
 vexpress_syscfg_regmap_init()
Message-ID: <20140611101740.GA13148@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402478542.3523.9.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function should be returning an ERR_PTR() on failure instead of
NULL.  Also there is a use after free bug if regmap_init() fails because
we free "func" and then dereference doing the return.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
index 73068e5..3250fc1 100644
--- a/drivers/misc/vexpress-syscfg.c
+++ b/drivers/misc/vexpress-syscfg.c
@@ -199,7 +199,7 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 	func = kzalloc(sizeof(*func) + sizeof(*func->template) * num,
 			GFP_KERNEL);
 	if (!func)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	func->syscfg = syscfg;
 	func->num_templates = num;
@@ -231,10 +231,14 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
 	func->regmap = regmap_init(dev, NULL, func,
 			&vexpress_syscfg_regmap_config);
 
-	if (IS_ERR(func->regmap))
+	if (IS_ERR(func->regmap)) {
+		void *err = func->regmap;
+
 		kfree(func);
-	else
-		list_add(&func->list, &syscfg->funcs);
+		return err;
+	}
+
+	list_add(&func->list, &syscfg->funcs);
 
 	return func->regmap;
 }
