Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3BOW4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3BOW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [ 04/10] s390/timer: avoid overflow when programming clock comparator
Date: Fri, 15 Feb 2013 14:56:36 -0800
Message-Id: <20130215225544.063361115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/time.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -120,6 +120,9 @@ static int s390_next_ktime(ktime_t expir
 	nsecs = ktime_to_ns(ktime_add(timespec_to_ktime(ts), expires));
 	do_div(nsecs, 125);
 	S390_lowcore.clock_comparator = sched_clock_base_cc + (nsecs << 9);
+	/* Program the maximum value if we have an overflow (== year 2042) */
+	if (unlikely(S390_lowcore.clock_comparator < sched_clock_base_cc))
+		S390_lowcore.clock_comparator = -1ULL;
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	return 0;
 }


