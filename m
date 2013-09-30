Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3I3KMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3I3KMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 038/104] htb: fix sign extension bug
Date: Mon, 30 Sep 2013 11:10:15 +0100
Message-Id: <1380535881-9239-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

commit cbd375567f7e4811b1c721f75ec519828ac6583f upstream.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index e9ea2f3..6f15bd1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -86,7 +86,7 @@ struct htb_class {
 	unsigned int children;
 	struct htb_class *parent;	/* parent class */
 
-	int prio;		/* these two are used only by leaves... */
+	u32 prio;		/* these two are used only by leaves... */
 	int quantum;		/* but stored for parent-to-leaf return */
 
 	union {
-- 
1.8.3.2

