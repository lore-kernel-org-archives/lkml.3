Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCaNaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:30:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaCaNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin Easton <kevin@guarana.org>,
        Ruchi Kandoi <kandoiruchi@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 50/71] jiffies: Avoid undefined behavior from signed overflow
Date: Mon, 31 Mar 2014 14:22:56 +0100
Message-Id: <1396272197-13394-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

commit 5a581b367b5df0531265311fc681c2abd377e5e6 upstream.

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
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/jiffies.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 265e2c3..f5df3dc 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -106,13 +106,13 @@ static inline u64 get_jiffies_64(void)
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
@@ -135,13 +135,13 @@ static inline u64 get_jiffies_64(void)
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
 
 /*
-- 
1.9.1

