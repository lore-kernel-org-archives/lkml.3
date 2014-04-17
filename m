Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaDQNrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:47:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48852 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757062AbaDQNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:45:01 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO accessors
Date: Thu, 17 Apr 2014 14:44:03 +0100
Message-Id: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This RFC series attempts to define a portable (i.e. cross-architecture)
definition of the {readX,writeX}_relaxed MMIO accessor functions. These
functions are already in widespread use amongst drivers (mainly those supporting
devices embedded in ARM SoCs), but lack any well-defined semantics and,
subsequently, any portable definitions to allow these drivers to be compiled for
other architectures.

The two main motivations for this series are:

 (1) To promote use of the _relaxed MMIO accessors on weakly-ordered
     architectures, where they can bring significant performance improvements
     over their non-relaxed counterparts.

 (2) To allow COMPILE_TEST to build drivers using the relaxed accessors across
     all architectures.

The proposed semantics largely match exactly those provided by the ARM
implementation (i.e. no weaker), with one exception (see below).

Informally:

  - Relaxed accesses to the same device are ordered with respect to each other.

  - Relaxed accesses are *not* guaranteed to be ordered with respect to normal
    memory accesses (e.g. DMA buffers -- this is what gives us the performance
    boost over the non-relaxed versions).

  - Relaxed accesses are not guaranteed to be ordered with respect to
    LOCK/UNLOCK operations.

In actual fact, the relaxed accessors *are* ordered with respect to LOCK/UNLOCK
operations on ARM[64], but I have added this constraint for the benefit of
PowerPC, which has expensive I/O barriers in the spin_unlock path for the
non-relaxed accessors.

A corollary to this is that mmiowb() probably needs rethinking. As it currently
stands, an mmiowb() is required to order MMIO writes to a device from multiple
CPUs, even if that device is protected by a lock. However, this isn't often used
in practice, leading to PowerPC implementing both mmiowb() *and* synchronising
I/O in spin_unlock.

I would propose making the non-relaxed I/O accessors ordered with respect to
LOCK/UNLOCK, leaving mmiowb() to be used with the relaxed accessors, if
required, but would welcome thoughts/suggestions on this topic.

All feedback welcome,

Will


Will Deacon (18):
  asm-generic: io: implement relaxed accessor macros as conditional
    wrappers
  microblaze: io: remove dummy relaxed accessor macros
  s390: io: remove dummy relaxed accessor macros for reads
  xtensa: io: remove dummy relaxed accessor macros for reads
  alpha: io: implement relaxed accessor macros for writes
  frv: io: implement dummy relaxed accessor macros for writes
  cris: io: implement dummy relaxed accessor macros for writes
  ia64: io: implement dummy relaxed accessor macros for writes
  m32r: io: implement dummy relaxed accessor macros for writes
  m68k: io: implement dummy relaxed accessor macros for writes
  mn10300: io: implement dummy relaxed accessor macros for writes
  parisc: io: implement dummy relaxed accessor macros for writes
  powerpc: io: implement dummy relaxed accessor macros for writes
  sparc: io: implement dummy relaxed accessor macros for writes
  tile: io: implement dummy relaxed accessor macros for writes
  x86: io: implement dummy relaxed accessor macros for writes
  documentation: memory-barriers: clarify relaxed io accessor semantics
  asm-generic: io: define relaxed accessor macros unconditionally

 Documentation/memory-barriers.txt | 13 +++++++++----
 arch/alpha/include/asm/io.h       | 12 ++++++++----
 arch/cris/include/asm/io.h        |  3 +++
 arch/frv/include/asm/io.h         |  3 +++
 arch/ia64/include/asm/io.h        |  4 ++++
 arch/m32r/include/asm/io.h        |  3 +++
 arch/m68k/include/asm/io.h        |  8 ++++++++
 arch/m68k/include/asm/io_no.h     |  4 ----
 arch/microblaze/include/asm/io.h  |  8 --------
 arch/mn10300/include/asm/io.h     |  4 ++++
 arch/parisc/include/asm/io.h      | 12 ++++++++----
 arch/powerpc/include/asm/io.h     | 12 ++++++++----
 arch/s390/include/asm/io.h        |  5 -----
 arch/sparc/include/asm/io.h       |  9 +++++++++
 arch/sparc/include/asm/io_32.h    |  3 ---
 arch/sparc/include/asm/io_64.h    | 22 ++++++++++------------
 arch/tile/include/asm/io.h        |  4 ++++
 arch/x86/include/asm/io.h         |  4 ++++
 arch/xtensa/include/asm/io.h      |  7 -------
 include/asm-generic/io.h          | 23 ++++++++++++++++-------
 20 files changed, 101 insertions(+), 62 deletions(-)

-- 
1.9.1

