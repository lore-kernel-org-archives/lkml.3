Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaATMkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:40:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51547 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:05 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 00/11] change scheduler domain hierarchy set-up
Date: Mon, 20 Jan 2014 12:39:37 +0000
Message-Id: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 20 Jan 2014 12:40:01.0441 (UTC) FILETIME=[BC5FB110:01CF15DC]
X-MC-Unique: 114012012400206801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCeq5t003786

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch-set cleans up the scheduler domain (sd) level initialisation
code.  It is based on the idea of Peter Zijlstra to use a single sd
init function sketched here: https://lkml.org/lkml/2013/11/5/239

The sd level data for conventional (SMT, MC, BOOK, CPU) sd levels which
can be set by the arch comprises the cpu mask and the sd topology flags
for this level.

An arch can either use the existing sd level hierarchy defined in the
scheduler core or specify its own complete sd level hierarchy in its
topology shim layer.

This clean-up is necessary because some of the arch specific settings
are just bitrot or accidents.  So far, additional arch specific sd
topology flags are set via flag specific weak functions, like
SD_ASYM_PACKING.  If in the future, we want to further distinguish the
functionality of the different sd levels based on more topology
information (e.g. Vincent's SD_SHARE_POWERDOMAIN flag) we do need a
better interface than this.

Changes in v2:

1) Export struct sched_domain_topology_info and set_sd_topology_info()
   towards the arch to enable it to customize sched domain topology
   data.

2) Keep a default topology setup inside the scheduler for the
   conventional sched domain levels.

3) Sched domain level topology flags can be specified dependent on
   runtime information (e.g. cpu feature) and per cpu.

4) Move struct sched_domain from interface header file into private
   scheduler header file for data encapsulation purposes.  With the
   deletion of the arch specific sd init macros and the sd ptr arg in
   arch_scale_freq_power(), struct sched_domain is no longer needed
   outside the scheduler core code.

What does the patch-set try to achieve:

1) Let the arch define the conventional (SMT, MC, BOOK, CPU) sched
   domain hierarchy.  The arch specifies per sched domain level the
   pointer to the getter function of the corresponding cpu mask and
   the topology flags as well as the name of the sched domain level,
   the latter for debug purposes.

2) Unify the set-up code for conventional and NUMA scheduler domains.
   All scheduler domain topology levels are now allocated in the same
   function sched_init_topology().  All scheduler domains now use a
   common init function sd_init() which makes the existing SD_FOO_INIT
   macros redundant.

3) The arch is no longer limited to the default sched domain levels
   (SMT, MC, BOOK, CPU) but can easily define its own sched domain level
   hierarchy.

4) Prepare the mechanics to make it easier to integrate the provision of
   additional topology related data (e.g. energy information) to the
   scheduler.

Current limitations:

1) The patch-set has only been tested on ARM TC2 (2 clusters, one with 2
   Cortex A15 and the other with 3 Cortex A7) and on an Intel i5-520M (2
   cores with 2 threads each) platform.

2) For other archs it has only been compile tested for certain
   configurations (powerpc: chroma_defconfig, mips: ip27_defconfig,
   s390: defconfig, tile: tilegx_defconfig).

The patch-set is against v3.13-rc8.

Dietmar Eggemann (11):
  sched: define sched_domain_topology_info
  sched: export cpu_smt_mask() and cpu_cpu_mask()
  sched: define TOPOLOGY_SD_FLAGS
  sched: replace SD_INIT_FUNC with sd_init()
  sched: add a name to sched_domain_topology_info
  sched: delete redundant sd init macros
  sched: consolidate sched_init_numa() and sched_init_conv()
  sched: introduce a func ptr for sd topology flags
  sched: provide SD_ASYM_PACKING via topology info table
  sched: delete sd ptr arg in arch_scale_freq_power()
  sched: un-export struct sched_domain

 arch/arm/kernel/topology.c        |    4 +-
 arch/ia64/include/asm/topology.h  |   24 ---
 arch/metag/include/asm/topology.h |   27 ---
 arch/powerpc/kernel/smp.c         |   34 +++-
 arch/s390/include/asm/topology.h  |    2 -
 arch/tile/include/asm/topology.h  |   33 ----
 include/linux/sched.h             |  119 ++++---------
 include/linux/topology.h          |  127 ++------------
 kernel/sched/core.c               |  351 ++++++++++++++++++-------------------
 kernel/sched/fair.c               |   10 +-
 kernel/sched/sched.h              |  169 ++++++++++++++----
 11 files changed, 384 insertions(+), 516 deletions(-)

-- 
1.7.9.5


