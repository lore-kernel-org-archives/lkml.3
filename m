Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3EUKdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:33:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:36419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3EUKdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:33:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="317074464"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/4] gpio-langwell: initialize lock before usage
Date: Tue, 21 May 2013 13:33:03 +0300
Message-Id: <1369132386-11725-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we will end up with traceback from LOCKDEP:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc2-next-20130521-00028-g09aa9fc #487
 00000000 00000000 f6c55c54 c1541fe4 f6040bf8 f6c55c8c c1069ef1 c1726bc1
 c1726cc8 c1726c9e 00000000 f6c584e0 f6c58000 f6c55ce8 00000000 f6040bf8
 f6040bf8 00000046 f6c58000 f6c55d00 c106a18d 00000a2b 00000003 00004f02
Call Trace:
 [<c1541fe4>] dump_stack+0x49/0x77
 [<c1069ef1>] register_lock_class+0x58/0x260
 [<c106a18d>] __lock_acquire+0x94/0xcff
 [<c106adc8>] ? __lock_acquire+0xccf/0xcff
 [<c106b2ad>] lock_acquire+0xcc/0x10d
 [<c1269c7c>] ? lnw_irq_type+0x63/0xe9
 [<c1545da0>] _raw_spin_lock_irqsave+0x32/0x42
 [<c1269c7c>] ? lnw_irq_type+0x63/0xe9
 [<c1269c7c>] lnw_irq_type+0x63/0xe9
 [<c108f454>] __irq_set_trigger+0x98/0x123
 [<c1090225>] irq_set_irq_type+0x2f/0x51
 [<c1090225>] ? irq_set_irq_type+0x2f/0x51
 [<c1269d02>] ? lnw_irq_type+0xe9/0xe9
 [<c1269d34>] lnw_gpio_irq_map+0x32/0x3b
 [<c10914f2>] irq_domain_add_legacy+0xe2/0x107
 [<c1091b53>] irq_domain_add_simple+0x47/0x60
 [<c1269f6e>] lnw_gpio_probe+0x119/0x217
 [<c1271018>] pci_device_probe+0x5a/0x92
...

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 62ef10a..c1f33dd 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -380,6 +380,8 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	lnw->chip.can_sleep = 0;
 	lnw->pdev = pdev;
 
+	spin_lock_init(&lnw->lock);
+
 	lnw->domain = irq_domain_add_simple(pdev->dev.of_node, ngpio, irq_base,
 					    &lnw_gpio_irq_ops, lnw);
 	if (!lnw->domain) {
@@ -399,8 +401,6 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	irq_set_handler_data(pdev->irq, lnw);
 	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
 
-	spin_lock_init(&lnw->lock);
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
-- 
1.8.2.rc0.22.gb3600c3

