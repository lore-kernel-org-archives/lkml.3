Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3GZVdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:33:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954Ab3GZUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 53/79] bcache: Journal replay fix
Date: Fri, 26 Jul 2013 13:47:43 -0700
Message-Id: <20130726204728.172651833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit faa5673617656ee58369a3cfe4a312cfcdc59c81 upstream.

The journal replay code starts by finding something that looks like a
valid journal entry, then it does a binary search over the unchecked
region of the journal for the journal entries with the highest sequence
numbers.

Trouble is, the logic was wrong - journal_read_bucket() returns true if
it found journal entries we need, but if the range of journal entries
we're looking for loops around the end of the journal - in that case
journal_read_bucket() could return true when it hadn't found the highest
sequence number we'd seen yet, and in that case the binary search did
the wrong thing. Whoops.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -182,9 +182,14 @@ bsearch:
 		pr_debug("starting binary search, l %u r %u", l, r);
 
 		while (l + 1 < r) {
+			seq = list_entry(list->prev, struct journal_replay,
+					 list)->j.seq;
+
 			m = (l + r) >> 1;
+			read_bucket(m);
 
-			if (read_bucket(m))
+			if (seq != list_entry(list->prev, struct journal_replay,
+					      list)->j.seq)
 				l = m;
 			else
 				r = m;


