Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3I0IEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:04:09 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55491 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3I0IEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:04:01 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/3] changes to enable lockless lockref on s390
Date: Fri, 27 Sep 2013 10:03:51 +0200
Message-Id: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092708-1948-0000-0000-0000066D03CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

enabling the new lockless lockref variant on s390 would have been trivial
until Tony Luck added a cpu_relax() call into the CMPXCHG_LOOP(), with
d472d9d9 "lockref: Relax in cmpxchg loop".

As already mentioned cpu_relax() is very expensive on s390 since it yields()
the current virtual cpu. So we are talking of several thousand cycles.
Considering this enabling the lockless lockref variant would contradict the
intention of the new semantics. And also some quick measurements show
performance regressions of 50% and more.

Simply removing the cpu_relax() call again seems also not very desireable
since Waiman Long reported that for some workloads the call improved
performance by 5%.

So let's go for a special cpu_relax() variant which can be overridden by
architectures. We have already an arch_mutex_cpu_relax() variant for the
very same purpose, but especially for mutexes.
Since I wouldn't like to add yet another cpu_relax() variant, e.g.
"arch_lockref_cpu_relax()", rename the already present variant to
cpu_relax_simple(), which can be used for both, mutexes and lockrefs.

Not sure if it would make sense to add a new "linux/processor.h"
include file which includes "asm/processor.h", since there doesn't seem to
be a common file where it is guaranteed that cpu_relax() is available.

I simply added the cpu_relax_simple() define to "linux/spinlock_up.h"
since that one explicitly includes "asm/processor.h" because of cpu_relax().

Heiko Carstens (3):
  mutex,spinlock: rename arch_mutex_cpu_relax() to cpu_relax_simple()
  lockref: use cpu_relax_simple()
  s390: enable ARCH_USE_CMPXCHG_LOCKREF

 arch/Kconfig                      | 2 +-
 arch/s390/Kconfig                 | 3 ++-
 arch/s390/include/asm/mutex.h     | 2 --
 arch/s390/include/asm/processor.h | 2 ++
 arch/s390/include/asm/spinlock.h  | 5 +++++
 include/linux/mutex.h             | 4 ----
 include/linux/spinlock_up.h       | 4 ++++
 kernel/mutex.c                    | 8 ++++----
 lib/lockref.c                     | 2 +-
 9 files changed, 19 insertions(+), 13 deletions(-)

-- 
1.8.3.4

