Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaIEGhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:37:36 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60827 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIEGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:37:34 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, hare@suse.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de, santosh@chelsio.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v2 0/6] driver-core: add asynch probe support
Date: Thu,  4 Sep 2014 23:37:21 -0700
Message-Id: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Here's a complete reimplementation of asynch loading support, it
discards completely the hippie / pipe dream idea that we need asynch
loading of modules / subsystems in general and just addresses running
probe asynchronously. This respin is based on Tejun's recommendation
on how to treat the probe asynchronously, we avoid async_schedule()
completely and just peg a struct work_struct on the driver private
structure. This obviously also means we have to flush_work() before
the driver's own remove() is called, we do that too.

Tejun's concerns on this regressing some driver's scripts which expect
the device to be available after loading remains valid, and the only
thing we can do to help there is to annotate the expecations on the
use of this "feature" to driver users. Scripts should be not be relying
on the driver init anyway so that type of usage should be phased out
and they should be hunting in udev for things popping up.

I'm a bit concerned about this actually regressing load time on
drivers that use this though instead of just having the module
probe run off of finit_module() though. Even with a kthread alternative
at least Santosh (Cc'd) has noted a regression in terms of time it
takes to complete probe on cxgb4. I'll eventually get your exact
numbers, but for now its an obvious regression *with* kthreads,
this solution goes with:

queue_work(system_unbound_wq, async_probe_work)

This is surely going to make things even worse... We could
use system_highpri_wq, or change the scheduling priority, but
for that I'd prefer to get feedback and someone to decide what
the right choice (TM) should be.

It is very important to highlight that async probe was added here
in light of issues found on *two* domains now that creeped up in
parallel:

0) some built-in drivers delaying init
1) systemd 30 second timeout

I have been exchanging some e-mails with Tetsuo about his
original proposed work around that started this work when the
systemd 30 second timeout issue creeped up first, this series
includes a slightly modified version of that work around
which should address the sigkill even without 786235ee merged.
There may be others -- and that needs to be witch hunted.
It would also now safely allow us to find drivers that run
over the limit without killing systems / modules. I think that's
probably the best thing to do for now -- as we sweep through and
find these, we could eventually nuke the WARN_ONCE() and completely
listen to the kill. For now its just causing more problems than
solving anything, but its a good reflection of balance of desires
and design between userspace / kernelspace.

Luis R. Rodriguez (6):
  driver-core: generalize freeing driver private member
  driver-core: add driver async_probe support
  kthread: warn on kill signal if not OOM
  cxgb4: use async probe
  mptsas: use async probe
  pata_marvell: use async probe

 drivers/ata/pata_marvell.c                      |  1 +
 drivers/base/base.h                             |  6 +++
 drivers/base/bus.c                              | 72 ++++++++++++++++++++++---
 drivers/base/dd.c                               |  4 ++
 drivers/message/fusion/mptsas.c                 |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  1 +
 include/linux/device.h                          |  5 ++
 kernel/kmod.c                                   | 21 +++++++-
 kernel/kthread.c                                | 19 +++++++
 9 files changed, 122 insertions(+), 8 deletions(-)

-- 
2.0.3

