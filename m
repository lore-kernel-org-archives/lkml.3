Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbaD2ObL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:31:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58934 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbaD2ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:31:09 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Hedi Berriche <hedi@sgi.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: [PATCH 0/3] kdb: Infrastructure to display sequence files
Date: Tue, 29 Apr 2014 15:30:37 +0100
Message-Id: <1398781841-15152-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset started out as a simple patch to introduce the irqs
command from Android's FIQ debugger to kdb. However it has since grown
more powerful because allowing kdb to reuse existing kernel
infrastructure gives us extra opportunities.

Based on the comments at the top of irqdesc.h (plotting to take the
irq_desc structure private to kernel/irq) and the relative similarity
between FIQ debugger's irqs command and the contents /proc/interrupts
we start by adding a kdb feature to print seq_files. This forms the 
foundation for a new command, interrupts.

I have also been able to implement a much more generic command,
seq_file, that can display a good number of files from pseudo
filesystems. This command is very powerful although that power does mean
care must be taken to deploy it safely. It is deliberately and by
default aimed at your foot!

Note that the risk associated with the seq_file command is why I
implemented the interrupts command in C (in principle it could have been
a kdb macro). Doing it in C codifies the need for show_interrupts() to
continue using spin locks as its locking strategy.

To give an idea of what can be done with this command. The following
seq_operations structures worked correctly and report no errors:

    cpuinfo_op
    extfrag_op
    fragmentation_op
    gpiolib_seq_ops
    int_seq_ops (a.k.a. /proc/interrupts)
    pagetypeinfo_op
    unusable_op
    vmalloc_op
    zoneinfo_op

The following display the information correctly but triggered errors
(sleeping function called from invalid context) with lock debugging
enabled:

    consoles_op
    crypto_seq_ops
    diskstats_op
    partitions_op
    slabinfo_op
    vmstat_op

All tests are run on an ARM multi_v7_defconfig kernel (plus lots of
debug features) and halted using magic SysRq so that kdb has interrupt
context. Note also that some of the seq_operations structures hook into
driver supplied code that will only be called if that driver is enabled
so the test above are useful but cannot be exhaustive.

Daniel Thompson (3):
  kdb: Add framework to display sequence files
  proc: Provide access to /proc/interrupts from kdb
  kdb: Implement seq_file command

 fs/proc/interrupts.c        | 10 +++++++++
 include/linux/kdb.h         |  3 +++
 kernel/debug/kdb/kdb_io.c   | 51 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_main.c | 28 +++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

-- 
1.9.0

