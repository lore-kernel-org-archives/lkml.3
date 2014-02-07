Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaBGLvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42262 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaBGLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 177/233] i915: remove pm_qos request on error
Date: Fri,  7 Feb 2014 11:46:36 +0000
Message-Id: <1391773652-25214-178-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 22accca01713b13dac386ca90b787aadf88f6551 upstream.

Not removing pm qos request and free memory for it can cause crash,
when some other driver use pm qos. For example, this oops:

BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff81307a6b>] plist_add+0x5b/0xd0
Call Trace:
 [<ffffffff810acf25>] pm_qos_update_target+0x125/0x1e0
 [<ffffffff810ad071>] pm_qos_add_request+0x91/0x100
 [<ffffffffa053ec14>] e1000_open+0xe4/0x5b0 [e1000e]

was caused by earlier i915 probe failure:

[drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000
[drm:i915_driver_load] *ERROR* failed to init modeset
i915: probe of 0000:00:02.0 failed with error -5

Bug report:
http://bugzilla.redhat.com/show_bug.cgi?id=1057533

Reported-by: Giandomenico De Tullio <ghisha@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
[danvet: Drop unnecessary code movement.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 0c956e9..58c3db8 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1675,6 +1675,7 @@ out_gem_unload:
 
 	intel_teardown_gmbus(dev);
 	intel_teardown_mchbar(dev);
+	pm_qos_remove_request(&dev_priv->pm_qos);
 	destroy_workqueue(dev_priv->wq);
 out_mtrrfree:
 	arch_phys_wc_del(dev_priv->mm.gtt_mtrr);
-- 
1.8.3.2

