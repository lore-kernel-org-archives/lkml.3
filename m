Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871Ab3CWBZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:25:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:10220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770Ab3CWBZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="310741523"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org
Subject: RFC: Kernel lock elision for TSX
Date: Fri, 22 Mar 2013 18:24:54 -0700
Message-Id: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit implements TSX lock elision for the kernel locks.
Lock elision uses hardware transactional memory to execute
locks in parallel.

This is just a RFC at this point, so that people can comment
on the code. Please send your feedback.
Code is against v3.9-rc3

Also available from:
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git
Branch: hle39/spinlock
The branch names may change as the tree is rebased.

For more details on the general elision concept please see:
http://halobates.de/adding-lock-elision-to-linux.pdf
http://lwn.net/Articles/533894/
Full TSX specification:
http://software.intel.com/file/41417 (chapter 8)

The patches provides the elision infrastructure and the changes
to the standard locks (rwsems, mutexes, spinlocks, rwspinlocks,
bit spinlocks) to elide.

The general strategy is to elide as many locks as possible, 
and use a combination of manual disabling and automatic
adaptation to handle lock regions that do not elide well.

Some additional kernel changes are also useful to fix common
transaction aborts. I have not included those in this patchkit,
but they will be submitted separately.  Many of these changes
improve general scalability, but improving cache line sharing
overhead.

Especially the adaptation algorithms have a lot of tunables.
The tuning is currently preliminary and will be revised later.

Some questions and answers:

- How much does it improve performance?
I cannot share any performance numbers at this point unfortunately.
Also please keep in mind that the tuning is very preliminary and
will be revised.

- How to test it:
You either need a system with Intel TSX. A qemu version with
TSX support is available from https://github.com/crjohns/qemu-tsx
and may also support the kernel (untested)

- The CONFIG_RTM_LOCKS option does not appear
Make sure CONFIG_PARAVIRT_GUEST and CONFIG_PARAVIRT_SPINLOCKS
is enabled. The spinlock code uses the paravirt locking infrastructure
to add elision.

- How does it interact with virtualization?
It cannot interoperate with Xen paravirtualized locks, but without 
them lock elision should work in virtualization. If the Xen
pvlocks are active spinlock elision will be disabled.
This may be fixed at some point.
There are some limitations in perf TSX PMU profiling with virtualization.

- How to tune it:
Use perf with the TSX extensions and the statistics exposed in
/sys/module/rtm_locks
You may need the latest hsw/pmu* branch from
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git

- Why does this use RTM and not HLE
RTM is more flexible and we don't need HLE in this code.

Andi Kleen
ak@linux.intel.com
Speaking for myself only
