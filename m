Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3IYAMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:12:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3IYAMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Matt Wilson <msw@amazon.com>
Subject: [ 04/40] xen-gnt: prevent adding duplicate gnt callbacks
Date: Tue, 24 Sep 2013 17:11:36 -0700
Message-Id: <20130925001042.434763163@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/grant-table.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -641,9 +641,18 @@ void gnttab_request_free_callback(struct
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


