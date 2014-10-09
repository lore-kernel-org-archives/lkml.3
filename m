Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaJIVKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:10:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbaJIVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/163] xhci: fix oops when xhci resumes from hibernate with hw lpm capable devices
Date: Thu,  9 Oct 2014 14:01:23 -0700
Message-Id: <1412888588-26755-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 96044694b8511bc2b04df0776b4ba295cfe005c0 upstream.

Resuming from hibernate (S4) will restart and re-initialize xHC.
The device contexts are freed and will be re-allocated later during device reset.

Usb core will disable link pm in device resume before device reset, which will
try to change the max exit latency, accessing the device contexts before they are re-allocated.

There is no need to zero (disable) the max exit latency when disabling hw lpm
for a freshly re-initialized xHC. So check that device context exists before
doing anything. The max exit latency will be set again after device reset when usb core
enables the link pm.

Reported-by: Imre Deak <imre.deak@intel.com>
Tested-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a879287..959e769 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3917,13 +3917,21 @@ static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
 	int ret;
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	if (max_exit_latency == xhci->devs[udev->slot_id]->current_mel) {
+
+	virt_dev = xhci->devs[udev->slot_id];
+
+	/*
+	 * virt_dev might not exists yet if xHC resumed from hibernate (S4) and
+	 * xHC was re-initialized. Exit latency will be set later after
+	 * hub_port_finish_reset() is done and xhci->devs[] are re-allocated
+	 */
+
+	if (!virt_dev || max_exit_latency == virt_dev->current_mel) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		return 0;
 	}
 
 	/* Attempt to issue an Evaluate Context command to change the MEL. */
-	virt_dev = xhci->devs[udev->slot_id];
 	command = xhci->lpm_command;
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
 	if (!ctrl_ctx) {
-- 
1.9.1

