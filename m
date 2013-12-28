Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3L1Wrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 17:47:43 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52565 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3L1Wrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 17:47:41 -0500
X-Greylist: delayed 2070 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2013 17:47:40 EST
Message-ID: <52BF4A80.3010503@halfdog.net>
Date: Sat, 28 Dec 2013 22:02:40 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

It seems that missing CPU-state sanitation during task switching
triggers kernel-panic. This might be related to unhandled FPU-errors.
See [1] for POC and serial console log of OOPs. Due to missing real
32-bit x86-hardware it is not clear, if this issue might be related to
subtle differences in virtual-8086 mode handling when inside a
virtualbox guest.

hd

[1] http://www.halfdog.net/Security/2013/Vm86SyscallTaskSwitchKernelPanic/


[  348.270712] fpu exception: 0000 [#1]
[  348.270763] Modules linked in: nfnetlink_log nfnetlink xt_multiport
xt_hashlimit xt_tcpudp ipt_ULOG xt_LOG xt_conntrack iptable_raw
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_filter ip_tables x_tables snd_pcm
snd_page_alloc snd_timer snd parport_pc soundcore microcode psmouse
serio_raw pcspkr evdev parport ac battery button i2c_piix4 i2c_core
ext4 crc16 mbcache jbd2 sg sr_mod sd_mod cdrom crc_t10dif ata_generic
ata_piix mptspi scsi_transport_spi mptscsih libata mptbase pcnet32 mii
scsi_mod
[  348.270763] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 3.11-2-486
#1 Debian 3.11.10-1
[  348.270763] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  348.270763] task: cf835400 ti: cf930000 task.ti: cf84a000
[  348.270763] EIP: 0060:[<c10013e0>] EFLAGS: 00010002 CPU: 0
[  348.270763] EIP is at __switch_to+0x190/0x300
[  348.270763] EAX: cd2eec00 EBX: cd2eec00 ECX: 00000000 EDX: 00000000
[  348.270763] ESI: cf835400 EDI: 00000001 EBP: cd2eedf8 ESP: cf931a40
[  348.270763]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  348.270763] CR0: 80050033 CR2: b76997e0 CR3: 0d11a000 CR4: 00000690
[  348.270763] Stack:
[  348.270763]  4a6ef7ab ccee9c80 ccee9900 cf835400 c13978cf cd2eec00
00200082 c15de480
[  348.270763]  00000018 67bf6d70 cf930000 cd2eec00 1625d3df 00000051
cd2eec2c c1056e15
[  348.270763]  00200086 0000000a cf931a90 c1006cc8 00393f1e 00000000
5d3e5d0f 00000040
[  348.270763] Call Trace:
[  348.270763]  [<c13978cf>] ? __schedule+0x1ef/0x510
[  348.270763]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.270763]  [<c1006cc8>] ? sched_clock+0x8/0x10
[  348.270763]  [<c13973d5>] ? schedule_hrtimeout_range_clock+0x165/0x180
[  348.270763]  [<c1044e9f>] ? __flush_work+0xbf/0x100
[  348.270763]  [<d0a4fa59>] ? nf_nat_get_offset+0x39/0x60 [nf_nat]
[  348.270763]  [<d0a68df7>] ? tcp_packet+0x637/0xf40 [nf_conntrack]
[  348.270763]  [<c124932c>] ? tty_write_room+0xc/0x20
[  348.270763]  [<c1246fb9>] ? n_tty_poll+0x189/0x1a0
[  348.270763]  [<c13973ff>] ? schedule_hrtimeout_range+0xf/0x20
[  348.270763]  [<c11093a0>] ? poll_schedule_timeout+0x20/0x40
[  348.270763]  [<c1109c77>] ? do_select+0x537/0x5f0
[  348.270763]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.270763]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.270763]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.270763]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.270763]  [<c12f688d>] ? nf_iterate+0x7d/0x90
[  348.270763]  [<c1067e6c>] ? __getnstimeofday+0x2c/0x110
[  348.270763]  [<c133f7f2>] ? bictcp_cong_avoid+0x12/0x4a0
[  348.270763]  [<c1067f55>] ? getnstimeofday+0x5/0x20
[  348.270763]  [<c131116b>] ? tcp_ack+0x82b/0xdc0
[  348.270763]  [<c10353a0>] ? local_bh_enable+0x70/0x80
[  348.270763]  [<c1300301>] ? ip_finish_output+0x151/0x350
[  348.270763]  [<c10c612a>] ? put_compound_page+0xa/0xe0
[  348.270763]  [<c1311b07>] ? tcp_rcv_established+0xf7/0x7a0
[  348.270763]  [<c12c1edc>] ? sk_reset_timer+0xc/0x20
[  348.270763]  [<c131a94e>] ? tcp_v4_do_rcv+0x15e/0x3b0
[  348.270763]  [<c12c3558>] ? release_sock+0x88/0xf0
[  348.270763]  [<c13088d7>] ? tcp_sendmsg+0x177/0xc60
[  348.270763]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.270763]  [<c1109e5c>] ? core_sys_select+0x12c/0x220
[  348.270763]  [<c12beee1>] ? sock_aio_write+0xe1/0x110
[  348.270763]  [<c10f9cda>] ? do_sync_write+0x6a/0xa0
[  348.270763]  [<c112b673>] ? fsnotify+0x203/0x2f0
[  348.270763]  [<c1109fdf>] ? SyS_select+0x8f/0xc0
[  348.270763]  [<c100aca2>] ? syscall_trace_leave+0xa2/0xb0
[  348.270763]  [<c1398fef>] ? syscall_call+0x7/0xb
[  348.270763] Code: e9 1d ff ff ff 8d b6 00 00 00 00 b8 7d 00 00 00
e8 36 b8 00 00 84 c0 0f 85 e1 fe ff ff 0f 06 8d 74 26 00 e9 d6 fe ff
ff 8d 76 00 <0f> 77 db 83 4c 02 00 00 89 f6 8d b6 00 00 00 00 eb 66 b8
ff ff
[  348.270763] EIP: [<c10013e0>] __switch_to+0x190/0x300 SS:ESP
0068:cf931a40
[  348.270763] ---[ end trace c3836805b501f815 ]---
[  348.274764] ------------[ cut here ]------------
[  348.278424] kernel BUG at
/build/linux-tAcKXn/linux-3.11.10/kernel/exit.c:870!
[  348.278764] invalid opcode: 0000 [#2]
[  348.278764] Modules linked in: nfnetlink_log nfnetlink xt_multiport
xt_hashlimit xt_tcpudp ipt_ULOG xt_LOG xt_conntrack iptable_raw
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_filter ip_tables x_tables snd_pcm
snd_page_alloc snd_timer snd parport_pc soundcore microcode psmouse
serio_raw pcspkr evdev parport ac battery button i2c_piix4 i2c_core
ext4 crc16 mbcache jbd2 sg sr_mod sd_mod cdrom crc_t10dif ata_generic
ata_piix mptspi scsi_transport_spi mptscsih libata mptbase pcnet32 mii
scsi_mod
[  348.278764] CPU: 0 PID: 2220 Comm: sshd Tainted: G      D
3.11-2-486 #1 Debian 3.11.10-1
[  348.278764] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  348.278764] task: cd2eec00 ti: cf930000 task.ti: cf930000
[  348.278764] EIP: 0060:[<c103348a>] EFLAGS: 00010282 CPU: 0
[  348.278764] EIP is at do_exit+0x44a/0x830
[  348.278764] EAX: 00000080 EBX: cf835400 ECX: 00000000 EDX: cd2eec00
[  348.278764] ESI: 00000001 EDI: 00000001 EBP: cf835c00 ESP: cf93190c
[  348.278764]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  348.278764] CR0: 80050033 CR2: b74faf38 CR3: 0d11a000 CR4: 00000690
[  348.278764] Stack:
[  348.278764]  0000000b cf931a04 00000010 c1393e1c cf835510 cf8353f8
cf835510 00000001
[  348.278764]  cf835558 cf931930 cf931930 00000046 0000000b cf931a04
00000010 c1399cf1
[  348.278764]  cf931a04 cf931a04 cf835400 c1446e22 c10029be 00000000
00000010 00000008
[  348.278764] Call Trace:
[  348.278764]  [<c1393e1c>] ? printk+0x37/0x3b
[  348.278764]  [<c1399cf1>] ? oops_end+0x81/0xc0
[  348.278764]  [<c10029be>] ? math_error+0x14e/0x2d0
[  348.278764]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.278764]  [<c1056921>] ? sched_slice.isra.35+0x41/0x80
[  348.278764]  [<c1055a8a>] ? update_cpu_load_active+0x1a/0x80
[  348.278764]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.278764]  [<c1002b40>] ? math_error+0x2d0/0x2d0
[  348.278764]  [<c1399585>] ? error_code+0x65/0x70
[  348.278764]  [<c10013e0>] ? __switch_to+0x190/0x300
[  348.278764]  [<c13978cf>] ? __schedule+0x1ef/0x510
[  348.278764]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.278764]  [<c1006cc8>] ? sched_clock+0x8/0x10
[  348.278764]  [<c13973d5>] ? schedule_hrtimeout_range_clock+0x165/0x180
[  348.278764]  [<c1044e9f>] ? __flush_work+0xbf/0x100
[  348.278764]  [<d0a4fa59>] ? nf_nat_get_offset+0x39/0x60 [nf_nat]
[  348.278764]  [<d0a68df7>] ? tcp_packet+0x637/0xf40 [nf_conntrack]
[  348.278764]  [<c124932c>] ? tty_write_room+0xc/0x20
[  348.278764]  [<c1246fb9>] ? n_tty_poll+0x189/0x1a0
[  348.278764]  [<c13973ff>] ? schedule_hrtimeout_range+0xf/0x20
[  348.278764]  [<c11093a0>] ? poll_schedule_timeout+0x20/0x40
[  348.278764]  [<c1109c77>] ? do_select+0x537/0x5f0
[  348.278764]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.278764]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.278764]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.278764]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.278764]  [<c12f688d>] ? nf_iterate+0x7d/0x90
[  348.278764]  [<c1067e6c>] ? __getnstimeofday+0x2c/0x110
[  348.278764]  [<c133f7f2>] ? bictcp_cong_avoid+0x12/0x4a0
[  348.278764]  [<c1067f55>] ? getnstimeofday+0x5/0x20
[  348.278764]  [<c131116b>] ? tcp_ack+0x82b/0xdc0
[  348.278764]  [<c10353a0>] ? local_bh_enable+0x70/0x80
[  348.278764]  [<c1300301>] ? ip_finish_output+0x151/0x350
[  348.278764]  [<c10c612a>] ? put_compound_page+0xa/0xe0
[  348.278764]  [<c1311b07>] ? tcp_rcv_established+0xf7/0x7a0
[  348.278764]  [<c12c1edc>] ? sk_reset_timer+0xc/0x20
[  348.278764]  [<c131a94e>] ? tcp_v4_do_rcv+0x15e/0x3b0
[  348.278764]  [<c12c3558>] ? release_sock+0x88/0xf0
[  348.278764]  [<c13088d7>] ? tcp_sendmsg+0x177/0xc60
[  348.278764]  [<c1056e15>] ? update_curr+0x95/0x140
[  348.278764]  [<c1109e5c>] ? core_sys_select+0x12c/0x220
[  348.278764]  [<c12beee1>] ? sock_aio_write+0xe1/0x110
[  348.278764]  [<c10f9cda>] ? do_sync_write+0x6a/0xa0
[  348.278764]  [<c112b673>] ? fsnotify+0x203/0x2f0
[  348.278764]  [<c1109fdf>] ? SyS_select+0x8f/0xc0
[  348.278764]  [<c100aca2>] ? syscall_trace_leave+0xa2/0xb0
[  348.278764]  [<c1398fef>] ? syscall_call+0x7/0xb
[  348.278764] Code: 74 05 e8 9a 2d 09 00 8b 83 c4 03 00 00 85 c0 74
06 01 05 60 d8 4e c1 f3 90 81 4b 0c 00 80 00 00 c7 03 40 00 00 00 e8
66 47 36 00 <0f> 0b 8d 74 26 00 8b 46 10 85 c0 0f 85 67 02 00 00 89 ae
0c 01
[  348.278764] EIP: [<c103348a>] do_exit+0x44a/0x830 SS:ESP 0068:cf93190c
[  348.278776] ---[ end trace c3836805b501f816 ]---
[  348.285890] type=1106 audit(1388235169.398:64338): pid=2218 uid=0
auid=1000 ses=2
[  348.285890]  msg='op=PAM:session_close acct="test"
exe="/usr/sbin/sshd" hostname=10.255.255.1 addr=10.255.255.1
terminal=ssh res=success'
[  348.287096] type=1104 audit(1388235169.402:64339): pid=2218 uid=0
auid=1000 ses=2
[  348.287096]  msg='op=PAM:setcred acct="test" exe="/usr/sbin/sshd"
hostname=10.255.255.1 addr=10.255.255.1 terminal=ssh res=success'
[  348.766895] fpu exception: 0000 [#3]
[  348.770794] Modules linked in: nfnetlink_log nfnetlink xt_multiport
xt_hashlimit xt_tcpudp ipt_ULOG xt_LOG xt_conntrack iptable_raw
iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack iptable_mangle iptable_filter ip_tables x_tables snd_pcm
snd_page_alloc snd_timer snd parport_pc soundcore microcode psmouse
serio_raw pcspkr evdev parport ac battery button i2c_piix4 i2c_core
ext4 crc16 mbcache jbd2 sg sr_mod sd_mod cdrom crc_t10dif ata_generic
ata_piix mptspi scsi_transport_spi mptscsih libata mptbase pcnet32 mii
scsi_mod
[  348.770794] CPU: 0 PID: 0 Comm: swapper Tainted: G      D
3.11-2-486 #1 Debian 3.11.10-1
[  348.770794] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  348.770794] task: c14d84e0 ti: cdd84000 task.ti: c14cc000
[  348.770794] EIP: 0060:[<c10013e0>] EFLAGS: 00210002 CPU: 0
[  348.770794] EIP is at __switch_to+0x190/0x300
[  348.770794] EAX: cf5ec000 EBX: cf5ec000 ECX: 00000000 EDX: 00000000
[  348.770794] ESI: c14d84e0 EDI: 00000001 EBP: cf5ec1f8 ESP: cdd85ad8
[  348.770794]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  348.770794] CR0: 80050033 CR2: b7662000 CR3: 0cdb3000 CR4: 00000690
[  348.770794] Stack:
[  348.770794]  37df9a44 ccf3d040 ccf3dac0 c14d84e0 c13978cf cf5ec000
00200082 00000000
[  348.770794]  00000000 00000000 cdd84000 cf5ec000 00000000 ccf11ef0
c14e6e98 c11c4d70
[  348.770794]  65747300 cdd85b7c c14e6e8c c104d0ca 65747300 cdd85b7c
c14e6e8c 00200292
[  348.770794] Call Trace:
[  348.770794]  [<c13978cf>] ? __schedule+0x1ef/0x510
[  348.770794]  [<c11c4d70>] ? timerqueue_add+0x50/0xb0
[  348.770794]  [<c104d0ca>] ? enqueue_hrtimer+0x1a/0x60
[  348.770794]  [<c1397332>] ? schedule_hrtimeout_range_clock+0xc2/0x180
[  348.770794]  [<c104cdc0>] ? hrtimer_get_res+0x30/0x30
[  348.770794]  [<c139731d>] ? schedule_hrtimeout_range_clock+0xad/0x180
[  348.770794]  [<c13973ff>] ? schedule_hrtimeout_range+0xf/0x20
[  348.770794]  [<c11093a0>] ? poll_schedule_timeout+0x20/0x40
[  348.770794]  [<c110a671>] ? do_sys_poll+0x3f1/0x490
[  348.770794]  [<c12d33c8>] ? dev_queue_xmit+0x1f8/0x3b0
[  348.770794]  [<c10353a0>] ? local_bh_enable+0x70/0x80
[  348.770794]  [<c1300301>] ? ip_finish_output+0x151/0x350
[  348.770794]  [<c13005c8>] ? ip_local_out+0x18/0x20
[  348.770794]  [<c13017cb>] ? ip_send_skb+0xb/0x50
[  348.770794]  [<c132376b>] ? udp_send_skb+0x27b/0x340
[  348.770794]  [<c1323af8>] ? udp_sendmsg+0x268/0x820
[  348.770794]  [<c12ff070>] ? ip_copy_metadata+0x140/0x140
[  348.770794]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.770794]  [<c11094d0>] ? poll_select_copy_remaining+0x110/0x110
[  348.770794]  [<c11c59f8>] ? put_dec.part.1+0xb8/0x100
[  348.770794]  [<c11c5dcf>] ? number.isra.2+0x38f/0x3a0
[  348.770794]  [<c11c76d9>] ? vsnprintf+0x179/0x420
[  348.770794]  [<c10bbc60>] ? find_get_page+0x10/0x50
[  348.770794]  [<c10bc5af>] ? find_lock_page+0x1f/0x60
[  348.770794]  [<c10ce33d>] ? shmem_getpage_gfp+0x7d/0x680
[  348.770794]  [<c11c5448>] ? format_decode+0x308/0x370
[  348.770794]  [<c11c770b>] ? vsnprintf+0x1ab/0x420
[  348.770794]  [<c10cf09f>] ? shmem_fault+0x3f/0x90
[  348.770794]  [<c10d8059>] ? __do_fault+0x329/0x450
[  348.770794]  [<c1396c18>] ? mutex_lock+0x8/0x15
[  348.770794]  [<c1100f35>] ? pipe_read+0x205/0x470
[  348.770794]  [<c10f9c3a>] ? do_sync_read+0x6a/0xa0
[  348.770794]  [<c1068117>] ? ktime_get_ts+0x37/0xf0
[  348.770794]  [<c1109718>] ? poll_select_set_timeout+0x58/0x80
[  348.770794]  [<c110a7ad>] ? SyS_poll+0x4d/0xb0
[  348.770794]  [<c1398fef>] ? syscall_call+0x7/0xb
[  348.770794] Code: e9 1d ff ff ff 8d b6 00 00 00 00 b8 7d 00 00 00
e8 36 b8 00 00 84 c0 0f 85 e1 fe ff ff 0f 06 8d 74 26 00 e9 d6 fe ff
ff 8d 76 00 <0f> 77 db 83 4c 02 00 00 89 f6 8d b6 00 00 00 00 eb 66 b8
ff ff
[  348.770794] EIP: [<c10013e0>] __switch_to+0x190/0x300 SS:ESP
0068:cdd85ad8
[  348.770794] ---[ end trace c3836805b501f817 ]---
[  348.770794] Kernel panic - not syncing: Attempted to kill the idle
task!



- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlK/Sl0ACgkQxFmThv7tq+6hcwCfSwoLsuqvl62oKVsbwUun2fi4
67sAn3UXxmyW8oEbMSuOu2KX7r/D4CMe
=YIVj
-----END PGP SIGNATURE-----
