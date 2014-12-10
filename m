Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaLJPxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:10 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48737 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaLJPxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:06 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET -mm] bitmap, cpumask, nodemask: implement pr_cont functions and use di"
Date: Wed, 10 Dec 2014 10:52:42 -0500
Message-Id: <1418226774-30215-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

bitmap implements two variants of scnprintf functions to format a
bitmap into a string and cpumask and nodemask wrap them to provide
equivalent interfaces.  The scnprintf family of functions require a
string buffer as an output target which complicates code paths which
just want to print out the mask through printk for informational or
debug purposes as they have to worry about how large the buffer should
be and whether it's too large to allocate on stack.

Neither cpumask or nodemask provides a guildeline on how large the
target buffer should be forcing users come up with their own solutions
- some allocate an arbitrarily sized buffer which is small enough to
allocate on stack but may be too short in corner cases, other come up
with a custom upper limit calculation considering the output format,
some allocate the buffer dynamically while one resorted to using lock
to synchronize access to a static buffer.

This is an artificial problem which is being solved repeatedly for no
benefit.  In a lot of cases, the output area already exists and can be
targeted directly making the intermediate buffer unnecessary.  This
patchset implement pr_cont variants of the formatting functions and
convert the scnprintf output function users to use them or seq_*()
functions to directly target the output area and remove the
intermediate buffers where possible.

This patchset contains the following 12 patches.

 0001-bitmap-restructure-bitmap_sn-list-printf.patch
 0002-bitmap-cpumask-nodemask-implement-pr_cont-variants-o.patch
 0003-mips-use-cpu-node-mask-pr_cont-and-seq-output-functi.patch
 0004-powerpc-use-cpu-node-mask-pr_cont-and-seq-output-fun.patch
 0005-tile-use-cpu-node-mask-pr_cont-and-seq-output-functi.patch
 0006-x86-use-cpu-node-mask-pr_cont-and-seq-output-functio.patch
 0007-xtensa-use-cpu-node-mask-pr_cont-and-seq-output-func.patch
 0008-cpuset-use-cpu-node-mask-pr_cont-and-seq-output-func.patch
 0009-rcu-use-cpu-node-mask-pr_cont-and-seq-output-functio.patch
 0010-sched-use-cpu-node-mask-pr_cont-and-seq-output-funct.patch
 0011-timer-use-cpu-node-mask-pr_cont-and-seq-output-funct.patch
 0012-percpu-use-cpu-node-mask-pr_cont-and-seq-output-func.patch

The first two patches implement the pr_cont variants of the formatting
functions.  The rest convert the existing users to pr_cont and seq
functions subsystem-by-subsystem.  It'd be the easiest to route all
through -mm but the conversion patches can go through individual
subsystem trees afterwards if necessary.

While there's ~70 line increase in LOC, the increase is from the
restructuring of bitmap output functions and addition of inline
interface functions along with comments and things get simplified /
more robust on the user side and future users won't have to try to
solve the same fruitless problem over and over again.

The patchset is based on top of -mm as of Dec 9, 2014 and also
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-bitmap-pr_cont

 arch/mips/netlogic/common/smp.c     |   11 +-
 arch/powerpc/sysdev/xics/ics-opal.c |    7 -
 arch/powerpc/sysdev/xics/ics-rtas.c |    8 -
 arch/tile/kernel/hardwall.c         |    6 -
 arch/tile/kernel/proc.c             |    6 -
 arch/tile/kernel/setup.c            |   12 +-
 arch/tile/mm/homecache.c            |   14 +--
 arch/tile/mm/init.c                 |   12 +-
 arch/x86/mm/numa.c                  |    9 --
 arch/x86/platform/uv/uv_nmi.c       |   27 ++----
 arch/xtensa/kernel/setup.c          |   10 --
 drivers/net/ethernet/tile/tilegx.c  |    6 -
 drivers/net/ethernet/tile/tilepro.c |    6 -
 include/linux/bitmap.h              |    4 
 include/linux/cpumask.h             |   18 ++++
 include/linux/nodemask.h            |   16 +++
 kernel/cpuset.c                     |   13 ---
 kernel/rcu/tree_plugin.h            |    6 -
 kernel/sched/core.c                 |   11 +-
 kernel/sched/stats.c                |   11 --
 kernel/time/tick-sched.c            |   12 --
 lib/bitmap.c                        |  148 ++++++++++++++++++++++++++----------
 mm/percpu.c                         |    7 -
 23 files changed, 224 insertions(+), 156 deletions(-)

Thanks.

--
tejun
