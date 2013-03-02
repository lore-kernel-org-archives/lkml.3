Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3CBHZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 02:25:10 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:55986 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3CBHZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 02:25:09 -0500
Date: Sat, 2 Mar 2013 07:25:08 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: preserve ordering of events from ovflist
Message-ID: <20130302072508.GA19297@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events arriving in ovflist are stored in LIFO order, so
we should account for that when inserting them into rddlist.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
  I think this can lead to starvation in some rare cases, but I have not
  been able to trigger it.  The window for ovflist insertion is tiny.

 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9fec183..5a1a596 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -598,7 +598,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 * contain them, and the list_splice() below takes care of them.
 		 */
 		if (!ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
+			list_add(&epi->rdllink, &ep->rdllist);
 			__pm_stay_awake(epi->ws);
 		}
 	}
-- 
Eric Wong
