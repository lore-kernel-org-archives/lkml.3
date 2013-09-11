Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3IKOh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:37:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3IKOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:37:56 -0400
Date: Wed, 11 Sep 2013 17:36:29 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [117/251] radeon kms: do not flush uninitialized hotplug work
Message-ID: <20130911143629.GB2209@swordfish.minsk.epam.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042911.752089217@goodmis.org>
 <20130911090648.GA2271@swordfish.minsk.epam.com>
 <20130911083741.6b2783b2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911083741.6b2783b2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one on top of stable 3.6.11 git.
Thank you, Steven.

---

[ Upstream commit 27c505ca84e164ec66ad55dcf3f5befaac83f10a ]

Commit a01c34f72e7cd2624570818f579b5ab464f93de2 (radeon kms: do not
flush uninitialized hotplug work) moved work initialisation phase to
the last step of radeon_irq_kms_init(). Meelis Roos reported that this
causes problems on his machine because drm_irq_install() uses hotplug
work on r100.

hotplug work flushed in radeon_irq_kms_fini(), with two possible cases:
-- radeon_irq_kms_fini() call after successful radeon_irq_kms_init()
-- radeon_irq_kms_fini() call after unsuccessful (or not called at all)
   radeon_irq_kms_init()

The latter one causes flush work on uninitialised hotplug work. Move
work initialisation before drm_irq_install(), but keep existing agreement
to flush hotplug work in radeon_irq_kms_fini() only for `irq.installed'
(successful radeon_irq_kms_init()) case.

WARNING: CPU: 0 PID: 243 at kernel/workqueue.c:1378 __queue_work+0x132/0x16d()
Call Trace:
[<c12319b3>] ? dump_stack+0xa/0x13
[<c1022600>] ? warn_slowpath_common+0x75/0x8a
[<c1031010>] ? __queue_work+0x132/0x16d
[<c1031010>] ? __queue_work+0x132/0x16d
[<c102269e>] ? warn_slowpath_null+0x1b/0x1f
[<c1031010>] ? __queue_work+0x132/0x16d
[<c103107b>] ? queue_work_on+0x30/0x40
[<f8aed3f3>] ? r100_irq_process+0x16d/0x1e6 [radeon]
[<f8ae77cf>] ? radeon_driver_irq_preinstall_kms+0xc2/0xc5 [radeon]
[<f8974d77>] ? drm_irq_install+0xb2/0x1ac [drm]
[<f897604d>] ? drm_vblank_init+0x196/0x1d2 [drm]
[<f8ae78d3>] ? radeon_irq_kms_init+0x33/0xc6 [radeon]
[<f8aef35a>] ? r100_startup+0x1a3/0x1d6 [radeon]
[<f8ad77c8>] ? radeon_ttm_init+0x26e/0x287 [radeon]
[<f8aef752>] ? r100_init+0x2b3/0x309 [radeon]
[<c118082e>] ? vga_client_register+0x39/0x40
[<f8ac535f>] ? radeon_device_init+0x54b/0x61b [radeon]
[<f8ac40fd>] ? cail_mc_write+0x13/0x13 [radeon]
[<f8ac6864>] ? radeon_driver_load_kms+0x82/0xda [radeon]
[<f8978bbd>] ? drm_get_pci_dev+0x136/0x22d [drm]
[<f8ac409b>] ? radeon_pci_probe+0x6c/0x86 [radeon]
[<c112acf6>] ? pci_device_probe+0x4c/0x83
[<c11846c7>] ? driver_probe_device+0x80/0x184
[<c112a848>] ? pci_match_id+0x18/0x36
[<c1184837>] ? __driver_attach+0x44/0x5f
[<c11833f4>] ? bus_for_each_dev+0x50/0x5a
[<c118433e>] ? driver_attach+0x14/0x16
[<c11847f3>] ? __device_attach+0x28/0x28
[<c1184045>] ? bus_add_driver+0xd6/0x1bf
[<c1184c22>] ? driver_register+0x78/0xcf
[<f8ba8000>] ? 0xf8ba7fff
[<c10003bf>] ? do_one_initcall+0x8b/0x121
[<c101e668>] ? change_page_attr_clear+0x2e/0x33
[<f8ba8000>] ? 0xf8ba7fff
[<c101e689>] ? set_memory_ro+0x1c/0x20
[<c104de94>] ? set_page_attributes+0x11/0x12
[<c104f6e1>] ? load_module+0x12fa/0x17e8
[<c107483b>] ? map_vm_area+0x22/0x31
[<c104fc36>] ? SyS_init_module+0x67/0x7d
[<c1234245>] ? sysenter_do_call+0x12/0x26

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/gpu/drm/radeon/radeon_irq_kms.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
index 443bd49..6be5d6b 100644
--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -243,9 +243,6 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 {
 	int r = 0;
 
-	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
-	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
-
 	spin_lock_init(&rdev->irq.lock);
 	r = drm_vblank_init(rdev->ddev, rdev->num_crtc);
 	if (r) {
@@ -261,10 +258,15 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
 			dev_info(rdev->dev, "radeon: using MSI.\n");
 		}
 	}
+
+	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
+	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
+
 	rdev->irq.installed = true;
 	r = drm_irq_install(rdev->ddev);
 	if (r) {
 		rdev->irq.installed = false;
+		flush_work(&rdev->hotplug_work);
 		return r;
 	}
 	DRM_INFO("radeon: irq initialized.\n");
@@ -286,8 +288,8 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
 		rdev->irq.installed = false;
 		if (rdev->msi_enabled)
 			pci_disable_msi(rdev->pdev);
+		flush_work_sync(&rdev->hotplug_work);
 	}
-	flush_work_sync(&rdev->hotplug_work);
 }
 
 /**

