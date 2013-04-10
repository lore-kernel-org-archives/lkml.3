Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937222Ab3DJWrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937171Ab3DJWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/64] ixgbe: fix registration order of driver and DCA nofitication
Date: Wed, 10 Apr 2013 15:46:20 -0700
Message-Id: <20130410224338.528826421@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <jakub.kicinski@intel.com>

commit f01fc1a82c2ee68726b400fadb156bd623b5f2f1 upstream.

ixgbe_notify_dca cannot be called before driver registration
because it expects driver's klist_devices to be allocated and
initialized. While on it make sure debugfs files are removed
when registration fails.

Signed-off-by: Jakub Kicinski <jakub.kicinski@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7858,12 +7858,19 @@ static int __init ixgbe_init_module(void
 	ixgbe_dbg_init();
 #endif /* CONFIG_DEBUG_FS */
 
+	ret = pci_register_driver(&ixgbe_driver);
+	if (ret) {
+#ifdef CONFIG_DEBUG_FS
+		ixgbe_dbg_exit();
+#endif /* CONFIG_DEBUG_FS */
+		return ret;
+	}
+
 #ifdef CONFIG_IXGBE_DCA
 	dca_register_notify(&dca_notifier);
 #endif
 
-	ret = pci_register_driver(&ixgbe_driver);
-	return ret;
+	return 0;
 }
 
 module_init(ixgbe_init_module);


