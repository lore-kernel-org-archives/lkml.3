Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbaBDVIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:08:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaBDVIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aristeu Rozanski <aris@redhat.com>, mark gross <mark.gross@intel.com>,
        Borislav Petkov <bp@suse.de>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 3.12 005/133] e752x_edac: Fix pci_dev usage count
Date: Tue,  4 Feb 2014 13:06:46 -0800
Message-Id: <20140204210737.171513931@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aristeu Rozanski <aris@redhat.com>

commit 90ed4988b8c030d65b41b7d13140e9376dc6ec5a upstream.

In case the device 0, function 1 is not found using pci_get_device(),
pci_scan_single_device() will be used but, differently than
pci_get_device(), it allocates a pci_dev but doesn't does bump the usage
count on the pci_dev and after few module removals and loads the pci_dev
will be freed.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Reviewed-by: mark gross <mark.gross@intel.com>
Link: http://lkml.kernel.org/r/20131205153755.GL4545@redhat.com
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/e752x_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1182,9 +1182,11 @@ static int e752x_get_devs(struct pci_dev
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
 				pvt->dev_info->err_dev, pvt->bridge_ck);
 
-	if (pvt->bridge_ck == NULL)
+	if (pvt->bridge_ck == NULL) {
 		pvt->bridge_ck = pci_scan_single_device(pdev->bus,
 							PCI_DEVFN(0, 1));
+		pci_dev_get(pvt->bridge_ck);
+	}
 
 	if (pvt->bridge_ck == NULL) {
 		e752x_printk(KERN_ERR, "error reporting device not found:"


