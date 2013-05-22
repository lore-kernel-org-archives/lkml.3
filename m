Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3EVKUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:20:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:9603 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab3EVKUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341306506"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/5] gpio-langwell: do not use direct access to iomapped memory
Date: Wed, 22 May 2013 13:20:11 +0300
Message-Id: <1369218014-28990-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We better to use readl() function instead of bad looking direct access.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index c1f33dd..8203084 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -65,7 +65,7 @@ enum GPIO_REG {
 
 struct lnw_gpio {
 	struct gpio_chip		chip;
-	void				*reg_base;
+	void __iomem			*reg_base;
 	spinlock_t			lock;
 	struct pci_dev			*pdev;
 	struct irq_domain		*domain;
@@ -318,9 +318,9 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
 };
 
 static int lnw_gpio_probe(struct pci_dev *pdev,
-			const struct pci_device_id *id)
+			  const struct pci_device_id *id)
 {
-	void *base;
+	void __iomem *base;
 	resource_size_t start, len;
 	struct lnw_gpio *lnw;
 	u32 gpio_base;
@@ -346,8 +346,10 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 		retval = -EFAULT;
 		goto err_ioremap;
 	}
-	irq_base = *(u32 *)base;
-	gpio_base = *((u32 *)base + 1);
+
+	irq_base = readl(base);
+	gpio_base = readl(sizeof(u32) + base);
+
 	/* release the IO mapping, since we already get the info from bar1 */
 	iounmap(base);
 	/* get the register base from bar0 */
-- 
1.8.2.rc0.22.gb3600c3

