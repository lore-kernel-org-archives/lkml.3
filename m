Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3LMML0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:11:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50772 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3LMMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:22 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 0/8] change scheduler domain hierarchy set-up
Date: Fri, 13 Dec 2013 12:11:20 +0000
Message-Id: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 13 Dec 2013 12:11:19.0288 (UTC) FILETIME=[6E317F80:01CEF7FC]
X-MC-Unique: 113121312111907001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCC6oY009910

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch-set cleans up the scheduler domain level initialization code.
It is based on the idea of Peter Zijlstra to use a single scheduler domain
init function sketched here: https://lkml.org/lkml/2013/11/5/239 

What does the patch-set try to achieve:

1) Let the arch define the conventional (here defined to all levels except
   the NUMA levels) scheduler domain hierarchy.  The arch specifies per
   scheduler domain the pointer to the getter function of the
   corresponding cpu mask as well as the topology related scheduler
   domain flags.

2) Unify the set-up code for conventional and NUMA scheduler domains.
   All scheduler domain topology levels are now allocated in the same
   function and the scheduler does not rely on a default scheduler
   domain topology array any more.  All scheduler domains now use a
   common initialization function which makes the existing SD_FOO_INIT
   macros redundant.

3) The arch is no longer limited to the existing scheduler domain levels
   (SMT, MC, BOOK, CPU) but can easily define additional levels.

4) Prepare the mechanics to make it easier to integrate the provision of
   additional topology related data (e.g. energy information) to the
   scheduler.

Current limitations:

1) The arch interface for scheduler domain set-up is only implemented for
   the ARM and the x86 arch and tested on an ARM TC2 (2 clusters, one with
   2 Cortex A15 and the other with 3 Cortex A7) and an Intel i5-520M (2
   cores with 2 threads each) platform.   

2) For other archs it has only been compile tested for certain
   configurations (powerpc: chroma_defconfig, mips: ip27_defconfig,
   s390: defconfig, tile: tilegx_defconfig).  Obviously, linking these
   kernels doesn't succeed due to the missing arch interface for
   scheduler domain set-up implementation (undefined reference to
   arch_sched_domain_info).

3) It does not delete the arch specific SD_FOO_INIT macros for ia64,
   metag, s390 and tile arch.

4) It does not delete the arch_sd_sibling_asym_packing function which
   will be redundant once the arch interface for scheduler domain set-up
   has been implemented for powerpc arch.

5) There is no default set-up any more.  Each arch has to define a
   arch_sched_domain_info array, a circumstance which might not be
   desirable.

6) It has to be specified what happens when an arch specifies an
   arch_sched_domain_info array with only a { NULL, } entry.

The patch-set is against v3.13-rc3.

I restrict the discussion to the scheduler community for now and will cc
the arch maintainer later, in case some level of agreement over these
patches can be reached.

Dietmar Eggemann (8):
  sched: arch interface for scheduler domain setup
  arm: implement arch interface for scheduler domain setup
  x86: implement arch interface for scheduler domain setup
  sched: allocate the entire topology array dynamically
  sched: introduce common topology level init function
  sched: replace for_each_sd_topology with explicit for loop
  sched: replace topology level init func ptr with sd_init
  sched: remove scheduler domain naming

 arch/arm/kernel/topology.c |    8 +
 arch/x86/kernel/topology.c |   12 ++
 include/linux/sched.h      |    3 -
 include/linux/topology.h   |  156 +++++-------------
 kernel/sched/core.c        |  380 +++++++++++++++++++++-----------------------
 kernel/sched/sched.h       |   19 +++
 6 files changed, 258 insertions(+), 320 deletions(-)

-- 
1.7.9.5


