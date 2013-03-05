Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3CECR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:17:29 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45763 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816Ab3CECR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:17:27 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/2] tighten lglock lockdep annotations
Date: Mon,  4 Mar 2013 18:17:23 -0800
Message-Id: <1362449845-7492-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov recently noticed that the lockdep annotations in lglock.c
are not sufficient to detect some obvious deadlocks, such as
lg_local_lock(LOCK) + lg_local_lock(LOCK) or
spin_lock(X) + lg_local_lock(Y) vs lg_local_lock(Y) + spin_lock(X).

Both issues can be fixed by indicating to lockdep that lglock's local
locks are not recursive.

Patch 1 introduces helper macros for lockdep annotations.

Patch 2 makes sure to use the appropriate helper macros to indicate that
the lglock local lock is a shared, non-recursive lock.

Michel Lespinasse (2):
  lockdep: introduce lock_acquire_exclusive/shared helper macros
  lglock: update lockdep annotations to report recursive local locks

 include/linux/lockdep.h | 92 +++++++++++++------------------------------------
 kernel/lglock.c         | 12 +++----
 2 files changed, 29 insertions(+), 75 deletions(-)

-- 
1.8.1.3
