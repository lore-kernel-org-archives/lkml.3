Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3AXD2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44114 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3AXD1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 01/74] usb: gadget: dummy: fix enumeration with g_multi
Date: Thu, 24 Jan 2013 01:26:13 -0200
Message-Id: <1358998046-613-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/gadget/dummy_hcd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index afdbb1c..4ad1f1c 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -126,10 +126,7 @@ static const char ep0name[] = "ep0";
 static const char *const ep_name[] = {
 	ep0name,				/* everyone has ep0 */
 
-	/* act like a net2280: high speed, six configurable endpoints */
-	"ep-a", "ep-b", "ep-c", "ep-d", "ep-e", "ep-f",
-
-	/* or like pxa250: fifteen fixed function endpoints */
+	/* act like a pxa250: fifteen fixed function endpoints */
 	"ep1in-bulk", "ep2out-bulk", "ep3in-iso", "ep4out-iso", "ep5in-int",
 	"ep6in-bulk", "ep7out-bulk", "ep8in-iso", "ep9out-iso", "ep10in-int",
 	"ep11in-bulk", "ep12out-bulk", "ep13in-iso", "ep14out-iso",
@@ -137,6 +134,10 @@ static const char *const ep_name[] = {
 
 	/* or like sa1100: two fixed function endpoints */
 	"ep1out-bulk", "ep2in-bulk",
+
+	/* and now some generic EPs so we have enough in multi config */
+	"ep3out", "ep4in", "ep5out", "ep6out", "ep7in", "ep8out", "ep9in",
+	"ep10out", "ep11out", "ep12in", "ep13out", "ep14in", "ep15out",
 };
 #define DUMMY_ENDPOINTS	ARRAY_SIZE(ep_name)
 
-- 
1.7.9.5

