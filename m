Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaAPNzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:55:01 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:46107 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPNy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:54:58 -0500
Date: Thu, 16 Jan 2014 14:54:50 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>
Subject: [PATCH -next] futex: fix futex_hashsize initialization
Message-ID: <20140116135450.GA4345@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011613-0542-0000-0000-000007AC8E79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"futexes: Increase hash table size for better performance" introduces a new
alloc_large_system_hash() call. alloc_large_system_hash() however may allocate
less memory than requested, e.g. limited by MAX_ORDER.

Hence pass a pointer to alloc_large_system_hash() which will contain the hash
shift when the function returns. Afterwards correctly set futex_hashsize.

Fixes a crash on s390 where the requested allocation size was 4MB but only 1MB
was allocated.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/futex.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3666aa0017ed..44a1261cb9ff 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2846,6 +2846,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 static int __init futex_init(void)
 {
 	u32 curval;
+	unsigned int futex_shift;
 	unsigned long i;
 
 #if CONFIG_BASE_SMALL
@@ -2857,8 +2858,9 @@ static int __init futex_init(void)
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
-- 
1.8.4.5

