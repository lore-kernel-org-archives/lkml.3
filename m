Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3A0APr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:15:47 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52092 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3A0APj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:39 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: Silence compiler array out-of-bounds false positive
Date: Sat, 26 Jan 2013 16:15:06 -0800
Message-Id: <1359245712-3843-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127001454.GA2682@linux.vnet.ibm.com>
 <1359245712-3843-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012700-5518-0000-0000-00000B0B3838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It turns out that gcc 4.8 warns on array indexes being out of bounds
unless it can prove otherwise.  It gives this warning on some RCU
initialization code.  Because this is far from any fastpath, add
an explicit check for array bounds and panic if so.  This gives the
compiler enough information to figure out that the array index is never
out of bounds.

However, if a similar false positive occurs on a fastpath, it will
probably be necessary to tell the compiler to keep its array-index
anxieties to itself.  ;-)

Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d145796..e0d9815 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2938,6 +2938,10 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
 
+	/* Silence gcc 4.8 warning about array index out of range. */
+	if (rcu_num_lvls > RCU_NUM_LVLS)
+		panic("rcu_init_one: rcu_num_lvls overflow");
+
 	/* Initialize the level-tracking arrays. */
 
 	for (i = 0; i < rcu_num_lvls; i++)
-- 
1.7.8

