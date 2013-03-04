Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3CDDnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60934 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755857Ab3CDDnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:02 -0500
Message-Id: <20130304033719.298931871@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [ 119/153] s390/timer: avoid overflow when programming clock comparator
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d911e03d097bdc01363df5d81c43f69432eb785c upstream.

Since ed4f209 "s390/time: fix sched_clock() overflow" a new helper function
is used to avoid overflows when converting TOD format values to nanosecond
values.
The kvm interrupt code formerly however only worked by accident because of
an overflow. It tried to program a timer that would expire in more than ~29
years. Because of the old TOD-to-nanoseconds overflow bug the real expiry
value however was much smaller, but now it isn't anymore.
This however triggers yet another bug in the function that programs the clock
comparator s390_next_ktime(): if the absolute "expires" value is after 2042
this will result in an overflow and the programmed value is lower than the
current TOD value which immediatly triggers a clock comparator (= timer)
interrupt.
Since the timer isn't expired it will be programmed immediately again and so
on... the result is a dead system.
To fix this simply program the maximum possible value if an overflow is
detected.

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/time.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a5f4f5a..0aa98db 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -120,6 +120,9 @@ static int s390_next_ktime(ktime_t expires,
 	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
 	do_div(nsecs, 125);
 	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
+	/* Program the maximum value if we have an overflow (== year 2042) */
+	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
+		S390_lowcore.clock_comparator = -1ULL;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }


