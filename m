Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3KVPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:39:45 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:40575 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3KVPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:39:42 -0500
Date: Fri, 22 Nov 2013 16:38:15 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Clock drift with GENERIC_TIME_VSYSCALL_OLD
Message-ID: <20131122163815.393ab1f2@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112215-4966-0000-0000-000007962AFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I just hunted down a time related bug which caused the Linux internal
xtime to drift away from the precise hardware clock provided by the
TOD clock found in the s390 architecture.

After a long search I came along this lovely piece of code in
kernel/time/timekeeping.c:

#ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
static inline void old_vsyscall_fixup(struct timekeeper *tk)

        s64 remainder;

        /*
        * Store only full nanoseconds into xtime_nsec after rounding
        * it up and add the remainder to the error difference.
        * XXX - This is necessary to avoid small 1ns inconsistnecies caused
        * by truncating the remainder in vsyscalls. However, it causes
        * additional work to be done in timekeeping_adjust(). Once
        * the vsyscall implementations are converted to use xtime_nsec
        * (shifted nanoseconds), and CONFIG_GENERIC_TIME_VSYSCALL_OLD
        * users are removed, this can be killed.
        */
        remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
        tk->xtime_nsec -= remainder;
        tk->xtime_nsec += 1ULL << tk->shift;
        tk->ntp_error += remainder << tk->ntp_error_shift;

}
#else
#define old_vsyscall_fixup(tk)
#endif

The highly precise result of our TOD clock source ends up in
tk->xtime_sec / tk->xtime_nsec where old_vsyscall_fixup just rounds
it up to the next nano-second (booo). To add insult to injury an
incorrect delta gets added to ntp_error, xtime has been forwarded by
((1ULL << tk->shift) - (tk->xtime_nsec & ((1ULL << tk->shift) - 1)))
and not set back by (tk->xtime_nsec & ((1ULL << tk->shift) - 1)).
xtime is too fast by one nano-second per tick. To verify that this
is indeed the problem I removed the line that adds the nano-second
to xtime_nsec and voila the clocks are in sync.

A possible patch to fix this would be:

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1347,6 +1347,7 @@ static inline void old_vsyscall_fixup(struct timekeeper *t
k)
        tk->xtime_nsec -= remainder;
        tk->xtime_nsec += 1ULL << tk->shift;
        tk->ntp_error += remainder << tk->ntp_error_shift;
+       tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
 
 }
 #else

But that has the downside that it creates a negative ntp_error that
can only be corrected with an adjustment of tk->mult which takes a
long time.

The fix I am going to use is to convert s390 to GENERIC_TIME_VSYSCALL,
you might want to think about doing that for powerpc and ia64 as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

