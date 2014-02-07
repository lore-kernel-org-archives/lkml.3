Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaBGMDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:03:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaBGLwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aristeu Rozanski <aris@redhat.com>, Borislav Petkov <bp@suse.de>,
        Jean Delvare <jdelvare@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 206/233] e752x_edac: Fix pci_dev usage count
Date: Fri,  7 Feb 2014 11:47:05 +0000
Message-Id: <1391773652-25214-207-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/e752x_edac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 644fec5..f1e9d7b 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1182,9 +1182,11 @@ static int e752x_get_devs(struct pci_dev *pdev, int dev_idx,
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
-- 
1.8.3.2

