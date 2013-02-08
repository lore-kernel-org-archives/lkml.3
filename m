Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3BHBQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:16:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3BHA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Ming Lei <ming.lei@canonical.com>
Subject: [ 25/34] USB: EHCI: fix timer bug affecting port resume
Date: Thu,  7 Feb 2013 16:57:21 -0800
Message-Id: <20130208004631.401466668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ee74290b7853db9d5fd64db70e5c175241c59fba upstream.

This patch (as1652) fixes a long-standing bug in ehci-hcd.  The driver
relies on status polls to know when to stop port-resume signalling.
It uses the root-hub status timer to schedule these status polls.  But
when the driver for the root hub is resumed, the timer is rescheduled
to go off immediately -- before the port is ready.  When this happens
the timer does not get re-enabled, which prevents the port resume from
finishing until some other event occurs.

The symptom is that when a new device is plugged in, it doesn't get
recognized or enumerated until lsusb is run or something else happens.

The solution is to re-enable the root-hub status timer after every
status poll while a port resume is in progress.

This bug hasn't surfaced before now because we never used to try to
suspend the root hub in the middle of a port resume (except by
coincidence).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Norbert Preining <preining@logic.at>
Tested-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -623,7 +623,11 @@ ehci_hub_status_data (struct usb_hcd *hc
 			status = STS_PCD;
 		}
 	}
-	/* FIXME autosuspend idle root hubs */
+
+	/* If a resume is in progress, make sure it can finish */
+	if (ehci->resuming_ports)
+		mod_timer(&hcd->rh_timer, jiffies + msecs_to_jiffies(25));
+
 	spin_unlock_irqrestore (&ehci->lock, flags);
 	return status ? retval : 0;
 }


