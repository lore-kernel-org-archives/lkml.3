Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab3AOW5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:57:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:48674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446Ab3AOW5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Subject: [ 62/71] usb: gadget: dummy: fix enumeration with g_multi
Date: Tue, 15 Jan 2013 14:54:59 -0800
Message-Id: <20130115225344.870485257@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/dummy_hcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -122,10 +122,7 @@ static const char ep0name [] = "ep0";
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
@@ -133,6 +130,10 @@ static const char *const ep_name [] = {
 
 	/* or like sa1100: two fixed function endpoints */
 	"ep1out-bulk", "ep2in-bulk",
+
+	/* and now some generic EPs so we have enough in multi config */
+	"ep3out", "ep4in", "ep5out", "ep6out", "ep7in", "ep8out", "ep9in",
+	"ep10out", "ep11out", "ep12in", "ep13out", "ep14in", "ep15out",
 };
 #define DUMMY_ENDPOINTS	ARRAY_SIZE(ep_name)
 


