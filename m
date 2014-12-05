Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaLEV3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:29:12 -0500
Received: from mail.ispras.ru ([83.149.199.45]:60967 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaLEV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:29:11 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] uio/uio_pci_generic: don't return zero on failure path in probe()
Date: Sat,  6 Dec 2014 00:28:01 +0300
Message-Id: <1417814881-4684-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If uio_register_device() fails in probe(), it breaks off initialization,
deallocates all resources, but returns zero.

The patch adds proper error code propagation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/uio/uio_pci_generic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 077ae12269ce..d0b508b68f3c 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -91,7 +91,8 @@ static int probe(struct pci_dev *pdev,
 	gdev->info.handler = irqhandler;
 	gdev->pdev = pdev;
 
-	if (uio_register_device(&pdev->dev, &gdev->info))
+	err = uio_register_device(&pdev->dev, &gdev->info);
+	if (err)
 		goto err_register;
 	pci_set_drvdata(pdev, gdev);
 
-- 
1.9.1

