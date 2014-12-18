Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaLRL3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:29:55 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43344 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaLRL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:29:54 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/9] kernel: Provide READ_ONCE and ASSIGN_ONCE
Date: Thu, 18 Dec 2014 12:30:11 +0100
Message-Id: <1418902211-2888-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121811-0013-0000-0000-000002431838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

here is the first part of the ACCESS_ONCE vs. non-scalar types rework.
I deferred the final patch as linux-next already contains new offenders.
I will provide the final patch (kernel: tighten rules for
ACCESS ONCE) in linux-next after rc1 together with some fixups.
This will make sure that any new offenders will get a warning or error
when _THEY_ add such code. Last time it was already too late to fixup
linux-next before the merge window.

So here are READ_ONCE, ASSIGN_ONCE and a bunch of fixups. I branched away
from a patch in kvm/next to avoid a merge conflict. This will result in
a slightly different diffstat in case you merge kvm/for-linus first
( 10 files changed, 103 insertions(+), 25 deletions(-))

Christian

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git  tags/for-linus

for you to fetch changes up to 5de72a2247ac05bde7c89039631b3d0c6186fafb:

  s390/kvm: REPLACE barrier fixup with READ_ONCE (2014-12-18 09:54:41 +0100)

----------------------------------------------------------------
kernel: Provide READ_ONCE and ASSIGN_ONCE

As discussed on LKML http://marc.info/?i=54611D86.4040306%40de.ibm.com
ACCESS_ONCE might fail with specific compilers for non-scalar accesses.

Here is a set of patches to tackle that problem.

The first patch introduce READ_ONCE and ASSIGN_ONCE. If the data structure
is larger than the machine word size memcpy is used and a warning is emitted.
The next patches fix up several in-tree users of ACCESS_ONCE on non-scalar
types.

This merge does not yet contain a patch that forces ACCESS_ONCE to work only
on scalar types. This is targetted for the next merge window as Linux next
already contains new offenders regarding ACCESS_ONCE vs. non-scalar types.

----------------------------------------------------------------
Christian Borntraeger (9):
      KVM: s390: Fix ipte locking
      kernel: Provide READ_ONCE and ASSIGN_ONCE
      mm: replace ACCESS_ONCE with READ_ONCE or barriers
      x86/spinlock: Replace ACCESS_ONCE with READ_ONCE
      x86/gup: Replace ACCESS_ONCE with READ_ONCE
      mips/gup: Replace ACCESS_ONCE with READ_ONCE
      arm64/spinlock: Replace ACCESS_ONCE READ_ONCE
      arm/spinlock: Replace ACCESS_ONCE with READ_ONCE
      s390/kvm: REPLACE barrier fixup with READ_ONCE

 arch/arm/include/asm/spinlock.h   |  4 +--
 arch/arm64/include/asm/spinlock.h |  4 +--
 arch/mips/mm/gup.c                |  2 +-
 arch/s390/kvm/gaccess.c           | 14 ++++----
 arch/x86/include/asm/spinlock.h   |  8 ++---
 arch/x86/mm/gup.c                 |  2 +-
 include/linux/compiler.h          | 74 +++++++++++++++++++++++++++++++++++++++
 mm/gup.c                          |  2 +-
 mm/memory.c                       | 11 +++++-
 mm/rmap.c                         |  3 +-
 10 files changed, 105 insertions(+), 19 deletions(-)

