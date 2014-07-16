Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaGPUf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:35:28 -0400
Received: from borg.tf-network.de ([62.75.218.204]:40427 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaGPUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:35:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 16:35:25 EDT
Message-ID: <53C6E07A.7070303@whissi.de>
Date: Wed, 16 Jul 2014 22:28:42 +0200
From: "Thomas D." <whissi@whissi.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Backport request for 3.14 stable to use rdmsrl_safe() first when
 initializing RAPL PMU to allow KVM guests to boot on Intel hosts
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I upgraded my KVM guest from linux-3.10.48 to linux-3.14.12 and
rebooting into the new kernel failed with

  [     0.930047] Call Trace:
  [     0.930047]  [<ffffffff81af1d36>] rapl_pmu_init+0xae/0x1b4
  [     0.930047]  [<ffffffff81af1c88>] ? uncore_cpu_setup+0x13/0x13
  [     0.930047]  [<ffffffff81000332>] do_one_initcall+0x112/0x160
  [     0.930047]  [<ffffffff810df618>] ? parse_args+0x1e8/0x320
  [     0.930047]  [<ffffffff81aea02c>] kernel_init_freeable+0x173/0x1fe
  [     0.930047]  [<ffffffff81ae9842>] ? do_early_param+0x88/0x88
  [     0.930047]  [<ffffffff815c4d20>] ? rest_init+0x80/0x80
  [     0.930047]  [<ffffffff815c4d2e>] kernel_init+0xe/0xf0
  [     0.930047]  [<ffffffff815da56c>] ret_from_fork+0x7c/0xb0
  [     0.930047]  [<ffffffff815c4d20>] ? rest_init+0x80/0x80
  [     0.930047] Code: 8b 14 10 e8 b0 47 1b 00 48 85 c0 49 89 c6 0f 84
8f 00 00 00 31 c0 b9 06 06 00 00 66 41 89 06 49 8d 46 10 49 89 46 10 49
89 46 18 <0f> 32 48 c1 e8 08 66 b9 1f 00 49 c7 46 20 c0 c7 a1 81 83 e0 1f
  [     0.930047] RIP  [<ffffffff8101f4b3>] rapl_cpu_prepare+0x83/0x110
  [     0.930047]  RSP <ffff88007c777dc0>
  [     0.953901] ---[ end trace 1a5a32cf5298005d ]---
  [     0.954374] Kernel panic - not syncing: Fatal exception
  [     0.954947] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)

I started a kernel bisect and the bad commit causing the problem was

commit 4788e5b4b2338f85fa42a712a182d8afd65d7c58
Author: Stephane Eranian <eranian@google.com>
Date:   Tue Nov 12 17:58:50 2013 +0100

    perf/x86: Add Intel RAPL PMU support

    [...]


In v3.15 this bug is already fixed with commit


commit 24223657806a0ebd0ae5c9caaf7b021091889cf2
Author: Venkatesh Srinivas <venkateshs@google.com>
Date:   Thu Mar 13 12:36:26 2014 -0700

    perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

    CPUs which should support the RAPL counters according to
    Family/Model/Stepping may still issue #GP when attempting to access
    the RAPL MSRs. This may happen when Linux is running under KVM and
    we are passing-through host F/M/S data, for example. Use rdmsrl_safe
    to first access the RAPL_POWER_UNIT MSR; if this fails, do not
    attempt to use this PMU.



Could you please help me getting this fix into 3.14 stable kernel?

I am not sure if applying 24223657 against 3.14 stable is enough. That's
why I am posting this to linux-kernel@vger following the "Reporting bugs
for the Linux kernel" guide (linux-kernel@vger is the mailing list for
the perf subsystem according to the the MAINTAINERS file) instead of
posting this to the stable@vger list.
Please correct me if I am doing something wrong. This is my first time
doing something like that.

Thanks!

Bugzilla: https://bugs.gentoo.org/show_bug.cgi?id=516908


-Thomas
