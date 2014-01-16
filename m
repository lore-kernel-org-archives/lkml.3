Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAPCDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:03:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10030 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750941AbaAPCDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:03:25 -0500
Message-Id: <20140116015824.201732155@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 20:58:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 0/8] Linux 3.2.53-rt76-rc1
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.2.53-rt76-rc1.

Note, the reason I did not release this earlier, was that I found
that the v3.2-rt series was locking up with my cpu hotplug stress test.
I finally got some time to debug this, and found that the problem was
in the invalidate_bh_lrs() where it was stuck in the on_each_cpu() call
where it was waiting for an offline CPU. Looking at what 3.4-rt does,
which does not have this problem, there were three patches in mainline
from Gilad Ben-Yossef that appears to fix the issue. At least it
makes the symptom go away. I may look into this deeper to make sure
that we did not just make a race window much harder to hit, and really
did fix the problem. But as 3.2-rt is now as stable as 3.4-rt and later
I can finally release this candidate.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 1/17/2014.

Enjoy,

-- Steve


To build 3.2.53-rt76-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.53.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.53-rt76-rc1.patch.xz

You can also build from 3.2.53-rt75 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.53-rt75-rt76-rc1.patch.xz


Changes from 3.2.53-rt75:

---


Gilad Ben-Yossef (3):
      smp: introduce a generic on_each_cpu_mask() function
      smp: add func to IPI cpus based on parameter func
      fs: only send IPI to invalidate LRU BH when needed

Peter Zijlstra (1):
      lockdep: Correctly annotate hardirq context in irq_exit()

Sebastian Andrzej Siewior (2):
      swait: Add a few more users
      rtmutex: use a trylock for waiter lock in trylock

Steven Rostedt (Red Hat) (1):
      Linux 3.2.53-rt76-rc1

Tiejun Chen (1):
      cpu_down: move migrate_enable() back

----
 arch/arm/kernel/smp_tlb.c                  | 20 ++-----
 arch/tile/include/asm/smp.h                |  7 ---
 arch/tile/kernel/smp.c                     | 19 -------
 drivers/net/wireless/orinoco/orinoco_usb.c |  2 +-
 drivers/usb/gadget/f_fs.c                  |  2 +-
 drivers/usb/gadget/inode.c                 |  4 +-
 fs/buffer.c                                | 15 ++++-
 include/linux/smp.h                        | 46 +++++++++++++++
 include/linux/spinlock_rt.h                |  1 +
 kernel/cpu.c                               |  2 +-
 kernel/rtmutex.c                           | 31 ++++++++--
 kernel/smp.c                               | 90 ++++++++++++++++++++++++++++++
 kernel/softirq.c                           | 45 ++++++++++++++-
 kernel/timer.c                             |  2 +-
 localversion-rt                            |  2 +-
 15 files changed, 232 insertions(+), 56 deletions(-)
