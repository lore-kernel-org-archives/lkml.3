Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569Ab3DEFJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:09:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51708 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab3DEFJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:09:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nishanth Menon <nm@ti.com>, Greg Guyotte <gguyotte@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: regulator: query on regulator re-entrance
Date: Fri, 5 Apr 2013 00:09:42 -0500
Message-ID: <1365138582-10409-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam, Mark,
TI platforms typically use Adaptive Voltage Scaling technique to determine
an optimal voltage on top of the traditional DVFS strategy to optimize power.

Depending on the SoC, we use AVS class 0, 1, 1.5, 2, 3. In general,
the AVS strategy is pretty much like a regulator which then gives command
to the PMIC for the optimal voltage to choose.

For example, on AM335x(beaglebone) platform, we use AVS class 2 strategy.
Ref[1]
If we ignore the details of the class 1.5 implementation, we will notice
a) regulator set_voltage equivalent set_voltage() is required.
b) this set_voltage does some 'magic stuff' depending on the SoC and AVS class
and calls the 'real regulator' which talks to the PMIC over i2c/spi etc..
in short the call sequence is more or less:

driver (cpufreq) -> AVS -> PMIC regulator.

By modeling AVS class drivers as an regulator, we then do not need to introduce
SoC specific hacks and APIs.
driver (cpufreq) -> AVS regulator -> PMIC regulator.
However, we then need ability to have regulator calls while in the context of
another regulator. Taking this to the next level we might want to chain
multiple regulators as well (example of additional strategy of ABB discussed
here[2]).

In short, an regulator which is also an consumer.

As a proof of concept, I wrote up a dummy AVS class 2 driver (without AVS
functionality)[3] - result is an lockdep warning[4].

I believe there'd be other similar user's who might find it useful to have
regulator chaining. However, considering that regulator framework has
been around for a while, the generic question is: are we ok to allow for
changes to let regulators be re-enterant? If this is interesting, then, I
am curious to know if there are any attempts to do this already in progress.
If interesting and no attempts, then we'd be interested in collaborating for it.

Ref:
[1] https://github.com/Angstrom-distribution/meta-ti/blob/master/recipes-kernel/linux/linux-am335x-3.2.0-psp04.06.00.08/0001-am33xx-Add-SmartReflex-support.patch
[2] http://marc.info/?t=136483993400003&r=1&w=2
[3] http://pastebin.com/yttSEQ0j
[4] lockdep warning
/sys/devices/system/cpu/cpu0/cpufreq # cat scaling_available_frequencies
300000 600000 800000 
/sys/devices/system/cpu/cpu0/cpufreq # echo -n "300000">scaling_setspeed
[   28.409606] 
[   28.411193] =============================================
[   28.416900] [ INFO: possible recursive locking detected ]
[   28.422607] 3.9.0-rc3-00064-g5e75410-dirty #39 Not tainted
[   28.428375] ---------------------------------------------
[   28.434082] sh/782 is trying to acquire lock:
[   28.438690]  (&rdev->mutex){+.+.+.}, at: [<c033e5d8>] regulator_get_voltage+0x18/0x38
[   28.447021] 
[   28.447021] but task is already holding lock:
[   28.453186]  (&rdev->mutex){+.+.+.}, at: [<c033e5d8>] regulator_get_voltage+0x18/0x38
[   28.461486] 
[   28.461486] other info that might help us debug this:
[   28.468414]  Possible unsafe locking scenario:
[   28.468414] 
[   28.474670]        CPU0
[   28.477264]        ----
[   28.479858]   lock(&rdev->mutex);
[   28.483367]   lock(&rdev->mutex);
[   28.486877] 
[   28.486877]  *** DEADLOCK ***
[   28.486877] 
[   28.493164]  May be due to missing lock nesting notation
[   28.493164] 
[   28.500335] 5 locks held by sh/782:
[   28.504028]  #0:  (&buffer->mutex){+.+.+.}, at: [<c01951a8>] sysfs_write_file+0x28/0xb4
[   28.512573]  #1:  (s_active#4){.+.+.+}, at: [<c01951dc>] sysfs_write_file+0x5c/0xb4
[   28.520721]  #2:  (&per_cpu(cpu_policy_rwsem, cpu)){++++..}, at: [<c0453260>] lock_policy_rwsem_write+0x30/0x44
[   28.531463]  #3:  (userspace_mutex){+.+...}, at: [<c045597c>] cpufreq_set+0x28/0xc8
[   28.539611]  #4:  (&rdev->mutex){+.+.+.}, at: [<c033e5d8>] regulator_get_voltage+0x18/0x38
[   28.548400] 
[   28.548400] stack backtrace:
[   28.553070] [<c001bc84>] (unwind_backtrace+0x0/0x130) from [<c009f4f0>] (print_deadlock_bug+0xcc/0xfc)
[   28.562927] [<c009f4f0>] (print_deadlock_bug+0xcc/0xfc) from [<c00a0d08>] (validate_chain.isra.27+0x3cc/0x67c)
[   28.573516] [<c00a0d08>] (validate_chain.isra.27+0x3cc/0x67c) from [<c00a3ce4>] (__lock_acquire+0x420/0xa24)
[   28.583923] [<c00a3ce4>] (__lock_acquire+0x420/0xa24) from [<c00a49dc>] (lock_acquire+0x9c/0x1f4)
[   28.593322] [<c00a49dc>] (lock_acquire+0x9c/0x1f4) from [<c058863c>] (mutex_lock_nested+0x78/0x3a0)
[   28.602874] [<c058863c>] (mutex_lock_nested+0x78/0x3a0) from [<c033e5d8>] (regulator_get_voltage+0x18/0x38)
[   28.613189] [<c033e5d8>] (regulator_get_voltage+0x18/0x38) from [<c033e0f0>] (_regulator_get_voltage+0x68/0x84)
[   28.623840] [<c033e0f0>] (_regulator_get_voltage+0x68/0x84) from [<c033e5e0>] (regulator_get_voltage+0x20/0x38)
[   28.634490] [<c033e5e0>] (regulator_get_voltage+0x20/0x38) from [<c0457d28>] (cpu0_set_target+0x184/0x490)
[   28.644714] [<c0457d28>] (cpu0_set_target+0x184/0x490) from [<c045284c>] (__cpufreq_driver_target+0x88/0xb8)
[   28.655090] [<c045284c>] (__cpufreq_driver_target+0x88/0xb8) from [<c04559dc>] (cpufreq_set+0x88/0xc8)
[   28.664916] [<c04559dc>] (cpufreq_set+0x88/0xc8) from [<c0452938>] (store_scaling_setspeed+0x5c/0x74)
[   28.674652] [<c0452938>] (store_scaling_setspeed+0x5c/0x74) from [<c0453308>] (store+0x5c/0x84)
[   28.683868] [<c0453308>] (store+0x5c/0x84) from [<c0195200>] (sysfs_write_file+0x80/0xb4)
[   28.692504] [<c0195200>] (sysfs_write_file+0x80/0xb4) from [<c012b0b4>] (vfs_write+0xa8/0x138)
[   28.701599] [<c012b0b4>] (vfs_write+0xa8/0x138) from [<c012b320>] (sys_write+0x40/0x68)
[   28.710052] [<c012b320>] (sys_write+0x40/0x68) from [<c0013d60>] (ret_fast_syscall+0x0/0x3c)

Cc: Greg Guyotte <gguyotte@ti.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-omap <linux-omap@vger.kernel.org>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>

Regards,
Nishanth Menon
