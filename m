Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaLELSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:18:23 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37109 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaLELSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:18:20 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v1 0/5] Reenable might_sleep() checks for might_fault()
Date: Fri,  5 Dec 2014 12:18:04 +0100
Message-Id: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120511-0029-0000-0000-00000209737F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently discovered that might_fault() doesn't call might_sleep() anymore.
Therefore bugs like:
	spin_lock(&lock);
	rc = copy_to_user(...);
	spin_unlock(&lock);
would not be detected with CONFIG_DEBUG_ATOMIC_SLEEP. The code was changed to
disable false positives for code like:
	pagefault_disable();
	rc = copy_to_user(...);
	pagefault_enable();

Until now, pagefault_disable() and pagefault_enable() simply modified the
preempt count, therefore telling the pagefault handler that the context is
atomic and sleeping is disallowed.

In order to reenable might_sleep() checks for the correct path, we need a way to
detect whether we run in a pagefault_disable() context.

This series therefore introduces a separate pagefault_count and uses it to count
the levels of pagefault_disable() per thread. might_sleep() checks are
reactivated for the !pagefault_disable() path.

So this should now work:
	spin_lock(&lock); /* also if left away */
	pagefault_disable()
	rc = copy_to_user(...);
	pagefault_enable();
	spin_unlock(&lock);
And this should report a warning again:
	spin_lock(&lock);
	rc = copy_to_user(...);
	spin_unlock(&lock);

Please note that this series will not completely split the handling of
pagefault_disable() and the preempt count. This will be done in another series.
Purpose of this series is to reenable might_sleep() checks for might_fault(),
avoiding to produce false positives.

Cross compiled on powerpc, arm, sparc, sparc64, arm64, x86_64, i386, mips,
alpha, ia64, xtensa, m68k, microblaze.

Tested on s390. Would be good to get some feedback on the ASM offsets for m32r,
sparc and xtensa (or if I should simply move the count to the end of the struct
for these archs ...).

Thanks!

David


David Hildenbrand (5):
  uaccess: add pagefault_count to thread_info
  uaccess: count pagefault_disable() levels in pagefault_count
  mm, uaccess: trigger might_sleep() in might_fault() when pagefaults
    are disabled
  uaccess: clearify that uaccess may only sleep if pagefaults are not
    disabled
  uaccess: CONFIG_DEBUG_PAGEFAULT_COUNT to debug pagefault_count

 arch/alpha/include/asm/thread_info.h      |  1 +
 arch/arc/include/asm/thread_info.h        |  1 +
 arch/arm/include/asm/thread_info.h        |  1 +
 arch/arm64/include/asm/thread_info.h      |  1 +
 arch/avr32/include/asm/thread_info.h      |  1 +
 arch/avr32/include/asm/uaccess.h          | 12 +++++---
 arch/blackfin/include/asm/thread_info.h   |  1 +
 arch/c6x/include/asm/thread_info.h        |  1 +
 arch/cris/include/asm/thread_info.h       |  1 +
 arch/frv/include/asm/thread_info.h        |  1 +
 arch/hexagon/include/asm/thread_info.h    |  1 +
 arch/hexagon/include/asm/uaccess.h        |  3 +-
 arch/ia64/include/asm/thread_info.h       |  1 +
 arch/m32r/include/asm/thread_info.h       |  5 +--
 arch/m32r/include/asm/uaccess.h           | 30 ++++++++++++------
 arch/m68k/include/asm/thread_info.h       |  1 +
 arch/metag/include/asm/thread_info.h      |  1 +
 arch/microblaze/include/asm/thread_info.h |  1 +
 arch/microblaze/include/asm/uaccess.h     |  6 ++--
 arch/mips/include/asm/thread_info.h       |  1 +
 arch/mips/include/asm/uaccess.h           | 45 ++++++++++++++++++---------
 arch/mn10300/include/asm/thread_info.h    |  1 +
 arch/openrisc/include/asm/thread_info.h   |  1 +
 arch/parisc/include/asm/thread_info.h     |  1 +
 arch/powerpc/include/asm/thread_info.h    |  1 +
 arch/s390/include/asm/thread_info.h       |  1 +
 arch/s390/include/asm/uaccess.h           | 15 ++++++---
 arch/score/include/asm/thread_info.h      |  1 +
 arch/score/include/asm/uaccess.h          | 15 ++++++---
 arch/sh/include/asm/thread_info.h         |  1 +
 arch/sparc/include/asm/thread_info_32.h   | 20 ++++++------
 arch/sparc/include/asm/thread_info_64.h   | 17 ++++++-----
 arch/tile/include/asm/thread_info.h       |  1 +
 arch/tile/include/asm/uaccess.h           | 21 ++++++++-----
 arch/um/include/asm/thread_info.h         |  1 +
 arch/unicore32/include/asm/thread_info.h  |  1 +
 arch/x86/include/asm/thread_info.h        |  1 +
 arch/x86/include/asm/uaccess.h            | 15 ++++++---
 arch/x86/include/asm/uaccess_32.h         |  6 ++--
 arch/x86/lib/usercopy_32.c                |  6 ++--
 arch/xtensa/include/asm/thread_info.h     |  5 +--
 include/linux/kernel.h                    |  3 +-
 include/linux/uaccess.h                   | 51 ++++++++++++++++++++++++++-----
 lib/Kconfig.debug                         |  9 ++++++
 lib/strnlen_user.c                        |  6 ++--
 mm/maccess.c                              | 11 +++++++
 mm/memory.c                               | 19 +++++-------
 47 files changed, 245 insertions(+), 101 deletions(-)

-- 
1.8.5.5

