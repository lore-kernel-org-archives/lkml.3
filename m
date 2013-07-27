Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3G0W6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 18:58:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35063 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3G0W6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 18:58:33 -0400
Date: Sat, 27 Jul 2013 15:58:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, davem@davemloft.net, arnd@arndb.de,
        mingo@kernel.org, torvalds@linux-foundation.org
Subject: [PATCH jiffies] Avoid undefined behavior from signed overflow
Message-ID: <20130727225828.GA11864@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072722-5518-0000-0000-000010ABD3BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the C standard 3.4.3p3, overflow of a signed integer results
in undefined behavior.  This commit therefore changes the definitions
of time_after() and time_after_eq() to avoid this undefined behavior.
The trick is that the subtraction is done using unsigned arithmetic,
which according to 6.2.5p9 cannot overflow because it is defined as
modulo arithmetic.  This has the added (though admittedly quite small)
benefit of shortening two lines of code by four characters each.

Note that the C standard considers the cast from signed to
unsigned to be implementation-defined, see 6.3.1.3p3.  However, on a
two-complement system, an implementation that defines anything other
than a reinterpretation of the bits is free come to me, and I will be
happy to act as a witness for its being committed to an insane asylum.
(Although I have nothing against saturating arithmetic or signals in
some cases, these things really should not be the default.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 97ba4e7..97967ba 100644
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

