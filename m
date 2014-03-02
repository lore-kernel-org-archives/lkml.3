Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaCBVIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:08:40 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35315 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaCBVIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:08:38 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Todza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 3/3] staging: dgap: fix error handling in dgap_init_module()
Date: Mon,  3 Mar 2014 01:08:08 +0400
Message-Id: <1393794488-12909-3-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
References: <20140225005154.GA22937@kroah.com>
 <1393794488-12909-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call pci_unregister_driver() if pci_register_driver() failed.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/dgap/dgap.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index b4157d7..510e8b3 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -535,18 +535,13 @@ int dgap_init_module(void)
 	 * If something went wrong in the scan, bail out of driver.
 	 */
 	if (rc < 0) {
-		/* Only unregister the pci driver if it was actually registered. */
-		if (dgap_NumBoards)
-			pci_unregister_driver(&dgap_driver);
-		else
-			printk("WARNING: dgap driver load failed.  No DGAP boards found.\n");
-
 		dgap_cleanup_module();
-	} else {
-		dgap_create_driver_sysfiles(&dgap_driver);
-		dgap_driver_state = DRIVER_READY;
+		return rc;
 	}
 
+	dgap_create_driver_sysfiles(&dgap_driver);
+	dgap_driver_state = DRIVER_READY;
+
 	return rc;
 }
 
-- 
1.8.3.2

