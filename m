Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaIXRUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:20:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41615 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbaIXRUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:20:15 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, benh@kernel.crashing.org, chris@zankel.net,
        cmetcalf@tilera.com, davem@davemloft.net, deller@gmx.de,
        dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, jcmvbkbc@gmail.com, jesper.nilsson@axis.com,
        mingo@redhat.com, monstr@monstr.eu, paulmck@linux.vnet.ibm.com,
        rdunlap@infradead.org, sam@ravnborg.org, schwidefsky@de.ibm.com,
        starvik@axis.com, takata@linux-m32r.org, tglx@linutronix.de,
        tony.luck@intel.com, daniel.thompson@linaro.org, broonie@linaro.org,
        linux@arm.linux.org.uk, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Wed, 24 Sep 2014 18:17:19 +0100
Message-Id: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

This is version three of the series I've originally posted here:

  v1: https://lkml.org/lkml/2014/4/17/269
  v2: https://lkml.org/lkml/2014/5/22/468

This is basically just a rebase on top of 3.17-rc6, minus the alpha patch
(which was merged into mainline).

I looked at reworking the non-relaxed accessors to imply mmiowb, but it
quickly got messy as some architectures (e.g. mips) deliberately keep
mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't trust
drivers to get mmiowb correct, so add barriers to both. Given that
arm/arm64/x86 don't care about mmiowb, I've left that as an exercise for
an architecture that does care.

In order to get this lot merged, we probably want to merge the asm-generic
patch (1/17) first, so Acks would be much appreciated on the architecture
bits.

As before, I've included the original cover letter below, as that describes
what I'm trying to do in more detail.

Thanks,

Will

--->8

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


Will Deacon (17):
  asm-generic: io: implement relaxed accessor macros as conditional
    wrappers
  microblaze: io: remove dummy relaxed accessor macros
  s390: io: remove dummy relaxed accessor macros for reads
  xtensa: io: remove dummy relaxed accessor macros for reads
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
 arch/sparc/include/asm/io_32.h    |  4 ----
 arch/sparc/include/asm/io_64.h    |  8 ++------
 arch/tile/include/asm/io.h        |  4 ++++
 arch/x86/include/asm/io.h         |  4 ++++
 arch/xtensa/include/asm/io.h      |  7 -------
 include/asm-generic/io.h          | 10 ++++++++++
 19 files changed, 79 insertions(+), 46 deletions(-)

-- 
2.1.0

