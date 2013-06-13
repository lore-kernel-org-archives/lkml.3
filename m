Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab3FMRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:11:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45969 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3FMRLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:11:36 -0400
Date: Thu, 13 Jun 2013 10:10:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: davej@redhat.com, rostedt@goodmis.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL urgent] Fixes for three more RCU regressions
Message-ID: <20130613171019.GA17912@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061317-3620-0000-0000-000003186239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

I must confess that this past merge window was not RCU's best showing.
This series contains three more fixes for RCU regressions:

1.	A fix to __DECLARE_TRACE_RCU() that causes it to act as an
	interrupt from idle rather than as a task switch from idle.
	This change is needed due to the recent use of _rcuidle()
	tracepoints that can be invoked from interrupt handlers as well
	as from idle.  Without this fix, invoking _rcuidle() tracepoints
	from interrupt handlers results in splats and (more seriously)
	confusion on RCU's part as to whether a given CPU is idle or not.
	This confusion can in turn result in too-short grace periods and
	therefore random memory corruption.

2.	A fix to a subtle deadlock that could result due to RCU doing
	a wakeup while holding one of its rcu_node structure's locks.
	Although the probability of occurrence is low, it really
	does happen.  The fix, courtesy of Steven Rostedt, uses
	irq_work_queue() to avoid the deadlock.

3.	A fix to a silent deadlock (invisible to lockdep) due to the
	interaction of timeouts posted by RCU debug code enabled by
	CONFIG_PROVE_RCU_DELAY=y, grace-period initialization, and CPU
	hotplug operations.  This will not occur in production kernels,
	but really does occur in randconfig testing.  Diagnosis courtesy
	of Steven Rostedt.

These fixes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

for you to fetch changes up to 971394f389992f8462c4e5ae0e3b49a10a9534a3:

  rcu: Fix deadlock with CPU hotplug, RCU GP init, and timer migration (2013-06-10 13:37:12 -0700)

----------------------------------------------------------------
Paul E. McKenney (2):
      trace: Allow idle-safe tracepoints to be called from irq
      rcu: Fix deadlock with CPU hotplug, RCU GP init, and timer migration

Steven Rostedt (1):
      rcu: Don't call wakeup() with rcu_node structure ->lock held

 include/linux/tracepoint.h |  4 ++--
 init/Kconfig               |  1 +
 kernel/rcutree.c           | 21 +++++++++++++++++----
 kernel/rcutree.h           |  2 ++
 4 files changed, 22 insertions(+), 6 deletions(-)

