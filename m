Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3CZWrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:47:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3CZWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Andreas Bombe <aeb@debian.org>
Subject: [ 86/98] USB: EHCI: fix regression in QH unlinking
Date: Tue, 26 Mar 2013 15:43:15 -0700
Message-Id: <20130326224251.403352299@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit d714aaf649460cbfd5e82e75520baa856b4fa0a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -304,7 +304,7 @@ static void ehci_iaa_watchdog(struct ehc
 	 * (a) SMP races against real IAA firing and retriggering, and
 	 * (b) clean HC shutdown, when IAA watchdog was pending.
 	 */
-	if (ehci->async_iaa) {
+	if (1) {
 		u32 cmd, status;
 
 		/* If we get here, IAA is *REALLY* late.  It's barely


