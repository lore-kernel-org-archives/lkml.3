Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaAJACg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:02:36 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55466 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbaAJACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:02:34 -0500
Date: Thu, 9 Jan 2014 16:02:33 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>, Andy King <acking@vmware.com>
Subject: [PATCH] VMCI: fix error handling path when registering guest driver
Message-ID: <20140110000232.GA16959@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When host capabilities check failed or when we were unable to register doorbell
bitmap we were forgetting to set error code and were returning 0 which would
make upper layers believe that probe was successful.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Andy King <acking@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_guest.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index c98b03b..d35cda0 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -165,7 +165,7 @@ static void vmci_guest_cid_update(u32 sub_id,
  * true if required hypercalls (or fallback hypercalls) are
  * supported by the host, false otherwise.
  */
-static bool vmci_check_host_caps(struct pci_dev *pdev)
+static int vmci_check_host_caps(struct pci_dev *pdev)
 {
 	bool result;
 	struct vmci_resource_query_msg *msg;
@@ -176,7 +176,7 @@ static bool vmci_check_host_caps(struct pci_dev *pdev)
 	check_msg = kmalloc(msg_size, GFP_KERNEL);
 	if (!check_msg) {
 		dev_err(&pdev->dev, "%s: Insufficient memory\n", __func__);
-		return false;
+		return -ENOMEM;
 	}
 
 	check_msg->dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
@@ -196,7 +196,7 @@ static bool vmci_check_host_caps(struct pci_dev *pdev)
 		__func__, result ? "PASSED" : "FAILED");
 
 	/* We need the vector. There are no fallbacks. */
-	return result;
+	return result ? 0 : -ENXIO;
 }
 
 /*
@@ -564,12 +564,14 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 			dev_warn(&pdev->dev,
 				 "VMCI device unable to register notification bitmap with PPN 0x%x\n",
 				 (u32) bitmap_ppn);
+			error = -ENXIO;
 			goto err_remove_vmci_dev_g;
 		}
 	}
 
 	/* Check host capabilities. */
-	if (!vmci_check_host_caps(pdev))
+	error = vmci_check_host_caps(pdev);
+	if (error)
 		goto err_remove_bitmap;
 
 	/* Enable device. */
