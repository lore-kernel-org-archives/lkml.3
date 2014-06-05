Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaFEE17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:27:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaFEEWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 196/214] ixgbe: fix registration order of driver and DCA nofitication
Date: Wed,  4 Jun 2014 21:19:19 -0700
Message-Id: <20140605041705.769166083@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: no debugfs support]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7464,12 +7464,15 @@ static int __init ixgbe_init_module(void
 	pr_info("%s - version %s\n", ixgbe_driver_string, ixgbe_driver_version);
 	pr_info("%s\n", ixgbe_copyright);
 
+	ret = pci_register_driver(&ixgbe_driver);
+	if (ret)
+		return ret;
+
 #ifdef CONFIG_IXGBE_DCA
 	dca_register_notify(&dca_notifier);
 #endif
 
-	ret = pci_register_driver(&ixgbe_driver);
-	return ret;
+	return 0;
 }
 
 module_init(ixgbe_init_module);


