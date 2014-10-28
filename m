Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaJ1W0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:26:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60330 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaJ1W0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:26:18 -0400
Date: Tue, 28 Oct 2014 15:22:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: [PATCH tip/core/rcu 0/7] Real-time updates for 3.19
Message-ID: <20141028222224.GA28263@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F50517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains real-time-related updates:

1.	Move RCU_NOCB_CPU to choice, courtesy of Stefan Hengelein.

2.	Place RCU_BOOST-specific variables under pre-existing #ifdef.

3.	Prevent synchronize_sched_expedited() from sending IPIs to
	idle and to nohz_full CPUs.

4.	Unify boost and kthread priorities, and allow this unified
	priority to be set at boot time, courtesy of Clark Williams.

5.	Remove redundant TREE_PREEMPT_RCU Kconfig option, courtesy of
	Pranith Kumar.

6.	Handle the possibility of a no-CBs CPU posting callbacks on
	their last pass through the idle loop by waking up the
	leader kthread after the CPU has gone completely offline.

7.	Fix rcuo online-time-creation reoganization bug, which seems
	to be a latent bug due to systems (wisely) bringing CPUs online
	in numerical order.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/rcu.txt                                                     |    4 
 b/Documentation/RCU/stallwarn.txt                                               |    8 -
 b/Documentation/RCU/trace.txt                                                   |    4 
 b/Documentation/RCU/whatisRCU.txt                                               |    2 
 b/Documentation/kernel-parameters.txt                                           |    6 +
 b/include/linux/init_task.h                                                     |    2 
 b/include/linux/rcupdate.h                                                      |    6 -
 b/include/linux/sched.h                                                         |    4 
 b/include/trace/events/rcu.h                                                    |    4 
 b/init/Kconfig                                                                  |   49 +++------
 b/kernel/rcu/Makefile                                                           |    2 
 b/kernel/rcu/tree.c                                                             |   44 +++++---
 b/kernel/rcu/tree.h                                                             |   10 -
 b/kernel/rcu/tree_plugin.h                                                      |   53 ++++++----
 b/kernel/rcu/update.c                                                           |    2 
 b/lib/Kconfig.debug                                                             |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T                       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03                         |    4 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T                       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09                         |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all  |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp      |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp       |    2 
 b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt                           |    2 
 b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt                   |   14 +-
 50 files changed, 157 insertions(+), 127 deletions(-)

