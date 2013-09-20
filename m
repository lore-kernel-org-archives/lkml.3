Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3ITULf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:11:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3ITUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/93] xen-gnt: prevent adding duplicate gnt callbacks
Date: Fri, 20 Sep 2013 13:08:01 -0700
Message-Id: <1379707768-1804-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/grant-table.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 157c0cc..51be226 100644
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
1.8.1.2

