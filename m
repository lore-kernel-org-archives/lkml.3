Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682AbaH0S5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:57:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933833AbaH0S5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:57:39 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] drm: Test for PCI root bus to avoid NULL pointer dereference
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Date: Wed, 27 Aug 2014 12:57:33 -0600
Message-ID: <20140827185651.29388.16082.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a GPU on the PCI root bus that calls
drm_pcie_get_speed_cap_mask() we end up with a NULL pointer
dereference since pdev->bus->self is NULL.  We already protect
against callers passing non-PCI devices, so let's also catch this
case and return -EINVAL.

Root complex graphics are not terribly likely outside of IGD, but
when we assign a standard plugin GPU to a virtual machine, our
assumption that we have a parent device quickly becomes invalid.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/gpu/drm/drm_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 020cfd9..411e806 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -390,7 +390,7 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
 	u32 lnkcap, lnkcap2;
 
 	*mask = 0;
-	if (!dev->pdev)
+	if (!dev->pdev || pci_is_root_bus(dev->pdev->bus))
 		return -EINVAL;
 
 	root = dev->pdev->bus->self;

