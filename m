Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3ILFow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:44:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3ILFko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:44 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=lyqGQGGjdEcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Id4X90VWJEYA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=x2szoZtqnggA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042906.773929301@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roger Quadros <rogerq@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [087/251] USB: EHCI: Fix resume signalling on remote wakeup
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0087-USB-EHCI-Fix-resume-signalling-on-remote-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit 47a64a13d54f6c669b00542848d5550be3d3310e ]

Set the ehci->resuming flag for the port we receive a remote
wakeup on so that resume signalling can be completed.

Without this, the root hub timer will not fire again to check
if the resume was completed and there will be a never-ending wait on
on the port.

This effect is only observed if the HUB IRQ IN does not come after we
have initiated the port resume.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/ehci-hub.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index c788022..20a6b75 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -830,6 +830,7 @@ static int ehci_hub_control (
 				/* resume signaling for 20 msec */
 				ehci->reset_done[wIndex] = jiffies
 						+ msecs_to_jiffies(20);
+				set_bit(wIndex, &ehci->resuming_ports);
 				/* check the port again */
 				mod_timer(&ehci_to_hcd(ehci)->rh_timer,
 						ehci->reset_done[wIndex]);
-- 
1.7.10.4


