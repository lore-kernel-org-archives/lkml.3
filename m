Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935986Ab3DKUtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:49:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935636Ab3DKUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:35 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T3VJgV-1P4gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=sucsabCD7F4A:10 a=9CtNJ4SuAAAA:8 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=JUWpGixzLPqpO7yirlEA:9 a=ticK52CwPBIA:10 a=_RhRFcbxBZMA:10 a=YPTUPuSgPjgA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202557.051548352@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Andreas Bombe <aeb@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 066/171 ] USB: EHCI: fix regression in QH unlinking
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0066-USB-EHCI-fix-regression-in-QH-unlinking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit d714aaf649460cbfd5e82e75520baa856b4fa0a0 ]

This patch (as1670) fixes a regression caused by commit
6402c796d3b4205d3d7296157956c5100a05d7d6 (USB: EHCI: work around
silicon bug in Intel's EHCI controllers).  The workaround goes through
two IAA cycles for each QH being unlinked.  During the first cycle,
the QH is not added to the async_iaa list (because it isn't fully gone
from the hardware yet), which means that list will be empty.

Unfortunately, I forgot to update the IAA watchdog timer routine.  It
thinks that an empty async_iaa list means the timer expiration was an
error, which isn't true any more.  This problem didn't show up during
initial testing because the controllers being tested all had working
IAA interrupts.  But not all controllers do, and when the watchdog
timer expires, the empty-list check prevents the second IAA cycle from
starting.  As a result, URB unlinks never complete.  The check needs
to be removed.

Among the symptoms of the regression are processes stuck in D wait
states and hangs during system shutdown.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Stephen Warren <swarren@wwwdotorg.org>
Reported-and-tested-by: Sven Joachim <svenjoac@gmx.de>
Reported-by: Andreas Bombe <aeb@debian.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/ehci-timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-timer.c b/drivers/usb/host/ehci-timer.c
index 20dbdcb..c3fa130 100644
--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -304,7 +304,7 @@ static void ehci_iaa_watchdog(struct ehci_hcd *ehci)
 	 * (a) SMP races against real IAA firing and retriggering, and
 	 * (b) clean HC shutdown, when IAA watchdog was pending.
 	 */
-	if (ehci->async_iaa) {
+	if (1) {
 		u32 cmd, status;
 
 		/* If we get here, IAA is *REALLY* late.  It's barely
-- 
1.7.10.4


