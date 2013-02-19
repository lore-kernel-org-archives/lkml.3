Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab3BSSud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:50:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54163 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3BSSuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 08/81] USB: EHCI: fix timer bug affecting port resume
Date: Tue, 19 Feb 2013 15:48:31 -0300
Message-Id: <1361299784-8830-9-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/ehci-hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index fc9e7cc..349d3fe 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -613,7 +613,11 @@ ehci_hub_status_data (struct usb_hcd *hcd, char *buf)
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
-- 
1.7.9.5

