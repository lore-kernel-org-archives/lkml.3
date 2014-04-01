Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaDAKQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:16:08 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34694 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaDAKQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:16:06 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: konrad.wilk@oracle.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, joe@perches.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com
Subject: [PATCH v2] xen: fix memory leak in __xen_pcibk_add_pci_dev()
Date: Tue, 01 Apr 2014 19:15:59 +0900
Message-ID: <2172979.BN2CJo57Rq@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It need to free dev_entry when it failed to assign to a new
slot on the virtual PCI bus.

smatch says:
 drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
possible memory leak of 'dev_entry'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
v2: The kfree() invocation is moved outside the locked region.

 drivers/xen/xen-pciback/vpci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
index 3165ce3..51afff9 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -137,6 +137,8 @@ unlock:
 	/* Publish this device. */
 	if (!err)
 		err = publish_cb(pdev, 0, 0, PCI_DEVFN(slot, func), devid);
+	else
+		kfree(dev_entry);
 
 out:
 	return err;
-- 
1.7.4.4


