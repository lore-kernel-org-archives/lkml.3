Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3JUIuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39339 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298Ab3JUIum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roger Pau Monne" <roger.pau@citrix.com>,
        "Matt Wilson" <msw@amazon.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "David Vrabel" <david.vrabel@citrix.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.831422308@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 019/149] xen-gnt: prevent adding duplicate gnt callbacks
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit 5f338d9001094a56cf87bd8a280b4e7ff953bb59 upstream.

With the current implementation, the callback in the tail of the list
can be added twice, because the check done in
gnttab_request_free_callback is bogus, callback->next can be NULL if
it is the last callback in the list. If we add the same callback twice
we end up with an infinite loop, were callback == callback->next.

Replace this check with a proper one that iterates over the list to
see if the callback has already been added.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Matt Wilson <msw@amazon.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/grant-table.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -355,9 +355,18 @@ void gnttab_request_free_callback(struct
 				  void (*fn)(void *), void *arg, u16 count)
 {
 	unsigned long flags;
+	struct gnttab_free_callback *cb;
+
 	spin_lock_irqsave(&gnttab_list_lock, flags);
-	if (callback->next)
-		goto out;
+
+	/* Check if the callback is already on the list */
+	cb = gnttab_free_callback_list;
+	while (cb) {
+		if (cb == callback)
+			goto out;
+		cb = cb->next;
+	}
+
 	callback->fn = fn;
 	callback->arg = arg;
 	callback->count = count;

