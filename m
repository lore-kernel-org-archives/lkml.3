Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaIWCjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:39:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:38235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaIWCjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:39:36 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 23/45] xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
Date: Tue, 23 Sep 2014 10:31:25 +0800
Message-Id: <1411439507-30391-23-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 9a54886342e227433aebc9d374f8ae268a836475 upstream.

When using a Renesas uPD720231 chipset usb-3 uas to sata bridge with a 120G
Crucial M500 ssd, model string: Crucial_ CT120M500SSD1, together with a
the integrated Intel xhci controller on a Haswell laptop:

00:14.0 USB controller [0c03]: Intel Corporation 8 Series USB xHCI HC [8086:9c31] (rev 04)

The following error gets logged to dmesg:

xhci error: Transfer event TRB DMA ptr not part of current TD

Treating COMP_STOP the same as COMP_STOP_INVAL when no event_seg gets found
fixes this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6f1b36d..95e8648 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2528,7 +2528,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * last TRB of the previous TD. The command completion handle
 		 * will take care the rest.
 		 */
-		if (!event_seg && trb_comp_code == COMP_STOP_INVAL) {
+		if (!event_seg && (trb_comp_code == COMP_STOP ||
+				   trb_comp_code == COMP_STOP_INVAL)) {
 			ret = 0;
 			goto cleanup;
 		}
-- 
1.7.9.5

