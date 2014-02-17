Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaBQWMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:12:40 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41464 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaBQWMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:12:38 -0500
Date: Mon, 17 Feb 2014 14:12:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH tip/core/rcu 0/55] Torture-test changes for 3.15
Message-ID: <20140217221231.GA8419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1542-0000-0000-00000652D87E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains rcutorture changes, including adding a simple
locktorture.  Creating this locktorture while sharing the rcutorture
infrastructure was the main point of this patch, but this effort
uncovered a number of shortcomings in rcutorture, which this series
also fixes.

1-6.	Usability improvements in rcutorture scripting.

7-13.	Enable concurrent rcutorture runs on systems with sufficient
	numbers of CPUs.

14.	Print the results directory at the end of the test.

15,17-25,27-28,30,32,37-41,46-48.
	Abstract facilities from rcutorture module and scripting for later
	use by locktorture.

16.	Don't create a results directory for dryruns.

26.	Print date and time of each phase of torturing.

29.	Issue a diagnostic if something does a system shutdown while
	rcutorture is running.

31.	Apply ACCESS_ONCE() to racy fullstop accesses.

33.	Clean up rcu_torture_init() error handling.

34.	Announce kthread creation.

35.	Clean up a number of rcutorture shutdown races, unifying the
	required shutdown actions into a new torture_kthread_stopping()
	function.

36.	Add a missing return statement in rcu_torture_barrier_init().

42.	Create a minimal locktorture module.

43-44.	Add an on-purpose buggy RCU implementation to rcutorture to help
	test the tests.

45.	Create a file for Kconfig parameters that are commmon across all
	rcutorture tests.

49.	Add beginning set of config files for locktorture.

50.	Avoid SEGV when cleanup-hooks function pointer is NULL.

51.	Add locktorture plugin for kvm_recheck.sh.

52.	Rename TREE_RCU-Kconfig.txt to avoid confusing scripts that
	look for Kconfig files, courtesy of Paul Bolle.

53.	Retain output from kvm-test-1-run.sh script.

54.	Add an on-purpose buggy lock implementation to locktorture to
	help test the tests.

55.	Save kvm.sh progress messages to log so that they can be used
	for later timing analysis.

							Thanx, Paul

------------------------------------------------------------------------

 a/kernel/rcu/torture.c                                                          | 2148 ------
 a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh                      |  203 
 a/tools/testing/selftests/rcutorture/configs/BUSTED                             |    7 
 a/tools/testing/selftests/rcutorture/configs/BUSTED.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/CFLIST                             |   13 
 a/tools/testing/selftests/rcutorture/configs/CFcommon                           |    2 
 a/tools/testing/selftests/rcutorture/configs/SRCU-N                             |    7 
 a/tools/testing/selftests/rcutorture/configs/SRCU-N.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/SRCU-P                             |    7 
 a/tools/testing/selftests/rcutorture/configs/SRCU-P.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/TINY01                             |   12 
 a/tools/testing/selftests/rcutorture/configs/TINY02                             |   12 
 a/tools/testing/selftests/rcutorture/configs/TREE01                             |   22 
 a/tools/testing/selftests/rcutorture/configs/TREE01.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/TREE02                             |   25 
 a/tools/testing/selftests/rcutorture/configs/TREE03                             |   22 
 a/tools/testing/selftests/rcutorture/configs/TREE04                             |   24 
 a/tools/testing/selftests/rcutorture/configs/TREE04.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/TREE05                             |   24 
 a/tools/testing/selftests/rcutorture/configs/TREE05.boot                        |    1 
 a/tools/testing/selftests/rcutorture/configs/TREE06                             |   25 
 a/tools/testing/selftests/rcutorture/configs/TREE07                             |   23 
 a/tools/testing/selftests/rcutorture/configs/TREE08                             |   25 
 a/tools/testing/selftests/rcutorture/configs/TREE08-T                           |   25 
 a/tools/testing/selftests/rcutorture/configs/TREE09                             |   20 
 a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST                        |   14 
 a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP           |   18 
 a/tools/testing/selftests/rcutorture/configs/v0.0/N2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v0.0/N3-3-T-nh-SD-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v0.0/N4-A-t-NH-sd-SMP-HP           |   18 
 a/tools/testing/selftests/rcutorture/configs/v0.0/N5-U-T-NH-sd-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v0.0/NT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v0.0/NT3-NH                        |   20 
 a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP           |   19 
 a/tools/testing/selftests/rcutorture/configs/v0.0/P2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v0.0/P3-3-T-nh-SD-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v0.0/P4-A-t-NH-sd-SMP-HP           |   22 
 a/tools/testing/selftests/rcutorture/configs/v0.0/P5-U-T-NH-sd-SMP-hp           |   28 
 a/tools/testing/selftests/rcutorture/configs/v0.0/PT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v0.0/PT2-NH                        |   22 
 a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh              |   33 
 a/tools/testing/selftests/rcutorture/configs/v3.12/CFLIST                       |   17 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N1-S-T-NH-SD-SMP-HP          |   19 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N2-2-t-nh-sd-SMP-hp          |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N3-3-T-nh-SD-SMP-hp          |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N4-A-t-NH-sd-SMP-HP          |   18 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N5-U-T-NH-sd-SMP-hp          |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N6---t-nh-SD-smp-hp          |   19 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N7-4-T-NH-SD-SMP-HP          |   26 
 a/tools/testing/selftests/rcutorture/configs/v3.12/N8-2-T-NH-SD-SMP-HP          |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.12/NT1-nh                       |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.12/NT3-NH                       |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P1-S-T-NH-SD-SMP-HP          |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P2-2-t-nh-sd-SMP-hp          |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P3-3-T-nh-SD-SMP-hp          |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P4-A-t-NH-sd-SMP-HP          |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P5-U-T-NH-sd-SMP-hp          |   28 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P6---t-nh-SD-smp-hp          |   18 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP          |   30 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-all      |   30 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-HP-none     |   30 
 a/tools/testing/selftests/rcutorture/configs/v3.12/P7-4-T-NH-SD-SMP-hp          |   30 
 a/tools/testing/selftests/rcutorture/configs/v3.12/PT1-nh                       |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.12/PT2-NH                       |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST                        |   14 
 a/tools/testing/selftests/rcutorture/configs/v3.3/N1-S-T-NH-SD-SMP-HP           |   19 
 a/tools/testing/selftests/rcutorture/configs/v3.3/N2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.3/N3-3-T-nh-SD-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.3/N4-A-t-NH-sd-SMP-HP           |   18 
 a/tools/testing/selftests/rcutorture/configs/v3.3/N5-U-T-NH-sd-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.3/NT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.3/NT3-NH                        |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.3/P1-S-T-NH-SD-SMP-HP           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.3/P2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.3/P3-3-T-nh-SD-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.3/P4-A-t-NH-sd-SMP-HP           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.3/P5-U-T-NH-sd-SMP-hp           |   28 
 a/tools/testing/selftests/rcutorture/configs/v3.3/PT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.3/PT2-NH                        |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh              |   44 
 a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST                        |   14 
 a/tools/testing/selftests/rcutorture/configs/v3.5/N1-S-T-NH-SD-SMP-HP           |   19 
 a/tools/testing/selftests/rcutorture/configs/v3.5/N2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.5/N3-3-T-nh-SD-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.5/N4-A-t-NH-sd-SMP-HP           |   18 
 a/tools/testing/selftests/rcutorture/configs/v3.5/N5-U-T-NH-sd-SMP-hp           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.5/NT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.5/NT3-NH                        |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.5/P1-S-T-NH-SD-SMP-HP           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.5/P2-2-t-nh-sd-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.5/P3-3-T-nh-SD-SMP-hp           |   20 
 a/tools/testing/selftests/rcutorture/configs/v3.5/P4-A-t-NH-sd-SMP-HP           |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.5/P5-U-T-NH-sd-SMP-hp           |   28 
 a/tools/testing/selftests/rcutorture/configs/v3.5/PT1-nh                        |   23 
 a/tools/testing/selftests/rcutorture/configs/v3.5/PT2-NH                        |   22 
 a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh              |   57 
 a/tools/testing/selftests/rcutorture/configs/ver_functions.sh                   |   57 
 a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt                   |   95 
 b/include/linux/torture.h                                                       |  146 
 b/kernel/Makefile                                                               |    1 
 b/kernel/locking/Makefile                                                       |    1 
 b/kernel/locking/locktorture.c                                                  |  454 +
 b/kernel/rcu/Makefile                                                           |    2 
 b/kernel/rcu/rcutorture.c                                                       | 3232 +++++++---
 b/kernel/torture.c                                                              |  893 ++
 b/lib/Kconfig.debug                                                             |   25 
 b/tools/testing/selftests/rcutorture/bin/functions.sh                           |    1 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh                    |   51 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh                     |   51 
 b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh                         |   55 
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh                      |   41 
 b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh                      |  205 
 b/tools/testing/selftests/rcutorture/bin/kvm.sh                                 |  378 -
 b/tools/testing/selftests/rcutorture/configs/BUSTED                             |    9 
 b/tools/testing/selftests/rcutorture/configs/BUSTED.boot                        |    1 
 b/tools/testing/selftests/rcutorture/configs/CFcommon                           |    2 
 b/tools/testing/selftests/rcutorture/configs/SRCU-N                             |    3 
 b/tools/testing/selftests/rcutorture/configs/SRCU-P                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TINY01                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TINY02                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE01                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE02                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE03                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE04                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE05                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE06                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE07                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE08                             |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE08-T                           |    1 
 b/tools/testing/selftests/rcutorture/configs/TREE09                             |    1 
 b/tools/testing/selftests/rcutorture/configs/lock/BUSTED                        |    6 
 b/tools/testing/selftests/rcutorture/configs/lock/BUSTED.boot                   |    1 
 b/tools/testing/selftests/rcutorture/configs/lock/CFLIST                        |    1 
 b/tools/testing/selftests/rcutorture/configs/lock/CFcommon                      |    2 
 b/tools/testing/selftests/rcutorture/configs/lock/LOCK01                        |    6 
 b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh              |   43 
 b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED                         |    7 
 b/tools/testing/selftests/rcutorture/configs/rcu/BUSTED.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST                         |   13 
 b/tools/testing/selftests/rcutorture/configs/rcu/CFcommon                       |    2 
 b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N                         |    7 
 b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-N.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P                         |    7 
 b/tools/testing/selftests/rcutorture/configs/rcu/SRCU-P.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TINY01                         |   12 
 b/tools/testing/selftests/rcutorture/configs/rcu/TINY02                         |   12 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01                         |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02                         |   25 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03                         |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04                         |   24 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05                         |   24 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE05.boot                    |    1 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE06                         |   25 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07                         |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08                         |   25 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T                       |   25 
 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09                         |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP       |   19 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh          |   33 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST                   |   17 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP      |   19 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp      |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP      |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp      |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp      |   19 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP      |   26 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP      |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh                   |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH                   |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP      |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp      |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP      |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp      |   28 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp      |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP      |   30 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all  |   30 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none |   30 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp      |   30 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh                   |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH                   |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP       |   19 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh          |   44 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST                    |   14 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP       |   19 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP       |   18 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH                    |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp       |   20 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP       |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp       |   28 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh                    |   23 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH                    |   22 
 b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh          |   57 
 b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh               |   57 
 b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh              |   22 
 b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh              |   25 
 b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh              |   23 
 b/tools/testing/selftests/rcutorture/configs/ver_functions.sh                   |   21 
 b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt                   |   95 
 236 files changed, 6643 insertions(+), 5512 deletions(-)

