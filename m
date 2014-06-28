Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaF1Knp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:43:45 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50654 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaF1Knn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:43:43 -0400
From: Xie XiuQi <xiexiuqi@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <rostedt@goodmis.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>, <m.chehab@samsung.com>
Subject: [PATCH 0/2] tracing: fix uptime overflow problem
Date: Sat, 28 Jun 2014 19:09:59 +0800
Message-ID: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "uptime" tracer added in:
    commit 8aacf017b065a805d27467843490c976835eb4a5
    tracing: Add "uptime" trace clock that uses jiffies
has wraparound problems when the system has been up more
than 1 hour 11 minutes and 34 seconds. It converts jiffies
to nanoseconds using:
        (u64)jiffies_to_usecs(jiffy) * 1000ULL
but since jiffies_to_usecs() only returns a 32-bit value, it
truncates at 2^32 microseconds.  An additional problem on 32-bit
systems is that the argument is "unsigned long", so fixing the
return value only helps until 2^32 jiffies (49.7 days on a HZ=1000
system).

Tony provide full featured jiffies_to_nsecs() function, but
can't resolve another problem that jiffies_lock is not safe
in NMI context.

Now we use the lockless function __current_kernel_time() and
getboottime() to calculate the uptime.

The former discussion is here:
http://lkml.org/lkml/2014/4/8/525

Additional, I changed trace_clock_jiffies to trace_clock_uptime,
in order to better describe its function and updated the document.

Xie XiuQi (2):
  tracing: fix uptime overflow problem
  tracing: update Documentation/trace/ftrace.txt for uptime

 Documentation/trace/ftrace.txt |  3 +--
 include/linux/trace_clock.h    |  2 +-
 kernel/trace/trace.c           |  2 +-
 kernel/trace/trace_clock.c     | 15 +++++++++++----
 4 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.0.0

