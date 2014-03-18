Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaCRTah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:30:37 -0400
Received: from mail-s79.mailgun.info ([184.173.153.207]:48647 "EHLO
	mail-s79.mailgun.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbaCRTae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:30:34 -0400
X-Greylist: delayed 1756 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 15:30:33 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=infinitecorridor.org; s=mx;
 q=dns; h=Date: From: To: Subject: Message-Id: Mime-Version:
 Content-Type: Sender;
 b=XA+MIsKYTva5cAJhCrR80uR6D6jiCObsS9zzLsSGWoiHbc2ahnN7C0eIfu+NKR1a/d0B7c
 ydyOs35aD3s0YqRVPV6J1xevyelWsqr1nSvUPc1XHGzLXEOeOODWEPsSVKXP0w8xTHSoERKL
 F8YUNPi0eEoDK27xRGT4mhXphZwrI=
Date: Tue, 18 Mar 2014 14:49:09 -0400
From: dafreedm@gmail.com
To: linux-kernel@vger.kernel.org
Subject: Consistent kernel oops with 3.11.10 & 3.12.9 on Haswell CPUs...
Message-Id: <20140318184909.GA26255@ofan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mailgun-Sid: WyIzZDFlZSIsICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiwgIjViMTFkIl0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

First-time poster to LKML, though I've been a Linux user for the past
15+ years.  Thanks to you all for your collective efforts at creating
such a great (useful, stable, etc) kernel...

Problem at hand: I'm getting consistent kernel oops (at times,
hard-crashes) on two of my identical servers (they are much more
common on one of the servers than the other, but I see them on both).
Please reference the kernel log messages appended to this email [1].

Though at times the oops occur even when the system is largely idle,
they seem to be exacerbated by md5sum'ing all files on a large
partition as part of archive verification --- say 1 million files
corresponding to 1 TByte of storage.  If I perform this repeatedly,
the machines seem to lock up about once a week.  Strangely, other
typical high-load/high-stress scenarios don't seem to provoke the oops
nearly so much (see below).

Naturally, such md5sum usage is putting heavy load on the processor,
memory, and even power supply, and my initial inclination is generally
that I must have some faulty components.  Even after otherwise
ambiguous diagnostics (described below), I'm highly skeptical that
there's anything here inherent to the md5sum codebase, in particular.
However, I have started to wonder whether this might be a kernel
regression...

For reference, here's my setup:

  Mainboard:  Supermicro X10SLQ
  Processor:  (Single-Socket) Intel Haswell i7-4770S (65W max TDP)
  Memory:     32GB Kingston DDR3 RAM (4x KVR16N11/8)
  PSU:        SeaSonic SS-400FL2 400W PSU
  O/S:        Debian v7.4 Wheezy (amd64)
  Filesystem: Ext4 (with default settings upon creation) over LUKS
  Kernel:     Using both:
                Linux 3.11.10 ('3.11-0.bpo.2-amd64' via wheezy-backports)
                Linux 3.12.9 ('3.12-0.bpo.2-amd64' via wheezy-backports)

To summarize where I am now: I've been very extensively testing all of
the likely culprits among hardware components on both of my servers
--- running memtest86 upon boot for 3+ days, memtester in userspace
for 24 hours, repeated kernel compiles with various '-j' values, and
the 'stress' and 'stressapptest' load generators (see [2] for full
details) --- and I have never seen even a hiccup in server operation
under such "artificial" environments --- however, it consistently
occurs with heavy md5sum operation, and randomly at other times.

At least from my past experiences (with scientific HPC clusters), such
diagnostic results would normally seem to largely rule out most
problems with the processor, memory, mainboard subsystems.  The PSU is
often a little harder to rule out, but the 400W Seasonic PSUs are
rated at 2--3 times the wattage I should really need, even under peak
load (given each server's single-socket CPU is 65W at max TDP, there
are only a few HDs and one SSD, and no discrete graphics at all, of
course).

I'm further surprised to see the exact same kernel-crash behavior on
two separate, but identical, servers, which leads me to wonder if
there's possibly some regression between the hardware (given that it's
relatively new Haswell microcode / silicon) and the (kernel?)
software.

Any thoughts on what might be occurring here?  Or what I should focus
on?  Thanks in advance.



[1] Attached 'KernelLogs' file.
[2] Attached 'SystemStressTesting' file.

--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=KernelLogs
Content-Transfer-Encoding: quoted-printable

[1] Here are *some* of the kernel logs (obtained via netconsole output
    to another server).  I have many more OOPS examples, but didn't
    want this email to be overly long:

[5314892.518312] BUG: unable to handle kernel paging request at ffffffff7f1=
80530
[5314892.518343] IP: [<ffffffff7f180530>] 0xffffffff7f18052f
[5314892.518361] PGD 180f067 PUD 0=20
[5314892.518374] Oops: 0010 [#1] SMP=20
[5314892.518386] Modules linked in: netconsole configfs fuse btrfs raid6_pq=
 zlib_deflate xor ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c r=
eiserfs nls_utf8 nls_cp437 vfat fat usb_storage sha256_generic dm_crypt dm_=
mod parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill cpufreq_stats =
cpufreq_userspace cpufreq_conservative cpufreq_powersave nfsd auth_rpcgss o=
id_registry nfs_acl nfs lockd fscache sunrpc loop raid1 md_mod snd_hda_code=
c_realtek snd_hda_codec_hdmi joydev hid_generic hid_kensington usbhid hid x=
86_pkg_temp_thermal coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel=
 aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul glue_helper snd_hda=
_intel snd_hda_codec iTCO_wdt iTCO_vendor_support snd_hwdep evdev snd_pcm s=
nd_page_alloc snd_seq i915 snd_seq_device snd_timer psmouse drm_kms_helper =
snd drm microcode soundcore serio_raw pcspkr lpc_ich i2c_i801 mei_me mfd_co=
re mei acpi_cpufreq mperf processor video button ext4 crc16 mbcache jbd2 sg=
 sd_mod crc_t10dif ahci igb libahci i2c_algo_bit i2c_core libata dca scsi_m=
od ehci_pci ehci_hcd fan xhci_hcd thermal thermal_sys e1000e usbcore ptp us=
b_common pps_core
[5314892.518784] CPU: 0 PID: 24302 Comm: gvfs-afc-volume Not tainted 3.11-0=
=2Ebpo.2-amd64 #1 Debian 3.11.10-1~bpo70+1
[5314892.518809] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/2=
013
[5314892.518833] task: ffff88081e5db840 ti: ffff88081db86000 task.ti: ffff8=
8081db86000
[5314892.518851] RIP: 0010:[<ffffffff7f180530>]  [<ffffffff7f180530>] 0xfff=
fffff7f18052f
[5314892.518873] RSP: 0018:ffff88081db87f00  EFLAGS: 00010282
[5314892.518887] RAX: 0000000000000004 RBX: 00007f22542dad00 RCX: 000000000=
0000008
[5314892.518904] RDX: 00007f22542dad00 RSI: ffff88081db87f10 RDI: 00007f225=
62610f2
[5314892.518921] RBP: 00007f22562610f2 R08: 00007f22542dac40 R09: 000000000=
0000000
[5314892.518939] R10: 0000000000000008 R11: 0000000000000246 R12: 00007f225=
70d81a0
[5314892.518956] R13: 00007f22542db9c0 R14: 00007f2258626040 R15: 000000000=
0000003
[5314892.518973] FS:  00007f22542db700(0000) GS:ffff88083fa00000(0000) knlG=
S:0000000000000000
[5314892.518992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[5314892.519006] CR2: ffffffff7f180530 CR3: 00000007d8713000 CR4: 000000000=
01407f0
[5314892.519023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[5314892.519040] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
[5314892.519057] Stack:
[5314892.519064]  ffffffff81180562 0000000000005eee ffffffff814a7f0d 636661=
2d73667667
[5314892.519087]  00656d756c6f762d 0000000000000000 0000000090f14c50 000000=
0000000000
[5314892.519110]  00007f22542dade0 00007f22542dace0 00000000ffffffff 00007f=
22542db9c0
[5314892.519133] Call Trace:
[5314892.519143]  [<ffffffff81180562>] ? SYSC_newstat+0x12/0x30
[5314892.519160]  [<ffffffff814a7f0d>] ? do_nanosleep+0x8d/0x110
[5314892.519175]  [<ffffffff81082c5d>] ? SyS_nanosleep+0x5d/0x70
[5314892.519191]  [<ffffffff814b29a9>] ? system_call_fastpath+0x16/0x1b
[5314892.519207] Code:  Bad RIP value.
[5314892.519221] RIP  [<ffffffff7f180530>] 0xffffffff7f18052f
[5314892.519237]  RSP <ffff88081db87f00>
[5314892.519246] CR2: ffffffff7f180530
[5314892.524155] ---[ end trace 43fc827669f10a2c ]---


[108440.835190] BUG: unable to handle kernel NULL pointer dereference at 00=
00000000000010
[108440.835224] IP: [<0000000000000010>] 0xf
[108440.835240] PGD 0=20
[108440.835249] Oops: 0010 [#1] SMP=20
[108440.835262] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi hid_kensington joydev hid_generic usbhid hid x86_pkg_t=
emp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec snd_hwdep kvm sn=
d_pcm snd_page_alloc snd_seq snd_seq_device crct10dif_pclmul crc32_pclmul c=
rc32c_intel iTCO_wdt snd_timer iTCO_vendor_support ghash_clmulni_intel evde=
v i915 aesni_intel aes_x86_64 lrw gf128mul glue_helper drm_kms_helper ablk_=
helper snd cryptd drm psmouse mei_me pcspkr mei lpc_ich i2c_i801 soundcore =
mfd_core serio_raw video processor button ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata scsi_mod igb i2c_algo_bit =
i2c_core dca ehci_pci e1000e xhci_hcd ehci_hcd ptp pps_core usbcore usb_com=
mon thermal fan thermal_sys
[108440.835615] CPU: 0 PID: 9268 Comm: kworker/0:1 Not tainted 3.12-0.bpo.1=
-amd64 #1 Debian 3.12.9-1~bpo70+1
[108440.835638] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108440.835662] Workqueue: kcryptd kcryptd_crypt [dm_crypt]
[108440.835676] task: ffff8807eca86040 ti: ffff88080b1b6000 task.ti: ffff88=
080b1b6000
[108440.835694] RIP: 0010:[<0000000000000010>]  [<0000000000000010>] 0xf
[108440.835713] RSP: 0018:ffff88080b1b7d38  EFLAGS: 00010286
[108440.835726] RAX: 0000000000000010 RBX: ffff8807f6741bc0 RCX: 0000000000=
001000
[108440.835744] RDX: ffff8807f6741c40 RSI: ffff88080b1b7d48 RDI: ffff88081b=
b128a0
[108440.835761] RBP: ffff88081bb128a0 R08: 0000000000000000 R09: 0000000000=
000008
[108440.835778] R10: 0000000000000400 R11: dead000000200200 R12: 0000000000=
001000
[108440.835795] R13: ffff8807f6741c40 R14: 0000000000000000 R15: ffffea001b=
af2998
[108440.835812] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS=
:0000000000000000
[108440.835831] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108440.835845] CR2: 0000000000000010 CR3: 000000000180c000 CR4: 0000000000=
1407f0
[108440.835862] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108440.835879] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108440.835899] Stack:
[108440.835905]  ffffffff811ba0bb 00000000811ba475 ffff88081bcdf740 0000000=
000000000
[108440.835928]  0000000000000000 000000000000000f 0000000000000c11 0000000=
000001000
[108440.835950]  ffffea001baf2998 0000000000000001 0000000000001000 ffff880=
81e562cc0
[108440.835973] Call Trace:
[108440.835984]  [<ffffffff811ba0bb>] ? __bio_add_page.part.16+0x10b/0x260
[108440.836002]  [<ffffffffa0658398>] ? kcryptd_crypt+0x118/0x3b0 [dm_crypt]
[108440.836020]  [<ffffffff8107a807>] ? process_one_work+0x157/0x450
[108440.836036]  [<ffffffff8107bc84>] ? worker_thread+0x114/0x370
[108440.836051]  [<ffffffff8107bb70>] ? manage_workers.isra.21+0x2d0/0x2d0
[108440.836068]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[108440.836081]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108440.836098]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[108440.836112]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108440.836126] Code:  Bad RIP value.
[108440.836141] RIP  [<0000000000000010>] 0xf
[108440.836156]  RSP <ffff88080b1b7d38>
[108440.836166] CR2: 0000000000000010
[108440.841374] ---[ end trace 5ee52543e4970e23 ]---
[108440.841396] BUG: unable to handle kernel paging request at ffffffffffff=
ffd8
[108440.841416] IP: [<ffffffff810825e7>] kthread_data+0x7/0x10
[108440.841430] PGD 180f067 PUD 1811067 PMD 0=20
[108440.841444] Oops: 0000 [#2] SMP=20
[108440.841454] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi hid_kensington joydev hid_generic usbhid hid x86_pkg_t=
emp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec snd_hwdep kvm sn=
d_pcm snd_page_alloc snd_seq snd_seq_device crct10dif_pclmul crc32_pclmul c=
rc32c_intel iTCO_wdt snd_timer iTCO_vendor_support ghash_clmulni_intel evde=
v i915 aesni_intel aes_x86_64 lrw gf128mul glue_helper drm_kms_helper ablk_=
helper snd cryptd drm psmouse mei_me pcspkr mei lpc_ich i2c_i801 soundcore =
mfd_core serio_raw video processor button ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata scsi_mod igb i2c_algo_bit =
i2c_core dca ehci_pci e1000e xhci_hcd ehci_hcd ptp pps_core usbcore usb_com=
mon thermal fan thermal_sys
[108440.841765] CPU: 0 PID: 9268 Comm: kworker/0:1 Tainted: G      D      3=
=2E12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108440.841788] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108440.841814] task: ffff8807eca86040 ti: ffff88080b1b6000 task.ti: ffff88=
080b1b6000
[108440.841830] RIP: 0010:[<ffffffff810825e7>]  [<ffffffff810825e7>] kthrea=
d_data+0x7/0x10
[108440.841850] RSP: 0018:ffff88080b1b79f0  EFLAGS: 00010092
[108440.841862] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81=
9ebc00
[108440.841878] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8807ec=
a86040
[108440.841894] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000=
00031d
[108440.841909] R10: 000000000000001a R11: 0000000000000000 R12: 0000000000=
000000
[108440.841925] R13: ffff8807eca86388 R14: ffff8807eca86290 R15: ffff8807ec=
a86030
[108440.841941] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS=
:0000000000000000
[108440.841959] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108440.841972] CR2: 0000000000000028 CR3: 000000000180c000 CR4: 0000000000=
1407f0
[108440.841988] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108440.842004] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108440.842019] Stack:
[108440.842025]  ffffffff8107c0bf ffff8807eca86388 ffff88083fa14300 ffff880=
7eca86040
[108440.842049]  ffffffff814c198a ffff8800371a92c0 ffff88081bacacc0 ffff880=
80b1b7fd8
[108440.842070]  ffff88080b1b7fd8 ffff88080b1b7fd8 ffff8807eca86040 0000000=
000000202
[108440.842091] Call Trace:
[108440.842099]  [<ffffffff8107c0bf>] ? wq_worker_sleeping+0xf/0x90
[108440.843106]  [<ffffffff814c198a>] ? __schedule+0x47a/0x780
[108440.844104]  [<ffffffff81062c1d>] ? do_exit+0x6fd/0xa80
[108440.845102]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[108440.846101]  [<ffffffff814ba5d2>] ? no_context+0x26b/0x27a
[108440.847076]  [<ffffffff814c76c0>] ? __do_page_fault+0x3c0/0x540
[108440.848027]  [<ffffffff811228f6>] ? mempool_alloc+0x56/0x160
[108440.848950]  [<ffffffffa0657980>] ? crypt_map+0xb0/0x150 [dm_crypt]
[108440.849848]  [<ffffffff814c4018>] ? page_fault+0x28/0x30
[108440.850720]  [<ffffffff811ba0bb>] ? __bio_add_page.part.16+0x10b/0x260
[108440.851568]  [<ffffffffa0658398>] ? kcryptd_crypt+0x118/0x3b0 [dm_crypt]
[108440.852410]  [<ffffffff8107a807>] ? process_one_work+0x157/0x450
[108440.853241]  [<ffffffff8107bc84>] ? worker_thread+0x114/0x370
[108440.854067]  [<ffffffff8107bb70>] ? manage_workers.isra.21+0x2d0/0x2d0
[108440.854890]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[108440.855706]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108440.856521]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[108440.857333]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108440.858142] Code: ff ff 66 90 65 48 8b 04 25 40 c8 00 00 48 8b 80 f0 02=
 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 f0 02 00 00=
 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 48 8b b7 f0 02 00 00 ba=20
[108440.859920] RIP  [<ffffffff810825e7>] kthread_data+0x7/0x10
[108440.860779]  RSP <ffff88080b1b79f0>
[108440.861627] CR2: ffffffffffffffd8
[108440.862469] ---[ end trace 5ee52543e4970e24 ]---
[108440.862470] Fixing recursive fault but reboot is needed!


[108476.671288] ------------[ cut here ]------------
[108476.671292] WARNING: CPU: 1 PID: 0 at /build/linux-SMWX37/linux-3.12.9/=
kernel/watchdog.c:245 watchdog_overflow_callback+0x9a/0xc0()
[108476.671293] Watchdog detected hard LOCKUP on cpu 1
[108476.671294] Modules linked in: dm_crypt dm_mod parport_pc ppdev lp parp=
ort bnep rfcomm bluetooth rfkill cpufreq_stats cpufreq_userspace cpufreq_co=
nservative cpufreq_powersave nfsd auth_rpcgss oid_registry nfs_acl nfs lock=
d fscache sunrpc netconsole configfs loop raid1 md_mod snd_hda_codec_realte=
k snd_hda_codec_hdmi hid_kensington joydev hid_generic usbhid hid x86_pkg_t=
emp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec snd_hwdep kvm sn=
d_pcm snd_page_alloc snd_seq snd_seq_device crct10dif_pclmul crc32_pclmul c=
rc32c_intel iTCO_wdt snd_timer iTCO_vendor_support ghash_clmulni_intel evde=
v i915 aesni_intel aes_x86_64 lrw gf128mul glue_helper drm_kms_helper ablk_=
helper snd cryptd drm psmouse mei_me pcspkr mei lpc_ich i2c_i801 soundcore =
mfd_core serio_raw video processor button ext4 crc16 mbcache jbd2 sg sd_mod=
 crc_t10dif crct10dif_common ahci libahci libata scsi_mod igb i2c_algo_bit =
i2c_core dca ehci_pci e1000e xhci_hcd ehci_hcd ptp pps_core usbcore usb_com=
mon thermal fan thermal_sys
[108476.671435] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108476.671436] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108476.671437]  0000000000000000 ffffffff816fc6b0 ffffffff814be0b3 ffff880=
83fa47c58
[108476.671440]  ffffffff810603a7 ffff88083bd57c00 0000000000000000 ffff880=
83fa47d50
[108476.671443]  0000000000000000 ffff88083fa47ef8 ffffffff81060495 fffffff=
f816fc688
[108476.671446] Call Trace:
[108476.671447]  <NMI>  [<ffffffff814be0b3>] ? dump_stack+0x41/0x51
[108476.671452]  [<ffffffff810603a7>] ? warn_slowpath_common+0x87/0xc0
[108476.671454]  [<ffffffff81060495>] ? warn_slowpath_fmt+0x45/0x50
[108476.671456]  [<ffffffff810a9c05>] ? call_console_drivers.constprop.15+0=
x95/0x100
[108476.671458]  [<ffffffff810e8a1a>] ? watchdog_overflow_callback+0x9a/0xc0
[108476.671460]  [<ffffffff81116c4c>] ? __perf_event_overflow+0x9c/0x230
[108476.671462]  [<ffffffff810aa75f>] ? wake_up_klogd+0x2f/0x40
[108476.671464]  [<ffffffff81028ef8>] ? x86_perf_event_set_period+0xd8/0x150
[108476.671466]  [<ffffffff8102fe62>] ? intel_pmu_handle_irq+0x1b2/0x3b0
[108476.671468]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[108476.671470]  [<ffffffff814c5672>] ? perf_event_nmi_handler+0x32/0x60
[108476.671472]  [<ffffffff814c4e05>] ? nmi_handle.isra.3+0x85/0x190
[108476.671474]  [<ffffffff814c56f0>] ? perf_ibs_nmi_handler+0x50/0x50
[108476.671476]  [<ffffffff814c50a9>] ? do_nmi+0x199/0x370
[108476.671478]  [<ffffffff814c4381>] ? end_repeat_nmi+0x1e/0x2e
[108476.671480]  [<ffffffff814c3866>] ? _raw_spin_lock+0x16/0x30
[108476.671482]  [<ffffffff814c3866>] ? _raw_spin_lock+0x16/0x30
[108476.671483]  [<ffffffff814c3866>] ? _raw_spin_lock+0x16/0x30
[108476.671484]  <<EOE>>  <IRQ>  [<ffffffff8109be4e>] ? sched_rt_period_tim=
er+0xde/0x2b0
[108476.671488]  [<ffffffff81289caa>] ? timerqueue_del+0x2a/0x80
[108476.671490]  [<ffffffff810855fb>] ? __run_hrtimer+0x6b/0x210
[108476.671492]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108476.671494]  [<ffffffff8109bd70>] ? dequeue_task_rt+0x50/0x50
[108476.671496]  [<ffffffff81085ed1>] ? hrtimer_interrupt+0x101/0x260
[108476.671498]  [<ffffffff81041ce6>] ? smp_apic_timer_interrupt+0x36/0x50
[108476.671500]  [<ffffffff814cc39d>] ? apic_timer_interrupt+0x6d/0x80
[108476.671500]  <EOI>  [<ffffffff813a012e>] ? cpuidle_enter_state+0x5e/0xf0
[108476.671504]  [<ffffffff813a0124>] ? cpuidle_enter_state+0x54/0xf0
[108476.671506]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108476.671508]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108476.671509]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108476.671511]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108476.671513] ---[ end trace 5ee52543e4970e26 ]---


[108651.050768] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detect=
ed by 5, t=3D52520 jiffies, g=3D201557, c=3D201556, q=3D581)
[108651.050854] sending NMI to all CPUs:
[108651.050857] NMI backtrace for cpu 5
[108651.050859] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.050871] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.050872] task: ffff88083bd39800 ti: ffff88083bd5e000 task.ti: ffff88=
083bd5e000
[108651.050874] RIP: 0010:[<ffffffff81290a64>]  [<ffffffff81290a64>] __bitm=
ap_andnot+0x24/0x50
[108651.050877] RSP: 0018:ffff88083fb43db0  EFLAGS: 00000006
[108651.050879] RAX: 0000000000000000 RBX: ffff88083fb4de00 RCX: 0000000000=
000003
[108651.050881] RDX: ffff88083fa0de40 RSI: ffff88083fb4de00 RDI: ffff88083f=
b4de00
[108651.050882] RBP: ffff88083fa0de40 R08: 0000000000000000 R09: 0000000000=
000008
[108651.050884] R10: 0000000000000803 R11: 0000000000000000 R12: 0000000000=
00de80
[108651.050885] R13: 0000000000080000 R14: 0000000000000000 R15: 0000000000=
0000ff
[108651.050887] FS:  0000000000000000(0000) GS:ffff88083fb40000(0000) knlGS=
:0000000000000000
[108651.050889] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.050891] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.050892] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.050894] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.050895] Stack:
[108651.050896]  ffffffff81047778 0000000000000005 000000000000de40 0000000=
500000002
[108651.050901]  0000000000000096 ffff88083fb43e28 0000000000002710 fffffff=
f81841900
[108651.050905]  ffffffff81841900 0000000000000005 ffffffff818a0d00 ffff880=
83bd5e000
[108651.050910] Call Trace:
[108651.050911]  <IRQ>=20
[108651.050912]  [<ffffffff81047778>] ? __x2apic_send_IPI_mask+0x168/0x190
[108651.050918]  [<ffffffff8104391f>] ? arch_trigger_all_cpu_backtrace+0x4f=
/0x90
[108651.050921]  [<ffffffff810ec991>] ? rcu_check_callbacks+0x601/0x650
[108651.050924]  [<ffffffff8106e09f>] ? update_process_times+0x3f/0x80
[108651.050926]  [<ffffffff810bdcaa>] ? tick_sched_handle.isra.10+0x2a/0x70
[108651.050929]  [<ffffffff810bddd5>] ? tick_sched_timer+0x45/0x70
[108651.050931]  [<ffffffff810855fb>] ? __run_hrtimer+0x6b/0x210
[108651.050997]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.051000]  [<ffffffff810bdd90>] ? tick_nohz_handler+0xa0/0xa0
[108651.051003]  [<ffffffff81085ed1>] ? hrtimer_interrupt+0x101/0x260
[108651.051005]  [<ffffffff81041ce6>] ? smp_apic_timer_interrupt+0x36/0x50
[108651.051008]  [<ffffffff814cc39d>] ? apic_timer_interrupt+0x6d/0x80
[108651.051009]  <EOI>=20
[108651.051011]  [<ffffffff813a012e>] ? cpuidle_enter_state+0x5e/0xf0
[108651.051016]  [<ffffffff813a0124>] ? cpuidle_enter_state+0x54/0xf0
[108651.051019]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.051022]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.051024]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.051027]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.051028] Code: 39 c0 7f eb f3 c3 90 4c 63 c9 31 c0 49 83 c1 3f 49 c1=
 e9 06 45 85 c9 7e 31 31 c9 45 31 c0 66 0f 1f 84 00 00 00 00 00 48 8b 04 ca=
 <48> f7 d0 48 23 04 ce 48 89 04 cf 48 83 c1 01 49 09 c0 41 39 c9=20
[108651.051076] NMI backtrace for cpu 1
[108651.051079] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.051080] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.051082] task: ffff88083bd0c840 ti: ffff88083bd32000 task.ti: ffff88=
083bd32000
[108651.051083] RIP: 0010:[<ffffffff814c3869>]  [<ffffffff814c3869>] _raw_s=
pin_lock+0x19/0x30
[108651.051087] RSP: 0018:ffff88083fa43e70  EFLAGS: 00000093
[108651.051088] RAX: 00000000000021ec RBX: 0000000000000000 RCX: ffff88083f=
a14300
[108651.051090] RDX: 00000000000021ee RSI: 0000000000000200 RDI: ffff88083f=
a14300
[108651.051091] RBP: ffffffff818a0cc0 R08: ffffffff818a0cc8 R09: 0000000000=
000000
[108651.051093] R10: 7fffffffffffffff R11: 7fffffffffffffff R12: 0000000000=
014300
[108651.051094] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000=
000001
[108651.051096] FS:  0000000000000000(0000) GS:ffff88083fa40000(0000) knlGS=
:0000000000000000
[108651.051098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.051099] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.051101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.051102] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.051103] Stack:
[108651.051105]  ffffffff8109be4e 00000001019cefe3 ffff88083fa14300 0000000=
000000000
[108651.051109]  ffffffff81289caa ffffffff819ee4b8 ffffffff819ee4a0 ffff880=
83fa4e220
[108651.051113]  ffffffff819ee4b8 ffff88083fa4e1e0 ffff88083fa43f60 ffff880=
83fa4e220
[108651.051117] Call Trace:
[108651.051118]  <IRQ>=20
[108651.051119]  [<ffffffff8109be4e>] ? sched_rt_period_timer+0xde/0x2b0
[108651.051125]  [<ffffffff81289caa>] ? timerqueue_del+0x2a/0x80
[108651.051127]  [<ffffffff810855fb>] ? __run_hrtimer+0x6b/0x210
[108651.051129]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.051132]  [<ffffffff8109bd70>] ? dequeue_task_rt+0x50/0x50
[108651.051134]  [<ffffffff81085ed1>] ? hrtimer_interrupt+0x101/0x260
[108651.051137]  [<ffffffff81041ce6>] ? smp_apic_timer_interrupt+0x36/0x50
[108651.051198]  [<ffffffff814cc39d>] ? apic_timer_interrupt+0x6d/0x80
[108651.051199]  <EOI>=20
[108651.051200]  [<ffffffff813a012e>] ? cpuidle_enter_state+0x5e/0xf0
[108651.051205]  [<ffffffff813a0124>] ? cpuidle_enter_state+0x54/0xf0
[108651.051207]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.051210]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.051212]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.051215]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.051217] Code: 74 f4 f3 90 0f b7 07 66 39 c8 75 f6 eb e8 0f 1f 40 00=
 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 75 03 c3 f3 90 0f b7 07=
 <66> 39 d0 75 f6 66 90 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00=20
[108651.051427] NMI backtrace for cpu 0
[108651.051431] CPU: 0 PID: 9268 Comm: kworker/0:1 Tainted: G      D W    3=
=2E12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.051433] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.051441] task: ffff8807eca86040 ti: ffff88080b1b6000 task.ti: ffff88=
080b1b6000
[108651.051443] RIP: 0010:[<ffffffff814c38bd>]  [<ffffffff814c38bd>] _raw_s=
pin_lock_irq+0x1d/0x30
[108651.051502] RSP: 0018:ffff88080b1b76d0  EFLAGS: 00000097
[108651.051504] RAX: 00000000000021ec RBX: ffff88083fa14300 RCX: ffff88080b=
1b7fd8
[108651.051506] RDX: 00000000000021ed RSI: ffffffff81062f8f RDI: ffff88083f=
a14300
[108651.051507] RBP: ffff8807eca86040 R08: 0000000002000000 R09: ffff88081a=
5b0800
[108651.051509] R10: 0000000000000410 R11: 0000000000000000 R12: 0000000000=
000000
[108651.051511] R13: ffff8807eca86388 R14: 0000000000000000 R15: ffff8807ec=
a86040
[108651.051566] FS:  0000000000000000(0000) GS:ffff88083fa00000(0000) knlGS=
:0000000000000000
[108651.051568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.051569] CR2: 0000000000000028 CR3: 000000000180c000 CR4: 0000000000=
1407f0
[108651.051571] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.051573] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.051627] Stack:
[108651.051629]  ffffffff814c15a9 ffff8807eca86040 ffffffff814bb14f ffff880=
80b1b7fd8
[108651.051687]  ffff88080b1b7fd8 ffff88080b1b7fd8 ffff8807eca86040 0000000=
000000000
[108651.051692]  ffff8807eca86040 0000000000000009 00007ffffffff000 0000000=
000002434
[108651.051750] Call Trace:
[108651.051753]  [<ffffffff814c15a9>] ? __schedule+0x99/0x780
[108651.051756]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[108651.051813]  [<ffffffff81062f8f>] ? do_exit+0xa6f/0xa80
[108651.051815]  [<ffffffff814bb14f>] ? printk+0x4f/0x54
[108651.051818]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[108651.051820]  [<ffffffff814ba5d2>] ? no_context+0x26b/0x27a
[108651.051876]  [<ffffffff814b9e7e>] ? pmd_offset+0x16/0x1b
[108651.051879]  [<ffffffff814c76c0>] ? __do_page_fault+0x3c0/0x540
[108651.051886]  [<ffffffff8128ca66>] ? vsnprintf+0x486/0x6a0
[108651.051889]  [<ffffffff814c4018>] ? page_fault+0x28/0x30
[108651.051891]  [<ffffffff810825e7>] ? kthread_data+0x7/0x10
[108651.051947]  [<ffffffff8107c0bf>] ? wq_worker_sleeping+0xf/0x90
[108651.051950]  [<ffffffff814c198a>] ? __schedule+0x47a/0x780
[108651.051952]  [<ffffffff81062c1d>] ? do_exit+0x6fd/0xa80
[108651.051955]  [<ffffffff814c4c48>] ? oops_end+0xa8/0xf0
[108651.051957]  [<ffffffff814ba5d2>] ? no_context+0x26b/0x27a
[108651.051960]  [<ffffffff814c76c0>] ? __do_page_fault+0x3c0/0x540
[108651.052016]  [<ffffffff811228f6>] ? mempool_alloc+0x56/0x160
[108651.052019]  [<ffffffffa0657980>] ? crypt_map+0xb0/0x150 [dm_crypt]
[108651.052022]  [<ffffffff814c4018>] ? page_fault+0x28/0x30
[108651.052026]  [<ffffffff811ba0bb>] ? __bio_add_page.part.16+0x10b/0x260
[108651.052028]  [<ffffffffa0658398>] ? kcryptd_crypt+0x118/0x3b0 [dm_crypt]
[108651.052031]  [<ffffffff8107a807>] ? process_one_work+0x157/0x450
[108651.052089]  [<ffffffff8107bc84>] ? worker_thread+0x114/0x370
[108651.052091]  [<ffffffff8107bb70>] ? manage_workers.isra.21+0x2d0/0x2d0
[108651.052093]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[108651.052096]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108651.052098]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[108651.052155]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[108651.052157] Code: ff 0f 79 05 e8 95 b6 dc ff 48 89 d0 c3 90 fa 66 0f 1f=
 44 00 00 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 75 03 c3 f3 90=
 <0f> b7 07 66 39 d0 75 f6 c3 66 2e 0f 1f 84 00 00 00 00 00 fa 66=20
[108651.052475] NMI backtrace for cpu 4
[108651.052478] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.052479] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.052535] task: ffff88083bd38040 ti: ffff88083bd5a000 task.ti: ffff88=
083bd5a000
[108651.052536] RIP: 0010:[<ffffffff812e9637>]  [<ffffffff812e9637>] intel_=
idle+0xc7/0x140
[108651.052540] RSP: 0018:ffff88083bd5bdc8  EFLAGS: 00000046
[108651.052542] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000=
000001
[108651.052596] RDX: 0000000000000000 RSI: ffff88083bd5bfd8 RDI: 0000000000=
000004
[108651.052598] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000=
06139b
[108651.052599] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000000
[108651.052654] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000=
000004
[108651.052656] FS:  0000000000000000(0000) GS:ffff88083fb00000(0000) knlGS=
:0000000000000000
[108651.052658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.052659] CR2: 00000000021a4000 CR3: 000000081da8e000 CR4: 0000000000=
1407e0
[108651.052714] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.052716] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.052717] Stack:
[108651.052718]  0000000000000002 0000000431ae8ba3 ffffffff8101bc15 ffff880=
83fb1a400
[108651.052775]  000062ea06f34f43 ffffffff8186ced0 ffffffff8186ce60 fffffff=
f813a011c
[108651.052833]  0000000000000002 0000000031ae8ba3 ffff88083fb0dd40 ffff880=
83fb1a400
[108651.052890] Call Trace:
[108651.052893]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.052896]  [<ffffffff813a011c>] ? cpuidle_enter_state+0x4c/0xf0
[108651.052898]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.052901]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.052903]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.052960]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.052961] Code: 48 8b 34 25 30 c8 00 00 48 89 d1 48 8d 86 38 e0 ff ff=
 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9=
 <85> 1d bb 3b 58 00 75 0f 48 8d 74 24 0c bf 05 00 00 00 e8 42 22=20
[108651.053276] NMI backtrace for cpu 2
[108651.053280] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.053284] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.053345] task: ffff88083bd0c0c0 ti: ffff88083bd36000 task.ti: ffff88=
083bd36000
[108651.053347] RIP: 0010:[<ffffffff812e9637>]  [<ffffffff812e9637>] intel_=
idle+0xc7/0x140
[108651.053351] RSP: 0018:ffff88083bd37dc8  EFLAGS: 00000046
[108651.053353] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000=
000001
[108651.053354] RDX: 0000000000000000 RSI: ffff88083bd37fd8 RDI: 0000000000=
000002
[108651.053411] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000=
000024
[108651.053412] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000032
[108651.053414] R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000=
000002
[108651.053416] FS:  0000000000000000(0000) GS:ffff88083fa80000(0000) knlGS=
:0000000000000000
[108651.053473] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.053478] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.053482] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.053487] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.053491] Stack:
[108651.053547]  0000000000000000 00000002003badec ffffffff8101bc15 ffff880=
83fa9a400
[108651.053552]  000062ea19e1ac97 ffffffff8186d030 ffffffff8186ce60 fffffff=
f813a011c
[108651.053556]  0000000000000000 00000000003badec 000062ea19e04f00 ffff880=
83fa9a400
[108651.053614] Call Trace:
[108651.053617]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.053620]  [<ffffffff813a011c>] ? cpuidle_enter_state+0x4c/0xf0
[108651.053623]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.053626]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.053681]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.053684]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.053686] Code: 48 8b 34 25 30 c8 00 00 48 89 d1 48 8d 86 38 e0 ff ff=
 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9=
 <85> 1d bb 3b 58 00 75 0f 48 8d 74 24 0c bf 05 00 00 00 e8 42 22=20
[108651.054108] NMI backtrace for cpu 6
[108651.054112] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.054113] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.054114] task: ffff88083bd39080 ti: ffff88083bd62000 task.ti: ffff88=
083bd62000
[108651.054115] RIP: 0010:[<ffffffff812e9637>]  [<ffffffff812e9637>] intel_=
idle+0xc7/0x140
[108651.054173] RSP: 0018:ffff88083bd63dc8  EFLAGS: 00000046
[108651.054174] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000=
000001
[108651.054175] RDX: 0000000000000000 RSI: ffff88083bd63fd8 RDI: 0000000000=
000006
[108651.054176] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000=
000000
[108651.054230] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000032
[108651.054231] R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000=
000006
[108651.054233] FS:  0000000000000000(0000) GS:ffff88083fb80000(0000) knlGS=
:0000000000000000
[108651.054234] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.054235] CR2: 00007f4ba4926618 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.054289] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.054290] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.054291] Stack:
[108651.054345]  0000000000000000 0000000600f3c8eb ffffffff8101bc15 ffff880=
83fb9a400
[108651.054348]  000062ea19e0b12a ffffffff8186d030 ffffffff8186ce60 fffffff=
f813a011c
[108651.054404]  0000000000000000 0000000000f3c8eb 0000000000000000 ffff880=
83fb9a400
[108651.054407] Call Trace:
[108651.054409]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.054465]  [<ffffffff813a011c>] ? cpuidle_enter_state+0x4c/0xf0
[108651.054467]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.054469]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.054471]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.054472]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.054474] Code: 48 8b 34 25 30 c8 00 00 48 89 d1 48 8d 86 38 e0 ff ff=
 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9=
 <85> 1d bb 3b 58 00 75 0f 48 8d 74 24 0c bf 05 00 00 00 e8 42 22=20
[108651.054888] NMI backtrace for cpu 3
[108651.054894] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.054895] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.054954] task: ffff88083bd387c0 ti: ffff88083bd58000 task.ti: ffff88=
083bd58000
[108651.054955] RIP: 0010:[<ffffffff812e9637>]  [<ffffffff812e9637>] intel_=
idle+0xc7/0x140
[108651.054959] RSP: 0018:ffff88083bd59dc8  EFLAGS: 00000046
[108651.054961] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000=
000001
[108651.055016] RDX: 0000000000000000 RSI: ffff88083bd59fd8 RDI: 0000000000=
000003
[108651.055018] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000=
000009
[108651.055019] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000032
[108651.055020] R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000=
000003
[108651.055076] FS:  0000000000000000(0000) GS:ffff88083fac0000(0000) knlGS=
:0000000000000000
[108651.055078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.055080] CR2: ffffffffff600400 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.055081] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.055136] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.055138] Stack:
[108651.055139]  0000000000000000 0000000300f3c8e3 ffffffff8101bc15 ffff880=
83fada400
[108651.055143]  000062ea19e0af82 ffffffff8186d030 ffffffff8186ce60 fffffff=
f813a011c
[108651.055201]  0000000000000000 0000000000f3c8e3 0000000000000000 ffff880=
83fada400
[108651.055259] Call Trace:
[108651.055262]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.055265]  [<ffffffff813a011c>] ? cpuidle_enter_state+0x4c/0xf0
[108651.055267]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.055270]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.055325]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.055328]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.055329] Code: 48 8b 34 25 30 c8 00 00 48 89 d1 48 8d 86 38 e0 ff ff=
 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9=
 <85> 1d bb 3b 58 00 75 0f 48 8d 74 24 0c bf 05 00 00 00 e8 42 22=20
[108651.055695] NMI backtrace for cpu 7
[108651.055699] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G      D W    3.12-0=
=2Ebpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[108651.055766] Hardware name: Supermicro X10SLQ/X10SLQ, BIOS 1.00 05/09/20=
13
[108651.055777] task: ffff88083bd3b840 ti: ffff88083bd64000 task.ti: ffff88=
083bd64000
[108651.055779] RIP: 0010:[<ffffffff812e9637>]  [<ffffffff812e9637>] intel_=
idle+0xc7/0x140
[108651.055783] RSP: 0018:ffff88083bd65dc8  EFLAGS: 00000046
[108651.055840] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000=
000001
[108651.055842] RDX: 0000000000000000 RSI: ffff88083bd65fd8 RDI: 0000000000=
000007
[108651.055843] RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000=
000001
[108651.055845] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000=
000032
[108651.055846] R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000=
000007
[108651.055848] FS:  0000000000000000(0000) GS:ffff88083fbc0000(0000) knlGS=
:0000000000000000
[108651.055904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[108651.055906] CR2: 00007f49b08a4000 CR3: 000000000180c000 CR4: 0000000000=
1407e0
[108651.055907] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[108651.055909] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[108651.055964] Stack:
[108651.055965]  0000000000000000 0000000700f3cbdc ffffffff8101bc15 ffff880=
83fbda400
[108651.055970]  000062ea19e0aec8 ffffffff8186d030 ffffffff8186ce60 fffffff=
f813a011c
[108651.056028]  0000000000000000 0000000000f3cbdc 0000000000000000 ffff880=
83fbda400
[108651.056033] Call Trace:
[108651.056036]  [<ffffffff8101bc15>] ? read_tsc+0x5/0x20
[108651.056092]  [<ffffffff813a011c>] ? cpuidle_enter_state+0x4c/0xf0
[108651.056095]  [<ffffffff813a028b>] ? cpuidle_idle_call+0xcb/0x240
[108651.056098]  [<ffffffff8101d759>] ? arch_cpu_idle+0x9/0x30
[108651.056101]  [<ffffffff810ac55b>] ? cpu_startup_entry+0xdb/0x2b0
[108651.056104]  [<ffffffff81040228>] ? start_secondary+0x1d8/0x230
[108651.056158] Code: 48 8b 34 25 30 c8 00 00 48 89 d1 48 8d 86 38 e0 ff ff=
 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9=
 <85> 1d bb 3b 58 00 75 0f 48 8d 74 24 0c bf 05 00 00 00 e8 42 22=20

--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=SystemStressTesting

[2] Here are the exact steps I took for various stress-testing (with
    root privileges when necessary, such as for memtester):

  aptitude install stress
  stress --cpu 8 --io 4 --vm 2 --timeout 10s --dry-run
  stress --cpu 8 --io 4 --vm 2 --hdd 3 --timeout 60s
  stress --cpu 8 --io 8 --vm 8 --hdd 4 --timeout 5m

  aptitude install stressapptest
  stressapptest -m 8 -i 4 -C 4 -W -s 30
  stressapptest -m 8 -i 4 -C 4 -W -f /root/sat-file-test --filesize 1gb -s 30
  stressapptest -m 8 -i 4 -C 4 -W -f /root/sat-file-test --filesize 1024 --random-threads 4 -s 30
  stressapptest -m 8 -i 4 -C 4 -W --cc_test -s 30
  stressapptest -m 8 -i 4 -C 4 -W --local_numa -s 30
  stressapptest -m 8 -i 4 -C 4 -W -n 127.0.0.1 --listen -s 30
  stressapptest -m 12 -i 6 -C 8 -W -f /root/sat-file-test --filesize 1024 --random-threads 4 -n 127.0.0
+.1 --listen -s 300

  aptitude install linux-source
  cp /usr/src/linux-source-3.2.tar.bz2 /root/
  tar xvfj linux-source-3.2.tar.bz2
  cd linux-source-3.2/
  make defconfig
  time make 1>LOG 2>ERR
  make mrproper
  make defconfig
  time make -j16 1>LOG 2>ERR

  aptitude install memtester
  memtester 30G

  aptitude install memtest86+  # reboot and run for 3+ days

--0ntfKIWw70PvrIHh--
