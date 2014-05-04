Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaEDPvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:51:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbaEDPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 3.4 15/43] USB: fix crash during hotplug of PCI USB controller card
Date: Sun,  4 May 2014 11:42:09 -0400
Message-Id: <20140504154226.317808760@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hcd-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -71,7 +71,7 @@ static void companion_common(struct pci_
 			continue;
 
 		companion_hcd = pci_get_drvdata(companion);
-		if (!companion_hcd)
+		if (!companion_hcd || !companion_hcd->self.root_hub)
 			continue;
 
 		/* For SET_HS_COMPANION, store a pointer to the EHCI bus in


