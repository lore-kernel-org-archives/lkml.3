Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaJFC7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 22:59:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41902 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaJFC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 22:58:58 -0400
Message-ID: <543206CD.1040505@gmail.com>
Date: Mon, 06 Oct 2014 11:04:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, bhelgaas@google.com
CC: xen-devel@lists.xenproject.org, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH next] xen: pcifront: Process failure for pcifront_(re)scan_root()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pcifront_rescan_root() or pcifront_scan_root() fails, need return
error code, neither set XenbusStateConnected state, just like the other
areas have done.

For pcifront_rescan_root(), it will return error code ("num_roots = 0;",
skip xenbus_switch_state return value).

For pcifront_scan_root(), it will return 0 ("num_roots = 0;", set 0 by
the return value of xenbus_switch_state, which always return 0, at
present).

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/pci/xen-pcifront.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 53df39a..d78d884 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -866,6 +866,11 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
 		xenbus_dev_error(pdev->xdev, err,
 				 "No PCI Roots found, trying 0000:00");
 		err = pcifront_scan_root(pdev, 0, 0);
+		if (err) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error scanning PCI root 0000:00");
+			goto out;
+		}
 		num_roots = 0;
 	} else if (err != 1) {
 		if (err == 0)
@@ -947,6 +952,11 @@ static int pcifront_attach_devices(struct pcifront_device *pdev)
 		xenbus_dev_error(pdev->xdev, err,
 				 "No PCI Roots found, trying 0000:00");
 		err = pcifront_rescan_root(pdev, 0, 0);
+		if (err) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error scanning PCI root 0000:00");
+			goto out;
+		}
 		num_roots = 0;
 	} else if (err != 1) {
 		if (err == 0)
-- 
1.9.3
