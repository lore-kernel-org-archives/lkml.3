Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbbA1ABw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:01:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:39631 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbbA1ABu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052491"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH V3 0/6] x86: Intel Cache Allocation Support
Date: Tue, 27 Jan 2015 16:00:03 -0800
Message-Id: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new cgroup subsystem to support the new Cache Allocation 
Technology (CAT) feature found in future Intel Xeon processors.

Cache Allocation Technology(CAT) provides a way for the Software
(OS/VMM) to restrict cache allocation to a defined 'subset' of cache
which may be overlapping with other 'subsets'. This feature is used
when allocating a line in cache ie when pulling new data into the cache.

This patch series is dependent on the patches for Intel Cache QOS Monitoring 
from Matt since the series also implements a common software cache for the 
IA32_PQR_MSR :
https://lkml.kernel.org/r/1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk

Changes in V3:
- Implements a common software cache for IA32_PQR_MSR
- Implements support for hsw CAT enumeration. This does not use the brand 
strings like earlier version but does a probe test. The probe test is done only 
on hsw family of processors
- Made a few coding convention, name changes and minor fixes

Changes in V2:
- Removed HSW specific enumeration changes. Plan to include it later as a
  seperate patch.  
- Fixed the code in prep_arch_switch to be specific for x86 and removed
  x86 defines.
- Fixed cbm_write to not write all 1s when a cgroup is freed.
- Fixed one possible memory leak in init.  
- Changed some of manual bitmap
  manipulation to use the predefined bitmap APIs to make code more readable
- Changed name in sources from cqe to cat
- Global cat enable flag changed to static_key and disabled cgroup early_init

Vikas Shivappa (6):
  x86/intel_cat: Intel Cache Allocation Technology detection
  x86/intel_cat: Adds support for Class of service management
  x86/intel_cat: Support cache bit mask for Intel CAT
  x86/intel_cat: Implement scheduling support for Intel CAT
  x86/intel_rdt: Software Cache for IA32_PQR_MSR
  x86/intel_cat: Intel haswell CAT enumeration

 arch/x86/include/asm/cpufeature.h          |   6 +-
 arch/x86/include/asm/intel_cat.h           |  99 ++++++++
 arch/x86/include/asm/processor.h           |   3 +
 arch/x86/include/asm/rdt.h                 |  13 +
 arch/x86/include/asm/switch_to.h           |   3 +
 arch/x86/kernel/cpu/Makefile               |   1 +
 arch/x86/kernel/cpu/common.c               |  16 ++
 arch/x86/kernel/cpu/intel_cat.c            | 367 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_cqm.c |  20 +-
 include/linux/cgroup_subsys.h              |   4 +
 init/Kconfig                               |  11 +
 kernel/sched/core.c                        |   1 +
 kernel/sched/sched.h                       |   3 +
 13 files changed, 533 insertions(+), 14 deletions(-)
 create mode 100644 arch/x86/include/asm/intel_cat.h
 create mode 100644 arch/x86/include/asm/rdt.h
 create mode 100644 arch/x86/kernel/cpu/intel_cat.c

-- 
1.9.1

