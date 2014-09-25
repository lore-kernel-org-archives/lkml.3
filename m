Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaIYJ5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:57:07 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:42018 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaIYJ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:57:05 -0400
Message-ID: <1411639019.15810.31.camel@marge.simpson.net>
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 11:56:59 +0200
In-Reply-To: <20140925091556.GB5430@worktop>
References: <20140924081845.572814794@infradead.org>
	 <1411633803.15810.12.camel@marge.simpson.net>
	 <20140925090619.GA5430@worktop> <20140925091556.GB5430@worktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 11:15 +0200, Peter Zijlstra wrote:

> I suppose just flipping the scheudle() and try_to_freeze() should do the
> trick. Ugly code that, but then again, I think audit is known for that.
> 
> Can you give that a go?

Yeah, seems that fixed that one.

And thanks to my clever ratelimiting, printk() no longer goes gaga as it
emits this one.. forever.  This boot is gonna take a while too :)


[   53.951297] BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
[   54.044733] in_atomic(): 1, irqs_disabled(): 0, pid: 2676, name: modprobe
[   54.120213] CPU: 42 PID: 2676 Comm: modprobe Tainted: G            E  3.17.0-default #5
[   54.212540] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[   54.294917]  0000000000000000 ffff880273f83838 ffffffff815b2ff2 ffff880273f83848
[   54.377182]  ffffffff8108d156 ffff880273f83878 ffffffff8108d1d8 ffff88026e71e600
[   54.459679]  ffff880273f83898 ffff88026e71e748 ffff88026e71e744 ffff880273f838f8
[   54.542107] Call Trace:
[   54.573965]  [<ffffffff815b2ff2>] dump_stack+0x72/0x88
[   54.635104]  [<ffffffff8108d156>] ___might_sleep+0xd6/0x110
[   54.700956]  [<ffffffff8108d1d8>] __might_sleep+0x48/0xd0
[   54.765821]  [<ffffffff8146c1d5>] cpufreq_freq_transition_begin+0x75/0x140
[   54.842571]  [<ffffffffa0548523>] pcc_cpufreq_target+0x63/0x208 [pcc_cpufreq]
[   54.923403]  [<ffffffff810dec5f>] ? update_ts_time_stats+0x7f/0xb0
[   54.996678]  [<ffffffff8146c725>] __cpufreq_driver_target+0x85/0x170
[   55.067871]  [<ffffffff8146ed98>] od_check_cpu+0xa8/0xb0
[   55.126035]  [<ffffffff8146f7c0>] dbs_check_cpu+0x180/0x1d0
[   55.191425]  [<ffffffff8146fbc0>] cpufreq_governor_dbs+0x3b0/0x720
[   55.259809]  [<ffffffff8146f493>] od_cpufreq_governor_dbs+0x33/0xe0
[   55.329556]  [<ffffffff81469cb9>] __cpufreq_governor+0xa9/0x210
[   55.396925]  [<ffffffff8146a892>] cpufreq_set_policy+0x1e2/0x2e0
[   55.462852]  [<ffffffff8146afac>] cpufreq_init_policy+0x8c/0x110
[   55.462854]  [<ffffffff8146d270>] ? cpufreq_update_policy+0x1b0/0x1b0
[   55.462857]  [<ffffffff8146cf96>] __cpufreq_add_dev+0x596/0x6b0
[   55.462859]  [<ffffffffa054d608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
[   55.462861]  [<ffffffff8146d0be>] cpufreq_add_dev+0xe/0x10
[   55.462863]  [<ffffffff8140eef1>] subsys_interface_register+0xc1/0xf0
[   55.462865]  [<ffffffff8146bcb7>] cpufreq_register_driver+0x117/0x2a0
[   55.462868]  [<ffffffffa054d65d>] pcc_cpufreq_init+0x55/0x9f8 [pcc_cpufreq]
[   55.462870]  [<ffffffffa054d608>] ? pcc_cpufreq_probe+0x4b4/0x4b4 [pcc_cpufreq]
[   55.462873]  [<ffffffff81000298>] do_one_initcall+0xc8/0x1f0
[   55.462875]  [<ffffffff811a581d>] ? __vunmap+0x9d/0x100
[   55.462877]  [<ffffffff810e9680>] do_init_module+0x30/0x1b0
[   55.462878]  [<ffffffff810ebaaa>] load_module+0x67a/0x700
[   55.462879]  [<ffffffff810e9800>] ? do_init_module+0x1b0/0x1b0
[   55.462881]  [<ffffffff810ebcdb>] SyS_init_module+0x9b/0xc0
[   55.462883]  [<ffffffff815b86a9>] system_call_fastpath+0x16/0x1b
[   55.463467] BUG: sleeping function called from invalid context at drivers/cpufreq/cpufreq.c:370
[   55.463468] in_atomic(): 1, irqs_disabled(): 0, pid: 2676, name: modprobe
[   55.463469] CPU: 42 PID: 2676 Comm: modprobe Tainted: G         









