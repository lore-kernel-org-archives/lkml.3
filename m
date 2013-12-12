Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3LLBKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:10:03 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60312 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3LLBJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:09:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/3] Introduce simple wait queues
Date: Wed, 11 Dec 2013 20:06:36 -0500
Message-ID: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple wait queue support has existed for quite some time (at least
since 3.4) in the preempt-rt kernels.  At this years RT summit, we agreed
that it makes sense to do the final cleanups on it and aim to mainline it.

It is similar to normal waitqueue support, but without some of the less
used functionality, giving it a smaller footprint vs. the normal wait queue.

For non-RT, we can still benefit from the footprint reduction factor.  Here
in this series, we deploy the simple wait queues in two places: (1) for
completions, and (2) in RCU processing.  As can be seen below from the bloat
meter, we still come out ahead even after adding the new swait code.  Plus
there are other deployment places pending, for additional benefits.

Thomas originally created it in order to avoid issues with the waitqueue head
lock on RT, as it can't be converted to a raw lock, which in turn limits the
contexts from which you can manipulate wait queues.  The simple wait queue
head uses a raw lock and hence queue manipulations can be done while atomic.

Output from:
 ./scripts/bloat-o-meter ../simplewait-absent/vmlinux ../simplewait-present/vmlinux
-----------------------------------------------------------------------------------
add/remove: 15/0 grow/shrink: 3/46 up/down: 821/-822 (-1)
function                                     old     new   delta
__swake_up_locked                              -     156    +156
swait_prepare                                  -     112    +112
__swake_up                                     -      88     +88
swait_finish                                   -      83     +83
rcu_nocb_kthread                             718     793     +75
swait_prepare_locked                           -      61     +61
swait_finish_locked                            -      55     +55
nfs_file_direct_read                         665     693     +28
__kstrtab___init_swaitqueue_head               -      23     +23
__init_swaitqueue_head                         -      23     +23
__ksymtab_swait_prepare                        -      16     +16
__ksymtab_swait_finish                         -      16     +16
__ksymtab___swake_up                           -      16     +16
__ksymtab___init_swaitqueue_head               -      16     +16
vermagic                                      27      42     +15
__kstrtab_swait_prepare                        -      14     +14
__kstrtab_swait_finish                         -      13     +13
__kstrtab___swake_up                           -      11     +11
rsp_wakeup                                    30      28      -2
rcu_report_qs_rnp                            287     285      -2
__call_rcu_nocb_enqueue                      181     179      -2
wait_rcu_gp                                   76      69      -7
submit_bio_wait                              103      96      -7
nfs_file_direct_write                        721     714      -7
kobj_completion_init                          59      52      -7
init_pcmcia_cs                                61      54      -7
i8042_probe                                 1602    1595      -7
i2c_del_adapter                              610     603      -7
hpet_cpuhp_notify                            273     266      -7
flush_kthread_worker                         112     105      -7
flow_cache_flush                             346     339      -7
ext4_init_fs                                 631     624      -7
ext4_fill_super                            11746   11739      -7
drop_sysctl_table                            184     177      -7
device_pm_sleep_init                         105      98      -7
crypto_larval_alloc                          155     148      -7
autofs4_expire_indirect                     1024    1017      -7
autofs4_expire_direct                        253     246      -7
ata_port_alloc                               431     424      -7
usb_start_wait_urb                           324     316      -8
loop_switch.isra                             151     143      -8
devtmpfs_delete_node                         191     183      -8
cpuidle_add_sysfs                            191     183      -8
cpuidle_add_device_sysfs                     402     394      -8
cache_wait_req.isra                          315     307      -8
devtmpfs_create_node                         275     264     -11
kthread                                      227     213     -14
usb_stor_probe1                             1746    1730     -16
usb_sg_init                                  753     737     -16
scsi_complete_async_scans                    320     304     -16
flush_kthread_work                           277     261     -16
do_fork                                      766     750     -16
do_coredump                                 3540    3524     -16
_rcu_barrier                                 632     616     -16
rcu_init_one                                1069    1040     -29
rcu_gp_kthread                              1578    1538     -40
wait_for_completion_timeout                  261     213     -48
wait_for_completion_io_timeout               261     213     -48
wait_for_completion_io                       248     200     -48
wait_for_completion                          248     200     -48
wait_for_completion_interruptible_timeout    286     235     -51
wait_for_completion_killable_timeout         316     253     -63
wait_for_completion_killable                 349     286     -63
wait_for_completion_interruptible            335     268     -67

Two notes with respect to bloat:

1) vermagic being larger is just noise; vanilla is v3.13-rc3 and swait is
   3.13.0-rc3-00003-ga0388b5 because I had LOCALVERSION_AUTO enabled.

2) The nfs_file_direct_read increase appears to be the butterfly effect
   causing gcc to do some rethinking of how it optimizes things; disassembly
   showed different register choices here and there, but no big obvious
   change such as inline-ing a function or similar. (gcc-4.8.1)


Testing:
--------
Comparison of v3.13-r3-vanilla vs. v3.13-r3-simplewait, RCU configured as:

CONFIG_TREE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_USER_QS=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y

Timing defconfig build of v3.13-rc3, with rcu's offloaded to
core zero (for i in `pgrep rcuo` ; do taskset -c -p 0 $i ; done)
and build run on 1-7 (single socket quad hyperthread dell 990)

 # make clean ; make defconfig ; reboot, ssh in...
 git status
 sync
 time taskset -c 1-7 make -j20 > /dev/null

Do above run three times each to gauge consistency.

   v3.13-r3-vanilla
   ----------------
real    2m19.486s
user    13m7.091s
sys     0m47.647s

real    2m19.061s
user    13m10.232s
sys     0m47.846s

real    2m18.864s
user    13m8.623s
sys     0m47.942s

   v3.13-r3-simplewait
   -------------------
real    2m19.271s
user    13m7.845s
sys     0m48.028s

real    2m18.374s
user    13m9.828s
sys     0m48.084s

real    2m18.344s
user    13m8.528s
sys     0m48.014s


So in this particular test, it looks like the change is lost in
the noise.  At least there isn't any blatant regressions.

A rcutorture run has been going for 2 1/2 hrs so far and hasn't
spit out any failure type messages so far...


Changes vs. the 3.10-rt patches it was based on:
------------------------------------------------
Warning: Not probably interesting to anyone other than RT folks who
have played with the previous versions of the patches.

-prior to 3.13, some of the wait and completion code was still in
 sched/core.c so I've had to relocate accordingly.

-the -rt adapt to completion patch did some renaming of the simple
 wait boilerplate; that has been pushed back down into the simplewait
 introductory commit.

-where possible, I've aligned the names of the simple wait
 functions to be just the normal wait functions, but with the added
 "s" prefix.  This makes review easier, and avoids bugs like we
 had in -rt where, swake_up was confused as a replacement for wake_all
 In -rt this was a separate patch from me; it is now squashed into
 the simplewait introductory commit as well.

-in -rt the file was include/wait-simple.h ; here I've used swait.h
 since it is more in alignment with the function names used above.

-in RT, there were two tracing_off() additions based on the
 value of migrate_disable_atomic, but the latter is RT specific,
 so drop those two chunks for this mainline version.

-in the -rt, we will still need PeterZ's follow on patch to ensure
 we don't call an unlimited number of ttwu with a raw lock held, but
 for now, I'd rather keep that as -rt specific; hoping we can find a
 better solution..?  http://marc.info/?l=linux-kernel&m=138089860308430&w=2

Paul.
---

Thomas Gleixner (3):
  wait-simple: Introduce the simple waitqueue implementation
  sched/core: convert completions to use simple wait queues
  rcu: use simple wait queues where possible in rcutree

 include/linux/completion.h |   8 +-
 include/linux/swait.h      | 220 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/uprobes.h    |   1 +
 kernel/Makefile            |   2 +-
 kernel/rcu/tree.c          |  16 ++--
 kernel/rcu/tree.h          |   7 +-
 kernel/rcu/tree_plugin.h   |  14 +--
 kernel/sched/completion.c  |  34 +++----
 kernel/swait.c             | 118 ++++++++++++++++++++++++
 9 files changed, 380 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/swait.h
 create mode 100644 kernel/swait.c

--
1.8.5.1

