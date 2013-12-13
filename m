Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3LMOg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:36:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3LMOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:36:55 -0500
Message-ID: <52AB1B83.3000000@open-e.com>
Date: Fri, 13 Dec 2013 15:36:51 +0100
From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] System hangs under a heavy load on kernel 3.4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:k2yJ/AD/GxDEsfVcfghA0zwKTqU16GTOjN+Vp6Xdi74
 yXk/22l5R/JmAvrv6M4+Vp5QYpOE2PIBOsSeHF3p9a+A8rVONP
 KFO9PJTwAe710vTnSCQVUlE9afTCzvDHWxxrsD6BnL+VoFHonE
 +qAGKg4/OHwqfejk2hsOm//olVCRbijqxzxCcEsXLnwaEos8Eo
 hIOnIGZIqBDaXvNSfrAM7owhqqNYxUQzCepFDQKra4p3zNahgv
 z2wBtTbMvTrAt3iuOPRN1dgUGjz0GwktHzR+Qb2nETjI3w7qbX
 GY07RQC9Xnt9NtRuYHIJrX6eT5ZMJLvekS5a2o6eUyLwXANm4d
 bjCtFPPmWv6b1DGrrcKoAOmwdB/54nnwTi6CySbTi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
we've got problems with kernel 3.4. It hangs during stability tests. 
Messages "INFO: rcu_sched self detected stall on CPU..." are still sent 
to the console but network is down and system doesn't react on key press.
Test creates volume group with two logical volumes and 20 snapshots of 
size five times smaller than LV. Snapshots are periodically started and 
stopped while logical volumes are filled by dd processes. XFS filesystem 
is used. It happens on different machines.

Already we have captured two different call traces (the second one 
happened twice also on 3.4.69):

34519.493785] INFO: rcu_sched self-detected stall on CPU { 6}  (t=6000 jiffies)
[34519.493791] Pid: 39642, comm: mount Tainted: G           O 3.4.69-oe64-00000-g8e19b63 #1
[34519.493793] Call Trace:
[34519.493794]<IRQ>   [<ffffffff8100fcca>] ? update_vsyscall+0xaa/0xd0
[34519.493803]  [<ffffffff8109e34e>] ? __rcu_pending+0xbe/0x420
[34519.493805]  [<ffffffff8109e6cf>] ? rcu_pending+0x1f/0x50
[34519.493807]  [<ffffffff8109eea5>] ? rcu_check_callbacks+0x25/0x60
[34519.493810]  [<ffffffff81048e1f>] ? update_process_times+0x3f/0x80
[34519.493814]  [<ffffffff8107439b>] ? tick_sched_timer+0x5b/0xa0
[34519.493825]  [<ffffffff8105b348>] ? __run_hrtimer+0x68/0x100
[34519.493827]  [<ffffffff81074340>] ? tick_do_update_jiffies64+0xc0/0xc0
[34519.493829]  [<ffffffff8105b4b7>] ? hrtimer_interrupt+0xd7/0x230
[34519.493833]  [<ffffffff810269c3>] ? smp_apic_timer_interrupt+0x63/0xa0
[34519.493837]  [<ffffffff815fbc0a>] ? apic_timer_interrupt+0x6a/0x70
[34519.493838]<EOI>   [<ffffffff8102e1e4>] ? __ticket_spin_lock+0x14/0x20
[34519.493844]  [<ffffffff815f51fb>] ? _raw_spin_lock_irqsave+0x2b/0x50
[34519.493846]  [<ffffffff815f51c5>] ? _raw_spin_lock+0x5/0x10
[34519.493849]  [<ffffffff812b76f8>] ? _atomic_dec_and_lock+0x48/0x70
[34519.493852]  [<ffffffff8121b969>] ? xfs_buf_rele+0x39/0xc0
[34519.493855]  [<ffffffff8121c8d1>] ? xfs_flush_buftarg+0x101/0x120
[34519.493857]  [<ffffffff8121c91a>] ? xfs_free_buftarg+0x2a/0x60
[34519.493859]  [<ffffffff81229b18>] ? xfs_fs_fill_super+0x178/0x280
[34519.493863]  [<ffffffff810ee0a9>] ? mount_bdev+0x1b9/0x1f0
[34519.493864]  [<ffffffff812299a0>] ? xfs_parseargs+0xbc0/0xbc0
[34519.493868]  [<ffffffff810db46c>] ? alloc_pages_current+0xac/0x120
[34519.493870]  [<ffffffff810edcde>] ? mount_fs+0x3e/0x180
[34519.493874]  [<ffffffff81107c95>] ? vfs_kern_mount+0x65/0xf0
[34519.493877]  [<ffffffff81107da3>] ? do_kern_mount+0x53/0x110
[34519.493879]  [<ffffffff811083b4>] ? do_mount+0x554/0x790
[34519.493883]  [<ffffffff8112ed39>] ? compat_sys_mount+0xa9/0x240
[34519.493885]  [<ffffffff815fcbd9>] ? ia32_do_call+0x13/0x13


Dec 13 14:13:27 [kern.err] kernel: [ 5493.913816] INFO: rcu_sched self-detected stall on CPU { 4}  (t=7647 jiffies)

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913819] Pid: 12889, comm: syslog-ng Tainted: G           O 3.4.58-oe64-00000-g46d0e40 #15

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913821] Call Trace:

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913822]<IRQ>   [<ffffffff8100fcca>] ? update_vsyscall+0xaa/0xd0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913827]  [<ffffffff8109e2fe>] ? __rcu_pending+0xbe/0x420

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913829]  [<ffffffff8109e67f>] ? rcu_pending+0x1f/0x50

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913830]  [<ffffffff8109ee55>] ? rcu_check_callbacks+0x25/0x60

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913832]  [<ffffffff81048e1f>] ? update_process_times+0x3f/0x80

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913834]  [<ffffffff8107434b>] ? tick_sched_timer+0x5b/0xa0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913836]  [<ffffffff8105b328>] ? __run_hrtimer+0x68/0x100

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913838]  [<ffffffff810742f0>] ? tick_do_update_jiffies64+0xc0/0xc0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913839]  [<ffffffff8105b497>] ? hrtimer_interrupt+0xd7/0x230

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913841]  [<ffffffff810269c3>] ? smp_apic_timer_interrupt+0x63/0xa0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913844]  [<ffffffff815fb3ca>] ? apic_timer_interrupt+0x6a/0x70

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913844]<EOI>   [<ffffffff812c23f0>] ? __const_udelay+0x40/0x40

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913848]  [<ffffffff8103df0b>] ? console_unlock+0x19b/0x280

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913850]  [<ffffffff8136007d>] ? do_con_write+0x63d/0x1d80

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913853]  [<ffffffff810fca80>] ? __pollwait+0x120/0x120

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913855]  [<ffffffff810f00ff>] ? copy_strings+0x19f/0x200

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913856]  [<ffffffff810fca80>] ? __pollwait+0x120/0x120

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913858]  [<ffffffff81361816>] ? con_write+0x16/0x40

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913860]  [<ffffffff8134da2d>] ? n_tty_write+0x1cd/0x3c0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913862]  [<ffffffff810630d0>] ? try_to_wake_up+0x280/0x280

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913863]  [<ffffffff81349dab>] ? tty_write+0x19b/0x260

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913865]  [<ffffffff8134d860>] ? n_tty_ioctl+0xc0/0xc0

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913866]  [<ffffffff810eac60>] ? vfs_write+0xd0/0x170

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913868]  [<ffffffff810eb413>] ? sys_write+0x53/0x90

Dec 13 14:13:27 [kern.err] kernel: [ 5493.913870]  [<ffffffff815fc399>] ? ia32_do_call+0x13/0x13


Does anyone have idea what is the cause of this issues?

-- 
Best regards
Arkadiusz Bubała
Open-E Poland Sp. z o.o.
www.open-e.com

