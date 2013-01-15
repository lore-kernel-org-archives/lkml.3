Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3APAAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:00:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:43597 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab3AOWf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 179/221] xhci: Handle HS bulk/ctrl endpoints that dont NAK.
Date: Tue, 15 Jan 2013 10:51:46 -0800
Message-Id: <20130115185010.947557902@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1250,6 +1250,8 @@ static unsigned int xhci_microframes_to_
 static unsigned int xhci_parse_microframe_interval(struct usb_device *udev,
 		struct usb_host_endpoint *ep)
 {
+	if (ep->desc.bInterval == 0)
+		return 0;
 	return xhci_microframes_to_exponent(udev, ep,
 			ep->desc.bInterval, 0, 15);
 }


