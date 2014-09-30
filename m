Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaI3VjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaI3VjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/103] xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
Date: Tue, 30 Sep 2014 14:30:58 -0700
Message-Id: <1412112708-27356-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d0d906f..41deedb 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2626,7 +2626,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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
1.9.1

