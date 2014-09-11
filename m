Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaIKNAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.896282859@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 077/131] xhci: Treat not finding the event_seg on
 COMP_STOP the same as COMP_STOP_INVAL
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2433,7 +2433,8 @@ static int handle_tx_event(struct xhci_h
 		 * last TRB of the previous TD. The command completion handle
 		 * will take care the rest.
 		 */
-		if (!event_seg && trb_comp_code == COMP_STOP_INVAL) {
+		if (!event_seg && (trb_comp_code == COMP_STOP ||
+				   trb_comp_code == COMP_STOP_INVAL)) {
 			ret = 0;
 			goto cleanup;
 		}

