Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbbAYS72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:59:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbbAYSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.18 032/183] drm/dp-mst: Remove branches before dropping the reference
Date: Sun, 25 Jan 2015 10:05:54 -0800
Message-Id: <20150125180811.560979452@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0391359ddf79b52bb7e7bb9ace08e34fb08b0e76 upstream.

When we unplug a dp mst branch we unreference the entire tree from
the root towards the leaves. Which is ok, since that's the way the
pointers and so also the refcounts go.

But when we drop the reference we must make sure that we remove the
branches/ports from the lists/pointers before dropping the reference.
Otherwise the get_validated functions will still return it instead
of returning NULL (which indicates a potentially on-going unplug).

The mst branch destroy gets this right for ports: First it deletes
the port from the ports list, then it unrefs. But the ports destroy
function gets it wrong: First it unrefs, then it drops the ref. Which
means a zombie mst branch can still be validate with get_validated_mstb_ref
when it shouldn't.

Fix this.

This should address a backtrace Dave dug out somewhere on unplug:

 [<ffffffffa00cc262>] drm_dp_mst_get_validated_mstb_ref_locked+0x92/0xa0 [drm_kms_helper]
 [<ffffffffa00cc211>] drm_dp_mst_get_validated_mstb_ref_locked+0x41/0xa0 [drm_kms_helper]
 [<ffffffffa00cc2aa>] drm_dp_get_validated_mstb_ref+0x3a/0x60 [drm_kms_helper]
 [<ffffffffa00cc2fb>] drm_dp_payload_send_msg.isra.14+0x2b/0x100 [drm_kms_helper]
 [<ffffffffa00cc547>] drm_dp_update_payload_part1+0x177/0x360 [drm_kms_helper]
 [<ffffffffa015c52e>] intel_mst_disable_dp+0x3e/0x80 [i915]
 [<ffffffffa013d60b>] haswell_crtc_disable+0x1cb/0x340 [i915]
 [<ffffffffa0136739>] intel_crtc_control+0x49/0x100 [i915]
 [<ffffffffa0136857>] intel_crtc_update_dpms+0x67/0x80 [i915]
 [<ffffffffa013fa59>] intel_connector_dpms+0x59/0x70 [i915]
 [<ffffffffa015c752>] intel_dp_destroy_mst_connector+0x32/0xc0 [i915]
 [<ffffffffa00cb44b>] drm_dp_destroy_port+0x6b/0xa0 [drm_kms_helper]
 [<ffffffffa00cb588>] drm_dp_destroy_mst_branch_device+0x108/0x130 [drm_kms_helper]
 [<ffffffffa00cb3cd>] drm_dp_port_teardown_pdt+0x3d/0x50 [drm_kms_helper]
 [<ffffffffa00cdb79>] drm_dp_mst_handle_up_req+0x499/0x540 [drm_kms_helper]
 [<ffffffff810d9ead>] ? trace_hardirqs_on_caller+0x15d/0x200 [<ffffffffa00cdc73>]
 drm_dp_mst_hpd_irq+0x53/0xa00 [drm_kms_helper] [<ffffffffa00c7dfb>]
 ? drm_dp_dpcd_read+0x1b/0x20 [drm_kms_helper] [<ffffffffa0153ed8>]
 ? intel_dp_dpcd_read_wake+0x38/0x70 [i915] [<ffffffffa015a225>]
 intel_dp_check_mst_status+0xb5/0x250 [i915] [<ffffffffa015ac71>]
 intel_dp_hpd_pulse+0x181/0x210 [i915] [<ffffffffa01104f6>]
 i915_digport_work_func+0x96/0x120 [i915]

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -839,6 +839,8 @@ static void drm_dp_put_mst_branch_device
 
 static void drm_dp_port_teardown_pdt(struct drm_dp_mst_port *port, int old_pdt)
 {
+	struct drm_dp_mst_branch *mstb;
+
 	switch (old_pdt) {
 	case DP_PEER_DEVICE_DP_LEGACY_CONV:
 	case DP_PEER_DEVICE_SST_SINK:
@@ -846,8 +848,9 @@ static void drm_dp_port_teardown_pdt(str
 		drm_dp_mst_unregister_i2c_bus(&port->aux);
 		break;
 	case DP_PEER_DEVICE_MST_BRANCHING:
-		drm_dp_put_mst_branch_device(port->mstb);
+		mstb = port->mstb;
 		port->mstb = NULL;
+		drm_dp_put_mst_branch_device(mstb);
 		break;
 	}
 }


