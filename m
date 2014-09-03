Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbaICWP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:15:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbaICWP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.14 74/88] xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
Date: Wed,  3 Sep 2014 15:05:48 -0700
Message-Id: <20140903220518.168241352@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2612,7 +2612,8 @@ static int handle_tx_event(struct xhci_h
 		 * last TRB of the previous TD. The command completion handle
 		 * will take care the rest.
 		 */
-		if (!event_seg && trb_comp_code == COMP_STOP_INVAL) {
+		if (!event_seg && (trb_comp_code == COMP_STOP ||
+				   trb_comp_code == COMP_STOP_INVAL)) {
 			ret = 0;
 			goto cleanup;
 		}


