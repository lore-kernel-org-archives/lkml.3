Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3JUIuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39262 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064Ab3JUIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "stephen hemminger" <stephen@networkplumber.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.35930908@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 001/149] htb: fix sign extension bug
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index f08b9166..caa5aff 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -86,7 +86,7 @@ struct htb_class {
 	unsigned int children;
 	struct htb_class *parent;	/* parent class */
 
-	int prio;		/* these two are used only by leaves... */
+	u32 prio;		/* these two are used only by leaves... */
 	int quantum;		/* but stored for parent-to-leaf return */
 
 	union {

