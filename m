Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3I3Kih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:38:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3I3KLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 010/104] xen-gnt: prevent adding duplicate gnt callbacks
Date: Mon, 30 Sep 2013 11:09:47 +0100
Message-Id: <1380535881-9239-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/grant-table.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 22be735..8a6ecc5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -728,9 +728,18 @@ void gnttab_request_free_callback(struct gnttab_free_callback *callback,
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
1.8.3.2

