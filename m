Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3BCOyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:54:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab3BCOyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:40 -0500
Message-Id: <20130203144644.159430779@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 001/128] usb: gadget: dummy: fix enumeration with g_multi
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 1d16638e3b9cc195bac18a8fcbca748f33c1bc24 upstream.

If we do have endpoints named like "ep-a" then bEndpointAddress is
counted internally by the gadget framework.

If we do have endpoints named like "ep-1" then bEndpointAddress is
assigned from the digit after "ep-".

If we do have both, then it is likely that after we used up the
"generic" endpoints we will use the digits and thus assign one
bEndpointAddress to multiple endpoints.

This theory can be proofed by using the completely enabled g_multi.
Without this patch, the mass storage won't enumerate and times out
because it shares endpoints with RNDIS.

This patch also adds fills up the endpoints list so we have in total
endpoints 1 to 15 in + out available while some of them are restricted
to certain types like BULK or ISO. Without this change the nokia gadget
won't load because the system does not provide enough (BULK) endpoints
but it did before ep-a - ep-f were removed.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/dummy_hcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -126,10 +126,7 @@ static const char ep0name [] = "ep0";
 static const char *const ep_name [] = {
 	ep0name,				/* everyone has ep0 */
 
-	/* act like a net2280: high speed, six configurable endpoints */
-	"ep-a", "ep-b", "ep-c", "ep-d", "ep-e", "ep-f",
-
-	/* or like pxa250: fifteen fixed function endpoints */
+	/* act like a pxa250: fifteen fixed function endpoints */
 	"ep1in-bulk", "ep2out-bulk", "ep3in-iso", "ep4out-iso", "ep5in-int",
 	"ep6in-bulk", "ep7out-bulk", "ep8in-iso", "ep9out-iso", "ep10in-int",
 	"ep11in-bulk", "ep12out-bulk", "ep13in-iso", "ep14out-iso",
@@ -137,6 +134,10 @@ static const char *const ep_name [] = {
 
 	/* or like sa1100: two fixed function endpoints */
 	"ep1out-bulk", "ep2in-bulk",
+
+	/* and now some generic EPs so we have enough in multi config */
+	"ep3out", "ep4in", "ep5out", "ep6out", "ep7in", "ep8out", "ep9in",
+	"ep10out", "ep11out", "ep12in", "ep13out", "ep14in", "ep15out",
 };
 #define DUMMY_ENDPOINTS	ARRAY_SIZE(ep_name)
 


