Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3EUKds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:33:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:50133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3EUKdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="337539847"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/4] gpio-langwell: do not use direct access to iomapped memory
Date: Tue, 21 May 2013 13:33:05 +0300
Message-Id: <1369132386-11725-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We better to use readl() function instead of bad looking direct access.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index ab797cc..652c1c7 100644
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

