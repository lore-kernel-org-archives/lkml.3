Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3KTBhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:37:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:26182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab3KTBhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:37:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="411505083"
Subject: [PATCH v6 0/5] MCS Lock: MCS lock code cleanup and optimizations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
References: <cover.1384885312.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Nov 2013 17:37:26 -0800
Message-ID: <1384911446.11046.450.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch series, we separated out the MCS lock code which was
previously embedded in the mutex.c.  This allows for easier reuse of
MCS lock in other places like rwsem and qrwlock.  We also did some micro
optimizations and barrier cleanup.  

The original code has potential leaks between critical sections, which
was not a problem when MCS was embedded within the mutex but needs
to be corrected when allowing the MCS lock to be used by itself for
other locking purposes. 

Proper barriers are now embedded with the usage of smp_load_acquire() in
mcs_spin_lock() and smp_store_release() in mcs_spin_unlock.  See
http://marc.info/?l=linux-arch&m=138386254111507 for info on the
new smp_load_acquire() and smp_store_release() functions. 

This patches were previously part of the rwsem optimization patch series
but now we spearate them out.

We have also added hooks to allow for architecture specific 
implementation of the mcs_spin_lock and mcs_spin_unlock functions.

Will, do you want to take a crack at adding implementation for ARM
with wfe instruction?

Tim

v6:
1. Fix a bug of improper xchg_acquire and extra space in barrier
fixing patch.
2. Added extra hooks to allow for architecture specific version
of mcs_spin_lock and mcs_spin_unlock to be used.

v5:
1. Rework barrier correction patch.  We now use smp_load_acquire()
in mcs_spin_lock() and smp_store_release() in
mcs_spin_unlock() to allow for architecture dependent barriers to be
automatically used.  This is clean and will provide the right
barriers for all architecture.

v4:
1. Move patch series to the latest tip after v3.12

v3:
1. modified memory barriers to support non x86 architectures that have
weak memory ordering.

v2:
1. change export mcs_spin_lock as a GPL export symbol
2. corrected mcs_spin_lock to references


Jason Low (1):
  MCS Lock: optimizations and extra comments

Tim Chen (2):
  MCS Lock: Restructure the MCS lock defines and locking code into its
    own file
  MCS Lock: Allows for architecture specific mcs lock and unlock

Waiman Long (2):
  MCS Lock: Move mcs_lock/unlock function into its own file
  MCS Lock: Barrier corrections

 arch/Kconfig                  |  3 ++
 include/linux/mcs_spinlock.h  | 30 +++++++++++++
 include/linux/mutex.h         |  5 ++-
 kernel/locking/Makefile       |  6 +--
 kernel/locking/mcs_spinlock.c | 98 +++++++++++++++++++++++++++++++++++++++++++
 kernel/locking/mutex.c        | 60 ++++----------------------
 6 files changed, 144 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/mcs_spinlock.h
 create mode 100644 kernel/locking/mcs_spinlock.c

-- 
1.7.11.7


