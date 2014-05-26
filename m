Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaEZQ5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:57:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:43464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaEZQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122305"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by xsaves/xrstors 
Date: Mon, 26 May 2014 10:01:07 -0700
Message-Id: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

With ever growing extended state registers (xstate) on x86 processors, kernel
needs to cope with issue of growing memory space occupied by xstate. The xsave
area is holding more and more xstate registers, growing from legacy FP and
SSE to AVX, AVX2, AVX-512, MPX, and Intel PT.

The recently introduced compacted format of xsave area saves xstates only
for enabled states. This patch set saves the xsave area space per process
in compacted format by xsaves/xrstors instructions.

xsaves/xrstors also supports modified optimization which tracks modified
xstates and only saves modified xstates to xsave area to improve saving
performance.

For more information about xsaves/xrstors instructions, please refer
to latest Intel X86 SDM.


Fenghua Yu (15):
  x86/xsaves: Detect xsaves/xrstors feature
  x86/xsaves: Add kernel parameter to disable xsaves/xrstors
  x86/alternative: Add alternative_input_2
  x86/xsaves: Change compacted format xsave area header
  x86/xsaves: Define macros for xsave instructions
  x86/xsaves: Define macro for handle xsave/xrstor fault
  x86/xsaves: Use xsaves/xrstors for saving and restoring xsave area
  x86/xsaves: Use xsaves/xrstors for context switch
  x86/xsaves: Use xsave/xrstor for saving and restoring user space
    context
  x86/xsaves: Clear reserved bits in xsave header
  x86/xsaves: Add xsaves and xrstors support for booting time
  x86/xsaves: Save xstate to task's xsave area in __save_fpu during
    booting time
  x86/xsaves: Call booting time xsaves and xrstors in setup_init_fpu_buf
  x86/xsaves: Enable xsaves/xrstors
  Define kernel API to get address of each state in xsave area

 Documentation/kernel-parameters.txt   |   9 ++
 arch/x86/include/asm/alternative.h    |  13 ++
 arch/x86/include/asm/cpufeature.h     |   2 +
 arch/x86/include/asm/fpu-internal.h   |   9 +-
 arch/x86/include/asm/processor.h      |   4 +-
 arch/x86/include/asm/xsave.h          | 220 +++++++++++++++++++++++++---------
 arch/x86/include/uapi/asm/msr-index.h |   2 +
 arch/x86/kernel/cpu/common.c          |   8 ++
 arch/x86/kernel/cpu/scattered.c       |   1 +
 arch/x86/kernel/i387.c                |   2 +-
 arch/x86/kernel/process.c             |   1 +
 arch/x86/kernel/xsave.c               | 112 +++++++++++++++--
 12 files changed, 313 insertions(+), 70 deletions(-)

-- 
1.8.1.2

