Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GHNGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:06:47 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:56110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GHNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:05:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363132800"; 
   d="scan'208";a="6453381"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 1/4] xen-gnt: prevent adding duplicate gnt callbacks
Date: Mon, 8 Jul 2013 15:03:24 +0200
Message-ID: <1373288607-1876-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current implementation, the callback in the tail of the list
can be added twice, because the check done in
gnttab_request_free_callback is bogus, callback->next can be NULL if
it is the last callback in the list. If we add the same callback twice
we end up with an infinite loop, were callback == callback->next.

Replace this check with a proper one that iterates over the list to
see if the callback has already been added.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/grant-table.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 04c1b2d..d5418c1 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -729,9 +729,18 @@ void gnttab_request_free_callback(struct gnttab_free_callback *callback,
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
-- 
1.7.7.5 (Apple Git-26)

