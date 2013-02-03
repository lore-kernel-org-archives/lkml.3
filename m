Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3BCP1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:27:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604Ab3BCOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:41 -0500
Message-Id: <20130203144644.478432526@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 005/128] xhci: Handle HS bulk/ctrl endpoints that dont NAK.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 55c1945edaac94c5338a3647bc2e85ff75d9cf36 upstream.

A high speed control or bulk endpoint may have bInterval set to zero,
which means it does not NAK.  If bInterval is non-zero, it means the
endpoint NAKs at a rate of 2^(bInterval - 1).

The xHCI code to compute the NAK interval does not handle the special
case of zero properly.  The current code unconditionally subtracts one
from bInterval and uses it as an exponent.  This causes a very large
bInterval to be used, and warning messages like these will be printed:

usb 1-1: ep 0x1 - rounding interval to 32768 microframes, ep desc says 0 microframes

This may cause the xHCI host hardware to reject the Configure Endpoint
command, which means the HS device will be unusable under xHCI ports.

This patch should be backported to kernels as old as 2.6.31, that contain
commit dfa49c4ad120a784ef1ff0717168aa79f55a483a "USB: xhci - fix math in
xhci_get_endpoint_interval()".

Reported-by: Vincent Pelletier <plr.vincent@gmail.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fb51c70..35616ff 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1250,6 +1250,8 @@ static unsigned int xhci_microframes_to_exponent(struct usb_device *udev,
 static unsigned int xhci_parse_microframe_interval(struct usb_device *udev,
 		struct usb_host_endpoint *ep)
 {
+	if (ep->desc.bInterval == 0)
+		return 0;
 	return xhci_microframes_to_exponent(udev, ep,
 			ep->desc.bInterval, 0, 15);
 }


