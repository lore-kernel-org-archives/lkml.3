Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3IJPaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:30:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23523 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3IJPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:30:09 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, david.vrabel@citrix.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v1 0/5] xen/PMU: PMU support for Xen PV guests
Date: Tue, 10 Sep 2013 11:31:45 -0400
Message-Id: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Linux side of Xen PMU support for PV guests, including dom0. Only
kernel changes are here, toolstack patch will be provided separately.

Here is description from the hypervisor patch submission that applies to this
series as well:

This version has following limitations:
* For accurate profiling of dom0/Xen dom0 VCPUs should be pinned.
* Hypervisor code is only profiled on processors that have running dom0 VCPUs
on them.
* No backtrace support.
* Will fail to load under XSM: we ran out of bits in permissions vector and
this needs to be fixed separately


A few notes that may help reviewing:

* A shared data structure (xenpmu_data_t) between each PV VPCU and hypervisor
CPU is used for passing registers' values as well as PMU state at the time of
PMU interrupt.

* PMU interrupts are taken by hypervisor at NMI level for both HVM and PV.

* Guest's interrupt handler does not read/write PMU MSRs directly. Instead, it
accesses xenpmu_data_t and flushes it to HW it before returning.

* PMU mode is controlled at runtime via /sys/hypervisor/pmu/pmu/{pmu_mode,pmu_flags}
in addition to 'vpmu' boot option (which is preserved for back compatibility).
The following modes are provided:
  * disable: VPMU is off
  * enable: VPMU is on. Guests can profile themselves, dom0 profiles itself and Xen
  * priv_enable: dom0 only profiling. dom0 collects samples for everyone. Sampling
    in guests is suspended.

* /proc/xen/xensyms file exports hypervisor's symbols to dom0 (similar to
  /proc/kallsyms)

* VPMU infrastructure is now used for both HVM and PV and therefore has been moved
up from hvm subtree



Boris Ostrovsky (5):
  xen: xensyms support
  xen/PMU: Sysfs interface for setting Xen PMU mode
  xen/PMU: Initialization code for Xen PMU
  xen/PMU: Add support for PMU registes on PV guests
  xen/PMU: Cache MSR accesses during interrupt handling

 arch/x86/include/asm/xen/hypercall.h |   6 +
 arch/x86/xen/Makefile                |   2 +-
 arch/x86/xen/enlighten.c             |  27 ++-
 arch/x86/xen/pmu.c                   | 422 +++++++++++++++++++++++++++++++++++
 arch/x86/xen/pmu.h                   |  15 ++
 arch/x86/xen/smp.c                   |  31 ++-
 arch/x86/xen/xen-head.S              |   5 +-
 drivers/xen/Kconfig                  |   5 +
 drivers/xen/sys-hypervisor.c         | 118 ++++++++++
 drivers/xen/xenfs/Makefile           |   1 +
 drivers/xen/xenfs/super.c            |   3 +
 drivers/xen/xenfs/xenfs.h            |   1 +
 drivers/xen/xenfs/xensyms.c          | 170 ++++++++++++++
 include/xen/interface/platform.h     |  21 ++
 include/xen/interface/xen.h          |   2 +
 include/xen/interface/xenpmu.h       | 127 +++++++++++
 16 files changed, 947 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/xen/pmu.c
 create mode 100644 arch/x86/xen/pmu.h
 create mode 100644 drivers/xen/xenfs/xensyms.c
 create mode 100644 include/xen/interface/xenpmu.h

-- 
1.8.1.4

