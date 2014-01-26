Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaAZB4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 20:56:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:41673 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaAZB4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 20:56:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,721,1384329600"; 
   d="scan'208";a="470834173"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v3 0/4] Intel MPX support
Date: Sun, 26 Jan 2014 17:08:54 +0800
Message-Id: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
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

Qiaowei Ren (4):
  x86, mpx: add documentation on Intel MPX
  x86, mpx: hook #BR exception handler to allocate bound tables
  x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
  x86, mpx: extend siginfo structure to include bound violation
    information

 Documentation/x86/intel_mpx.txt    |  226 ++++++++++++++++++++
 arch/x86/Kconfig                   |    4 +
 arch/x86/include/asm/mpx.h         |   63 ++++++
 arch/x86/include/asm/processor.h   |   16 ++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/mpx.c              |  415 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c            |   61 +++++-
 include/uapi/asm-generic/siginfo.h |    9 +-
 include/uapi/linux/prctl.h         |    6 +
 kernel/signal.c                    |    4 +
 kernel/sys.c                       |   12 +
 11 files changed, 815 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/x86/intel_mpx.txt
 create mode 100644 arch/x86/include/asm/mpx.h
 create mode 100644 arch/x86/kernel/mpx.c

