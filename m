Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaBWGRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:17:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:42691 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaBWGRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:17:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,527,1389772800"; 
   d="scan'208";a="342951924"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v5 0/3] Intel MPX support 
Date: Sun, 23 Feb 2014 21:27:48 +0800
Message-Id: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Memory Protection Extensions
(MPX) feature found in future Intel processors.

MPX can be used in conjunction with compiler changes to check memory
references, for those references whose compile-time normal intentions
are usurped at runtime due to buffer overflow or underflow.

MPX provides this capability at very low performance overhead for
newly compiled code, and provides compatibility mechanisms with legacy
software components. MPX architecture is designed allow a machine to
run both MPX enabled software and legacy software that is MPX unaware.
In such a case, the legacy software does not benefit from MPX, but it
also does not experience any change in functionality or reduction in
performance.

More information about Intel MPX can be found in "Intel(R) Architecture
Instruction Set Extensions Programming Reference".

To get the advantage of MPX, changes are required in the OS kernel,
binutils, compiler, system libraries support.

New GCC option -fmpx is introduced to utilize MPX instructions.
Currently GCC compiler sources with MPX support is available in a
separate branch in common GCC SVN repository. See GCC SVN page
(http://gcc.gnu.org/svn.html) for details.

To have the full protection, we had to add MPX instrumentation to all
the necessary Glibc routines (e.g. memcpy) written on assembler, and
compile Glibc with the MPX enabled GCC compiler. Currently MPX enabled
Glibc source can be found in Glibc git repository.

Enabling an application to use MPX will generally not require source
code updates but there is some runtime code, which is responsible for
configuring and enabling MPX, needed in order to make use of MPX.
For most applications this runtime support will be available by linking
to a library supplied by the compiler or possibly it will come directly
from the OS once OS versions that support MPX are available.

MPX kernel code, namely this patchset, has mainly the 2 responsibilities:
provide handlers for bounds faults (#BR), and manage bounds memory.

Currently no hardware with MPX ISA is available but it is always
possible to use SDE (Intel(R) software Development Emulator) instead,
which can be downloaded from
http://software.intel.com/en-us/articles/intel-software-development-emulator


Changes since v1:
  * check to see if #BR occurred in userspace or kernel space.
  * use generic structure and macro as much as possible when
    decode mpx instructions.

Changes since v2:
  * fix some compile warnings.
  * update documentation.

Changes since v3:
  * correct some syntax errors at documentation, and document
    extended struct siginfo.
  * for kill the process when the error code of BNDSTATUS is 3.
  * add some comments.
  * remove new prctl() commands.
  * fix some compile warnings for 32-bit.

Changes since v4:
  * raise SIGBUS if the allocations of the bound tables fail.

Qiaowei Ren (3):
  x86, mpx: add documentation on Intel MPX
  x86, mpx: hook #BR exception handler to allocate bound tables
  x86, mpx: extend siginfo structure to include bound violation
    information

 Documentation/x86/intel_mpx.txt    |  239 +++++++++++++++++++++++++
 arch/x86/include/asm/mpx.h         |   54 ++++++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/mpx.c              |  335 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c            |   62 +++++++-
 include/uapi/asm-generic/siginfo.h |    9 +-
 kernel/signal.c                    |    4 +
 7 files changed, 702 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/x86/intel_mpx.txt
 create mode 100644 arch/x86/include/asm/mpx.h
 create mode 100644 arch/x86/kernel/mpx.c

