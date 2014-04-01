Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaDALQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaDALQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/144] drm/i915: fix pch pci device enumeration
Date: Tue,  1 Apr 2014 12:13:53 +0100
Message-Id: <1396350948-29910-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit bcdb72ac7c00d2b56359fc82bcc8fe50454717d5 upstream.

pci_get_class(class, from) drops the refcount for 'from', so the
extra pci_dev_put we do on it will result in a use after free bug
starting with the WARN below.

Regression introduced in

commit 6a9c4b35e6696a63805b6da5e4889c6986e9ee1b
Author: Rui Guo <firemeteor@users.sourceforge.net>
Date:   Wed Jun 19 21:10:23 2013 +0800

    drm/i915: Fix PCH detect with multiple ISA bridges in VM

[  164.338460] WARNING: CPU: 1 PID: 2094 at include/linux/kref.h:47 klist_next+0xae/0x110()
[  164.347731] CPU: 1 PID: 2094 Comm: modprobe Tainted: G           O 3.13.0-imre+ #354
[  164.356468] Hardware name: Intel Corp. VALLEYVIEW B0 PLATFORM/NOTEBOOK, BIOS BYTICRB1.X64.0062.R70.1310112051 10/11/2013
[  164.368796] Call Trace:
[  164.371609]  [<ffffffff816a32a6>] dump_stack+0x4e/0x7a
[  164.377447]  [<ffffffff8104f75d>] warn_slowpath_common+0x7d/0xa0
[  164.384238]  [<ffffffff8104f83a>] warn_slowpath_null+0x1a/0x20
[  164.390851]  [<ffffffff8169aeae>] klist_next+0xae/0x110
[  164.396777]  [<ffffffff8130a110>] ? pci_do_find_bus+0x70/0x70
[  164.403286]  [<ffffffff813cb4a9>] bus_find_device+0x89/0xc0
[  164.409719]  [<ffffffff8130a373>] pci_get_dev_by_id+0x63/0xa0
[  164.416238]  [<ffffffff8130a4e4>] pci_get_class+0x44/0x50
[  164.422433]  [<ffffffffa034821f>] intel_dsm_detect+0x16f/0x1f0 [i915]
[  164.429801]  [<ffffffffa03482ae>] intel_register_dsm_handler+0xe/0x10 [i915]
[  164.437831]  [<ffffffffa02d30fe>] i915_driver_load+0xafe/0xf30 [i915]
[  164.445126]  [<ffffffff8158a150>] ? intel_alloc_coherent+0x110/0x110
[  164.452340]  [<ffffffffa0148c07>] drm_dev_register+0xc7/0x150 [drm]
[  164.459462]  [<ffffffffa014b23f>] drm_get_pci_dev+0x11f/0x1f0 [drm]
[  164.466554]  [<ffffffff816abb81>] ? _raw_spin_unlock_irqrestore+0x51/0x70
[  164.474287]  [<ffffffffa02cf7a6>] i915_pci_probe+0x56/0x60 [i915]
[  164.481185]  [<ffffffff8130a028>] pci_device_probe+0x78/0xf0
[  164.487603]  [<ffffffff813cd495>] driver_probe_device+0x155/0x350
[  164.494505]  [<ffffffff813cd74e>] __driver_attach+0x6e/0xa0
[  164.500826]  [<ffffffff813cd6e0>] ? __device_attach+0x50/0x50
[  164.507333]  [<ffffffff813cb2be>] bus_for_each_dev+0x6e/0xc0
[  164.513752]  [<ffffffff813ccefe>] driver_attach+0x1e/0x20
[  164.519870]  [<ffffffff813cc958>] bus_add_driver+0x138/0x260
[  164.526289]  [<ffffffffa0188000>] ? 0xffffffffa0187fff
[  164.532116]  [<ffffffff813cde78>] driver_register+0x98/0xe0
[  164.538558]  [<ffffffffa0188000>] ? 0xffffffffa0187fff
[  164.544389]  [<ffffffff813087b0>] __pci_register_driver+0x60/0x70
[  164.551336]  [<ffffffffa014b37d>] drm_pci_init+0x6d/0x120 [drm]
[  164.558040]  [<ffffffffa0188000>] ? 0xffffffffa0187fff
[  164.563928]  [<ffffffffa018806a>] i915_init+0x6a/0x6c [i915]
[  164.570363]  [<ffffffff810002da>] do_one_initcall+0xaa/0x160
[  164.576783]  [<ffffffff8103b140>] ? set_memory_nx+0x40/0x50
[  164.583100]  [<ffffffff810ce7f5>] load_module+0x1fb5/0x2550
[  164.589410]  [<ffffffff810caab0>] ? store_uevent+0x40/0x40
[  164.595628]  [<ffffffff810cee7d>] SyS_init_module+0xed/0x100
[  164.602048]  [<ffffffff816b3c52>] system_call_fastpath+0x16/0x1b

v2: simplify the loop further (Chris)

Signed-off-by: Imre Deak <imre.deak@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Reported-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65652
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=74161
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 9180fde..61684db 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -450,7 +450,7 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 void intel_detect_pch(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct pci_dev *pch;
+	struct pci_dev *pch = NULL;
 
 	/* In all current cases, num_pipes is equivalent to the PCH_NOP setting
 	 * (which really amounts to a PCH but no South Display).
@@ -471,12 +471,9 @@ void intel_detect_pch(struct drm_device *dev)
 	 * all the ISA bridge devices and check for the first match, instead
 	 * of only checking the first one.
 	 */
-	pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, NULL);
-	while (pch) {
-		struct pci_dev *curr = pch;
+	while ((pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, pch))) {
 		if (pch->vendor == PCI_VENDOR_ID_INTEL) {
-			unsigned short id;
-			id = pch->device & INTEL_PCH_DEVICE_ID_MASK;
+			unsigned short id = pch->device & INTEL_PCH_DEVICE_ID_MASK;
 			dev_priv->pch_id = id;
 
 			if (id == INTEL_PCH_IBX_DEVICE_ID_TYPE) {
@@ -502,18 +499,16 @@ void intel_detect_pch(struct drm_device *dev)
 				DRM_DEBUG_KMS("Found LynxPoint LP PCH\n");
 				WARN_ON(!IS_HASWELL(dev));
 				WARN_ON(!IS_ULT(dev));
-			} else {
-				goto check_next;
-			}
-			pci_dev_put(pch);
+			} else
+				continue;
+
 			break;
 		}
-check_next:
-		pch = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, curr);
-		pci_dev_put(curr);
 	}
 	if (!pch)
-		DRM_DEBUG_KMS("No PCH found?\n");
+		DRM_DEBUG_KMS("No PCH found.\n");
+
+	pci_dev_put(pch);
 }
 
 bool i915_semaphore_is_enabled(struct drm_device *dev)
-- 
1.9.1

