Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3I1K6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:58:20 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:32927 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3I1K6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:58:17 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 0/3] changes to enable lockless lockref on s390
Date: Sat, 28 Sep 2013 12:58:08 +0200
Message-Id: <1380365891-34457-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092810-3548-0000-0000-000006AECA65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I just updated the patch set to include your suggested changes.

You can also pull the three patches from

  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git lockref

Original part of description that still matters:

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

Heiko Carstens (3):
  mutex: replace CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX with simple ifdef
  lockref: use arch_mutex_cpu_relax() in CMPXCHG_LOOP()
  s390: enable ARCH_USE_CMPXCHG_LOCKREF

 arch/Kconfig                      |  3 ---
 arch/s390/Kconfig                 |  2 +-
 arch/s390/include/asm/mutex.h     |  2 --
 arch/s390/include/asm/processor.h |  2 ++
 arch/s390/include/asm/spinlock.h  |  5 +++++
 include/linux/mutex.h             |  6 +++---
 lib/lockref.c                     | 10 +++++++++-
 7 files changed, 20 insertions(+), 10 deletions(-)

-- 
1.8.3.4

