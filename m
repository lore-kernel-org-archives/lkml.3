Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaKXNF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:05:28 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38731 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaKXNDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:03:42 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 0/7] ACCESS_ONCE and non-scalar accesses
Date: Mon, 24 Nov 2014 14:03:23 +0100
Message-Id: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0017-0000-0000-000001F464BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed on LKML http://marc.info/?i=54611D86.4040306%40de.ibm.com
ACCESS_ONCE might fail with specific compiler for non-scalar accesses.

Here is a set of patches to tackle that problem. (The first patch
is already in kvm/next).
The last patch will force ACCESS_ONCE to error-out if it is used
on non-scalar accesses.
I have cross-compiled the resulting kernel with defconfig for
microblaze, m68k, alpha, s390,x86_64, i686, sparc, sparc64, mips,
ia64, arm and arm64.

So hopefully this patch set should be complete regarding the non-scalar
accesses. (As Linus pointed out, accesses > word size are a problem
on its own, but this patch set does not tackle this)

The result is also available as 0d199efcfc9875b8de17bb4fe1d87a27bd39a172
on
git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git ACCESS_ONCE

Now:
- It would be good to have the changes reviewed by component experts.
- It would also be good if architecture maintainers could double check, that
  "kernel: Force ACCESS_ONCE to work only on scalar types" does not break
  anything beyond defconfig.
- some comments about cc stable

Thanks

Christian
----------------------------------------------------------------
Christian Borntraeger (7):
      KVM: s390: Fix ipte locking
      mm: replace page table access via ACCESS_ONCE with barriers
      x86: Rework ACCESS_ONCE for spinlock code
      x86: Replace ACCESS_ONCE in gup with a barrier
      mips: Replace ACCESS_ONCE in gup with a barrier
      arm64: Replace ACCESS_ONCE for spinlock code with barriers
      kernel: Force ACCESS_ONCE to work only on scalar types

 arch/arm64/include/asm/spinlock.h |  7 +++++--
 arch/mips/mm/gup.c                |  6 ++++--
 arch/s390/kvm/gaccess.c           | 20 ++++++++++++++------
 arch/x86/include/asm/spinlock.h   | 14 +++++++++-----
 arch/x86/mm/gup.c                 |  7 +++++--
 include/linux/compiler.h          | 12 +++++++++++-
 mm/gup.c                          |  4 +++-
 mm/memory.c                       |  3 ++-
 mm/rmap.c                         |  3 ++-
 9 files changed, 55 insertions(+), 21 deletions(-)

