Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3HTCnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:43:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34387 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3HTCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin Easton <kevin@guarana.org>
Subject: [PATCH tip/core/rcu 9/9] jiffies: Avoid undefined behavior from signed overflow
Date: Mon, 19 Aug 2013 19:42:14 -0700
Message-Id: <1376966534-30775-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-1542-0000-0000-000000A78BF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

According to the C standard 3.4.3p3, overflow of a signed integer results
in undefined behavior.  This commit therefore changes the definitions
of time_after(), time_after_eq(), time_after64(), and time_after_eq64()
to avoid this undefined behavior.  The trick is that the subtraction
is done using unsigned arithmetic, which according to 6.2.5p9 cannot
overflow because it is defined as modulo arithmetic.  This has the added
(though admittedly quite small) benefit of shortening four lines of code
by four characters each.

Note that the C standard considers the cast from unsigned to
signed to be implementation-defined, see 6.3.1.3p3.  However, on a
two's-complement system, an implementation that defines anything other
than a reinterpretation of the bits is free to come to me, and I will be
happy to act as a witness for its being committed to an insane asylum.
(Although I have nothing against saturating arithmetic or signals in some
cases, these things really should not be the default when compiling an
operating-system kernel.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Kevin Easton <kevin@guarana.org>
[ paulmck: Included time_after64() and time_after_eq64(), as suggested
  by Eric Dumazet, also fixed commit message.]
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/jiffies.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 97ba4e7..d235e88 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -101,13 +101,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after(a,b)		\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(b) - (long)(a) < 0))
+	 ((long)((b) - (a)) < 0))
 #define time_before(a,b)	time_after(b,a)
 
 #define time_after_eq(a,b)	\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(a) - (long)(b) >= 0))
+	 ((long)((a) - (b)) >= 0))
 #define time_before_eq(a,b)	time_after_eq(b,a)
 
 /*
@@ -130,13 +130,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after64(a,b)	\
 	(typecheck(__u64, a) &&	\
 	 typecheck(__u64, b) && \
-	 ((__s64)(b) - (__s64)(a) < 0))
+	 ((__s64)((b) - (a)) < 0))
 #define time_before64(a,b)	time_after64(b,a)
 
 #define time_after_eq64(a,b)	\
 	(typecheck(__u64, a) && \
 	 typecheck(__u64, b) && \
-	 ((__s64)(a) - (__s64)(b) >= 0))
+	 ((__s64)((a) - (b)) >= 0))
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 #define time_in_range64(a, b, c) \
-- 
1.8.1.5

