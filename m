Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaFJTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaFJTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 030/160] USB: fix crash during hotplug of PCI USB controller card
Date: Tue, 10 Jun 2014 12:44:30 -0700
Message-Id: <1402429600-20477-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a2ff864b53eac9a0e9b05bfe9d1781ccd6c2af71 upstream.

The code in hcd-pci.c that matches up EHCI controllers with their
companion UHCI or OHCI controllers assumes that the private drvdata
fields don't get set too early.  However, it turns out that this field
gets set by usb_create_hcd(), before hcd-pci expects it, and this can
result in a crash when two controllers are probed in parallel (as can
happen when a new controller card is hotplugged).

The companions_rwsem lock was supposed to prevent this sort of thing,
but usb_create_hcd() is called outside the scope of the rwsem.

A simple solution is to check that the root-hub pointer has been
initialized as well as the drvdata field.  This doesn't happen until
usb_add_hcd() is called; that call and the check are both protected by
the rwsem.

This patch should be applied to stable kernels from 3.10 onward.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Stefani Seibold <stefani@seibold.net>
Tested-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/hcd-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index dfe9d0f..36ac1ae 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -75,7 +75,7 @@ static void for_each_companion(struct pci_dev *pdev, struct usb_hcd *hcd,
 				PCI_SLOT(companion->devfn) != slot)
 			continue;
 		companion_hcd = pci_get_drvdata(companion);
-		if (!companion_hcd)
+		if (!companion_hcd || !companion_hcd->self.root_hub)
 			continue;
 		fn(pdev, hcd, companion, companion_hcd);
 	}
-- 
1.9.1

