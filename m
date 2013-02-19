Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab3BSSyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:54:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933698Ab3BSSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 73/81] s390/timer: avoid overflow when programming clock comparator
Date: Tue, 19 Feb 2013 15:49:36 -0300
Message-Id: <1361299784-8830-74-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/s390/kernel/time.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index c5531db..747ab28 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -121,6 +121,9 @@ static int s390_next_ktime(ktime_t expires,
 	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
 	do_div(nsecs, 125);
 	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
+	/* Program the maximum value if we have an overflow (== year 2042) */
+	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
+		S390_lowcore.clock_comparator = -1ULL;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }
-- 
1.7.9.5

