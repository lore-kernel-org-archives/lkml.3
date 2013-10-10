Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab3JJQO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:14:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52574 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 001/104] htb: fix sign extension bug
Date: Thu, 10 Oct 2013 08:40:49 -0700
Message-Id: <1381419752-29733-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit cbd375567f7e4811b1c721f75ec519828ac6583f ]

When userspace passes a large priority value
the assignment of the unsigned value hopt->prio
to  signed int cl->prio causes cl->prio to become negative and the
comparison is with TC_HTB_NUMPRIO is always false.

The result is that HTB crashes by referencing outside
the array when processing packets. With this patch the large value
wraps around like other values outside the normal range.

See: https://bugzilla.kernel.org/show_bug.cgi?id=60669

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 79e8ed4..8ea8a79 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -92,7 +92,7 @@ struct htb_class {
 	unsigned int children;
 	struct htb_class *parent;	/* parent class */
 
-	int prio;		/* these two are used only by leaves... */
+	u32 prio;		/* these two are used only by leaves... */
 	int quantum;		/* but stored for parent-to-leaf return */
 
 	union {
-- 
1.8.1.2

