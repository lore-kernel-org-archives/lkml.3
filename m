Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3BQXLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:11:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45592 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535Ab3BQWy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:58 -0500
Message-Id: <20130217225003.083385422@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 12/66] USB: EHCI: fix bug in scheduling periodic split transfers
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3e619d04159be54b3daa0b7036b0ce9e067f4b5d upstream.

This patch (as1654) fixes a very old bug in ehci-hcd, connected with
scheduling of periodic split transfers.  The calculations for
full/low-speed bus usage are all carried out after the correction for
bit-stuffing has been applied, but the values in the max_tt_usecs
array assume it hasn't been.  The array should allow for allocation of
up to 90% of the bus capacity, which is 900 us, not 780 us.

The symptom caused by this bug is that any isochronous transfer to a
full-speed device with a maxpacket size larger than about 980 bytes is
always rejected with a -ENOSPC error.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 2b6917d..b476daf 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -213,7 +213,7 @@ static inline unsigned char tt_start_uframe(struct ehci_hcd *ehci, __hc32 mask)
 }
 
 static const unsigned char
-max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 30, 0 };
+max_tt_usecs[] = { 125, 125, 125, 125, 125, 125, 125, 25 };
 
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])


