Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaIZJqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbaIZJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/142] xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
Date: Fri, 26 Sep 2014 11:43:51 +0200
Message-Id: <12434db6ddb3f56ecc025fb3f75744b385c82c4e.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6118e292d5df..46ad9f3f589d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2579,7 +2579,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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
2.1.0

