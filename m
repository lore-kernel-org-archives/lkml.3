Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334Ab3DDOzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:55:10 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:13326 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762207Ab3DDOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:55:08 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Subject: [PATCH RFC 0/3] mutex: Improve mutex performance by doing less atomic-ops & spinning
Date: Thu,  4 Apr 2013 10:54:15 -0400
Message-Id: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a collection of 3 different mutex related patches
aimed at improving mutex performance especially for system with large
number of CPUs. This is achieved by doing less atomic operations and
mutex spinning (when the CONFIG_MUTEX_SPIN_ON_OWNER is on).

The first patch reduces the number of atomic operations executed. It
can produce dramatic performance improvement in the AIM7 benchmark
with large number of CPUs. For example, there was a more than 3X
improvement in the high_systime workload with a 3.7.10 kernel on
an 8-socket x86-64 system with 80 cores. The 3.8 kernels, on the
other hand, are not mutex limited for that workload anymore. So the
performance improvement is only about 1% for the high_systime workload.

Patches 2 and 3 represent different ways to reduce mutex spinning. Of
the 2, the third one is better from both a performance perspective
and the fact that no mutex data structure change is needed. See the
individual patch descriptions for more information on those patches.

The table below shows the performance impact on the AIM7 benchmark with
a 3.8.5 kernel running on the same 8-socket system mentioned above:

+--------------+------------------------------------------------------+
|   Workload   |              Mean % Change 10-100 users              |
|              +-----------------+-----------------+------------------+
|              |   Patches 1+2   |   Patches 1+3   | Relative %Change |
+--------------+-----------------+-----------------+------------------+
| fserver      |     +1.7%       |      0.0%       |     -1.7%        |
| new_fserver  |     -0.2%       |     -1.5%       |     -1.2%        |
+--------------+-----------------+-----------------+------------------+
|   Workload   |             Mean % Change 100-1000 users             |
|              +-----------------+-----------------+------------------+
|              |   Patches 1+2   |   Patches 1+3   | Relative %Change |
+--------------+-----------------+-----------------+------------------+
| fserver      |    +18.6%       |    +43.4%       |    +21.0%        |
| new_fserver  |    +14.0%       |    +23.4%       |     +8.2%        |
+--------------+-----------------+-----------------+------------------+
|   Workload   |             Mean % Change 1100-2000 users            |
|              +-----------------+-----------------+------------------+
|              |   Patches 1+2   |   Patches 1+3   | Relative %Change |
+--------------+-----------------+-----------------+------------------+
| fserver      |    +11.6%       |     +5.1%       |     -5.8%        |
| new_fserver  |    +13.3%       |     +7.6%       |     -5.0%        |
+--------------+-----------------+-----------------+------------------+

So patch 2 is better at low and high load. Patch 3 is better at
intermediate load. For other AIM7 workloads, patch 3 is generally
better.

Waiman Long (3):
  mutex: Make more scalable by doing less atomic operations
  mutex: restrict mutex spinning to only one task per mutex
  mutex: dynamically disable mutex spinning at high load

 arch/x86/include/asm/mutex.h |   16 ++++++++++++++++
 include/linux/mutex.h        |    3 +++
 kernel/mutex.c               |   21 ++++++++++++++++++---
 kernel/mutex.h               |    8 ++++++++
 kernel/sched/core.c          |   22 ++++++++++++++++++++++
 5 files changed, 67 insertions(+), 3 deletions(-)

