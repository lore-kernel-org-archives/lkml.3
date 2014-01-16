Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaAPOTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:19:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaAPOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:19:08 -0500
Date: Thu, 16 Jan 2014 06:18:26 -0800
From: tip-bot for Heiko Carstens <tipbot@zytor.com>
Message-ID: <tip-63b1a81699c2a45c9f737419b1ec1da0ecf92812@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org, jason.low2@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <20140116135450.GA4345@osiris>
References: <20140116135450.GA4345@osiris>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futexes: Fix futex_hashsize initialization
Git-Commit-ID: 63b1a81699c2a45c9f737419b1ec1da0ecf92812
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 06:18:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b1a81699c2a45c9f737419b1ec1da0ecf92812
Gitweb:     http://git.kernel.org/tip/63b1a81699c2a45c9f737419b1ec1da0ecf92812
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 16 Jan 2014 14:54:50 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 15:14:32 +0100

futexes: Fix futex_hashsize initialization

"futexes: Increase hash table size for better performance"
introduces a new alloc_large_system_hash() call.

alloc_large_system_hash() however may allocate less memory than
requested, e.g. limited by MAX_ORDER.

Hence pass a pointer to alloc_large_system_hash() which will
contain the hash shift when the function returns. Afterwards
correctly set futex_hashsize.

Fixes a crash on s390 where the requested allocation size was
4MB but only 1MB was allocated.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Link: http://lkml.kernel.org/r/20140116135450.GA4345@osiris
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/futex.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 30971b5..1ddc449 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2844,6 +2844,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 static int __init futex_init(void)
 {
 	u32 curval;
+	unsigned int futex_shift;
 	unsigned long i;
 
 #if CONFIG_BASE_SMALL
@@ -2855,8 +2856,9 @@ static int __init futex_init(void)
 	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
 					       futex_hashsize, 0,
 					       futex_hashsize < 256 ? HASH_SMALL : 0,
-					       NULL, NULL, futex_hashsize, futex_hashsize);
-
+					       &futex_shift, NULL,
+					       futex_hashsize, futex_hashsize);
+	futex_hashsize = 1UL << futex_shift;
 	/*
 	 * This will fail and we want it. Some arch implementations do
 	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
