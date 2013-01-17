Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AQJIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:08:20 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:56328
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3AQJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:08:14 -0500
Date: Thu, 17 Jan 2013 10:08:04 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1739288036.20130117100804@eikelenboom.it>
To: linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <marcel@holtmann.org>
Subject: Re: 3.8.0-rc3: possible circular locking dependency: &tty->legacy_mutex / &tty->hangup_work with serial/RFCOMM connection via USB bluetooth dongle
In-Reply-To: <34560309.20130112194639@eikelenboom.it>
References: <34560309.20130112194639@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Saturday, January 12, 2013, 7:46:39 PM, you wrote:

> Hi,

> Running a 3.8.0-rc3 kernel (latest commit b719f43059903820c31edb30f4663a2818836e7f) kernel (debian squeeze os), i'm running into this lockdep warning when:

Ok, this seems to be fixed by commit: 852e4a8152b427c3f318bb0e1b5e938d64dcdc32 (tty: don't deadlock while flushing workqueue)


> - Running a perl script that uses rfcomm to communicatie via bluetooth with a bluetooth/TTL converter.
> - It can run ok for a few hours before this lockdep occurs and the perl script freezes.
> - The info related to bluetooth from syslog:

> Jan 12 10:24:08 serveerstertje kernel: [    7.919775] Bluetooth: Virtual HCI driver ver 1.3
> Jan 12 10:24:08 serveerstertje kernel: [    7.920314] Bluetooth: HCI UART driver ver 2.2
> Jan 12 10:24:08 serveerstertje kernel: [    7.920316] Bluetooth: HCI H4 protocol initialized
> Jan 12 10:24:08 serveerstertje kernel: [    7.920317] Bluetooth: HCI BCSP protocol initialized
> Jan 12 10:24:08 serveerstertje kernel: [    7.920318] Bluetooth: HCILL protocol initialized
> Jan 12 10:24:08 serveerstertje kernel: [    7.920318] Bluetooth: HCIATH3K protocol initialized
> Jan 12 10:24:08 serveerstertje kernel: [    7.920319] Bluetooth: HCI Three-wire UART (H5) protocol initialized

> Jan 12 10:24:08 serveerstertje kernel: [    8.191897] Bluetooth: RFCOMM TTY layer initialized
> Jan 12 10:24:08 serveerstertje kernel: [    8.191930] Bluetooth: RFCOMM socket layer initialized
> Jan 12 10:24:08 serveerstertje kernel: [    8.191931] Bluetooth: RFCOMM ver 1.11
> Jan 12 10:24:08 serveerstertje kernel: [    8.191932] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Jan 12 10:24:08 serveerstertje kernel: [    8.191933] Bluetooth: BNEP filters: protocol multicast
> Jan 12 10:24:08 serveerstertje kernel: [    8.191944] Bluetooth: BNEP socket layer initialized
> Jan 12 10:24:08 serveerstertje kernel: [    8.191945] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Jan 12 10:24:08 serveerstertje kernel: [    8.191954] Bluetooth: HIDP socket layer initialized

> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Bluetooth deamon 4.66
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Starting SDP server
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Starting experimental netlink support
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Failed to find Bluetooth netlink family
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Failed to init netlink plugin
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: bridge pan0 created
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: HCI dev 0 registered
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Failed to open RFKILL control device
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: HCI dev 0 up
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Starting security manager 0
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Adapter /org/bluez/3912/hci0 has been enabled
> Jan 12 10:24:09 serveerstertje bluetoothd[3912]: Failed to access HAL


> - And the lockdep warning itself:

> [28678.458250]
> [28678.476588] ======================================================
> [28678.494887] [ INFO: possible circular locking dependency detected ]
> [28678.513013] 3.8.0-rc3-20130112-netpatched-rocketscience-radeon #1 Not tainted
> [28678.530909] -------------------------------------------------------
> [28678.548636] kworker/2:1/19513 is trying to acquire lock:
> [28678.566070]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff819ba5ee>] tty_lock_nested+0x3e/0x80
> [28678.583577]
> [28678.583577] but task is already holding lock:
> [28678.617615]  ((&tty->hangup_work)){+.+...}, at: [<ffffffff81080bf8>] process_one_work+0x158/0x4b0
> [28678.634569]
> [28678.634569] which lock already depends on the new lock.
> [28678.634569]
> [28678.683868]
> [28678.683868] the existing dependency chain (in reverse order) is:
> [28678.715354]
[28678.715354] ->> #2 ((&tty->hangup_work)){+.+...}:
> [28678.745890]        [<ffffffff810b4d2e>] __lock_acquire+0x44e/0xdd0
> [28678.760975]        [<ffffffff810b576a>] lock_acquire+0xba/0x100
> [28678.775834]        [<ffffffff8108322a>] flush_work+0x3a/0x250
> [28678.790408]        [<ffffffff81451568>] tty_ldisc_flush_works+0x18/0x40
> [28678.804877]        [<ffffffff814517ae>] tty_ldisc_release+0x2e/0x90
> [28678.818952]        [<ffffffff8144b827>] tty_release+0x3c7/0x590
> [28678.832813]        [<ffffffff8114e009>] __fput+0xa9/0x2c0
> [28678.846411]        [<ffffffff8114e289>] ____fput+0x9/0x10
> [28678.859644]        [<ffffffff810854d5>] task_work_run+0x95/0xb0
> [28678.872661]        [<ffffffff8100dc4d>] do_notify_resume+0x6d/0x80
> [28678.885516]        [<ffffffff819bb5a2>] int_signal+0x12/0x17
> [28678.898047]
[28678.898047] ->> #1 (&tty->legacy_mutex/1){+.+...}:
> [28678.922334]        [<ffffffff810b4d2e>] __lock_acquire+0x44e/0xdd0
> [28678.934268]        [<ffffffff810b576a>] lock_acquire+0xba/0x100
> [28678.945916]        [<ffffffff819b754c>] mutex_lock_nested+0x4c/0x450
> [28678.957318]        [<ffffffff819ba5ee>] tty_lock_nested+0x3e/0x80
> [28678.968500]        [<ffffffff819ba6aa>] tty_lock_pair+0x6a/0x70
> [28678.979405]        [<ffffffff8144b5cb>] tty_release+0x16b/0x590
> [28678.990012]        [<ffffffff8114e009>] __fput+0xa9/0x2c0
> [28679.000367]        [<ffffffff8114e289>] ____fput+0x9/0x10
> [28679.009455] FW: BLOCKED low udp input: IN=eth0 OUT= MAC=40:61:86:f4:67:d9:00:08:ae:10:46:60:08:00 SRC=112.203.174.221 DST=88.159.69.252 LEN=131 TOS=0x00 PREC=0x00 TTL=38 ID=17898 PROTO=UDP SPT=27001 DPT=1024 LEN=111
> [28679.030869]        [<ffffffff810854d5>] task_work_run+0x95/0xb0
> [28679.040727]        [<ffffffff8100dc4d>] do_notify_resume+0x6d/0x80
> [28679.050419]        [<ffffffff819bb5a2>] int_signal+0x12/0x17
> [28679.059880]
[28679.059880] ->> #0 (&tty->legacy_mutex){+.+.+.}:
> [28679.077823]        [<ffffffff810b41d8>] validate_chain+0x1258/0x1300
> [28679.086583]        [<ffffffff810b4d2e>] __lock_acquire+0x44e/0xdd0
> [28679.095126]        [<ffffffff810b576a>] lock_acquire+0xba/0x100
> [28679.103399]        [<ffffffff819b754c>] mutex_lock_nested+0x4c/0x450
> [28679.111468]        [<ffffffff819ba5ee>] tty_lock_nested+0x3e/0x80
> [28679.119247]        [<ffffffff819ba63b>] tty_lock+0xb/0x10
> [28679.126712]        [<ffffffff814492b5>] __tty_hangup+0x65/0x3c0
> [28679.133940]        [<ffffffff81449620>] do_tty_hangup+0x10/0x20
> [28679.140970]        [<ffffffff81080c60>] process_one_work+0x1c0/0x4b0
> [28679.147755]        [<ffffffff8108134e>] worker_thread+0x11e/0x3d0
> [28679.154383]        [<ffffffff81088a36>] kthread+0xd6/0xe0
> [28679.160649]        [<ffffffff819bb1bc>] ret_from_fork+0x7c/0xb0
> [28679.166666]
> [28679.166666] other info that might help us debug this:
> [28679.166666]
> [28679.183748] Chain exists of:
> [28679.183748]   &tty->legacy_mutex --> &tty->legacy_mutex/1 --> (&tty->hangup_work)
> [28679.183748]
> [28679.200495]  Possible unsafe locking scenario:
> [28679.200495]
> [28679.211416]        CPU0                    CPU1
> [28679.216751]        ----                    ----
> [28679.222049]   lock((&tty->hangup_work));
> [28679.227206]                                lock(&tty->legacy_mutex/1);
> [28679.232380]                                lock((&tty->hangup_work));
> [28679.237532]   lock(&tty->legacy_mutex);
> [28679.242673]
> [28679.242673]  *** DEADLOCK ***
> [28679.242673]
> [28679.257840] 2 locks held by kworker/2:1/19513:
> [28679.262888]  #0:  (events){.+.+.+}, at: [<ffffffff81080bf8>] process_one_work+0x158/0x4b0
> [28679.268053]  #1:  ((&tty->hangup_work)){+.+...}, at: [<ffffffff81080bf8>] process_one_work+0x158/0x4b0
> [28679.273381]
> [28679.273381] stack backtrace:
> [28679.283820] Pid: 19513, comm: kworker/2:1 Not tainted 3.8.0-rc3-20130112-netpatched-rocketscience-radeon #1
> [28679.289347] Call Trace:
> [28679.294804]  [<ffffffff810b2c74>] print_circular_bug+0x204/0x300
> [28679.300384]  [<ffffffff810b41d8>] validate_chain+0x1258/0x1300
> [28679.305997]  [<ffffffff810b4d2e>] __lock_acquire+0x44e/0xdd0
> [28679.311599]  [<ffffffff810b4d4b>] ? __lock_acquire+0x46b/0xdd0
> [28679.317222]  [<ffffffff810b576a>] lock_acquire+0xba/0x100
> [28679.322889]  [<ffffffff819ba5ee>] ? tty_lock_nested+0x3e/0x80
> [28679.328481]  [<ffffffff819ba5ee>] ? tty_lock_nested+0x3e/0x80
> [28679.334023]  [<ffffffff819b754c>] mutex_lock_nested+0x4c/0x450
> [28679.339415]  [<ffffffff819ba5ee>] ? tty_lock_nested+0x3e/0x80
> [28679.344784]  [<ffffffff810b5788>] ? lock_acquire+0xd8/0x100
> [28679.350154]  [<ffffffff81449279>] ? __tty_hangup+0x29/0x3c0
> [28679.355506]  [<ffffffff819ba5ee>] tty_lock_nested+0x3e/0x80
> [28679.360939]  [<ffffffff819ba63b>] tty_lock+0xb/0x10
> [28679.366282]  [<ffffffff814492b5>] __tty_hangup+0x65/0x3c0
> [28679.371651]  [<ffffffff81080bf8>] ? process_one_work+0x158/0x4b0
> [28679.377032]  [<ffffffff810b1918>] ? trace_hardirqs_on_caller+0xf8/0x200
> [28679.382273]  [<ffffffff81449620>] do_tty_hangup+0x10/0x20
> [28679.387216]  [<ffffffff81080c60>] process_one_work+0x1c0/0x4b0
> [28679.392118]  [<ffffffff81080bf8>] ? process_one_work+0x158/0x4b0
> [28679.397039]  [<ffffffff81449610>] ? __tty_hangup+0x3c0/0x3c0
> [28679.401952]  [<ffffffff8108134e>] worker_thread+0x11e/0x3d0
> [28679.406859]  [<ffffffff810b1918>] ? trace_hardirqs_on_caller+0xf8/0x200
> [28679.411787]  [<ffffffff81081230>] ? manage_workers+0x2e0/0x2e0
> [28679.416683]  [<ffffffff81088a36>] kthread+0xd6/0xe0
> [28679.421538]  [<ffffffff81088960>] ? __init_kthread_worker+0x70/0x70
> [28679.426429]  [<ffffffff819bb1bc>] ret_from_fork+0x7c/0xb0
> [28679.431278]  [<ffffffff81088960>] ? __init_kthread_worker+0x70/0x70


> - This is followed by blocked task messages for the perl script:

> Jan 12 18:25:29 serveerstertje kernel: [28926.144229] INFO: task zabbix_slimmeme:26976 blocked for more than 120 seconds.
> Jan 12 18:25:29 serveerstertje kernel: [28926.162883] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 12 18:25:29 serveerstertje kernel: [28926.181312] zabbix_slimmeme D ffff88003851d230     0 26976  22112 0x00000000
> Jan 12 18:25:29 serveerstertje kernel: [28926.199596]  ffff88002d473818 0000000000000216 ffff880000000002 ffffffff8202be38
> Jan 12 18:25:29 serveerstertje kernel: [28926.217728]  ffff88003851d230 0000000000013040 ffff88002d473fd8 ffff88002d472010
> Jan 12 18:25:29 serveerstertje kernel: [28926.235627]  0000000000013040 0000000000013040 ffff88002d473fd8 0000000000013040
> Jan 12 18:25:29 serveerstertje kernel: [28926.253346] Call Trace:
> Jan 12 18:25:29 serveerstertje kernel: [28926.270648]  [<ffffffff810be1ed>] ? __module_text_address+0xd/0x60
> Jan 12 18:25:29 serveerstertje kernel: [28926.322462]  [<ffffffff810be1ed>] ? __module_text_address+0xd/0x60
> Jan 12 18:25:29 serveerstertje kernel: [28926.339617]  [<ffffffff810be44b>] ? is_module_text_address+0x2b/0x60
> Jan 12 18:25:29 serveerstertje kernel: [28926.356452]  [<ffffffff81085958>] ? __kernel_text_address+0x58/0x80
> Jan 12 18:25:29 serveerstertje kernel: [28926.373057]  [<ffffffff81140049>] ? sysfs_slab_add+0x149/0x200
> Jan 12 18:25:29 serveerstertje kernel: [28926.389435]  [<ffffffff81140067>] ? sysfs_slab_add+0x167/0x200
> Jan 12 18:25:29 serveerstertje kernel: [28926.405516]  [<ffffffff819b8d04>] schedule+0x24/0x70
> Jan 12 18:25:29 serveerstertje kernel: [28926.421242]  [<ffffffff819b5f6d>] schedule_timeout+0x1bd/0x220
> Jan 12 18:25:29 serveerstertje kernel: [28926.436793]  [<ffffffff810b5788>] ? lock_acquire+0xd8/0x100
> Jan 12 18:25:29 serveerstertje kernel: [28926.452138]  [<ffffffff819b8201>] ? wait_for_common+0x31/0x170
> Jan 12 18:25:29 serveerstertje kernel: [28926.467171]  [<ffffffff810b5c17>] ? lock_release+0x117/0x250
> Jan 12 18:25:29 serveerstertje kernel: [28926.481938]  [<ffffffff819b82d1>] wait_for_common+0x101/0x170
> Jan 12 18:25:29 serveerstertje kernel: [28926.496482]  [<ffffffff81098730>] ? try_to_wake_up+0x310/0x310
> Jan 12 18:25:29 serveerstertje kernel: [28926.510873]  [<ffffffff819b83e8>] wait_for_completion+0x18/0x20
> Jan 12 18:25:29 serveerstertje kernel: [28926.525014]  [<ffffffff81083385>] flush_work+0x195/0x250
> Jan 12 18:25:29 serveerstertje kernel: [28926.538855]  [<ffffffff810833a0>] ? flush_work+0x1b0/0x250
> Jan 12 18:25:29 serveerstertje kernel: [28926.552411]  [<ffffffff81080400>] ? cwq_dec_nr_in_flight+0xd0/0xd0
> Jan 12 18:25:29 serveerstertje kernel: [28926.565910]  [<ffffffff81451568>] tty_ldisc_flush_works+0x18/0x40
> Jan 12 18:25:29 serveerstertje kernel: [28926.579013]  [<ffffffff814517ae>] tty_ldisc_release+0x2e/0x90
> Jan 12 18:25:29 serveerstertje kernel: [28926.591876]  [<ffffffff8144b827>] tty_release+0x3c7/0x590
> Jan 12 18:25:29 serveerstertje kernel: [28926.604527]  [<ffffffff810b1a2d>] ? trace_hardirqs_on+0xd/0x10
> Jan 12 18:25:29 serveerstertje kernel: [28926.616853]  [<ffffffff819b63a9>] ? __mutex_unlock_slowpath+0x149/0x1d0
> Jan 12 18:25:29 serveerstertje kernel: [28926.628997]  [<ffffffff81098730>] ? try_to_wake_up+0x310/0x310
> Jan 12 18:25:29 serveerstertje kernel: [28926.640952]  [<ffffffff8144bdb4>] tty_open+0x3c4/0x5f0
> Jan 12 18:25:30 serveerstertje kernel: [28926.652584]  [<ffffffff81150a18>] chrdev_open+0x98/0x170
> Jan 12 18:25:30 serveerstertje kernel: [28926.663972]  [<ffffffff810912cd>] ? lg_local_unlock+0x3d/0x70
> Jan 12 18:25:30 serveerstertje kernel: [28926.675152]  [<ffffffff81150980>] ? cdev_put+0x30/0x30
> Jan 12 18:25:30 serveerstertje kernel: [28926.686173]  [<ffffffff8114b1fe>] do_dentry_open+0x25e/0x310
> Jan 12 18:25:30 serveerstertje kernel: [28926.696868]  [<ffffffff8114b3c0>] finish_open+0x30/0x50
> Jan 12 18:25:30 serveerstertje kernel: [28926.707267]  [<ffffffff8115a79e>] do_last+0x30e/0xe90
> Jan 12 18:25:30 serveerstertje kernel: [28926.717404]  [<ffffffff81157aba>] ? link_path_walk+0x9a/0x9f0
> Jan 12 18:25:30 serveerstertje kernel: [28926.727353]  [<ffffffff8115b3ce>] path_openat+0xae/0x4e0
> Jan 12 18:25:30 serveerstertje kernel: [28926.737008]  [<ffffffff810b5c17>] ? lock_release+0x117/0x250
> Jan 12 18:25:30 serveerstertje kernel: [28926.746482]  [<ffffffff81160264>] ? do_select+0x5f4/0x6d0
> Jan 12 18:25:30 serveerstertje kernel: [28926.755613]  [<ffffffff8115b934>] do_filp_open+0x44/0xa0
> Jan 12 18:25:30 serveerstertje kernel: [28926.764542]  [<ffffffff811691e3>] ? __alloc_fd+0xb3/0x150
> Jan 12 18:25:30 serveerstertje kernel: [28926.773224]  [<ffffffff8114ad13>] do_sys_open+0x103/0x1f0
> Jan 12 18:25:30 serveerstertje kernel: [28926.781585]  [<ffffffff8114ae3c>] sys_open+0x1c/0x20
> Jan 12 18:25:30 serveerstertje kernel: [28926.789685]  [<ffffffff819bb269>] system_call_fastpath+0x16/0x1b
> Jan 12 18:25:30 serveerstertje kernel: [28926.797570] INFO: lockdep is turned off.




