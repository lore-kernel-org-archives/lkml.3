Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab3E1Dzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758844Ab3E1DyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.43804019@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [38/94] USB: UHCI: fix for suspend of virtual HP controller
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 997ff893603c6455da4c5e26ba1d0f81adfecdfc upstream.

HP's virtual UHCI host controller takes a long time to suspend
(several hundred microseconds), even when no devices are attached.
This provokes a warning message from uhci-hcd in the auto-stop case.

To prevent this from happening, this patch adds a test to avoid
performing an auto-stop when the wait_for_hp quirk flag is set.  The
controller will still suspend through the normal runtime PM mechanism.
And since that pathway includes a 1-ms delay, the slowness of the
virtual hardware won't matter.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: ZhenHua <zhen-hual@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/uhci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -221,7 +221,8 @@ static int uhci_hub_status_data(struct u
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 

