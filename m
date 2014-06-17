Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033AbaFQRCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:02:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbaFQQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 017/121] USB: fix crash during hotplug of PCI USB controller card
Date: Tue, 17 Jun 2014 09:13:30 -0700
Message-Id: <1403021714-16320-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
index 2b487d4..50ebe6c 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -71,7 +71,7 @@ static void companion_common(struct pci_dev *pdev, struct usb_hcd *hcd,
 			continue;
 
 		companion_hcd = pci_get_drvdata(companion);
-		if (!companion_hcd)
+		if (!companion_hcd || !companion_hcd->self.root_hub)
 			continue;
 
 		/* For SET_HS_COMPANION, store a pointer to the EHCI bus in
-- 
1.9.1

