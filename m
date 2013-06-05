Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3FEVB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:01:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658Ab3FEUxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 11/33] USB: UHCI: fix for suspend of virtual HP controller
Date: Wed,  5 Jun 2013 13:52:49 -0700
Message-Id: <20130605204705.008708414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 


