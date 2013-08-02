Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3HBRjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:39:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:2503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab3HBRgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="356385619"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] NTB: Add Error Handling in ntb_device_setup
Date: Fri,  2 Aug 2013 10:35:30 -0700
Message-Id: <1375464944-27914-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an error is encountered in ntb_device_setup, it is possible that the
spci_cmd isn't populated.  Writes to the offset can result in a NULL
pointer dereference.  This issue is easily encountered by running in
NTB-RP mode, as it currently is not supported and will generate an
error.  To get around this issue, return if an error is encountered
prior to attempting to write to the spci_cmd offset.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 2dacd19..515099e 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -644,10 +644,13 @@ static int ntb_device_setup(struct ntb_device *ndev)
 		rc = -ENODEV;
 	}
 
+	if (rc)
+		return rc;
+
 	/* Enable Bus Master and Memory Space on the secondary side */
 	writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER, ndev->reg_ofs.spci_cmd);
 
-	return rc;
+	return 0;
 }
 
 static void ntb_device_free(struct ntb_device *ndev)
-- 
1.7.9.5

