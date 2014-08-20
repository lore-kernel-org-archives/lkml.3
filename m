Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaHTLyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:54:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58977 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Dave Ertman <davidx.m.ertman@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/104] e1000e: Fix compilation warning when !CONFIG_PM_SLEEP
Date: Wed, 20 Aug 2014 13:43:35 +0200
Message-Id: <20e7aadfcf5f6af2507bbc414f7d9a0419a6ecf7.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 38a529b5d42e4cfc5ac94844e61335a00eb2d320 upstream.

Commit 7509963c703b (e1000e: Fix a compile flag mis-match for
suspend/resume) moved suspend and resume hooks to be available when
CONFIG_PM is set. However, it can be set even if CONFIG_PM_SLEEP is not set
causing following warnings to be emitted:

drivers/net/ethernet/intel/e1000e/netdev.c:6178:12: warning:
  	‘e1000_suspend’ defined but not used [-Wunused-function]

drivers/net/ethernet/intel/e1000e/netdev.c:6185:12: warning:
	‘e1000_resume’ defined but not used [-Wunused-function]

To fix this make the hooks to be available only when CONFIG_PM_SLEEP is set
and remove CONFIG_PM wrapping from driver ops because this is already
handled by SET_SYSTEM_SLEEP_PM_OPS() and SET_RUNTIME_PM_OPS().

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Dave Ertman <davidx.m.ertman@intel.com>
Cc: Aaron Brown <aaron.f.brown@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 2778858957f6..07547f67b0a4 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6186,7 +6186,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int e1000_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -6205,7 +6205,7 @@ static int e1000_resume(struct device *dev)
 
 	return __e1000_resume(pdev);
 }
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_RUNTIME
 static int e1000_runtime_suspend(struct device *dev)
@@ -7027,13 +7027,11 @@ static DEFINE_PCI_DEVICE_TABLE(e1000_pci_tbl) = {
 };
 MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
-#ifdef CONFIG_PM
 static const struct dev_pm_ops e1000_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(e1000_suspend, e1000_resume)
 	SET_RUNTIME_PM_OPS(e1000_runtime_suspend, e1000_runtime_resume,
 			   e1000_idle)
 };
-#endif
 
 /* PCI Device API Driver */
 static struct pci_driver e1000_driver = {
@@ -7041,11 +7039,9 @@ static struct pci_driver e1000_driver = {
 	.id_table = e1000_pci_tbl,
 	.probe    = e1000_probe,
 	.remove   = e1000_remove,
-#ifdef CONFIG_PM
 	.driver   = {
 		.pm = &e1000_pm_ops,
 	},
-#endif
 	.shutdown = e1000_shutdown,
 	.err_handler = &e1000_err_handler
 };
-- 
2.0.4

