Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaDGW3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbaDGW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:28:55 -0400
Subject: [PATCH 2/3] vfio/pci: Fix unchecked return value
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 07 Apr 2014 16:28:54 -0600
Message-ID: <20140407222854.12761.65543.stgit@bling.home>
In-Reply-To: <20140407221857.12761.73684.stgit@bling.home>
References: <20140407221857.12761.73684.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's nothing we can do different if pci_load_and_free_saved_state()
fails, other than maybe print some log message, but the actual re-load
of the state is an unnecessary step here since we've only just saved
it.  We can cleanup a coverity warning and eliminate the unnecessary
stop by freeing the state ourselves.

Detected by Coverity: CID 753101

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7ba0424..85063f1 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -57,7 +57,8 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 
 	ret = vfio_config_init(vdev);
 	if (ret) {
-		pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state);
+		kfree(vdev->pci_saved_state);
+		vdev->pci_saved_state = NULL;
 		pci_disable_device(pdev);
 		return ret;
 	}

