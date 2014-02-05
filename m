Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBEOyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:54:12 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9205
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaBEOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:54:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 5 Feb 2014 22:54:10 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-arm-kernel@lists.infradead.org>
Subject: v3.14-rc1 locking bug in system suspend
Message-ID: <20140205145408.GA3708@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I start seeing the following locking bug on IMX6 with suspend operation
after moving to v3.14-rc1.  Before I start looking into the issue, I
would like to confirm if it's an IMX specific problem or one seen on
other platforms.  Please ask if you need more info.

Shawn


root@arm:~# echo mem > /sys/power/state
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
mmc1: card e624 removed
Freezing user space processes ... (elapsed 0.002 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
PM: Entering mem sleep
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 0 PID: 1849 Comm: bash Not tainted 3.14.0-rc1+ #1648
Backtrace:
[<80012144>] (dump_backtrace) from [<800122e4>] (show_stack+0x18/0x1c)
 r6:808c48a0 r5:00000000 r4:00000000 r3:00000000
[<800122cc>] (show_stack) from [<80637ac0>] (dump_stack+0x78/0x94)
[<80637a48>] (dump_stack) from [<80064fa0>] (__lock_acquire+0x18f4/0x1ce0)
 r4:00000002 r3:bda3f200
[<800636ac>] (__lock_acquire) from [<80065894>] (lock_acquire+0x68/0x7c)
 r10:bd906000 r9:bda3f200 r8:00000000 r7:00000000 r6:60000013 r5:bd906000
 r4:00000000
[<8006582c>] (lock_acquire) from [<8063c938>] (mutex_lock_nested+0x5c/0x3b8)
 r7:00000000 r6:80dfc78c r5:804be444 r4:bf122928
[<8063c8dc>] (mutex_lock_nested) from [<804be444>] (snd_soc_suspend+0x34/0x42c)
 r10:00000000 r9:00000000 r8:00000000 r7:bf1c4444 r6:bf1c4410 r5:be8fd150
 r4:be8fd010
[<804be410>] (snd_soc_suspend) from [<8034392c>] (platform_pm_suspend+0x34/0x64)
 r10:00000000 r8:00000000 r7:bf1c4444 r6:bf1c4410 r5:803438f8 r4:bf1c4410
[<803438f8>] (platform_pm_suspend) from [<80348e18>] (dpm_run_callback.isra.7+0x34/0x6c)
[<80348de4>] (dpm_run_callback.isra.7) from [<80349354>] (__device_suspend+0x10c/0x220)
 r9:808dd974 r8:808c4a5c r6:00000002 r5:80e5001c r4:bf1c4410
[<80349248>] (__device_suspend) from [<8034a338>] (dpm_suspend+0x60/0x220)
 r7:bf1c4410 r6:808dd90c r5:80e5001c r4:bf1c44c0
[<8034a2d8>] (dpm_suspend) from [<8034a790>] (dpm_suspend_start+0x60/0x68)
 r10:8079a818 r9:00000000 r8:00000004 r7:80dfbe90 r6:80641eec r5:00000000
 r4:00000002
[<8034a730>] (dpm_suspend_start) from [<8006a788>] (suspend_devices_and_enter+0x74/0x318)
 r4:00000003 r3:80dfbe98
[<8006a714>] (suspend_devices_and_enter) from [<8006abd8>] (pm_suspend+0x1ac/0x244)
 r10:8079a818 r8:00000004 r7:00000003 r6:80641eec r5:00000000 r4:00000003
[<8006aa2c>] (pm_suspend) from [<80069a4c>] (state_store+0x70/0xc0)
 r5:00000003 r4:be9c7680
[<800699dc>] (state_store) from [<80294034>] (kobj_attr_store+0x1c/0x28)
 r10:bd99cb88 r8:00000000 r7:bd907f78 r6:be9c7680 r5:00000004 r4:bd99cb80
[<80294018>] (kobj_attr_store) from [<80140f90>] (sysfs_kf_write+0x54/0x58)
[<80140f3c>] (sysfs_kf_write) from [<8014474c>] (kernfs_fop_write+0xc4/0x160)
 r6:be9c7680 r5:bd99cb80 r4:00000004 r3:80140f3c
[<80144688>] (kernfs_fop_write) from [<800dfa14>] (vfs_write+0xbc/0x184)
 r10:00000000 r9:00000000 r8:00000000 r7:bd907f78 r6:00281c08 r5:00000004
 r4:bda1bd00
[<800df958>] (vfs_write) from [<800dfe00>] (SyS_write+0x48/0x70)
 r10:00000000 r8:00000000 r7:00000004 r6:00281c08 r5:00000000 r4:bda1bd00
[<800dfdb8>] (SyS_write) from [<8000e800>] (ret_fast_syscall+0x0/0x48)
 r9:bd906000 r8:8000e9c4 r7:00000004 r6:00281c08 r5:00000004 r4:76f575e0
INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=2104 jiffies, g=576, c=575, q=2)
Task dump for CPU 0:
bash            R running      0  1849   1848 0x00000002
Backtrace:
[<80065894>] (lock_acquire) from [<80061410>] (trace_hardirqs_off+0x14/0x18)
Backtrace aborted due to bad frame pointer <bd907b3c>
INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=8424 jiffies, g=576, c=575, q=3)
Task dump for CPU 0:
bash            R running      0  1849   1848 0x00000002
Backtrace:
[<80065894>] (lock_acquire) from [<80061410>] (trace_hardirqs_off+0x14/0x18)
Backtrace aborted due to bad frame pointer <bd907b3c>

