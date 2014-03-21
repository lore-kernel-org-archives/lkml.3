Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966274AbaCUAKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:10:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966245AbaCUAJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin Easton <kevin@guarana.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 3.4 35/35] jiffies: Avoid undefined behavior from signed overflow
Date: Thu, 20 Mar 2014 17:11:26 -0700
Message-Id: <20140321001055.303251041@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Ruchi Kandoi <kandoiruchi@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/jiffies.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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


