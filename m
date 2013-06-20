Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3FTOlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:41:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:7382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab3FTOlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:41:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,905,1363158000"; 
   d="scan'208";a="356797338"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jerome Blin <jerome.blin@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzalloc()
Date: Thu, 20 Jun 2013 17:44:22 +0300
Message-Id: <1371739462-21139-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI part of the driver accidentally used sizeof(*ssp) instead of the
correct sizeof(*pdata). This leads to nasty memory corruptions like the one
below:

    BUG: unable to handle kernel paging request at 0000000749fd30b8
    IP: [<ffffffff813fe8a1>] __list_del_entry+0x31/0xd0
    PGD 0
    Oops: 0000 [#1] PREEMPT SMP
    Modules linked in:
    CPU: 0 PID: 30 Comm: kworker/0:1 Not tainted 3.10.0-rc6v3.10-rc6_sdhci_modprobe+ #443
    task: ffff8801483a0940 ti: ffff88014839e000 task.ti: ffff88014839e000
    RIP: 0010:[<ffffffff813fe8a1>]  [<ffffffff813fe8a1>] __list_del_entry+0x31/0xd0
    RSP: 0000:ffff88014839fde8  EFLAGS: 00010046
    RAX: ffff880149fd30b0 RBX: ffff880149fd3040 RCX: dead000000200200
    RDX: 0000000749fd30b0 RSI: ffff880149fd3058 RDI: ffff88014834d640
    RBP: ffff88014839fde8 R08: ffff88014834d640 R09: 0000000000000001
    R10: ffff8801483a0940 R11: 0000000000000001 R12: ffff880149fd3040
    R13: ffffffff810e0b30 R14: ffff8801483a0940 R15: ffff88014834d640
    FS:  0000000000000000(0000) GS:ffff880149e00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000168 CR3: 0000000001e0b000 CR4: 00000000001407f0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Stack:
     ffff88014839fe48 ffffffff810e0baf ffffffff81120abd ffff88014839fe20
     ffff8801483a0940 ffff8801483a0940 ffff8801483a0940 ffff8801486b1c90
     ffff88014834d640 ffffffff810e0b30 0000000000000000 0000000000000000
    Call Trace:
     [<ffffffff810e0baf>] worker_thread+0x7f/0x390
     [<ffffffff81120abd>] ? trace_hardirqs_on+0xd/0x10
     [<ffffffff810e0b30>] ? manage_workers.isra.22+0x2b0/0x2b0
     [<ffffffff810e6c09>] kthread+0xd9/0xe0
     [<ffffffff810f93df>] ? local_clock+0x3f/0x50
     [<ffffffff810e6b30>] ? kthread_create_on_node+0x110/0x110
     [<ffffffff818c5dec>] ret_from_fork+0x7c/0xb0
     [<ffffffff810e6b30>] ? kthread_create_on_node+0x110/0x110

Fix this by using the right structure size in devm_kzalloc().

Reported-by: Jerome Blin <jerome.blin@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: stable@vger.kernel.org # 3.9+
---
 drivers/spi/spi-pxa2xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index f5d84d6..48b396f 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1075,7 +1075,7 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 	    acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
 		return NULL;
 
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*ssp), GFP_KERNEL);
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata) {
 		dev_err(&pdev->dev,
 			"failed to allocate memory for platform data\n");
-- 
1.8.3.1

