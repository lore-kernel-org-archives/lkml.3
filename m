Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3IXLqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 07:46:35 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:38859 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab3IXLqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 07:46:33 -0400
Date: Tue, 24 Sep 2013 14:46:30 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
cc: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: i2c-i801 hangs indefinitely on IBM x3550
Message-ID: <alpine.SOC.1.00.1309241438110.29702@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried latest Debian kernel (3.10-3-amd64) and latest upstream kernel 
(3.12-rc2) on a decommisioned IBM x3550 server. i2c-i801 is autoloaded 
but all access to it seems to wait forever, including stopping reboot 
from happening because modprobe is still running and blocked on this.

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
        Subsystem: IBM Device 02dd
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at 0440 [size=32]
        Kernel driver in use: i801_smbus


[    3.028771] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[...]
[  240.172009] INFO: task modprobe:267 blocked for more than 120 seconds.
[  240.172074]       Not tainted 3.12.0-rc2 #2
[  240.172127] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.172186] modprobe        D ffff88003cec83e0     0   267      1 0x00000006
[  240.172336]  ffff88003cec80c0 0000000000000086 0000000000012dc0 ffff88003baf1fd8
[  240.172572]  0000000000012dc0 ffff88003baf1fd8 ffffffffa0029340 ffff88003baf1a48
[  240.172808]  ffffffffa0029344 ffff88003cec80c0 00000000ffffffff ffffffffa0029348
[  240.173044] Call Trace:
[  240.173111]  [<ffffffff8147d750>] ? schedule_preempt_disabled+0x20/0x60
[  240.173170]  [<ffffffff8147bac3>] ? __mutex_lock_slowpath+0x133/0x1b0
[  240.173234]  [<ffffffffa0027750>] ? i2c_register_adapter+0x390/0x390 [i2c_core]
[  240.173293]  [<ffffffff8147bb56>] ? mutex_lock+0x16/0x30
[  240.173350]  [<ffffffffa0027761>] ? i2c_add_adapter+0x11/0x60 [i2c_core]
[  240.173424]  [<ffffffffa001b39f>] ? __i2c_bit_add_bus+0x1af/0x360 [i2c_algo_bit]
[  240.173567]  [<ffffffffa027f614>] ? radeon_i2c_create+0x194/0x2a0 [radeon]
[  240.173662]  [<ffffffffa0263232>] ? radeon_combios_i2c_init+0xb2/0x4e0 [radeon]
[  240.173774]  [<ffffffffa027c4b8>] ? radeon_modeset_init+0x1a8/0x990 [radeon]
[  240.173867]  [<ffffffffa025624c>] ? radeon_debugfs_add_files+0xac/0x100 [radeon]
[  240.173975]  [<ffffffffa02576a0>] ? radeon_driver_load_kms+0xe0/0x160 [radeon]
[  240.174070]  [<ffffffffa019146c>] ? drm_get_pci_dev+0x11c/0x2d0 [drm]
[  240.174144]  [<ffffffff812817c8>] ? pci_device_probe+0x78/0xc0
[  240.174217]  [<ffffffff81320448>] ? driver_probe_device+0x68/0x220
[  240.174288]  [<ffffffff813206bb>] ? __driver_attach+0x7b/0x80
[  240.174359]  [<ffffffff81320640>] ? __device_attach+0x40/0x40
[  240.174429]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  240.174500]  [<ffffffff8131fbb8>] ? bus_add_driver+0x1e8/0x290
[  240.174570]  [<ffffffff81320c46>] ? driver_register+0x56/0xd0
[  240.174644]  [<ffffffffa0384000>] ? 0xffffffffa0383fff
[  240.174715]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  240.174788]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  240.174859]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  240.174929]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  240.175000]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  240.175071] INFO: task modprobe:283 blocked for more than 120 seconds.
[  240.175142]       Not tainted 3.12.0-rc2 #2
[  240.175208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.175294] modprobe        D ffff88003daada90     0   283      1 0x00000004
[  240.175455]  ffff88003daad770 0000000000000086 0000000000012dc0 ffff88003d73bfd8
[  240.175719]  0000000000012dc0 ffff88003d73bfd8 ffff88003ccb0c00 0000000000000000
[  240.175982]  ffff88003ccb0f90 ffff88003ccb0f70 ffff88003ccb0f80 0000000000000000
[  240.176264] Call Trace:
[  240.176332]  [<ffffffffa00bb5cd>] ? i801_transaction+0x9d/0x120 [i2c_i801]
[  240.176407]  [<ffffffff8105f340>] ? wake_up_atomic_t+0x30/0x30
[  240.176479]  [<ffffffffa00bb8d5>] ? i801_access+0x285/0xaa0 [i2c_i801]
[  240.176551]  [<ffffffff8125bb8a>] ? number.isra.1+0x31a/0x350
[  240.176624]  [<ffffffff8115c83b>] ? ep_poll_callback+0x10b/0x160
[  240.176696]  [<ffffffffa0026103>] ? i2c_smbus_xfer+0xc3/0x160 [i2c_core]
[  240.176770]  [<ffffffffa0026283>] ? i2c_default_probe+0xe3/0x130 [i2c_core]
[  240.176843]  [<ffffffff8131c372>] ? device_for_each_child+0x52/0x60
[  240.176916]  [<ffffffffa00279db>] ? i2c_do_add_adapter+0x1ab/0x290 [i2c_core]
[  240.176991]  [<ffffffff81255a1a>] ? kobject_uevent_env+0x10a/0x4c0
[  240.177064]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  240.177151]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  240.177223]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  240.177311]  [<ffffffffa00258e8>] ? i2c_for_each_dev+0x28/0x40 [i2c_core]
[  240.177385]  [<ffffffffa00269d9>] ? i2c_register_driver+0x59/0xa0 [i2c_core]
[  240.177458]  [<ffffffffa0005000>] ? 0xffffffffa0004fff
[  240.177527]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  240.177599]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  240.177670]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  240.177740]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  240.177811]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  360.176013] INFO: task modprobe:267 blocked for more than 120 seconds.
[  360.176092]       Not tainted 3.12.0-rc2 #2
[  360.176158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.176245] modprobe        D ffff88003cec83e0     0   267      1 0x00000006
[  360.176409]  ffff88003cec80c0 0000000000000086 0000000000012dc0 ffff88003baf1fd8
[  360.176673]  0000000000012dc0 ffff88003baf1fd8 ffffffffa0029340 ffff88003baf1a48
[  360.176936]  ffffffffa0029344 ffff88003cec80c0 00000000ffffffff ffffffffa0029348
[  360.177200] Call Trace:
[  360.177282]  [<ffffffff8147d750>] ? schedule_preempt_disabled+0x20/0x60
[  360.177354]  [<ffffffff8147bac3>] ? __mutex_lock_slowpath+0x133/0x1b0
[  360.177431]  [<ffffffffa0027750>] ? i2c_register_adapter+0x390/0x390 [i2c_core]
[  360.177518]  [<ffffffff8147bb56>] ? mutex_lock+0x16/0x30
[  360.177589]  [<ffffffffa0027761>] ? i2c_add_adapter+0x11/0x60 [i2c_core]
[  360.177663]  [<ffffffffa001b39f>] ? __i2c_bit_add_bus+0x1af/0x360 [i2c_algo_bit]
[  360.177806]  [<ffffffffa027f614>] ? radeon_i2c_create+0x194/0x2a0 [radeon]
[  360.177901]  [<ffffffffa0263232>] ? radeon_combios_i2c_init+0xb2/0x4e0 [radeon]
[  360.178013]  [<ffffffffa027c4b8>] ? radeon_modeset_init+0x1a8/0x990 [radeon]
[  360.178106]  [<ffffffffa025624c>] ? radeon_debugfs_add_files+0xac/0x100 [radeon]
[  360.178214]  [<ffffffffa02576a0>] ? radeon_driver_load_kms+0xe0/0x160 [radeon]
[  360.178309]  [<ffffffffa019146c>] ? drm_get_pci_dev+0x11c/0x2d0 [drm]
[  360.178383]  [<ffffffff812817c8>] ? pci_device_probe+0x78/0xc0
[  360.178455]  [<ffffffff81320448>] ? driver_probe_device+0x68/0x220
[  360.178527]  [<ffffffff813206bb>] ? __driver_attach+0x7b/0x80
[  360.178597]  [<ffffffff81320640>] ? __device_attach+0x40/0x40
[  360.178668]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  360.178738]  [<ffffffff8131fbb8>] ? bus_add_driver+0x1e8/0x290
[  360.178810]  [<ffffffff81320c46>] ? driver_register+0x56/0xd0
[  360.178883]  [<ffffffffa0384000>] ? 0xffffffffa0383fff
[  360.178953]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  360.179027]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  360.179098]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  360.179168]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  360.179240]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  360.179311] INFO: task modprobe:283 blocked for more than 120 seconds.
[  360.179382]       Not tainted 3.12.0-rc2 #2
[  360.179448] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.179534] modprobe        D ffff88003daada90     0   283      1 0x00000004
[  360.179695]  ffff88003daad770 0000000000000086 0000000000012dc0 ffff88003d73bfd8
[  360.179959]  0000000000012dc0 ffff88003d73bfd8 ffff88003ccb0c00 0000000000000000
[  360.180239]  ffff88003ccb0f90 ffff88003ccb0f70 ffff88003ccb0f80 0000000000000000
[  360.180503] Call Trace:
[  360.180570]  [<ffffffffa00bb5cd>] ? i801_transaction+0x9d/0x120 [i2c_i801]
[  360.180644]  [<ffffffff8105f340>] ? wake_up_atomic_t+0x30/0x30
[  360.180716]  [<ffffffffa00bb8d5>] ? i801_access+0x285/0xaa0 [i2c_i801]
[  360.180789]  [<ffffffff8125bb8a>] ? number.isra.1+0x31a/0x350
[  360.180862]  [<ffffffff8115c83b>] ? ep_poll_callback+0x10b/0x160
[  360.180934]  [<ffffffffa0026103>] ? i2c_smbus_xfer+0xc3/0x160 [i2c_core]
[  360.181008]  [<ffffffffa0026283>] ? i2c_default_probe+0xe3/0x130 [i2c_core]
[  360.181081]  [<ffffffff8131c372>] ? device_for_each_child+0x52/0x60
[  360.181154]  [<ffffffffa00279db>] ? i2c_do_add_adapter+0x1ab/0x290 [i2c_core]
[  360.181229]  [<ffffffff81255a1a>] ? kobject_uevent_env+0x10a/0x4c0
[  360.181302]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  360.181389]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  360.181461]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  360.181549]  [<ffffffffa00258e8>] ? i2c_for_each_dev+0x28/0x40 [i2c_core]
[  360.181623]  [<ffffffffa00269d9>] ? i2c_register_driver+0x59/0xa0 [i2c_core]
[  360.181696]  [<ffffffffa0005000>] ? 0xffffffffa0004fff
[  360.181765]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  360.181837]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  360.181907]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  360.181978]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  360.182049]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  480.180015] INFO: task modprobe:267 blocked for more than 120 seconds.
[  480.180094]       Not tainted 3.12.0-rc2 #2
[  480.180161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.181816] modprobe        D ffff88003cec83e0     0   267      1 0x00000006
[  480.181979]  ffff88003cec80c0 0000000000000086 0000000000012dc0 ffff88003baf1fd8
[  480.182242]  0000000000012dc0 ffff88003baf1fd8 ffffffffa0029340 ffff88003baf1a48
[  480.182506]  ffffffffa0029344 ffff88003cec80c0 00000000ffffffff ffffffffa0029348
[  480.182770] Call Trace:
[  480.182851]  [<ffffffff8147d750>] ? schedule_preempt_disabled+0x20/0x60
[  480.182924]  [<ffffffff8147bac3>] ? __mutex_lock_slowpath+0x133/0x1b0
[  480.183001]  [<ffffffffa0027750>] ? i2c_register_adapter+0x390/0x390 [i2c_core]
[  480.183087]  [<ffffffff8147bb56>] ? mutex_lock+0x16/0x30
[  480.183159]  [<ffffffffa0027761>] ? i2c_add_adapter+0x11/0x60 [i2c_core]
[  480.183232]  [<ffffffffa001b39f>] ? __i2c_bit_add_bus+0x1af/0x360 [i2c_algo_bit]
[  480.183371]  [<ffffffffa027f614>] ? radeon_i2c_create+0x194/0x2a0 [radeon]
[  480.183466]  [<ffffffffa0263232>] ? radeon_combios_i2c_init+0xb2/0x4e0 [radeon]
[  480.183578]  [<ffffffffa027c4b8>] ? radeon_modeset_init+0x1a8/0x990 [radeon]
[  480.183671]  [<ffffffffa025624c>] ? radeon_debugfs_add_files+0xac/0x100 [radeon]
[  480.183779]  [<ffffffffa02576a0>] ? radeon_driver_load_kms+0xe0/0x160 [radeon]
[  480.183873]  [<ffffffffa019146c>] ? drm_get_pci_dev+0x11c/0x2d0 [drm]
[  480.183947]  [<ffffffff812817c8>] ? pci_device_probe+0x78/0xc0
[  480.184030]  [<ffffffff81320448>] ? driver_probe_device+0x68/0x220
[  480.184107]  [<ffffffff813206bb>] ? __driver_attach+0x7b/0x80
[  480.184180]  [<ffffffff81320640>] ? __device_attach+0x40/0x40
[  480.184254]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  480.184326]  [<ffffffff8131fbb8>] ? bus_add_driver+0x1e8/0x290
[  480.184397]  [<ffffffff81320c46>] ? driver_register+0x56/0xd0
[  480.184470]  [<ffffffffa0384000>] ? 0xffffffffa0383fff
[  480.184541]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  480.184614]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  480.184685]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  480.184755]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  480.184826]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  480.184898] INFO: task modprobe:283 blocked for more than 120 seconds.
[  480.184969]       Not tainted 3.12.0-rc2 #2
[  480.185035] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.185121] modprobe        D ffff88003daada90     0   283      1 0x00000004
[  480.185282]  ffff88003daad770 0000000000000086 0000000000012dc0 ffff88003d73bfd8
[  480.185546]  0000000000012dc0 ffff88003d73bfd8 ffff88003ccb0c00 0000000000000000
[  480.185809]  ffff88003ccb0f90 ffff88003ccb0f70 ffff88003ccb0f80 0000000000000000
[  480.186073] Call Trace:
[  480.186139]  [<ffffffffa00bb5cd>] ? i801_transaction+0x9d/0x120 [i2c_i801]
[  480.186213]  [<ffffffff8105f340>] ? wake_up_atomic_t+0x30/0x30
[  480.186284]  [<ffffffffa00bb8d5>] ? i801_access+0x285/0xaa0 [i2c_i801]
[  480.186357]  [<ffffffff8125bb8a>] ? number.isra.1+0x31a/0x350
[  480.186430]  [<ffffffff8115c83b>] ? ep_poll_callback+0x10b/0x160
[  480.186502]  [<ffffffffa0026103>] ? i2c_smbus_xfer+0xc3/0x160 [i2c_core]
[  480.186576]  [<ffffffffa0026283>] ? i2c_default_probe+0xe3/0x130 [i2c_core]
[  480.186649]  [<ffffffff8131c372>] ? device_for_each_child+0x52/0x60
[  480.186722]  [<ffffffffa00279db>] ? i2c_do_add_adapter+0x1ab/0x290 [i2c_core]
[  480.186798]  [<ffffffff81255a1a>] ? kobject_uevent_env+0x10a/0x4c0
[  480.186871]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  480.186958]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  480.187030]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  480.187118]  [<ffffffffa00258e8>] ? i2c_for_each_dev+0x28/0x40 [i2c_core]
[  480.187192]  [<ffffffffa00269d9>] ? i2c_register_driver+0x59/0xa0 [i2c_core]
[  480.187265]  [<ffffffffa0005000>] ? 0xffffffffa0004fff
[  480.187334]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  480.187406]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  480.187476]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  480.187547]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  480.187618]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  600.184009] INFO: task modprobe:267 blocked for more than 120 seconds.
[  600.184081]       Not tainted 3.12.0-rc2 #2
[  600.184147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.184234] modprobe        D ffff88003cec83e0     0   267      1 0x00000006
[  600.184395]  ffff88003cec80c0 0000000000000086 0000000000012dc0 ffff88003baf1fd8
[  600.184659]  0000000000012dc0 ffff88003baf1fd8 ffffffffa0029340 ffff88003baf1a48
[  600.184922]  ffffffffa0029344 ffff88003cec80c0 00000000ffffffff ffffffffa0029348
[  600.185186] Call Trace:
[  600.185256]  [<ffffffff8147d750>] ? schedule_preempt_disabled+0x20/0x60
[  600.185328]  [<ffffffff8147bac3>] ? __mutex_lock_slowpath+0x133/0x1b0
[  600.185402]  [<ffffffffa0027750>] ? i2c_register_adapter+0x390/0x390 [i2c_core]
[  600.185489]  [<ffffffff8147bb56>] ? mutex_lock+0x16/0x30
[  600.185560]  [<ffffffffa0027761>] ? i2c_add_adapter+0x11/0x60 [i2c_core]
[  600.185633]  [<ffffffffa001b39f>] ? __i2c_bit_add_bus+0x1af/0x360 [i2c_algo_bit]
[  600.185749]  [<ffffffffa027f614>] ? radeon_i2c_create+0x194/0x2a0 [radeon]
[  600.185844]  [<ffffffffa0263232>] ? radeon_combios_i2c_init+0xb2/0x4e0 [radeon]
[  600.185955]  [<ffffffffa027c4b8>] ? radeon_modeset_init+0x1a8/0x990 [radeon]
[  600.186047]  [<ffffffffa025624c>] ? radeon_debugfs_add_files+0xac/0x100 [radeon]
[  600.186155]  [<ffffffffa02576a0>] ? radeon_driver_load_kms+0xe0/0x160 [radeon]
[  600.186247]  [<ffffffffa019146c>] ? drm_get_pci_dev+0x11c/0x2d0 [drm]
[  600.186319]  [<ffffffff812817c8>] ? pci_device_probe+0x78/0xc0
[  600.186390]  [<ffffffff81320448>] ? driver_probe_device+0x68/0x220
[  600.186462]  [<ffffffff813206bb>] ? __driver_attach+0x7b/0x80
[  600.186532]  [<ffffffff81320640>] ? __device_attach+0x40/0x40
[  600.186602]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  600.186673]  [<ffffffff8131fbb8>] ? bus_add_driver+0x1e8/0x290
[  600.186744]  [<ffffffff81320c46>] ? driver_register+0x56/0xd0
[  600.186815]  [<ffffffffa0384000>] ? 0xffffffffa0383fff
[  600.186884]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  600.186956]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  600.187026]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  600.187096]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  600.187168]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  600.187238] INFO: task modprobe:283 blocked for more than 120 seconds.
[  600.187309]       Not tainted 3.12.0-rc2 #2
[  600.187375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.187461] modprobe        D ffff88003daada90     0   283      1 0x00000004
[  600.187622]  ffff88003daad770 0000000000000086 0000000000012dc0 ffff88003d73bfd8
[  600.187885]  0000000000012dc0 ffff88003d73bfd8 ffff88003ccb0c00 0000000000000000
[  600.188158]  ffff88003ccb0f90 ffff88003ccb0f70 ffff88003ccb0f80 0000000000000000
[  600.188423] Call Trace:
[  600.188490]  [<ffffffffa00bb5cd>] ? i801_transaction+0x9d/0x120 [i2c_i801]
[  600.188562]  [<ffffffff8105f340>] ? wake_up_atomic_t+0x30/0x30
[  600.188634]  [<ffffffffa00bb8d5>] ? i801_access+0x285/0xaa0 [i2c_i801]
[  600.188706]  [<ffffffff8125bb8a>] ? number.isra.1+0x31a/0x350
[  600.188776]  [<ffffffff8115c83b>] ? ep_poll_callback+0x10b/0x160
[  600.188849]  [<ffffffffa0026103>] ? i2c_smbus_xfer+0xc3/0x160 [i2c_core]
[  600.188922]  [<ffffffffa0026283>] ? i2c_default_probe+0xe3/0x130 [i2c_core]
[  600.188995]  [<ffffffff8131c372>] ? device_for_each_child+0x52/0x60
[  600.189068]  [<ffffffffa00279db>] ? i2c_do_add_adapter+0x1ab/0x290 [i2c_core]
[  600.189142]  [<ffffffff81255a1a>] ? kobject_uevent_env+0x10a/0x4c0
[  600.189214]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  600.189301]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  600.189374]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  600.189462]  [<ffffffffa00258e8>] ? i2c_for_each_dev+0x28/0x40 [i2c_core]
[  600.189536]  [<ffffffffa00269d9>] ? i2c_register_driver+0x59/0xa0 [i2c_core]
[  600.189608]  [<ffffffffa0005000>] ? 0xffffffffa0004fff
[  600.189678]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  600.189750]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  600.189820]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  600.189891]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  600.189961]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  629.274318] systemd-udevd[6677]: starting version 204
[  720.188014] INFO: task modprobe:267 blocked for more than 120 seconds.
[  720.188092]       Not tainted 3.12.0-rc2 #2
[  720.188158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.188245] modprobe        D ffff88003cec83e0     0   267      1 0x00000006
[  720.188408]  ffff88003cec80c0 0000000000000086 0000000000012dc0 ffff88003baf1fd8
[  720.188672]  0000000000012dc0 ffff88003baf1fd8 ffffffffa0029340 ffff88003baf1a48
[  720.188936]  ffffffffa0029344 ffff88003cec80c0 00000000ffffffff ffffffffa0029348
[  720.189200] Call Trace:
[  720.189282]  [<ffffffff8147d750>] ? schedule_preempt_disabled+0x20/0x60
[  720.189354]  [<ffffffff8147bac3>] ? __mutex_lock_slowpath+0x133/0x1b0
[  720.189431]  [<ffffffffa0027750>] ? i2c_register_adapter+0x390/0x390 [i2c_core]
[  720.189518]  [<ffffffff8147bb56>] ? mutex_lock+0x16/0x30
[  720.189589]  [<ffffffffa0027761>] ? i2c_add_adapter+0x11/0x60 [i2c_core]
[  720.189663]  [<ffffffffa001b39f>] ? __i2c_bit_add_bus+0x1af/0x360 [i2c_algo_bit]
[  720.189807]  [<ffffffffa027f614>] ? radeon_i2c_create+0x194/0x2a0 [radeon]
[  720.189903]  [<ffffffffa0263232>] ? radeon_combios_i2c_init+0xb2/0x4e0 [radeon]
[  720.190015]  [<ffffffffa027c4b8>] ? radeon_modeset_init+0x1a8/0x990 [radeon]
[  720.190108]  [<ffffffffa025624c>] ? radeon_debugfs_add_files+0xac/0x100 [radeon]
[  720.190215]  [<ffffffffa02576a0>] ? radeon_driver_load_kms+0xe0/0x160 [radeon]
[  720.190311]  [<ffffffffa019146c>] ? drm_get_pci_dev+0x11c/0x2d0 [drm]
[  720.191953]  [<ffffffff812817c8>] ? pci_device_probe+0x78/0xc0
[  720.192036]  [<ffffffff81320448>] ? driver_probe_device+0x68/0x220
[  720.192113]  [<ffffffff813206bb>] ? __driver_attach+0x7b/0x80
[  720.192187]  [<ffffffff81320640>] ? __device_attach+0x40/0x40
[  720.192260]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  720.192333]  [<ffffffff8131fbb8>] ? bus_add_driver+0x1e8/0x290
[  720.192404]  [<ffffffff81320c46>] ? driver_register+0x56/0xd0
[  720.192478]  [<ffffffffa0384000>] ? 0xffffffffa0383fff
[  720.192548]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  720.192622]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  720.192692]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  720.192763]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  720.192834]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  720.192906] INFO: task modprobe:283 blocked for more than 120 seconds.
[  720.192977]       Not tainted 3.12.0-rc2 #2
[  720.193043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.193129] modprobe        D ffff88003daada90     0   283      1 0x00000004
[  720.193291]  ffff88003daad770 0000000000000086 0000000000012dc0 ffff88003d73bfd8
[  720.193554]  0000000000012dc0 ffff88003d73bfd8 ffff88003ccb0c00 0000000000000000
[  720.193818]  ffff88003ccb0f90 ffff88003ccb0f70 ffff88003ccb0f80 0000000000000000
[  720.194081] Call Trace:
[  720.194148]  [<ffffffffa00bb5cd>] ? i801_transaction+0x9d/0x120 [i2c_i801]
[  720.194221]  [<ffffffff8105f340>] ? wake_up_atomic_t+0x30/0x30
[  720.194293]  [<ffffffffa00bb8d5>] ? i801_access+0x285/0xaa0 [i2c_i801]
[  720.194366]  [<ffffffff8125bb8a>] ? number.isra.1+0x31a/0x350
[  720.194439]  [<ffffffff8115c83b>] ? ep_poll_callback+0x10b/0x160
[  720.194511]  [<ffffffffa0026103>] ? i2c_smbus_xfer+0xc3/0x160 [i2c_core]
[  720.194585]  [<ffffffffa0026283>] ? i2c_default_probe+0xe3/0x130 [i2c_core]
[  720.194658]  [<ffffffff8131c372>] ? device_for_each_child+0x52/0x60
[  720.194731]  [<ffffffffa00279db>] ? i2c_do_add_adapter+0x1ab/0x290 [i2c_core]
[  720.194806]  [<ffffffff81255a1a>] ? kobject_uevent_env+0x10a/0x4c0
[  720.194879]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  720.194966]  [<ffffffff8131e6c3>] ? bus_for_each_dev+0x53/0x90
[  720.195038]  [<ffffffffa0027ad0>] ? __process_new_adapter+0x10/0x10 [i2c_core]
[  720.195126]  [<ffffffffa00258e8>] ? i2c_for_each_dev+0x28/0x40 [i2c_core]
[  720.195200]  [<ffffffffa00269d9>] ? i2c_register_driver+0x59/0xa0 [i2c_core]
[  720.195273]  [<ffffffffa0005000>] ? 0xffffffffa0004fff
[  720.195342]  [<ffffffff810002d2>] ? do_one_initcall+0x102/0x150
[  720.195414]  [<ffffffff8109d304>] ? load_module+0x1b64/0x2310
[  720.195485]  [<ffffffff8109a160>] ? m_show+0x1c0/0x1c0
[  720.195555]  [<ffffffff8109db41>] ? SyS_init_module+0x91/0xc0
[  720.195626]  [<ffffffff8147f062>] ? system_call_fastpath+0x16/0x1b
[  790.695879] i2c /dev entries driver

-- 
Meelis Roos (mroos@linux.ee)
