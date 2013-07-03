Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3GCS7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:59:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130Ab3GCSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:48 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=M2X0cg7vQ44A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8F504AwDmlIA:10 a=cH6R9-kdAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=bt0zGP92IBIA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=FpPCvutuz0mlo6cx:21 a=NJ616faCBnhfs8Wk:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184046.777672478@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [013/141] USB: UHCI: fix for suspend of virtual HP controller
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0013-USB-UHCI-fix-for-suspend-of-virtual-HP-controller.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 997ff893603c6455da4c5e26ba1d0f81adfecdfc ]

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
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/uhci-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 768d542..c994655 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -222,7 +222,8 @@ static int uhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		/* auto-stop if nothing connected for 1 second */
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
-		else if (time_after_eq(jiffies, uhci->auto_stop_time))
+		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
+				!uhci->wait_for_hp)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 
-- 
1.7.10.4


