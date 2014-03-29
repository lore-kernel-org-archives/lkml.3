Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaC2JrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:47:04 -0400
Received: from mout.gmx.net ([212.227.17.21]:59216 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbaC2JrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:47:00 -0400
Message-ID: <5336968E.9050406@gmx.de>
Date: Sat, 29 Mar 2014 10:46:54 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <5313037F.2040000@gmx.de>
In-Reply-To: <5313037F.2040000@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:mmS7OcwnQyPv5YBq/yaR2Asc6uJBC3FdPQRCg/UjBa6l3qnT0I+
 iU7g1SfX3Mgzgjv1qGI3y4PKVUjj5hiqAD7nUFuFXECOAEEMKJBMRJmUHYzjkRMh7K4w2e6
 6PHY9ZDzCjAT3VRNPvc21i5Fh4PzxepwRaCbOA72+Hl5rmiQSq31NTZg0zoHm0Wk2e8Kexp
 GO3B1d+Tp726NUIBqbCVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256


In the mean while I bisected that merge id few times more to be the first bad commit - by choosing your tip tree instead of Linus git tree nad bisecting between HEAD and v3.9.

The picture is always the same - the KVM hangs, after 2 mins NMIs do happen, often, often, but not always I do have iwlwifi messages too, here's an example :


Mar 27 22:02:09 n22 smartd[6549]: Monitoring 2 ATA and 0 SCSI devices
Mar 27 22:02:10 n22 smartd[6549]: Device: /dev/sdb [USB Sunplus], 2 Offline uncorrectable sectors
Mar 27 22:02:10 n22 smartd[6549]: Device: /dev/sdb [USB Sunplus], previous self-test completed with error (read test element)
Mar 27 22:02:10 n22 smartd[6572]: smartd has fork()ed into background mode. New PID=6572.
Mar 27 22:02:10 n22 smartd[6572]: file /var/run/smartd.pid written containing PID 6572
Mar 27 22:03:04 n22 kernel: INFO: rcu_sched self-detected stall on CPU
Mar 27 22:03:04 n22 kernel:     0: (59999 ticks this GP) idle=bc9/140000000000001/0 softirq=12464/12464
Mar 27 22:03:04 n22 kernel:      (t=60000 jiffies g=6333 c=6332 q=89441)
Mar 27 22:03:04 n22 kernel: sending NMI to all CPUs:
Mar 27 22:03:04 n22 kernel: NMI backtrace for cpu 0
Mar 27 22:03:04 n22 kernel: CPU: 0 PID: 6469 Comm: qemu-system-x86 Not tainted 3.12.0-rc4+ #54
Mar 27 22:03:04 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Mar 27 22:03:04 n22 kernel: task: ef603a80 ti: e9c84000 task.ti: e9c84000
Mar 27 22:03:04 n22 kernel: EIP: 0060:[<c12f413d>] EFLAGS: 00000006 CPU: 0
Mar 27 22:03:04 n22 kernel: EIP is at __const_udelay+0xd/0x20
Mar 27 22:03:04 n22 kernel: EAX: 01062560 EBX: 00002710 ECX: c161dde0 EDX: 00278a91
Mar 27 22:03:04 n22 kernel: ESI: 00015d61 EDI: c162d240 EBP: e9c85c78 ESP: e9c85c78
Mar 27 22:03:04 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Mar 27 22:03:04 n22 kernel: CR0: 80050033 CR2: 00000000 CR3: 2b1b9000 CR4: 000427f0
Mar 27 22:03:04 n22 kernel: Stack:
Mar 27 22:03:04 n22 kernel: e9c85c88 c102d665 c1576014 f3643fa0 e9c85cd4 c10b439b c1580d80 0000ea60
Mar 27 22:03:04 n22 kernel: 000018bd 000018bc 00015d61 c10b7799 e9c85cc8 c106b2dd 00000001 00000096
Mar 27 22:03:04 n22 kernel: c1673584 f3643fa0 00000000 c162d240 ef603a80 00000000 00000000 e9c85ce8
Mar 27 22:03:04 n22 kernel: Call Trace:
Mar 27 22:03:04 n22 kernel: [<c102d665>] arch_trigger_all_cpu_backtrace+0x55/0x70
Mar 27 22:03:04 n22 kernel: [<c10b439b>] rcu_check_callbacks+0x2cb/0x540
Mar 27 22:03:04 n22 kernel: [<c10b7799>] ? acct_account_cputime+0x19/0x20
Mar 27 22:03:04 n22 kernel: [<c106b2dd>] ? account_system_time+0xbd/0x170
Mar 27 22:03:04 n22 kernel: [<c1049a1b>] update_process_times+0x3b/0x70
Mar 27 22:03:04 n22 kernel: [<c1090bf3>] tick_sched_handle.isra.11+0x33/0x40
Mar 27 22:03:04 n22 kernel: [<c1090db0>] tick_sched_timer+0x40/0x70
Mar 27 22:03:04 n22 kernel: [<c105da40>] ? __remove_hrtimer+0x40/0xa0
Mar 27 22:03:04 n22 kernel: [<c105dcf9>] __run_hrtimer+0x69/0x190
Mar 27 22:03:04 n22 kernel: [<c1090d70>] ? tick_sched_do_timer+0x40/0x40
Mar 27 22:03:04 n22 kernel: [<c105e877>] hrtimer_interrupt+0xf7/0x290
Mar 27 22:03:04 n22 kernel: [<c105e8f8>] ? hrtimer_interrupt+0x178/0x290
Mar 27 22:03:04 n22 kernel: [<c102b3df>] local_apic_timer_interrupt+0x2f/0x60
Mar 27 22:03:04 n22 kernel: [<c1041df5>] ? irq_enter+0x15/0x60
Mar 27 22:03:04 n22 kernel: [<c14a2403>] smp_apic_timer_interrupt+0x33/0x50
Mar 27 22:03:04 n22 kernel: [<c14a16fc>] apic_timer_interrupt+0x34/0x3c
Mar 27 22:03:04 n22 kernel: [<f8b4fa33>] ? kvm_resched+0x3/0x30 [kvm]
Mar 27 22:03:04 n22 kernel: [<f8b672b2>] kvm_arch_vcpu_ioctl_run+0xf32/0x10a0 [kvm]
Mar 27 22:03:04 n22 kernel: [<c106fe58>] ? task_tick_fair+0x128/0x690
Mar 27 22:03:04 n22 kernel: [<c106a6bd>] ? __update_cpu_load+0xad/0xe0
Mar 27 22:03:04 n22 kernel: [<c106754e>] ? scheduler_tick+0x8e/0xc0
Mar 27 22:03:04 n22 kernel: [<f8b621e8>] ? kvm_arch_vcpu_load+0x58/0x200 [kvm]
Mar 27 22:03:04 n22 kernel: [<f8b52003>] kvm_vcpu_ioctl+0x453/0x4f0 [kvm]
Mar 27 22:03:04 n22 kernel: [<c108f235>] ? clockevents_program_event+0xa5/0x160
Mar 27 22:03:04 n22 kernel: [<c1090a39>] ? tick_program_event+0x29/0x30
Mar 27 22:03:04 n22 kernel: [<c105e8f8>] ? hrtimer_interrupt+0x178/0x290
Mar 27 22:03:04 n22 kernel: [<f8b51bb0>] ? vcpu_put+0x30/0x30 [kvm]
Mar 27 22:03:04 n22 kernel: [<c113edf7>] do_vfs_ioctl+0x77/0x560
Mar 27 22:03:04 n22 kernel: [<c1041e9a>] ? irq_exit+0x5a/0x90
Mar 27 22:03:04 n22 kernel: [<c14a2408>] ? smp_apic_timer_interrupt+0x38/0x50
Mar 27 22:03:04 n22 kernel: [<c14a16fc>] ? apic_timer_interrupt+0x34/0x3c
Mar 27 22:03:04 n22 kernel: [<c113f325>] SyS_ioctl+0x45/0x70
Mar 27 22:03:04 n22 kernel: [<c14a1d81>] sysenter_do_call+0x12/0x22
Mar 27 22:03:04 n22 kernel: Code: fd 48 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 66 66 66 66 90 ff 15 2c 2a 65 c1 5d c3 55 c1 e0 02 89 e5 64 8b 15 9c ff 6f c1 <69> d2 fa 00 00 00 f7 e2 8d 42 01 ff 15 2c 2a 65 c1 5d c3 55 89
Mar 27 22:03:04 n22 kernel: NMI backtrace for cpu 1
Mar 27 22:03:04 n22 kernel: CPU: 1 PID: 6412 Comm: period_search_1 Not tainted 3.12.0-rc4+ #54
Mar 27 22:03:04 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Mar 27 22:03:04 n22 kernel: task: ef6f0d80 ti: eb0fc000 task.ti: eb0fc000
Mar 27 22:03:04 n22 kernel: EIP: 0073:[<080515e4>] EFLAGS: 00000297 CPU: 1
Mar 27 22:03:04 n22 kernel: EIP is at 0x80515e4
Mar 27 22:03:04 n22 kernel: EAX: 00000036 EBX: 00000036 ECX: 00000030 EDX: 089c1520
Mar 27 22:03:04 n22 kernel: ESI: 08a68720 EDI: 089b5f60 EBP: bf8ee7b8 ESP: bf8ee710
Mar 27 22:03:04 n22 kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Mar 27 22:03:04 n22 kernel:
Mar 27 22:03:04 n22 kernel: NMI backtrace for cpu 3
Mar 27 22:03:04 n22 kernel: CPU: 3 PID: 6413 Comm: wcgrid_mcm1_7.2 Not tainted 3.12.0-rc4+ #54
Mar 27 22:03:04 n22 kernel: Hardware name: LENOVO 4180F65/4180F65, BIOS 83ET75WW (1.45 ) 05/10/2013
Mar 27 22:03:04 n22 kernel: task: ef6f2d00 ti: ef434000 task.ti: ef434000
Mar 27 22:03:04 n22 kernel: EIP: 0073:[<0804e100>] EFLAGS: 00000202 CPU: 3
Mar 27 22:03:04 n22 kernel: EIP is at 0x804e100
Mar 27 22:03:04 n22 kernel: EAX: 00000012 EBX: 00000016 ECX: 00000004 EDX: 0b67a9c8
Mar 27 22:03:04 n22 kernel: ESI: 0b67b908 EDI: 00000005 EBP: bfda6bd8 ESP: bfda6b50
Mar 27 22:03:04 n22 kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Mar 27 22:03:04 n22 kernel:
Mar 27 22:03:04 n22 kernel: NMI backtrace for cpu 2









On 03/02/2014 11:10 AM, Toralf Förster wrote:
> Hello Ingo,
> 
> 
> the issue I mentioned in [1] and [2] was bisected now few times in a
> row to this id :
> 
> 
> commit 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
> Merge: 6bfa687 d0e639c
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Wed Oct 9 12:36:13 2013 +0200
> 
>     Merge tag 'v3.12-rc4' into sched/core
> 
>     Merge Linux v3.12-rc4 to fix a conflict and also to refresh the tree
>     before applying more scheduler patches.
> 
>     Conflicts:
>         arch/avr32/include/asm/Kbuild
> 
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> 
> Unfortunately I cannot blame a single commit of the merged branch for
> the breakage of my system (till now). But with kernels after the merge
> commit I cannot longer start a KVM machine here.
> 
> Do you have any idea how I could continue to nail down the problem ?
> 
> 
> 
> [1] http://article.gmane.org/gmane.linux.kernel/1657962
> [2] http://article.gmane.org/gmane.linux.kernel/1633225
> 
> 
> 

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlM2lo4ACgkQxOrN3gB26U5/twD/Tcf4Dz59r7eNoq+cQLujwmCn
lRyyaIgUkhebhpOeRFMA/0tWmEpPxEjrlwB9WZzRPVG6d19QkVYgh22oKz/NJowA
=OVT9
-----END PGP SIGNATURE-----
