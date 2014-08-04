Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHDQ7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56585 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "ShiChun Ma" <masc2008@qq.com>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.907082447@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 09/94] xhci: correct burst count field for isoc
 transfers on 1.0 xhci hosts
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 3213b151387df0b95f4eada104f68eb1c1409cb3 upstream.

The transfer burst count (TBC) field in xhci 1.0 hosts should be set
to the number of bursts needed to transfer all packets in a isoc TD.
Supported values are 0-2 (1 to 3 bursts per service interval).

Formula for TBC calculation is given in xhci spec section 4.11.2.3:
TBC = roundup( Transfer Descriptor Packet Count / Max Burst Size +1 ) - 1

This patch should be applied to stable kernels since 3.0 that contain
the commit 5cd43e33b9519143f06f507dd7cbee6b7a621885
"xhci 1.0: Set transfer burst count field."

Suggested-by: ShiChun Ma <masc2008@qq.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3521,7 +3521,7 @@ static unsigned int xhci_get_burst_count
 		return 0;
 
 	max_burst = urb->ep->ss_ep_comp.bMaxBurst;
-	return roundup(total_packet_count, max_burst + 1) - 1;
+	return DIV_ROUND_UP(total_packet_count, max_burst + 1) - 1;
 }
 
 /*

