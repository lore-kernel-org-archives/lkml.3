Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab3BKNt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:49:56 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55007 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab3BKNtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:49:55 -0500
Date: Mon, 11 Feb 2013 14:49:43 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 regression patch for 3.8-rc8
Message-ID: <20130211144943.69c83140@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13021113-1948-0000-0000-000004456D07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The recent fix for the s390 sched_clock() function uncovered yet
another bug in s390_next_ktime which causes an endless loop in KVM.
This regression should be fixed before v3.8.

I keep the fingers crossed that this is the last one for v3.8.

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator

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

