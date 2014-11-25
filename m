Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaKYMmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:42:18 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50550 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaKYMir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:38:47 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCHv2 00/10] ACCESS_ONCE and non-scalar accesses
Date: Tue, 25 Nov 2014 13:38:27 +0100
Message-Id: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112512-0021-0000-0000-000001E7A91F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed on LKML http://marc.info/?i=54611D86.4040306%40de.ibm.com
ACCESS_ONCE might fail with specific compiler for non-scalar accesses.

Here is a set of patches to tackle that problem.

The first patch is already in kvm/next and this series is against rc3 (as
kvm/next so that we can avoid a merge conflict as soon as this series
has stabilized).
The 2nd patch introduces READ_ONCE/ASSIGN_ONCE as suggested by Linus.
The 2nd to last patch will force ACCESS_ONCE to error-out if it is used
on non-scalar accesses.

I have cross-compiled the resulting kernel with defconfig for
microblaze, m68k, alpha, s390,x86_64, i686, sparc, sparc64, mips,
ia64, arm and arm64.
Will Deacon pointed me to the right defconfig for arm32 to also trigger
a finding here.
Runtime testing was only done on s390x.

There is a small problem left with sparc (32bit) and m68k:

mm/rmap.c: In function 'mm_find_pmd':
include/linux/compiler.h:220:72: warning: '__val' may be used uninitialized in this function [-Wmaybe-uninitialized]
       ({ typeof(p) __val; __read_once_size(&p, &__val, sizeof(__val)); __val; })
                                                                        ^
include/linux/compiler.h:220:20: note: '__val' was declared here
       ({ typeof(p) __val; __read_once_size(&p, &__val, sizeof(__val)); __val; })
                    ^
mm/rmap.c:584:9: note: in expansion of macro 'READ_ONCE'
  pmde = READ_ONCE(*pmd);

Reason is that for both architectures pmd_t is long[16]. WTF?

So the next spin will either fix m68k/sparc or use a barrier + ACCESS_ONCE.

Comments?

Christian Borntraeger (10):
  KVM: s390: Fix ipte locking
  kernel: Provide READ_ONCE and ASSIGN_ONCE
  mm: replace ACCESS_ONCE with READ_ONCE
  x86/spinlock: Replace ACCESS_ONCE with READ_ONCE/ASSIGN_ONCE
  x86: Replace ACCESS_ONCE in gup with READ_ONCE
  mips: Replace ACCESS_ONCE in gup with READ_ONCE
  arm64: Replace ACCESS_ONCE for spinlock code with READ_ONCE
  arm: Replace ACCESS_ONCE for spinlock code with READ_ONCE
  tighten rules for ACCESS ONCE
  KVM: s390: change ipte lock from barrier to READ_ONCE

 arch/arm/include/asm/spinlock.h   |  4 ++--
 arch/arm64/include/asm/spinlock.h |  4 ++--
 arch/mips/mm/gup.c                |  2 +-
 arch/s390/kvm/gaccess.c           | 14 +++++++------
 arch/x86/include/asm/spinlock.h   |  8 +++----
 arch/x86/mm/gup.c                 |  2 +-
 include/linux/compiler.h          | 44 ++++++++++++++++++++++++++++++++++++++-
 mm/gup.c                          |  2 +-
 mm/memory.c                       |  2 +-
 mm/rmap.c                         |  2 +-
 10 files changed, 64 insertions(+), 20 deletions(-)


