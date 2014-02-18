Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaBRX2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:28:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaBRWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 07/24] drm/i915: kick any firmware framebuffers before claiming the gtt
Date: Tue, 18 Feb 2014 14:46:54 -0800
Message-Id: <20140218224550.428188838@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9f846a16d213523fbe6daea17e20df6b8ac5a1e5 upstream.

Especially vesafb likes to map everything as uc- (yikes), and if that
mapping hangs around still while we try to map the gtt as wc the
kernel will downgrade our request to uc-, resulting in abyssal
performance.

Unfortunately we can't do this as early as readon does (i.e. as the
first thing we do when initializing the hw) because our fb/mmio space
region moves around on a per-gen basis. So I've had to move it below
the gtt initialization, but that seems to work, too. The important
thing is that we do this before we set up the gtt wc mapping.

Now an altogether different question is why people compile their
kernels with vesafb enabled, but I guess making things just work isn't
bad per se ...

v2:
- s/radeondrmfb/inteldrmfb/
- fix up error handling

v3: Kill #ifdef X86, this is Intel after all. Noticed by Ben Widawsky.

v4: Jani Nikula complained about the pointless bool primary
initialization.

v5: Don't oops if we can't allocate, noticed by Chris Wilson.

v6: Resolve conflicts with agp rework and fixup whitespace.

This is commit e188719a2891f01b3100d in drm-next.

Backport to 3.5 -fixes queue requested by Dave Airlie - due to grub
using vesa on fedora their initrd seems to load vesafb before loading
the real kms driver. So tons more people actually experience a
dead-slow gpu. Hence also the Cc: stable.

Reported-and-tested-by: "Kilarski, Bernard R" <bernard.r.kilarski@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/i915_dma.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1934,6 +1934,27 @@ ips_ping_for_i915_load(void)
 	}
 }
 
+static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
+{
+	struct apertures_struct *ap;
+	struct pci_dev *pdev = dev_priv->dev->pdev;
+	bool primary;
+
+	ap = alloc_apertures(1);
+	if (!ap)
+		return;
+
+	ap->ranges[0].base = dev_priv->dev->agp->base;
+	ap->ranges[0].size =
+		dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
+	primary =
+		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
+
+	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
+
+	kfree(ap);
+}
+
 /**
  * i915_driver_load - setup chip and create an initial config
  * @dev: DRM device
@@ -1971,6 +1992,15 @@ int i915_driver_load(struct drm_device *
 		goto free_priv;
 	}
 
+	dev_priv->mm.gtt = intel_gtt_get();
+	if (!dev_priv->mm.gtt) {
+		DRM_ERROR("Failed to initialize GTT\n");
+		ret = -ENODEV;
+		goto put_bridge;
+	}
+
+	i915_kick_out_firmware_fb(dev_priv);
+
 	pci_set_master(dev->pdev);
 
 	/* overlay on gen2 is broken and can't address above 1G */
@@ -1996,13 +2026,6 @@ int i915_driver_load(struct drm_device *
 		goto put_bridge;
 	}
 
-	dev_priv->mm.gtt = intel_gtt_get();
-	if (!dev_priv->mm.gtt) {
-		DRM_ERROR("Failed to initialize GTT\n");
-		ret = -ENODEV;
-		goto out_rmmap;
-	}
-
 	agp_size = dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
 
 	dev_priv->mm.gtt_mapping =


