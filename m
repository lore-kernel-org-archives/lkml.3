Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3FDRNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:13:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 13/75] USB: UHCI: fix for suspend of virtual HP controller
Date: Tue,  4 Jun 2013 09:54:57 -0700
Message-Id: <1370364959-9475-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/uhci-hub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 15d1322..eda1f2e 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -225,7 +225,8 @@ static int uhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 
-- 
1.8.1.2

