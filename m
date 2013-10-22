Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3JVR3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:29:40 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47279 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3JVR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:29:30 -0400
Message-ID: <5266B5F2.5070102@hp.com>
Date: Tue, 22 Oct 2013 13:29:22 -0400
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: BUG: soft lockup - CPU#8 stuck for 22s!
Content-Type: multipart/mixed;
 boundary="------------010704090003070803020605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010704090003070803020605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greetings, all.

Just wanted to drop this out there to see if it rang any bells.
I've been getting a soft lockup (numad thread stuck on a cpu
while attempting to attach a task to a cgroup) for a while now,
but I thought it was only happening when I applied Mel Gorman's
set of AutoNUMA patches. Today, however, it happened on a stock
3.12rc3 kernel as well, so it is in the baseline. And before
anyone asks, I wanted to make sure directed numa activities
such as numad would do interacted safely with the AutoNUMA
stuff so that's why I was running with both enabled.

I believe this started in the 3.11 timeframe (and I'll try to
bisect to narrow things down).

The problem/reproduction environment is:
	+ Centos 6.4
	/* The next three lines are to get numad running */
	+ mkdir /cgroup/cpuset
	+ mount cgroup -t cgroup -o cpuset /cgroup/cpuset
	+ service numad start
	+ loop running the AutoNUMA tests available at:
	git://gitorious.org/autonuma-benchmark/autonuma-benchmark.git

How long it takes to hit this varies -- since it looks like it
is not due to Mel's changes at all, a stress test for cgroup
interactions would likely kick it faster (anyone care to point
me at one?).

/var/log/messages output attached, trimmed to just one boot+instance
of the problem.

Oct 22 11:05:10 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s!
[numad:27384]
Oct 22 11:05:10 hornet2 kernel: Modules linked in: ebtable_nat ebtables
xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc
ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables
ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack
ip6table_filter ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun
kvm_intel kvm uinput hp_wmi sparse_keymap rfkill snd_usb_audio
snd_usbmidi_lib snd_rawmidi acpi_cpufreq freq_table iTCO_wdt
iTCO_vendor_support sg microcode serio_raw pcspkr sb_edac edac_core wmi
i2c_i801 lpc_ich mfd_core xhci_hcd e1000e ptp pps_core ioatdma dca
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore
snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_t10dif
crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahci
pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log
dm_mod
Oct 22 11:05:10 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not
tainted 3.12.0-rc3+ #1
Oct 22 11:05:10 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620
Workstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:10 hornet2 kernel: task: ffff88070e9c60c0 ti:
ffff88070e520000 task.ti: ffff88070e520000
Oct 22 11:05:10 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]
[<ffffffff8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:05:10 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000217
Oct 22 11:05:10 hornet2 kernel: RAX: 0000000000000000 RBX:
ffffffff81117b52 RCX: ffff880c073ca6e8
Oct 22 11:05:10 hornet2 kernel: RDX: ffff880c12a1f040 RSI:
ffff88070c264000 RDI: ffffffff81a46cc8
Oct 22 11:05:10 hornet2 kernel: RBP: ffff88070e521cc8 R08:
ffff880c2fc55ba0 R09: ffff880c030fa000
Oct 22 11:05:10 hornet2 kernel: R10: f4f0000000000000 R11:
f000000000000000 R12: 0000000000000d0f
Oct 22 11:05:10 hornet2 kernel: R13: ffff88070e521ce8 R14:
0000000000000030 R15: ffff88070e520000
Oct 22 11:05:10 hornet2 kernel: FS:  00007f5cf7023700(0000)
GS:ffff880c2fc40000(0000) knlGS:0000000000000000
Oct 22 11:05:10 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Oct 22 11:05:10 hornet2 kernel: CR2: ffffffffff600400 CR3:
000000070f357000 CR4: 00000000000407e0
Oct 22 11:05:10 hornet2 kernel: Stack:
Oct 22 11:05:10 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9
ffff880c0f5c9020 0000000000000000
Oct 22 11:05:10 hornet2 kernel: ffff88070e521da8 ffffffff810c4896
0000000000000030 ffff88070e521d28
Oct 22 11:05:10 hornet2 kernel: 000000005266940e 0000000000000000
ffff88070c264000 ffff880600000001
Oct 22 11:05:10 hornet2 kernel: Call Trace:
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c0ee9>]
task_cgroup_from_root+0x29/0xa0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4896>]
cgroup_attach_task+0xe6/0x3b0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4ccf>]
attach_task_by_pid+0x16f/0x1b0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4d26>]
cgroup_tasks_write+0x16/0x20
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c1b3c>]
cgroup_write_X64+0xec/0x150
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81210cb3>] ?
security_file_permission+0x23/0x90
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4338>]
cgroup_file_write+0x58/0xc0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81178683>] ?
file_start_write+0x33/0x40
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170
Oct 22 11:05:10 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff8154af92>]
system_call_fastpath+0x16/0x1b
Oct 22 11:05:10 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9
c3 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5
66 66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84
00 00 00 00 00 55

Thanks in advance for any input/interest.
Don Morris

--------------010704090003070803020605
Content-Type: text/plain; charset=UTF-8;
 name="cgroup_hang_trimmed"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="cgroup_hang_trimmed"

Oct 22 07:22:15 hornet2 rsyslogd: [origin software=3D"rsyslogd" swVersion=
=3D"5.8.10" x-pid=3D"26236" x-info=3D"http://www.rsyslog.com"] start
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys cpuset
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys cpu
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys cpuacct
Oct 22 07:22:15 hornet2 kernel: Linux version 3.12.0-rc3+ (dmorris@hornet=
2.americas.hpqcorp.net) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GC=
C) ) #1 SMP Wed Oct 2 09:20:00 EDT 2013
Oct 22 07:22:15 hornet2 kernel: Command line: root=3D/dev/mapper/vg_horne=
t200-lv_root ro rd_NO_LUKS KEYBOARDTYPE=3Dpc KEYTABLE=3Dus LANG=3Den_US.U=
TF-8 rd_NO_MD rd_LVM_LV=3Dvg_hornet200/lv_root SYSFONT=3Dlatarcyrheb-sun1=
6 rhgb crashkernel=3D256M quiet rd_LVM_LV=3Dvg_hornet200/lv_swap rd_NO_DM=
 ramdisk_size=3D131072
Oct 22 07:22:15 hornet2 kernel: e820: BIOS-provided physical RAM map:
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x0000000000000000-0x0000=
00000009ffff] usable
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x0000000000100000-0x0000=
0000cb3e5fff] usable
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cb3e6000-0x0000=
0000cb6e2fff] reserved
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cb6e3000-0x0000=
0000cb7f7fff] ACPI data
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cb7f8000-0x0000=
0000cb9c3fff] ACPI NVS
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cb9c4000-0x0000=
0000cbad9fff] reserved
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cbada000-0x0000=
0000cbadafff] usable
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cbadb000-0x0000=
0000cbb60fff] ACPI NVS
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000cbb61000-0x0000=
0000cbffffff] usable
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000f0000000-0x0000=
0000f7ffffff] reserved
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000fed1c000-0x0000=
0000fed1ffff] reserved
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x00000000ff000000-0x0000=
0000ffffffff] reserved
Oct 22 07:22:15 hornet2 kernel: BIOS-e820: [mem 0x0000000100000000-0x0000=
000c2fffffff] usable
Oct 22 07:22:15 hornet2 kernel: NX (Execute Disable) protection: active
Oct 22 07:22:15 hornet2 kernel: efi: EFI v2.31 by American Megatrends
Oct 22 07:22:15 hornet2 kernel: efi:  ACPI 2.0=3D0xcb71a000  SMBIOS=3D0xc=
ba99b98  ACPI=3D0xcb71a000  MPS=3D0xf4b00=20
Oct 22 07:22:15 hornet2 kernel: efi: mem00: type=3D3, attr=3D0xf, range=3D=
[0x0000000000000000-0x0000000000008000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem01: type=3D7, attr=3D0xf, range=3D=
[0x0000000000008000-0x000000000004d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem02: type=3D2, attr=3D0xf, range=3D=
[0x000000000004d000-0x000000000004f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem03: type=3D4, attr=3D0xf, range=3D=
[0x000000000004f000-0x0000000000050000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem04: type=3D3, attr=3D0xf, range=3D=
[0x0000000000050000-0x00000000000a0000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem05: type=3D3, attr=3D0xf, range=3D=
[0x0000000000100000-0x0000000000110000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem06: type=3D7, attr=3D0xf, range=3D=
[0x0000000000110000-0x0000000001000000) (14MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem07: type=3D2, attr=3D0xf, range=3D=
[0x0000000001000000-0x0000000001100000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem08: type=3D7, attr=3D0xf, range=3D=
[0x0000000001100000-0x000000007f42a000) (2019MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem09: type=3D2, attr=3D0xf, range=3D=
[0x000000007f42a000-0x0000000080000000) (11MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem10: type=3D7, attr=3D0xf, range=3D=
[0x0000000080000000-0x00000000bc243000) (962MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem11: type=3D4, attr=3D0xf, range=3D=
[0x00000000bc243000-0x00000000bc338000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem12: type=3D7, attr=3D0xf, range=3D=
[0x00000000bc338000-0x00000000bc34d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem13: type=3D4, attr=3D0xf, range=3D=
[0x00000000bc34d000-0x00000000bc3fe000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem14: type=3D7, attr=3D0xf, range=3D=
[0x00000000bc3fe000-0x00000000bc465000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem15: type=3D4, attr=3D0xf, range=3D=
[0x00000000bc465000-0x00000000bcdaa000) (9MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem16: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcdaa000-0x00000000bcdab000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem17: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcdab000-0x00000000bcdad000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem18: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcdad000-0x00000000bcdcb000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem19: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcdcb000-0x00000000bcdcc000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem20: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcdcc000-0x00000000bcdd0000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem21: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcdd0000-0x00000000bcdd1000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem22: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcdd1000-0x00000000bce9a000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem23: type=3D4, attr=3D0xf, range=3D=
[0x00000000bce9a000-0x00000000bceaf000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem24: type=3D7, attr=3D0xf, range=3D=
[0x00000000bceaf000-0x00000000bcf5e000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem25: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcf5e000-0x00000000bcfc0000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem26: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcfc0000-0x00000000bcfc1000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem27: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcfc1000-0x00000000bcfea000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem28: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcfea000-0x00000000bcfef000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem29: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcfef000-0x00000000bcff0000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem30: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcff0000-0x00000000bcff1000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem31: type=3D4, attr=3D0xf, range=3D=
[0x00000000bcff1000-0x00000000bcff2000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem32: type=3D7, attr=3D0xf, range=3D=
[0x00000000bcff2000-0x00000000bd1e2000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem33: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd1e2000-0x00000000bd1e3000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem34: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd1e3000-0x00000000bd204000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem35: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd204000-0x00000000bd205000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem36: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd205000-0x00000000bd206000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem37: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd206000-0x00000000bd22f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem38: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd22f000-0x00000000bd235000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem39: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd235000-0x00000000bd236000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem40: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd236000-0x00000000bd23c000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem41: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd23c000-0x00000000bd23d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem42: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd23d000-0x00000000bd44a000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem43: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd44a000-0x00000000bd44b000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem44: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd44b000-0x00000000bd44c000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem45: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd44c000-0x00000000bd475000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem46: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd475000-0x00000000bd47c000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem47: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd47c000-0x00000000bd47d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem48: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd47d000-0x00000000bd47f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem49: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd47f000-0x00000000bd480000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem50: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd480000-0x00000000bd62e000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem51: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd62e000-0x00000000bd62f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem52: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd62f000-0x00000000bd68f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem53: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd68f000-0x00000000bd690000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem54: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd690000-0x00000000bd691000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem55: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd691000-0x00000000bd6ba000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem56: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd6ba000-0x00000000bd6c3000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem57: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd6c3000-0x00000000bd6c5000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem58: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd6c5000-0x00000000bd83c000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem59: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd83c000-0x00000000bd83d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem60: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd83d000-0x00000000bd8d8000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem61: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd8d8000-0x00000000bd8d9000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem62: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd8d9000-0x00000000bd8db000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem63: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd8db000-0x00000000bd904000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem64: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd904000-0x00000000bd90d000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem65: type=3D4, attr=3D0xf, range=3D=
[0x00000000bd90d000-0x00000000bd90f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem66: type=3D7, attr=3D0xf, range=3D=
[0x00000000bd90f000-0x00000000bdb71000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem67: type=3D4, attr=3D0xf, range=3D=
[0x00000000bdb71000-0x00000000bdb72000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem68: type=3D7, attr=3D0xf, range=3D=
[0x00000000bdb72000-0x00000000bdb75000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem69: type=3D4, attr=3D0xf, range=3D=
[0x00000000bdb75000-0x00000000bdb9e000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem70: type=3D7, attr=3D0xf, range=3D=
[0x00000000bdb9e000-0x00000000bdc49000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem71: type=3D4, attr=3D0xf, range=3D=
[0x00000000bdc49000-0x00000000bde7c000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem72: type=3D7, attr=3D0xf, range=3D=
[0x00000000bde7c000-0x00000000bde81000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem73: type=3D4, attr=3D0xf, range=3D=
[0x00000000bde81000-0x00000000bde82000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem74: type=3D7, attr=3D0xf, range=3D=
[0x00000000bde82000-0x00000000bdea1000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem75: type=3D4, attr=3D0xf, range=3D=
[0x00000000bdea1000-0x00000000be0a7000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem76: type=3D7, attr=3D0xf, range=3D=
[0x00000000be0a7000-0x00000000be28f000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem77: type=3D4, attr=3D0xf, range=3D=
[0x00000000be28f000-0x00000000beecf000) (12MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem78: type=3D7, attr=3D0xf, range=3D=
[0x00000000beecf000-0x00000000beed4000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem79: type=3D4, attr=3D0xf, range=3D=
[0x00000000beed4000-0x00000000bf4ee000) (6MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem80: type=3D7, attr=3D0xf, range=3D=
[0x00000000bf4ee000-0x00000000c41ec000) (76MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem81: type=3D2, attr=3D0xf, range=3D=
[0x00000000c41ec000-0x00000000c54ff000) (19MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem82: type=3D1, attr=3D0xf, range=3D=
[0x00000000c54ff000-0x00000000c5567000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem83: type=3D7, attr=3D0xf, range=3D=
[0x00000000c5567000-0x00000000c8347000) (45MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem84: type=3D4, attr=3D0xf, range=3D=
[0x00000000c8347000-0x00000000c8367000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem85: type=3D7, attr=3D0xf, range=3D=
[0x00000000c8367000-0x00000000c837a000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem86: type=3D4, attr=3D0xf, range=3D=
[0x00000000c837a000-0x00000000c89cb000) (6MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem87: type=3D7, attr=3D0xf, range=3D=
[0x00000000c89cb000-0x00000000c89cd000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem88: type=3D4, attr=3D0xf, range=3D=
[0x00000000c89cd000-0x00000000c9e01000) (20MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem89: type=3D7, attr=3D0xf, range=3D=
[0x00000000c9e01000-0x00000000ca556000) (7MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem90: type=3D3, attr=3D0xf, range=3D=
[0x00000000ca556000-0x00000000cb3e6000) (14MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem91: type=3D0, attr=3D0xf, range=3D=
[0x00000000cb3e6000-0x00000000cb47f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem92: type=3D0, attr=3D0xf, range=3D=
[0x00000000cb47f000-0x00000000cb6e3000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem93: type=3D9, attr=3D0xf, range=3D=
[0x00000000cb6e3000-0x00000000cb71a000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem94: type=3D9, attr=3D0xf, range=3D=
[0x00000000cb71a000-0x00000000cb7f8000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem95: type=3D10, attr=3D0xf, range=3D=
[0x00000000cb7f8000-0x00000000cb8da000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem96: type=3D10, attr=3D0xf, range=3D=
[0x00000000cb8da000-0x00000000cb9c4000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem97: type=3D6, attr=3D0x8000000000=
00000f, range=3D[0x00000000cb9c4000-0x00000000cb9ec000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem98: type=3D6, attr=3D0x8000000000=
00000f, range=3D[0x00000000cb9ec000-0x00000000cba89000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem99: type=3D6, attr=3D0x8000000000=
00000f, range=3D[0x00000000cba89000-0x00000000cba8c000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem100: type=3D6, attr=3D0x800000000=
000000f, range=3D[0x00000000cba8c000-0x00000000cba9b000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem101: type=3D5, attr=3D0x800000000=
000000f, range=3D[0x00000000cba9b000-0x00000000cbaa7000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem102: type=3D5, attr=3D0x800000000=
000000f, range=3D[0x00000000cbaa7000-0x00000000cbada000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem103: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbada000-0x00000000cbadb000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem104: type=3D10, attr=3D0xf, range=
=3D[0x00000000cbadb000-0x00000000cbb61000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem105: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbb61000-0x00000000cbcb3000) (1MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem106: type=3D3, attr=3D0xf, range=3D=
[0x00000000cbcb3000-0x00000000cbf57000) (2MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem107: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbf57000-0x00000000cbf5b000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem108: type=3D3, attr=3D0xf, range=3D=
[0x00000000cbf5b000-0x00000000cbf5f000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem109: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbf5f000-0x00000000cbf62000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem110: type=3D3, attr=3D0xf, range=3D=
[0x00000000cbf62000-0x00000000cbf66000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem111: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbf66000-0x00000000cbf73000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem112: type=3D3, attr=3D0xf, range=3D=
[0x00000000cbf73000-0x00000000cbf85000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem113: type=3D4, attr=3D0xf, range=3D=
[0x00000000cbf85000-0x00000000cc000000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem114: type=3D7, attr=3D0xf, range=3D=
[0x0000000100000000-0x0000000c30000000) (45824MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem115: type=3D11, attr=3D0x80000000=
00000001, range=3D[0x00000000f0000000-0x00000000f8000000) (128MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem116: type=3D11, attr=3D0x80000000=
00000001, range=3D[0x00000000fed1c000-0x00000000fed20000) (0MB)
Oct 22 07:22:15 hornet2 kernel: efi: mem117: type=3D11, attr=3D0x80000000=
00000001, range=3D[0x00000000ff000000-0x0000000100000000) (16MB)
Oct 22 07:22:15 hornet2 kernel: SMBIOS 2.7 present.
Oct 22 07:22:15 hornet2 kernel: No AGP bridge found
Oct 22 07:22:15 hornet2 kernel: e820: last_pfn =3D 0xc30000 max_arch_pfn =
=3D 0x400000000
Oct 22 07:22:15 hornet2 kernel: x86 PAT enabled: cpu 0, old 0x70406000704=
06, new 0x7010600070106
Oct 22 07:22:15 hornet2 kernel: e820: last_pfn =3D 0xcc000 max_arch_pfn =3D=
 0x400000000
Oct 22 07:22:15 hornet2 kernel: found SMP MP-table at [mem 0x000f4af0-0x0=
00f4aff] mapped at [ffff8800000f4af0]
Oct 22 07:22:15 hornet2 kernel: Using GB pages for direct mapping
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0x00000000-0x00=
0fffff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xc2fe00000-0xc=
2fffffff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xc2c000000-0xc=
2fdfffff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xc00000000-0xc=
2bffffff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0x00100000-0xcb=
3e5fff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xcbada000-0xcb=
adafff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xcbb61000-0xcb=
ffffff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0x100000000-0xb=
ffffffff]
Oct 22 07:22:15 hornet2 kernel: RAMDISK: [mem 0x7f42a000-0x7fbfbfff]
Oct 22 07:22:15 hornet2 kernel: Reserving 256MB of memory at 640MB for cr=
ashkernel (System RAM: 49080MB)
Oct 22 07:22:15 hornet2 kernel: ACPI: RSDP 00000000cb71a000 00024 (v02 HP=
QOEM)
Oct 22 07:22:15 hornet2 kernel: ACPI: XSDT 00000000cb71a098 000AC (v01 HP=
QOEM SLIC-WKS 01072009 AMI  00010013)
Oct 22 07:22:15 hornet2 kernel: ACPI: FACP 00000000cb7215c0 0010C (v05 HP=
QOEM SLIC-WKS 01072009 AMI  00010013)
Oct 22 07:22:15 hornet2 kernel: ACPI: DSDT 00000000cb71a1d0 073EB (v02 HP=
QOEM SLIC-WKS 00000315 INTL 20051117)
Oct 22 07:22:15 hornet2 kernel: ACPI: FACS 00000000cb9bb080 00040
Oct 22 07:22:15 hornet2 kernel: ACPI: APIC 00000000cb7216d0 001B4 (v03 HP=
QOEM SLIC-WKS 01072009 AMI  00010013)
Oct 22 07:22:15 hornet2 kernel: ACPI: FPDT 00000000cb721888 00044 (v01 HP=
QOEM SLIC-WKS 01072009 AMI  00010013)
Oct 22 07:22:15 hornet2 kernel: ACPI: ASF! 00000000cb7218d0 000A5 (v32 IN=
TEL       HCG 00000001 TFSM 000F4240)
Oct 22 07:22:15 hornet2 kernel: ACPI: MCFG 00000000cb721978 0003C (v01 HP=
QOEM OEMMCFG. 01072009 MSFT 00000097)
Oct 22 07:22:15 hornet2 kernel: ACPI: SRAT 00000000cb7219b8 00430 (v01 A =
M I  AMI SRAT 00000001 AMI. 00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: SLIT 00000000cb721de8 00030 (v01 A =
M I  AMI SLIT 00000000 AMI. 00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: HPET 00000000cb721e18 00038 (v01 HP=
QOEM SLIC-WKS 01072009 AMI. 00000005)
Oct 22 07:22:15 hornet2 kernel: ACPI: ASF! 00000000cb721e50 000A0 (v32 IN=
TEL       HCG 00000001 TFSM 000F4240)
Oct 22 07:22:15 hornet2 kernel: ACPI: UEFI 00000000cb721ef0 0012A (v01  I=
NTEL  RstScuO 00000000      00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: SSDT 00000000cb722020 05913 (v01 CO=
MPAQ      WMI 00000001 MSFT 03000001)
Oct 22 07:22:15 hornet2 kernel: ACPI: SSDT 00000000cb727938 02A71 (v02 HP=
QOEM   CpuDef 00004000 INTL 20051117)
Oct 22 07:22:15 hornet2 kernel: ACPI: SSDT 00000000cb72a3b0 CD380 (v02  I=
NTEL    CpuPm 00004000 INTL 20051117)
Oct 22 07:22:15 hornet2 kernel: ACPI: IFEU 00000000cb7f7730 00042 (v01 HP=
QOEM SLIC-WKS 01072009      00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: UEFI 00000000cb7f7778 0005C (v01  I=
NTEL  RstScuV 00000000      00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: UEFI 00000000cb7f77d8 0005C (v01  I=
NTEL RstSataV 00000000      00000000)
Oct 22 07:22:15 hornet2 kernel: ACPI: DMAR 00000000cb7f7838 00100 (v01 A =
M I   OEMDMAR 00000001 INTL 00000001)
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x00 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x01 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x02 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x03 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x04 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x05 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x06 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x07 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x08 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x09 -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x0a -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 0 -> APIC 0x0b -> Node 0
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x20 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x21 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x22 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x23 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x24 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x25 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x26 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x27 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x28 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x29 -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x2a -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: PXM 1 -> APIC 0x2b -> Node 1
Oct 22 07:22:15 hornet2 kernel: SRAT: Node 0 PXM 0 [mem 0x00000000-0xcfff=
ffff]
Oct 22 07:22:15 hornet2 kernel: SRAT: Node 0 PXM 0 [mem 0x100000000-0x72f=
ffffff]
Oct 22 07:22:15 hornet2 kernel: SRAT: Node 1 PXM 1 [mem 0x730000000-0xc2f=
ffffff]
Oct 22 07:22:15 hornet2 kernel: ACPI: [SRAT:0x01] ignored 12 entries of 1=
6 found
Oct 22 07:22:15 hornet2 kernel: NUMA: Node 0 [mem 0x00000000-0xcfffffff] =
+ [mem 0x100000000-0x72fffffff] -> [mem 0x00000000-0x72fffffff]
Oct 22 07:22:15 hornet2 kernel: Initmem setup node 0 [mem 0x00000000-0x72=
fffffff]
Oct 22 07:22:15 hornet2 kernel:  NODE_DATA [mem 0x72fffe000-0x72fffffff]
Oct 22 07:22:15 hornet2 kernel: Initmem setup node 1 [mem 0x730000000-0xc=
2fffffff]
Oct 22 07:22:15 hornet2 kernel:  NODE_DATA [mem 0xc2fffb000-0xc2fffcfff]
Oct 22 07:22:15 hornet2 kernel: Zone ranges:
Oct 22 07:22:15 hornet2 kernel:  DMA      [mem 0x00001000-0x00ffffff]
Oct 22 07:22:15 hornet2 kernel:  DMA32    [mem 0x01000000-0xffffffff]
Oct 22 07:22:15 hornet2 kernel:  Normal   [mem 0x100000000-0xc2fffffff]
Oct 22 07:22:15 hornet2 kernel: Movable zone start for each node
Oct 22 07:22:15 hornet2 kernel: Early memory node ranges
Oct 22 07:22:15 hornet2 kernel:  node   0: [mem 0x00001000-0x0009ffff]
Oct 22 07:22:15 hornet2 kernel:  node   0: [mem 0x00100000-0xcb3e5fff]
Oct 22 07:22:15 hornet2 kernel:  node   0: [mem 0xcbada000-0xcbadafff]
Oct 22 07:22:15 hornet2 kernel:  node   0: [mem 0xcbb61000-0xcbffffff]
Oct 22 07:22:15 hornet2 kernel:  node   0: [mem 0x100000000-0x72fffffff]
Oct 22 07:22:15 hornet2 kernel:  node   1: [mem 0x730000000-0xc2fffffff]
Oct 22 07:22:15 hornet2 kernel: ACPI: PM-Timer IO Port: 0x408
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x20]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x22]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x10] lapic_id[0x24]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x12] lapic_id[0x26]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x14] lapic_id[0x28]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x16] lapic_id[0x2a]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x21]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x23]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x11] lapic_id[0x25]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x13] lapic_id[0x27]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x15] lapic_id[0x29]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC (acpi_id[0x17] lapic_id[0x2b]=
 enabled)
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x04] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x06] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x08] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0a] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0c] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0e] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x10] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x12] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x14] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x16] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x05] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x07] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x09] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0b] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0d] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x0f] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x11] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x13] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x15] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: LAPIC_NMI (acpi_id[0x17] high edge =
lint[0x1])
Oct 22 07:22:15 hornet2 kernel: ACPI: IOAPIC (id[0x00] address[0xfec00000=
] gsi_base[0])
Oct 22 07:22:15 hornet2 kernel: IOAPIC[0]: apic_id 0, version 32, address=
 0xfec00000, GSI 0-23
Oct 22 07:22:15 hornet2 kernel: ACPI: IOAPIC (id[0x02] address[0xfec01000=
] gsi_base[24])
Oct 22 07:22:15 hornet2 kernel: IOAPIC[1]: apic_id 2, version 32, address=
 0xfec01000, GSI 24-47
Oct 22 07:22:15 hornet2 kernel: ACPI: IOAPIC (id[0x03] address[0xfec40000=
] gsi_base[48])
Oct 22 07:22:15 hornet2 kernel: IOAPIC[2]: apic_id 3, version 32, address=
 0xfec40000, GSI 48-71
Oct 22 07:22:15 hornet2 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global=
_irq 2 dfl dfl)
Oct 22 07:22:15 hornet2 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global=
_irq 9 high level)
Oct 22 07:22:15 hornet2 kernel: Using ACPI (MADT) for SMP configuration i=
nformation
Oct 22 07:22:15 hornet2 kernel: ACPI: HPET id: 0x8086a701 base: 0xfed0000=
0
Oct 22 07:22:15 hornet2 kernel: smpboot: Allowing 24 CPUs, 0 hotplug CPUs=

Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0x000a=
0000-0x000fffff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcb3e=
6000-0xcb6e2fff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcb6e=
3000-0xcb7f7fff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcb7f=
8000-0xcb9c3fff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcb9c=
4000-0xcbad9fff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcbad=
b000-0xcbb60fff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xcc00=
0000-0xefffffff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xf000=
0000-0xf7ffffff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xf800=
0000-0xfed1bfff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xfed1=
c000-0xfed1ffff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xfed2=
0000-0xfeffffff]
Oct 22 07:22:15 hornet2 kernel: PM: Registered nosave memory: [mem 0xff00=
0000-0xffffffff]
Oct 22 07:22:15 hornet2 kernel: e820: [mem 0xcc000000-0xefffffff] availab=
le for PCI devices
Oct 22 07:22:15 hornet2 kernel: setup_percpu: NR_CPUS:32 nr_cpumask_bits:=
32 nr_cpu_ids:24 nr_node_ids:2
Oct 22 07:22:15 hornet2 kernel: PERCPU: Embedded 27 pages/cpu @ffff880713=
c00000 s80384 r8192 d22016 u131072
Oct 22 07:22:15 hornet2 kernel: Built 2 zonelists in Zone order, mobility=
 grouping on.  Total pages: 12368154
Oct 22 07:22:15 hornet2 kernel: Policy zone: Normal
Oct 22 07:22:15 hornet2 kernel: Kernel command line: root=3D/dev/mapper/v=
g_hornet200-lv_root ro rd_NO_LUKS KEYBOARDTYPE=3Dpc KEYTABLE=3Dus LANG=3D=
en_US.UTF-8 rd_NO_MD rd_LVM_LV=3Dvg_hornet200/lv_root SYSFONT=3Dlatarcyrh=
eb-sun16 rhgb crashkernel=3D256M quiet rd_LVM_LV=3Dvg_hornet200/lv_swap r=
d_NO_DM ramdisk_size=3D131072
Oct 22 07:22:15 hornet2 kernel: PID hash table entries: 4096 (order: 3, 3=
2768 bytes)
Oct 22 07:22:15 hornet2 kernel: xsave: enabled xstate_bv 0x7, cntxt size =
0x340
Oct 22 07:22:15 hornet2 kernel: Checking aperture...
Oct 22 07:22:15 hornet2 kernel: No AGP bridge found
Oct 22 07:22:15 hornet2 kernel: Memory: 49036068K/50258068K available (54=
35K kernel code, 807K rwdata, 2556K rodata, 1092K init, 1240K bss, 122200=
0K reserved)
Oct 22 07:22:15 hornet2 kernel: SLUB: HWalign=3D64, Order=3D0-3, MinObjec=
ts=3D0, CPUs=3D24, Nodes=3D2
Oct 22 07:22:15 hornet2 kernel: Hierarchical RCU implementation.
Oct 22 07:22:15 hornet2 kernel: 	RCU restricting CPUs from NR_CPUS=3D32 t=
o nr_cpu_ids=3D24.
Oct 22 07:22:15 hornet2 kernel: NR_IRQS:4352 nr_irqs:1688 16
Oct 22 07:22:15 hornet2 kernel: Console: colour dummy device 80x25
Oct 22 07:22:15 hornet2 kernel: console [tty0] enabled
Oct 22 07:22:15 hornet2 kernel: Enabling automatic NUMA balancing. Config=
ure with numa_balancing=3D or sysctl
Oct 22 07:22:15 hornet2 kernel: tsc: Fast TSC calibration using PIT
Oct 22 07:22:15 hornet2 kernel: tsc: Detected 1995.243 MHz processor
Oct 22 07:22:15 hornet2 kernel: Calibrating delay loop (skipped), value c=
alculated using timer frequency.. 3990.48 BogoMIPS (lpj=3D1995243)
Oct 22 07:22:15 hornet2 kernel: pid_max: default: 32768 minimum: 301
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xcb9c4000-0xcb=
a9afff]
Oct 22 07:22:15 hornet2 kernel: init_memory_mapping: [mem 0xcba9b000-0xcb=
ad9fff]
Oct 22 07:22:15 hornet2 kernel: Security Framework initialized
Oct 22 07:22:15 hornet2 kernel: SELinux:  Initializing.
Oct 22 07:22:15 hornet2 kernel: Dentry cache hash table entries: 8388608 =
(order: 14, 67108864 bytes)
Oct 22 07:22:15 hornet2 kernel: Inode-cache hash table entries: 4194304 (=
order: 13, 33554432 bytes)
Oct 22 07:22:15 hornet2 kernel: Mount-cache hash table entries: 256
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys devices
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys freezer
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys net_cls
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys blkio
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys perf_event
Oct 22 07:22:15 hornet2 kernel: Initializing cgroup subsys net_prio
Oct 22 07:22:15 hornet2 kernel: CPU: Physical Processor ID: 0
Oct 22 07:22:15 hornet2 kernel: CPU: Processor Core ID: 0
Oct 22 07:22:15 hornet2 kernel: ENERGY_PERF_BIAS: Set to 'normal', was 'p=
erformance'
Oct 22 07:22:15 hornet2 kernel: ENERGY_PERF_BIAS: View and update with x8=
6_energy_perf_policy(8)
Oct 22 07:22:15 hornet2 kernel: mce: CPU supports 18 MCE banks
Oct 22 07:22:15 hornet2 kernel: CPU0: Thermal monitoring enabled (TM1)
Oct 22 07:22:15 hornet2 kernel: Last level iTLB entries: 4KB 512, 2MB 0, =
4MB 0
Oct 22 07:22:15 hornet2 kernel: Last level dTLB entries: 4KB 512, 2MB 32,=
 4MB 32
Oct 22 07:22:15 hornet2 kernel: tlb_flushall_shift: 5
Oct 22 07:22:15 hornet2 kernel: Freeing SMP alternatives memory: 20K (fff=
fffff81bdc000 - ffffffff81be1000)
Oct 22 07:22:15 hornet2 kernel: ACPI: Core revision 20130725
Oct 22 07:22:15 hornet2 kernel: ACPI: All ACPI Tables successfully acquir=
ed
Oct 22 07:22:15 hornet2 kernel: ftrace: allocating 22483 entries in 88 pa=
ges
Oct 22 07:22:15 hornet2 kernel: Switched APIC routing to physical flat.
Oct 22 07:22:15 hornet2 kernel: ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2=
 apic2=3D-1 pin2=3D-1
Oct 22 07:22:15 hornet2 kernel: smpboot: CPU0: Intel(R) Xeon(R) CPU E5-26=
20 0 @ 2.00GHz (fam: 06, model: 2d, stepping: 07)
Oct 22 07:22:15 hornet2 kernel: Performance Events: PEBS fmt1+, 16-deep L=
BR, SandyBridge events, full-width counters, Intel PMU driver.
Oct 22 07:22:15 hornet2 kernel: ... version:                3
Oct 22 07:22:15 hornet2 kernel: ... bit width:              48
Oct 22 07:22:15 hornet2 kernel: ... generic registers:      4
Oct 22 07:22:15 hornet2 kernel: ... value mask:             0000fffffffff=
fff
Oct 22 07:22:15 hornet2 kernel: ... max period:             0000fffffffff=
fff
Oct 22 07:22:15 hornet2 kernel: ... fixed-purpose events:   3
Oct 22 07:22:15 hornet2 kernel: ... event mask:             0000000700000=
00f
Oct 22 07:22:15 hornet2 kernel: NMI watchdog: enabled on all CPUs, perman=
ently consumes one hw-PMU counter.
Oct 22 07:22:15 hornet2 kernel: smpboot: Booting Node   0, Processors  # =
  1 #   2 #   3 #   4 #   5 OK
Oct 22 07:22:15 hornet2 kernel: smpboot: Booting Node   1, Processors  # =
  6 #   7 #   8 #   9 #  10 #  11 OK
Oct 22 07:22:15 hornet2 kernel: smpboot: Booting Node   0, Processors  # =
 12 #  13 #  14 #  15 #  16 #  17 OK
Oct 22 07:22:15 hornet2 kernel: smpboot: Booting Node   1, Processors  # =
 18 #  19 #  20 #  21 #  22 #  23 OK
Oct 22 07:22:15 hornet2 kernel: Brought up 24 CPUs
Oct 22 07:22:15 hornet2 kernel: smpboot: Total of 24 processors activated=
 (95835.38 BogoMIPS)
Oct 22 07:22:15 hornet2 kernel: devtmpfs: initialized
Oct 22 07:22:15 hornet2 kernel: PM: Registering ACPI NVS region [mem 0xcb=
7f8000-0xcb9c3fff] (1884160 bytes)
Oct 22 07:22:15 hornet2 kernel: PM: Registering ACPI NVS region [mem 0xcb=
adb000-0xcbb60fff] (548864 bytes)
Oct 22 07:22:15 hornet2 kernel: regulator-dummy: no parameters
Oct 22 07:22:15 hornet2 kernel: NET: Registered protocol family 16
Oct 22 07:22:15 hornet2 kernel: cpuidle: using governor ladder
Oct 22 07:22:15 hornet2 kernel: cpuidle: using governor menu
Oct 22 07:22:15 hornet2 kernel: ACPI FADT declares the system doesn't sup=
port PCIe ASPM, so disable it
Oct 22 07:22:15 hornet2 kernel: ACPI: bus type PCI registered
Oct 22 07:22:15 hornet2 kernel: acpiphp: ACPI Hot Plug PCI Controller Dri=
ver version: 0.5
Oct 22 07:22:15 hornet2 kernel: PCI: MMCONFIG for domain 0000 [bus 00-7f]=
 at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
Oct 22 07:22:15 hornet2 kernel: PCI: MMCONFIG at [mem 0xf0000000-0xf7ffff=
ff] reserved in E820
Oct 22 07:22:15 hornet2 kernel: PCI: Using configuration type 1 for base =
access
Oct 22 07:22:15 hornet2 kernel: bio: create slab <bio-0> at 0
Oct 22 07:22:15 hornet2 kernel: ACPI: Added _OSI(Module Device)
Oct 22 07:22:15 hornet2 kernel: ACPI: Added _OSI(Processor Device)
Oct 22 07:22:15 hornet2 kernel: ACPI: Added _OSI(3.0 _SCP Extensions)
Oct 22 07:22:15 hornet2 kernel: ACPI: Added _OSI(Processor Aggregator Dev=
ice)
Oct 22 07:22:15 hornet2 kernel: ACPI: Executed 1 blocks of module-level e=
xecutable AML code
Oct 22 07:22:15 hornet2 kernel: ACPI: Interpreter enabled
Oct 22 07:22:15 hornet2 kernel: ACPI Exception: AE_NOT_FOUND, While evalu=
ating Sleep State [\_S1_] (20130725/hwxface-571)
Oct 22 07:22:15 hornet2 kernel: ACPI Exception: AE_NOT_FOUND, While evalu=
ating Sleep State [\_S2_] (20130725/hwxface-571)
Oct 22 07:22:15 hornet2 kernel: ACPI: (supports S0 S3 S4 S5)
Oct 22 07:22:15 hornet2 kernel: ACPI: Using IOAPIC for interrupt routing
Oct 22 07:22:15 hornet2 kernel: PCI: Using host bridge windows from ACPI;=
 if necessary, use "pci=3Dnocrs" and report a bug
Oct 22 07:22:15 hornet2 kernel: ACPI: No dock devices found.
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000=
 [bus 00-3f])
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:00: Requesting ACPI _OSC con=
trol (0x1d)
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:00: ACPI _OSC request failed=
 (AE_SUPPORT), returned control mask: 0x0d
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:00: ACPI _OSC control for PC=
Ie not granted, disabling ASPM
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:00: fail to add MMCONFIG inf=
ormation, can't access extended PCI configuration space under this bridge=
=2E
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.IOH_: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.VTDR: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.PCH_: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.CWDT: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.HPET: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI0.ITPM: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: PCI host bridge to bus 0000:00
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [bus 0=
0-3f]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [io  0=
x0000-0x03af]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [io  0=
x03e0-0x0cf7]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [io  0=
x03b0-0x03df]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [io  0=
x0d00-0xffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [mem 0=
x000a0000-0x000bffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [mem 0=
x000c0000-0x000dffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [mem 0=
xd0000000-0xefffffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:00: root bus resource [mem 0=
x3c0000000000-0x3c007fffffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:01.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:03.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:19.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1a.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.5: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.6: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.7: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1d.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1e.0: System wakeup disabled =
by ACPI
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:01.0: PCI bridge to [bus 03]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0: PCI bridge to [bus 05]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:03.0: PCI bridge to [bus 04]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0: PCI bridge to [bus 02]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.5: PCI bridge to [bus 06]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.6: PCI bridge to [bus 07]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.7: PCI bridge to [bus 08]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1e.0: PCI bridge to [bus 09] =
(subtractive decode)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Root Bridge [PCI1] (domain 0000=
 [bus 40-ff])
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:01: Requesting ACPI _OSC con=
trol (0x1d)
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:01: ACPI _OSC request failed=
 (AE_SUPPORT), returned control mask: 0x0d
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:01: ACPI _OSC control for PC=
Ie not granted, disabling ASPM
Oct 22 07:22:15 hornet2 kernel: acpi PNP0A08:01: fail to add MMCONFIG inf=
ormation, can't access extended PCI configuration space under this bridge=
=2E
Oct 22 07:22:15 hornet2 kernel: ACPI: \_SB_.PCI1.VTDR: can't evaluate _AD=
R (0x5)
Oct 22 07:22:15 hornet2 kernel: PCI host bridge to bus 0000:40
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [bus 4=
0-ff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [io  0=
x0000-0x03af]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [io  0=
x03e0-0x0cf7]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [mem 0=
x000c0000-0x000dffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [mem 0=
xf8000000-0xfbffffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:40: root bus resource [mem 0=
x3c0800000000-0x3c087fffffff]
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4=
 5 6 7 10 *11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs *3 =
4 5 6 7 10 11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4=
 5 6 10 *11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *=
4 5 6 10 11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4=
 *5 6 7 10 11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4=
 5 6 7 10 11 12 14 15) *0
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4=
 5 6 *7 10 11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4=
 5 6 7 *10 11 12 14 15)
Oct 22 07:22:15 hornet2 kernel: ACPI: Enabled 2 GPEs in block 00 to 3F
Oct 22 07:22:15 hornet2 kernel: vgaarb: device added: PCI:0000:05:00.0,de=
codes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Oct 22 07:22:15 hornet2 kernel: vgaarb: loaded
Oct 22 07:22:15 hornet2 kernel: vgaarb: bridge control possible 0000:05:0=
0.0
Oct 22 07:22:15 hornet2 kernel: SCSI subsystem initialized
Oct 22 07:22:15 hornet2 kernel: ACPI: bus type USB registered
Oct 22 07:22:15 hornet2 kernel: usbcore: registered new interface driver =
usbfs
Oct 22 07:22:15 hornet2 kernel: usbcore: registered new interface driver =
hub
Oct 22 07:22:15 hornet2 kernel: usbcore: registered new device driver usb=

Oct 22 07:22:15 hornet2 kernel: PCI: Using ACPI for IRQ routing
Oct 22 07:22:15 hornet2 kernel: PCI: Discovered peer bus 3f
Oct 22 07:22:15 hornet2 kernel: PCI host bridge to bus 0000:3f
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:3f: root bus resource [io  0=
x0000-0xffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:3f: root bus resource [mem 0=
x00000000-0x3fffffffffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:3f: No busn resource found f=
or root bus, will use [bus 3f-ff]
Oct 22 07:22:15 hornet2 kernel: PCI: Discovered peer bus 7f
Oct 22 07:22:15 hornet2 kernel: PCI host bridge to bus 0000:7f
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:7f: root bus resource [io  0=
x0000-0xffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:7f: root bus resource [mem 0=
x00000000-0x3fffffffffff]
Oct 22 07:22:15 hornet2 kernel: pci_bus 0000:7f: No busn resource found f=
or root bus, will use [bus 7f-ff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:02:00.0: no compatible bridge wi=
ndow for [mem 0x3c0000000000-0x3c000007bfff 64bit pref]
Oct 22 07:22:15 hornet2 kernel: NetLabel: Initializing
Oct 22 07:22:15 hornet2 kernel: NetLabel:  domain hash size =3D 128
Oct 22 07:22:15 hornet2 kernel: NetLabel:  protocols =3D UNLABELED CIPSOv=
4
Oct 22 07:22:15 hornet2 kernel: NetLabel:  unlabeled traffic allowed by d=
efault
Oct 22 07:22:15 hornet2 kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, =
0, 0, 0, 0, 0
Oct 22 07:22:15 hornet2 kernel: hpet0: 8 comparators, 64-bit 14.318180 MH=
z counter
Oct 22 07:22:15 hornet2 kernel: Switched to clocksource hpet
Oct 22 07:22:15 hornet2 kernel: pnp: PnP ACPI init
Oct 22 07:22:15 hornet2 kernel: ACPI: bus type PNP registered
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfc000000-0xfcffffff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfd000000-0xfdffffff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfe000000-0xfeafffff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfeb00000-0xfebfffff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfed00400-0xfed3ffff =
window] could not be reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xfed45000-0xfedfffff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:00: [mem 0xeff46000-0xeff46fff =
window] has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:01: [mem 0xeff44000-0xeff45fff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:02: [io  0x0620-0x063f] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:02: [io  0x0610-0x061f] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:08: [io  0x04d0-0x04d1] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [io  0x0400-0x0453] could n=
ot be reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [io  0x0458-0x047f] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [io  0x1180-0x119f] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [io  0x0500-0x057f] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [mem 0xfed1c000-0xfed1ffff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [mem 0xfec00000-0xfecfffff]=
 could not be reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [mem 0xfed08000-0xfed08fff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0a: [mem 0xff000000-0xffffffff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0b: [io  0x0454-0x0457] has bee=
n reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0d: [mem 0xfbf20000-0xfbf21fff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: system 00:0e: [mem 0xfed40000-0xfed44fff]=
 has been reserved
Oct 22 07:22:15 hornet2 kernel: pnp: PnP ACPI: found 15 devices
Oct 22 07:22:15 hornet2 kernel: ACPI: bus type PNP unregistered
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0: BAR 14: assigned [mem 0=
xe0500000-0xe05fffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:01.0: PCI bridge to [bus 03]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0: PCI bridge to [bus 05]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0:   bridge window [io  0x=
c000-0xcfff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0:   bridge window [mem 0x=
efd00000-0xefdfffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:02.0:   bridge window [mem 0x=
d0000000-0xdfffffff 64bit pref]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:03.0: PCI bridge to [bus 04]
Oct 22 07:22:15 hornet2 kernel: pci 0000:02:00.0: BAR 7: assigned [mem 0x=
e0404000-0xe047ffff 64bit pref]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0: PCI bridge to [bus 02]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0:   bridge window [io  0x=
d000-0xdfff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0:   bridge window [mem 0x=
e0500000-0xe05fffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:11.0:   bridge window [mem 0x=
e0000000-0xe04fffff 64bit pref]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.0: PCI bridge to [bus 01]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.0:   bridge window [io  0x=
e000-0xefff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.0:   bridge window [mem 0x=
efe00000-0xefefffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.5: PCI bridge to [bus 06]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.6: PCI bridge to [bus 07]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.7: PCI bridge to [bus 08]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1c.7:   bridge window [mem 0x=
efc00000-0xefcfffff]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1e.0: PCI bridge to [bus 09]
Oct 22 07:22:15 hornet2 kernel: pci 0000:00:1e.0:   bridge window [mem 0x=
efb00000-0xefbfffff]
Oct 22 07:22:15 hornet2 kernel: NET: Registered protocol family 2
Oct 22 07:22:15 hornet2 kernel: TCP established hash table entries: 52428=
8 (order: 11, 8388608 bytes)
Oct 22 07:22:15 hornet2 kernel: TCP bind hash table entries: 65536 (order=
: 8, 1048576 bytes)
Oct 22 07:22:15 hornet2 kernel: TCP: Hash tables configured (established =
524288 bind 65536)
Oct 22 07:22:15 hornet2 kernel: TCP: reno registered
Oct 22 07:22:15 hornet2 kernel: UDP hash table entries: 32768 (order: 8, =
1048576 bytes)
Oct 22 07:22:15 hornet2 kernel: UDP-Lite hash table entries: 32768 (order=
: 8, 1048576 bytes)
Oct 22 07:22:15 hornet2 kernel: NET: Registered protocol family 1
Oct 22 07:22:15 hornet2 kernel: Trying to unpack rootfs image as initramf=
s...
Oct 22 07:22:15 hornet2 kernel: Freeing initrd memory: 8008K (ffff88007f4=
2a000 - ffff88007fbfc000)
Oct 22 07:22:15 hornet2 kernel: PCI-DMA: Using software bounce buffering =
for IO (SWIOTLB)
Oct 22 07:22:15 hornet2 kernel: software IO TLB [mem 0xc4347000-0xc834700=
0] (64MB) mapped at [ffff8800c4347000-ffff8800c8346fff]
Oct 22 07:22:15 hornet2 kernel: audit: initializing netlink socket (disab=
led)
Oct 22 07:22:15 hornet2 kernel: type=3D2000 audit(1382440874.916:1): init=
ialized
Oct 22 07:22:15 hornet2 kernel: bounce pool size: 64 pages
Oct 22 07:22:15 hornet2 kernel: HugeTLB registered 2 MB page size, pre-al=
located 0 pages
Oct 22 07:22:15 hornet2 kernel: VFS: Disk quotas dquot_6.5.2
Oct 22 07:22:15 hornet2 kernel: Dquot-cache hash table entries: 512 (orde=
r 0, 4096 bytes)
Oct 22 07:22:15 hornet2 kernel: msgmni has been set to 32768
Oct 22 07:22:15 hornet2 kernel: Block layer SCSI generic (bsg) driver ver=
sion 0.4 loaded (major 252)
Oct 22 07:22:15 hornet2 kernel: io scheduler noop registered
Oct 22 07:22:15 hornet2 kernel: io scheduler deadline registered
Oct 22 07:22:15 hornet2 kernel: io scheduler cfq registered (default)
Oct 22 07:22:15 hornet2 kernel: pci_hotplug: PCI Hot Plug PCI Core versio=
n: 0.5
Oct 22 07:22:15 hornet2 kernel: pciehp: PCI Express Hot Plug Controller D=
river version: 0.4
Oct 22 07:22:15 hornet2 kernel: efifb: probing for efifb
Oct 22 07:22:15 hornet2 kernel: efifb: framebuffer at 0xd0000000, mapped =
to 0xffffc90017e00000, using 6144k, total 16384k
Oct 22 07:22:15 hornet2 kernel: efifb: mode is 1024x768x32, linelength=3D=
4096, pages=3D1
Oct 22 07:22:15 hornet2 kernel: efifb: scrolling: redraw
Oct 22 07:22:15 hornet2 kernel: efifb: Truecolor: size=3D8:8:8:8, shift=3D=
24:16:8:0
Oct 22 07:22:15 hornet2 kernel: Console: switching to colour frame buffer=
 device 128x48
Oct 22 07:22:15 hornet2 kernel: fb0: EFI VGA frame buffer device
Oct 22 07:22:15 hornet2 kernel: input: Power Button as /devices/LNXSYSTM:=
00/device:00/PNP0C0C:00/input/input0
Oct 22 07:22:15 hornet2 kernel: ACPI: Power Button [PWRB]
Oct 22 07:22:15 hornet2 kernel: input: Power Button as /devices/LNXSYSTM:=
00/LNXPWRBN:00/input/input1
Oct 22 07:22:15 hornet2 kernel: ACPI: Power Button [PWRF]
Oct 22 07:22:15 hornet2 kernel: ACPI: Requesting acpi_cpufreq
Oct 22 07:22:15 hornet2 kernel: GHES: HEST is not enabled!
Oct 22 07:22:15 hornet2 kernel: Serial: 8250/16550 driver, 4 ports, IRQ s=
haring enabled
Oct 22 07:22:15 hornet2 kernel: 0000:00:16.3: ttyS0 at I/O 0xf060 (irq =3D=
 17, base_baud =3D 115200) is a 16550A
Oct 22 07:22:15 hornet2 kernel: Non-volatile memory driver v1.3
Oct 22 07:22:15 hornet2 kernel: Linux agpgart interface v0.103
Oct 22 07:22:15 hornet2 kernel: brd: module loaded
Oct 22 07:22:15 hornet2 kernel: loop: module loaded
Oct 22 07:22:15 hornet2 kernel: libphy: Fixed MDIO Bus: probed
Oct 22 07:22:15 hornet2 kernel: ehci_hcd: USB 2.0 'Enhanced' Host Control=
ler (EHCI) Driver
Oct 22 07:22:15 hornet2 kernel: ehci-pci: EHCI PCI platform driver
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1a.0: EHCI Host Controll=
er
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1a.0: new USB bus regist=
ered, assigned bus number 1
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1a.0: debug port 2
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1a.0: irq 16, io mem 0xe=
ff4e000
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1a.0: USB 2.0 started, E=
HCI 1.00
Oct 22 07:22:15 hornet2 kernel: usb usb1: New USB device found, idVendor=3D=
1d6b, idProduct=3D0002
Oct 22 07:22:15 hornet2 kernel: usb usb1: New USB device strings: Mfr=3D3=
, Product=3D2, SerialNumber=3D1
Oct 22 07:22:15 hornet2 kernel: usb usb1: Product: EHCI Host Controller
Oct 22 07:22:15 hornet2 kernel: usb usb1: Manufacturer: Linux 3.12.0-rc3+=
 ehci_hcd
Oct 22 07:22:15 hornet2 kernel: usb usb1: SerialNumber: 0000:00:1a.0
Oct 22 07:22:15 hornet2 kernel: hub 1-0:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 1-0:1.0: 3 ports detected
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1d.0: EHCI Host Controll=
er
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1d.0: new USB bus regist=
ered, assigned bus number 2
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1d.0: debug port 2
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1d.0: irq 23, io mem 0xe=
ff4d000
Oct 22 07:22:15 hornet2 kernel: ehci-pci 0000:00:1d.0: USB 2.0 started, E=
HCI 1.00
Oct 22 07:22:15 hornet2 kernel: usb usb2: New USB device found, idVendor=3D=
1d6b, idProduct=3D0002
Oct 22 07:22:15 hornet2 kernel: usb usb2: New USB device strings: Mfr=3D3=
, Product=3D2, SerialNumber=3D1
Oct 22 07:22:15 hornet2 kernel: usb usb2: Product: EHCI Host Controller
Oct 22 07:22:15 hornet2 kernel: usb usb2: Manufacturer: Linux 3.12.0-rc3+=
 ehci_hcd
Oct 22 07:22:15 hornet2 kernel: usb usb2: SerialNumber: 0000:00:1d.0
Oct 22 07:22:15 hornet2 kernel: hub 2-0:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 2-0:1.0: 3 ports detected
Oct 22 07:22:15 hornet2 kernel: ohci_hcd: USB 1.1 'Open' Host Controller =
(OHCI) Driver
Oct 22 07:22:15 hornet2 kernel: ohci-pci: OHCI PCI platform driver
Oct 22 07:22:15 hornet2 kernel: uhci_hcd: USB Universal Host Controller I=
nterface driver
Oct 22 07:22:15 hornet2 kernel: i8042: PNP: PS/2 Controller [PNP0303:PS2K=
,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Oct 22 07:22:15 hornet2 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 22 07:22:15 hornet2 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12=

Oct 22 07:22:15 hornet2 kernel: mousedev: PS/2 mouse device common for al=
l mice
Oct 22 07:22:15 hornet2 kernel: rtc_cmos 00:06: RTC can wake from S4
Oct 22 07:22:15 hornet2 kernel: rtc_cmos 00:06: rtc core: registered rtc_=
cmos as rtc0
Oct 22 07:22:15 hornet2 kernel: rtc_cmos 00:06: alarms up to one month, y=
3k, 114 bytes nvram, hpet irqs
Oct 22 07:22:15 hornet2 kernel: Intel P-state driver initializing.
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 0
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 1
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 2
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 3
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 4
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 5
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 6
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 7
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 8
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 9
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 10
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 11
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 12
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 13
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 14
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 15
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 16
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 17
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 18
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 19
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 20
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 21
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 22
Oct 22 07:22:15 hornet2 kernel: Intel pstate controlling: cpu 23
Oct 22 07:22:15 hornet2 kernel: EFI Variables Facility v0.08 2004-May-17
Oct 22 07:22:15 hornet2 kernel: pstore: Registered efi as persistent stor=
e backend
Oct 22 07:22:15 hornet2 kernel: hidraw: raw HID events driver (C) Jiri Ko=
sina
Oct 22 07:22:15 hornet2 kernel: usbcore: registered new interface driver =
usbhid
Oct 22 07:22:15 hornet2 kernel: usbhid: USB HID core driver
Oct 22 07:22:15 hornet2 kernel: drop_monitor: Initializing network drop m=
onitor service
Oct 22 07:22:15 hornet2 kernel: TCP: cubic registered
Oct 22 07:22:15 hornet2 kernel: Initializing XFRM netlink socket
Oct 22 07:22:15 hornet2 kernel: NET: Registered protocol family 17
Oct 22 07:22:15 hornet2 kernel: registered taskstats version 1
Oct 22 07:22:15 hornet2 kernel: IMA: No TPM chip found, activating TPM-by=
pass!
Oct 22 07:22:15 hornet2 kernel: rtc_cmos 00:06: setting system clock to 2=
013-10-22 11:21:15 UTC (1382440875)
Oct 22 07:22:15 hornet2 kernel: Freeing unused kernel memory: 1092K (ffff=
ffff81acb000 - ffffffff81bdc000)
Oct 22 07:22:15 hornet2 kernel: Write protecting the kernel read-only dat=
a: 10240k
Oct 22 07:22:15 hornet2 kernel: Freeing unused kernel memory: 696K (ffff8=
80001552000 - ffff880001600000)
Oct 22 07:22:15 hornet2 kernel: Freeing unused kernel memory: 1540K (ffff=
88000187f000 - ffff880001a00000)
Oct 22 07:22:15 hornet2 kernel: device-mapper: uevent: version 1.0.3
Oct 22 07:22:15 hornet2 kernel: device-mapper: ioctl: 4.26.0-ioctl (2013-=
08-15) initialised: dm-devel@redhat.com
Oct 22 07:22:15 hornet2 kernel: udevd (201): /proc/201/oom_adj is depreca=
ted, please use /proc/201/oom_score_adj instead.
Oct 22 07:22:15 hornet2 kernel: [drm] Initialized drm 1.1.0 20060810
Oct 22 07:22:15 hornet2 kernel: [drm] radeon kernel modesetting enabled.
Oct 22 07:22:15 hornet2 kernel: fb: conflicting fb hw usage radeondrmfb v=
s EFI VGA - removing generic driver
Oct 22 07:22:15 hornet2 kernel: Console: switching to colour dummy device=
 80x25
Oct 22 07:22:15 hornet2 kernel: pcieport 0000:00:02.0: driver skip pci_se=
t_master, fix it!
Oct 22 07:22:15 hornet2 kernel: [drm] initializing kernel modesetting (TA=
HITI 0x1002:0x6798 0x1002:0x0B00).
Oct 22 07:22:15 hornet2 kernel: [drm] register mmio base: 0xEFD00000
Oct 22 07:22:15 hornet2 kernel: [drm] register mmio size: 262144
Oct 22 07:22:15 hornet2 kernel: ATOM BIOS: Tahiti
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: VRAM: 3072M 0x000000=
0000000000 - 0x00000000BFFFFFFF (3072M used)
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: GTT: 1024M 0x0000000=
0C0000000 - 0x00000000FFFFFFFF
Oct 22 07:22:15 hornet2 kernel: [drm] Detected VRAM RAM=3D3072M, BAR=3D25=
6M
Oct 22 07:22:15 hornet2 kernel: [drm] RAM width 384bits DDR
Oct 22 07:22:15 hornet2 kernel: [TTM] Zone  kernel: Available graphics me=
mory: 24565136 kiB
Oct 22 07:22:15 hornet2 kernel: [TTM] Zone   dma32: Available graphics me=
mory: 2097152 kiB
Oct 22 07:22:15 hornet2 kernel: [TTM] Initializing pool allocator
Oct 22 07:22:15 hornet2 kernel: [TTM] Initializing DMA pool allocator
Oct 22 07:22:15 hornet2 kernel: [drm] radeon: 3072M of VRAM memory ready
Oct 22 07:22:15 hornet2 kernel: [drm] radeon: 1024M of GTT memory ready.
Oct 22 07:22:15 hornet2 kernel: [drm] GART: num cpu pages 262144, num gpu=
 pages 262144
Oct 22 07:22:15 hornet2 kernel: [drm] probing gen 2 caps for device 8086:=
3c04 =3D 7a7103/e
Oct 22 07:22:15 hornet2 kernel: [drm] PCIE gen 3 link speeds already enab=
led
Oct 22 07:22:15 hornet2 kernel: [drm] Loading TAHITI Microcode
Oct 22 07:22:15 hornet2 kernel: usb 1-1: new high-speed USB device number=
 2 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 1-1: New USB device found, idVendor=3D=
8087, idProduct=3D0024
Oct 22 07:22:15 hornet2 kernel: usb 1-1: New USB device strings: Mfr=3D0,=
 Product=3D0, SerialNumber=3D0
Oct 22 07:22:15 hornet2 kernel: hub 1-1:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 1-1:1.0: 6 ports detected
Oct 22 07:22:15 hornet2 kernel: [drm] PCIE GART of 1024M enabled (table a=
t 0x0000000000276000).
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: WB enabled
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 0 use gpu addr 0x00000000c0000c00 and cpu addr 0xffff880c156edc00
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 1 use gpu addr 0x00000000c0000c04 and cpu addr 0xffff880c156edc04
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 2 use gpu addr 0x00000000c0000c08 and cpu addr 0xffff880c156edc08
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 3 use gpu addr 0x00000000c0000c0c and cpu addr 0xffff880c156edc0c
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 4 use gpu addr 0x00000000c0000c10 and cpu addr 0xffff880c156edc10
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fence driver on ring=
 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc900187b5a18
Oct 22 07:22:15 hornet2 kernel: [drm] Supports vblank timestamp caching R=
ev 1 (10.10.2010).
Oct 22 07:22:15 hornet2 kernel: [drm] Driver supports precise vblank time=
stamp query.
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: radeon: using MSI.
Oct 22 07:22:15 hornet2 kernel: [drm] radeon: irq initialized.
Oct 22 07:22:15 hornet2 kernel: usb 2-1: new high-speed USB device number=
 2 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 2-1: New USB device found, idVendor=3D=
8087, idProduct=3D0024
Oct 22 07:22:15 hornet2 kernel: usb 2-1: New USB device strings: Mfr=3D0,=
 Product=3D0, SerialNumber=3D0
Oct 22 07:22:15 hornet2 kernel: hub 2-1:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 2-1:1.0: 8 ports detected
Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 0 succeeded in 1 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 1 succeeded in 1 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 2 succeeded in 1 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 3 succeeded in 2 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 4 succeeded in 1 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] ring test on 5 succeeded in 2 usecs=

Oct 22 07:22:15 hornet2 kernel: [drm] UVD initialized successfully.
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 0 support
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 1 support
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 2 support
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 3 support
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 4 support
Oct 22 07:22:15 hornet2 kernel: [drm] Enabling audio 5 support
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 0 succeeded in 0 us=
ecs
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 1 succeeded in 0 us=
ecs
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 2 succeeded in 0 us=
ecs
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 3 succeeded in 0 us=
ecs
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 4 succeeded in 1 us=
ecs
Oct 22 07:22:15 hornet2 kernel: tsc: Refined TSC clocksource calibration:=
 1995.192 MHz
Oct 22 07:22:15 hornet2 kernel: usb 2-1.1: new low-speed USB device numbe=
r 3 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 2-1.1: New USB device found, idVendor=
=3D03f0, idProduct=3D0324
Oct 22 07:22:15 hornet2 kernel: usb 2-1.1: New USB device strings: Mfr=3D=
1, Product=3D2, SerialNumber=3D0
Oct 22 07:22:15 hornet2 kernel: usb 2-1.1: Product: HP Basic USB Keyboard=

Oct 22 07:22:15 hornet2 kernel: usb 2-1.1: Manufacturer: Lite-On Technolo=
gy Corp.
Oct 22 07:22:15 hornet2 kernel: input: Lite-On Technology Corp. HP Basic =
USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0=
/input/input2
Oct 22 07:22:15 hornet2 kernel: [drm] ib test on ring 5 succeeded
Oct 22 07:22:15 hornet2 kernel: hid-generic 0003:03F0:0324.0001: input,hi=
draw0: USB HID v1.10 Keyboard [Lite-On Technology Corp. HP Basic USB Keyb=
oard] on usb-0000:00:1d.0-1.1/input0
Oct 22 07:22:15 hornet2 kernel: [drm] Radeon Display Connectors
Oct 22 07:22:15 hornet2 kernel: [drm] Connector 0:
Oct 22 07:22:15 hornet2 kernel: [drm]   DP-1
Oct 22 07:22:15 hornet2 kernel: [drm]   HPD5
Oct 22 07:22:15 hornet2 kernel: [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 =
0x6538 0x6538 0x653c 0x653c
Oct 22 07:22:15 hornet2 kernel: [drm]   Encoders:
Oct 22 07:22:15 hornet2 kernel: [drm]     DFP1: INTERNAL_UNIPHY2
Oct 22 07:22:15 hornet2 kernel: [drm] Connector 1:
Oct 22 07:22:15 hornet2 kernel: [drm]   DP-2
Oct 22 07:22:15 hornet2 kernel: [drm]   HPD4
Oct 22 07:22:15 hornet2 kernel: [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 =
0x6548 0x6548 0x654c 0x654c
Oct 22 07:22:15 hornet2 kernel: [drm]   Encoders:
Oct 22 07:22:15 hornet2 kernel: [drm]     DFP2: INTERNAL_UNIPHY2
Oct 22 07:22:15 hornet2 kernel: [drm] Connector 2:
Oct 22 07:22:15 hornet2 kernel: [drm]   HDMI-A-1
Oct 22 07:22:15 hornet2 kernel: [drm]   HPD1
Oct 22 07:22:15 hornet2 kernel: [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 =
0x6568 0x6568 0x656c 0x656c
Oct 22 07:22:15 hornet2 kernel: [drm]   Encoders:
Oct 22 07:22:15 hornet2 kernel: [drm]     DFP3: INTERNAL_UNIPHY1
Oct 22 07:22:15 hornet2 kernel: [drm] Connector 3:
Oct 22 07:22:15 hornet2 kernel: [drm]   DVI-I-1
Oct 22 07:22:15 hornet2 kernel: [drm]   HPD3
Oct 22 07:22:15 hornet2 kernel: [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 =
0x6588 0x6588 0x658c 0x658c
Oct 22 07:22:15 hornet2 kernel: [drm]   Encoders:
Oct 22 07:22:15 hornet2 kernel: [drm]     DFP4: INTERNAL_UNIPHY
Oct 22 07:22:15 hornet2 kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Oct 22 07:22:15 hornet2 kernel: [drm] Internal thermal controller with fa=
n control
Oct 22 07:22:15 hornet2 kernel: [drm] radeon: power management initialize=
d
Oct 22 07:22:15 hornet2 kernel: [drm] fb mappable at 0xD1480000
Oct 22 07:22:15 hornet2 kernel: [drm] vram apper at 0xD0000000
Oct 22 07:22:15 hornet2 kernel: [drm] size 9216000
Oct 22 07:22:15 hornet2 kernel: [drm] fb depth is 24
Oct 22 07:22:15 hornet2 kernel: [drm]    pitch is 7680
Oct 22 07:22:15 hornet2 kernel: fbcon: radeondrmfb (fb0) is primary devic=
e
Oct 22 07:22:15 hornet2 kernel: Console: switching to colour frame buffer=
 device 240x75
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: fb0: radeondrmfb fra=
me buffer device
Oct 22 07:22:15 hornet2 kernel: radeon 0000:05:00.0: registered panic not=
ifier
Oct 22 07:22:15 hornet2 kernel: [drm] Initialized radeon 2.34.0 20080528 =
for 0000:05:00.0 on minor 0
Oct 22 07:22:15 hornet2 kernel: usb 2-1.2: new low-speed USB device numbe=
r 4 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 2-1.2: New USB device found, idVendor=
=3D04ca, idProduct=3D0062
Oct 22 07:22:15 hornet2 kernel: usb 2-1.2: New USB device strings: Mfr=3D=
0, Product=3D2, SerialNumber=3D0
Oct 22 07:22:15 hornet2 kernel: usb 2-1.2: Product: USB Optical Mouse
Oct 22 07:22:15 hornet2 kernel: input: USB Optical Mouse as /devices/pci0=
000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
Oct 22 07:22:15 hornet2 kernel: hid-generic 0003:04CA:0062.0002: input,hi=
draw1: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.2/in=
put0
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: new full-speed USB device numb=
er 5 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: New USB device found, idVendor=
=3D0764, idProduct=3D0501
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: New USB device strings: Mfr=3D=
1, Product=3D2, SerialNumber=3D3
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: Product: CRCA102-3I1
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: Manufacturer: CP1500PFCLCD
Oct 22 07:22:15 hornet2 kernel: usb 2-1.3: SerialNumber: CPS
Oct 22 07:22:15 hornet2 kernel: hid-generic 0003:0764:0501.0003: hiddev0,=
hidraw2: USB HID v1.10 Device [CP1500PFCLCD CRCA102-3I1] on usb-0000:00:1=
d.0-1.3/input0
Oct 22 07:22:15 hornet2 kernel: isci: Intel(R) C600 SAS Controller Driver=
 - version 1.1.0
Oct 22 07:22:15 hornet2 kernel: isci 0000:02:00.0: driver configured for =
rev: 5 silicon
Oct 22 07:22:15 hornet2 kernel: isci 0000:02:00.0: OEM SAS parameters (ve=
rsion: 1.1) loaded (platform)
Oct 22 07:22:15 hornet2 kernel: pcieport 0000:00:11.0: driver skip pci_se=
t_master, fix it!
Oct 22 07:22:15 hornet2 kernel: isci 0000:02:00.0: SCU controller 0: phy =
3-0 cables: {short, short, short, short}
Oct 22 07:22:15 hornet2 kernel: scsi0 : isci
Oct 22 07:22:15 hornet2 kernel: usb 2-1.4: new high-speed USB device numb=
er 6 using ehci-pci
Oct 22 07:22:15 hornet2 kernel: usb 2-1.4: New USB device found, idVendor=
=3D0424, idProduct=3D2504
Oct 22 07:22:15 hornet2 kernel: usb 2-1.4: New USB device strings: Mfr=3D=
0, Product=3D0, SerialNumber=3D0
Oct 22 07:22:15 hornet2 kernel: hub 2-1.4:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 2-1.4:1.0: 4 ports detected
Oct 22 07:22:15 hornet2 kernel: scsi1 : ata_generic
Oct 22 07:22:15 hornet2 kernel: scsi2 : ata_generic
Oct 22 07:22:15 hornet2 kernel: ata1: PATA max UDMA/100 cmd 0xf0b0 ctl 0x=
f0a0 bmdma 0xf070 irq 18
Oct 22 07:22:15 hornet2 kernel: ata2: PATA max UDMA/100 cmd 0xf090 ctl 0x=
f080 bmdma 0xf078 irq 18
Oct 22 07:22:15 hornet2 kernel: Switched to clocksource tsc
Oct 22 07:22:15 hornet2 kernel: ahci 0000:00:1f.2: AHCI 0001.0300 32 slot=
s 6 ports 6 Gbps 0xf impl RAID mode
Oct 22 07:22:15 hornet2 kernel: ahci 0000:00:1f.2: flags: 64bit ncq sntf =
pm led clo pio slum part ems sxs apst=20
Oct 22 07:22:15 hornet2 kernel: scsi3 : ahci
Oct 22 07:22:15 hornet2 kernel: scsi4 : ahci
Oct 22 07:22:15 hornet2 kernel: scsi5 : ahci
Oct 22 07:22:15 hornet2 kernel: scsi6 : ahci
Oct 22 07:22:15 hornet2 kernel: scsi7 : ahci
Oct 22 07:22:15 hornet2 kernel: scsi8 : ahci
Oct 22 07:22:15 hornet2 kernel: ata3: SATA max UDMA/133 abar m2048@0xeff4=
b000 port 0xeff4b100 irq 91
Oct 22 07:22:15 hornet2 kernel: ata4: SATA max UDMA/133 abar m2048@0xeff4=
b000 port 0xeff4b180 irq 91
Oct 22 07:22:15 hornet2 kernel: ata5: SATA max UDMA/133 abar m2048@0xeff4=
b000 port 0xeff4b200 irq 91
Oct 22 07:22:15 hornet2 kernel: ata6: SATA max UDMA/133 abar m2048@0xeff4=
b000 port 0xeff4b280 irq 91
Oct 22 07:22:15 hornet2 kernel: ata7: DUMMY
Oct 22 07:22:15 hornet2 kernel: ata8: DUMMY
Oct 22 07:22:15 hornet2 kernel: ata3: SATA link up 6.0 Gbps (SStatus 133 =
SControl 300)
Oct 22 07:22:15 hornet2 kernel: ata5: SATA link up 3.0 Gbps (SStatus 123 =
SControl 300)
Oct 22 07:22:15 hornet2 kernel: ata4: SATA link up 6.0 Gbps (SStatus 133 =
SControl 300)
Oct 22 07:22:15 hornet2 kernel: ata4.00: supports DRM functions and may n=
ot be fully accessible
Oct 22 07:22:15 hornet2 kernel: ata3.00: ATA-9: M4-CT512M4SSD2, 040H, max=
 UDMA/100
Oct 22 07:22:15 hornet2 kernel: ata3.00: 1000215216 sectors, multi 16: LB=
A48 NCQ (depth 31/32), AA
Oct 22 07:22:15 hornet2 kernel: ata4.00: ATA-9: Crucial_CT960M500SSD1, MU=
02, max UDMA/133
Oct 22 07:22:15 hornet2 kernel: ata4.00: 1875385008 sectors, multi 16: LB=
A48 NCQ (depth 31/32), AA
Oct 22 07:22:15 hornet2 kernel: ata3.00: configured for UDMA/100
Oct 22 07:22:15 hornet2 kernel: ata5.00: ATA-8: ST500DM002-1BD142, HP73, =
max UDMA/100
Oct 22 07:22:15 hornet2 kernel: ata5.00: 976773168 sectors, multi 16: LBA=
48 NCQ (depth 31/32)
Oct 22 07:22:15 hornet2 kernel: scsi 3:0:0:0: Direct-Access     ATA      =
M4-CT512M4SSD2   040H PQ: 0 ANSI: 5
Oct 22 07:22:15 hornet2 kernel: ata4.00: supports DRM functions and may n=
ot be fully accessible
Oct 22 07:22:15 hornet2 kernel: ata6: SATA link up 1.5 Gbps (SStatus 113 =
SControl 300)
Oct 22 07:22:15 hornet2 kernel: ata4.00: configured for UDMA/133
Oct 22 07:22:15 hornet2 kernel: ata5.00: configured for UDMA/100
Oct 22 07:22:15 hornet2 kernel: scsi 4:0:0:0: Direct-Access     ATA      =
Crucial_CT960M50 MU02 PQ: 0 ANSI: 5
Oct 22 07:22:15 hornet2 kernel: scsi 5:0:0:0: Direct-Access     ATA      =
ST500DM002-1BD14 HP73 PQ: 0 ANSI: 5
Oct 22 07:22:15 hornet2 kernel: ata6.00: ATAPI: hp       CDDVDW SH-216ALN=
, HA5A, max UDMA/100
Oct 22 07:22:15 hornet2 kernel: ata6.00: configured for UDMA/100
Oct 22 07:22:15 hornet2 kernel: scsi 6:0:0:0: CD-ROM            hp       =
CDDVDW SH-216ALN HA5A PQ: 0 ANSI: 5
Oct 22 07:22:15 hornet2 kernel: firewire_ohci 0000:09:05.0: enabling devi=
ce (0100 -> 0102)
Oct 22 07:22:15 hornet2 kernel: firewire_ohci 0000:09:05.0: added OHCI v1=
=2E0 device as card 0, 8 IR + 8 IT contexts, quirks 0x80
Oct 22 07:22:15 hornet2 kernel: sd 3:0:0:0: [sda] 1000215216 512-byte log=
ical blocks: (512 GB/476 GiB)
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: [sdb] 1875385008 512-byte log=
ical blocks: (960 GB/894 GiB)
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: [sdb] 4096-byte physical bloc=
ks
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: [sdc] 976773168 512-byte logi=
cal blocks: (500 GB/465 GiB)
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: [sdc] 4096-byte physical bloc=
ks
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: [sdb] Write Protect is off
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: [sdc] Write Protect is off
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: [sdb] Write cache: enabled, r=
ead cache: enabled, doesn't support DPO or FUA
Oct 22 07:22:15 hornet2 kernel: sd 3:0:0:0: [sda] Write Protect is off
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: [sdc] Write cache: enabled, r=
ead cache: enabled, doesn't support DPO or FUA
Oct 22 07:22:15 hornet2 kernel: sd 3:0:0:0: [sda] Write cache: enabled, r=
ead cache: enabled, doesn't support DPO or FUA
Oct 22 07:22:15 hornet2 kernel: sdb: sdb1 sdb2
Oct 22 07:22:15 hornet2 kernel: sda: sda1 sda2 sda3
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: [sdb] Attached SCSI disk
Oct 22 07:22:15 hornet2 kernel: sd 3:0:0:0: [sda] Attached SCSI disk
Oct 22 07:22:15 hornet2 kernel: sdc: sdc1 sdc2
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: [sdc] Attached SCSI disk
Oct 22 07:22:15 hornet2 kernel: sr0: scsi3-mmc drive: 40x/40x writer dvd-=
ram cd/rw xa/form2 cdda tray
Oct 22 07:22:15 hornet2 kernel: cdrom: Uniform CD-ROM driver Revision: 3.=
20
Oct 22 07:22:15 hornet2 kernel: bio: create slab <bio-1> at 1
Oct 22 07:22:15 hornet2 kernel: firewire_core 0000:09:05.0: created devic=
e fw0: GUID 0060b0000082b706, S400
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-0): INFO: recovery required o=
n readonly filesystem
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-0): write access will be enab=
led during recovery
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-0): recovery complete
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-0): mounted filesystem with o=
rdered data mode. Opts: (null)
Oct 22 07:22:15 hornet2 kernel: type=3D1404 audit(1382440881.128:2): enfo=
rcing=3D1 old_enforcing=3D0 auid=3D4294967295 ses=3D4294967295
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s dir not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission execmod in class dir=
 not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s lnk_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission open in class lnk_fi=
le not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission execmod in class lnk=
_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s chr_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s blk_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission execmod in class blk=
_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s sock_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission execmod in class soc=
k_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission audit_access in clas=
s fifo_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission execmod in class fif=
o_file not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission syslog in class capa=
bility2 not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission wake_alarm in class =
capability2 not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission block_suspend in cla=
ss capability2 not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux:  Permission attach_queue in clas=
s tun_socket not defined in policy.
Oct 22 07:22:15 hornet2 kernel: SELinux: the above unknown classes and pe=
rmissions will be allowed
Oct 22 07:22:15 hornet2 kernel: type=3D1403 audit(1382440881.662:3): poli=
cy loaded auid=3D4294967295 ses=3D4294967295
Oct 22 07:22:15 hornet2 kernel: WARNING! power/level is deprecated; use p=
ower/control instead
Oct 22 07:22:15 hornet2 kernel: snd_hda_intel 0000:00:1b.0: enabling devi=
ce (0100 -> 0102)
Oct 22 07:22:15 hornet2 kernel: input: HDA Intel PCH Front Headphone as /=
devices/pci0000:00/0000:00:1b.0/sound/card0/input4
Oct 22 07:22:15 hornet2 kernel: input: HDA Intel PCH Line Out as /devices=
/pci0000:00/0000:00:1b.0/sound/card0/input5
Oct 22 07:22:15 hornet2 kernel: input: HDA Intel PCH Line as /devices/pci=
0000:00/0000:00:1b.0/sound/card0/input6
Oct 22 07:22:15 hornet2 kernel: input: HDA Intel PCH Rear Mic as /devices=
/pci0000:00/0000:00:1b.0/sound/card0/input7
Oct 22 07:22:15 hornet2 kernel: input: HDA Intel PCH Front Mic as /device=
s/pci0000:00/0000:00:1b.0/sound/card0/input8
Oct 22 07:22:15 hornet2 kernel: snd_hda_intel 0000:05:00.1: enabling devi=
ce (0100 -> 0102)
Oct 22 07:22:15 hornet2 kernel: hda-intel 0000:05:00.1: Handle VGA-switch=
eroo audio client
Oct 22 07:22:15 hornet2 kernel: hda-intel 0000:05:00.1: Force to non-snoo=
p mode
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D11 as /=
devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input9
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D10 as /=
devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input10
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D9 as /d=
evices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input11
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D8 as /d=
evices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input12
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D7 as /d=
evices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input13
Oct 22 07:22:15 hornet2 kernel: input: HDA ATI HDMI HDMI/DP,pcm=3D3 as /d=
evices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input14
Oct 22 07:22:15 hornet2 kernel: dca service started, version 1.12.1
Oct 22 07:22:15 hornet2 kernel: ioatdma: Intel(R) QuickData Technology Dr=
iver 4.00
Oct 22 07:22:15 hornet2 kernel: pps_core: LinuxPPS API ver. 1 registered
Oct 22 07:22:15 hornet2 kernel: pps_core: Software ver. 5.3.6 - Copyright=
 2005-2007 Rodolfo Giometti <giometti@linux.it>
Oct 22 07:22:15 hornet2 kernel: PTP clock support registered
Oct 22 07:22:15 hornet2 kernel: e1000e: Intel(R) PRO/1000 Network Driver =
- 2.3.2-k
Oct 22 07:22:15 hornet2 kernel: e1000e: Copyright(c) 1999 - 2013 Intel Co=
rporation.
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:00:19.0: Interrupt Throttling=
 Rate (ints/sec) set to dynamic conservative mode
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:00:19.0 eth0: registered PHC =
clock
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:00:19.0 eth0: (PCI Express:2.=
5GT/s:Width x1) e8:39:35:63:2a:94
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:00:19.0 eth0: Intel(R) PRO/10=
00 Network Connection
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 1=
1, PBA No: 0100FF-0FF
Oct 22 07:22:15 hornet2 kernel: pcieport 0000:00:1c.0: driver skip pci_se=
t_master, fix it!
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:01:00.0: Interrupt Throttling=
 Rate (ints/sec) set to dynamic conservative mode
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:01:00.0 eth1: registered PHC =
clock
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:01:00.0 eth1: (PCI Express:2.=
5GT/s:Width x1) e8:39:35:63:2a:93
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:01:00.0 eth1: Intel(R) PRO/10=
00 Network Connection
Oct 22 07:22:15 hornet2 kernel: e1000e 0000:01:00.0 eth1: MAC: 3, PHY: 8,=
 PBA No: FFFFFF-0FF
Oct 22 07:22:15 hornet2 kernel: xhci_hcd 0000:08:00.0: xHCI Host Controll=
er
Oct 22 07:22:15 hornet2 kernel: xhci_hcd 0000:08:00.0: new USB bus regist=
ered, assigned bus number 3
Oct 22 07:22:15 hornet2 kernel: usb usb3: New USB device found, idVendor=3D=
1d6b, idProduct=3D0002
Oct 22 07:22:15 hornet2 kernel: usb usb3: New USB device strings: Mfr=3D3=
, Product=3D2, SerialNumber=3D1
Oct 22 07:22:15 hornet2 kernel: usb usb3: Product: xHCI Host Controller
Oct 22 07:22:15 hornet2 kernel: usb usb3: Manufacturer: Linux 3.12.0-rc3+=
 xhci_hcd
Oct 22 07:22:15 hornet2 kernel: usb usb3: SerialNumber: 0000:08:00.0
Oct 22 07:22:15 hornet2 kernel: hub 3-0:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 3-0:1.0: 4 ports detected
Oct 22 07:22:15 hornet2 kernel: xhci_hcd 0000:08:00.0: xHCI Host Controll=
er
Oct 22 07:22:15 hornet2 kernel: xhci_hcd 0000:08:00.0: new USB bus regist=
ered, assigned bus number 4
Oct 22 07:22:15 hornet2 kernel: usb usb4: New USB device found, idVendor=3D=
1d6b, idProduct=3D0003
Oct 22 07:22:15 hornet2 kernel: usb usb4: New USB device strings: Mfr=3D3=
, Product=3D2, SerialNumber=3D1
Oct 22 07:22:15 hornet2 kernel: usb usb4: Product: xHCI Host Controller
Oct 22 07:22:15 hornet2 kernel: usb usb4: Manufacturer: Linux 3.12.0-rc3+=
 xhci_hcd
Oct 22 07:22:15 hornet2 kernel: usb usb4: SerialNumber: 0000:08:00.0
Oct 22 07:22:15 hornet2 kernel: hub 4-0:1.0: USB hub found
Oct 22 07:22:15 hornet2 kernel: hub 4-0:1.0: 4 ports detected
Oct 22 07:22:15 hornet2 kernel: ACPI Warning: 0x000000000000f000-0x000000=
000000f01f SystemIO conflicts with Region \_SB_.PCI0.SMB_.SMIO 1 (2013072=
5/utaddress-251)
Oct 22 07:22:15 hornet2 kernel: ACPI: If an ACPI driver is available for =
this device, you should use it instead of the native driver
Oct 22 07:22:15 hornet2 kernel: usb 3-2: new high-speed USB device number=
 2 using xhci_hcd
Oct 22 07:22:15 hornet2 kernel: usb 3-2: New USB device found, idVendor=3D=
046d, idProduct=3D082d
Oct 22 07:22:15 hornet2 kernel: usb 3-2: New USB device strings: Mfr=3D0,=
 Product=3D2, SerialNumber=3D1
Oct 22 07:22:15 hornet2 kernel: usb 3-2: Product: HD Pro Webcam C920
Oct 22 07:22:15 hornet2 kernel: usb 3-2: SerialNumber: EBF1F4DF
Oct 22 07:22:15 hornet2 kernel: wmi: Mapper loaded
Oct 22 07:22:15 hornet2 kernel: EDAC MC: Ver: 3.0.0
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0e.0 PCI I=
D 8086:3ca0
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0e.0 PCI I=
D 8086:3ca0
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0e.0 PCI I=
D 8086:3ca0
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.0 PCI I=
D 8086:3ca8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.0 PCI I=
D 8086:3ca8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.0 PCI I=
D 8086:3ca8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.1 PCI I=
D 8086:3c71
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.1 PCI I=
D 8086:3c71
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.1 PCI I=
D 8086:3c71
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.2 PCI I=
D 8086:3caa
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.2 PCI I=
D 8086:3caa
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.2 PCI I=
D 8086:3caa
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.3 PCI I=
D 8086:3cab
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.3 PCI I=
D 8086:3cab
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.3 PCI I=
D 8086:3cab
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.4 PCI I=
D 8086:3cac
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.4 PCI I=
D 8086:3cac
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.4 PCI I=
D 8086:3cac
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.5 PCI I=
D 8086:3cad
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.5 PCI I=
D 8086:3cad
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0f.5 PCI I=
D 8086:3cad
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 11.0 PCI I=
D 8086:3cb8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 11.0 PCI I=
D 8086:3cb8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 11.0 PCI I=
D 8086:3cb8
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.6 PCI I=
D 8086:3cf4
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.6 PCI I=
D 8086:3cf4
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.6 PCI I=
D 8086:3cf4
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.7 PCI I=
D 8086:3cf6
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.7 PCI I=
D 8086:3cf6
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0c.7 PCI I=
D 8086:3cf6
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0d.6 PCI I=
D 8086:3cf5
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0d.6 PCI I=
D 8086:3cf5
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Seeking for: dev 0d.6 PCI I=
D 8086:3cf5
Oct 22 07:22:15 hornet2 kernel: EDAC MC0: Giving out device to 'sbridge_e=
dac.c' 'Sandy Bridge Socket#0': DEV 0000:3f:0e.0
Oct 22 07:22:15 hornet2 kernel: EDAC MC1: Giving out device to 'sbridge_e=
dac.c' 'Sandy Bridge Socket#1': DEV 0000:7f:0e.0
Oct 22 07:22:15 hornet2 kernel: EDAC sbridge: Driver loaded.
Oct 22 07:22:15 hornet2 kernel: input: PC Speaker as /devices/platform/pc=
spkr/input/input15
Oct 22 07:22:15 hornet2 kernel: microcode: CPU0 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU1 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU2 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU3 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU4 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU5 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU6 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU7 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU8 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU9 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU10 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU11 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU12 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU13 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU14 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU15 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU16 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU17 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU18 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU19 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU20 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU21 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU22 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU23 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: Microcode Update Driver: v2.00=
 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct 22 07:22:15 hornet2 kernel: sd 3:0:0:0: Attached scsi generic sg0 typ=
e 0
Oct 22 07:22:15 hornet2 kernel: sd 4:0:0:0: Attached scsi generic sg1 typ=
e 0
Oct 22 07:22:15 hornet2 kernel: sd 5:0:0:0: Attached scsi generic sg2 typ=
e 0
Oct 22 07:22:15 hornet2 kernel: sr 6:0:0:0: Attached scsi generic sg3 typ=
e 5
Oct 22 07:22:15 hornet2 kernel: microcode: CPU0 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU0 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU1 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU1 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU2 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU2 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU3 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU3 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU4 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU4 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU5 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU5 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU6 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU6 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU7 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU7 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU8 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU8 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU9 sig=3D0x206d7, pf=3D0x1, =
revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU9 updated to revision 0x710=
, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU10 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU10 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU11 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU11 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU12 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU12 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU13 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU13 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU14 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU14 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU15 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU15 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU16 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU16 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU17 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU17 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU18 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU18 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU19 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU19 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU20 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU20 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU21 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU21 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU22 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU22 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: microcode: CPU23 sig=3D0x206d7, pf=3D0x1,=
 revision=3D0x70e
Oct 22 07:22:15 hornet2 kernel: microcode: CPU23 updated to revision 0x71=
0, date =3D 2013-06-17
Oct 22 07:22:15 hornet2 kernel: iTCO_vendor_support: vendor-support=3D0
Oct 22 07:22:15 hornet2 kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver=
 v1.10
Oct 22 07:22:15 hornet2 kernel: iTCO_wdt: unable to reset NO_REBOOT flag,=
 device disabled by hardware/BIOS
Oct 22 07:22:15 hornet2 kernel: usbcore: registered new interface driver =
snd-usb-audio
Oct 22 07:22:15 hornet2 kernel: input: HP WMI hotkeys as /devices/virtual=
/input/input16
Oct 22 07:22:15 hornet2 kernel: tun: Universal TUN/TAP device driver, 1.6=

Oct 22 07:22:15 hornet2 kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@=
qualcomm.com>
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-0): re-mounted. Opts: (null)
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-2): mounted filesystem with o=
rdered data mode. Opts: (null)
Oct 22 07:22:15 hornet2 kernel: EXT4-fs (dm-5): mounted filesystem with o=
rdered data mode. Opts: (null)
Oct 22 07:22:15 hornet2 kernel: Adding 35045372k swap on /dev/mapper/vg_h=
ornet200-lv_swap.  Priority:-1 extents:1 across:35045372k=20
Oct 22 07:22:15 hornet2 kernel: NET: Registered protocol family 10
Oct 22 07:22:15 hornet2 kernel: ip6_tables: (C) 2000-2006 Netfilter Core =
Team
Oct 22 07:22:15 hornet2 kernel: nf_conntrack version 0.5.0 (16384 buckets=
, 65536 max)
Oct 22 07:22:15 hornet2 kernel: ip_tables: (C) 2000-2006 Netfilter Core T=
eam
Oct 22 07:22:15 hornet2 kernel: IPv6: ADDRCONF(NETDEV_UP): eth1: link is =
not ready
Oct 22 07:22:15 hornet2 kernel: e1000e: eth1 NIC Link is Up 1000 Mbps Ful=
l Duplex, Flow Control: Rx/Tx
Oct 22 07:22:15 hornet2 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link=
 becomes ready
Oct 22 07:22:15 hornet2 cpuspeed: Enabling performance cpu frequency scal=
ing governor
Oct 22 07:22:15 hornet2 kdump: kexec: loaded kdump kernel
Oct 22 07:22:15 hornet2 kdump: started up
Oct 22 07:22:16 hornet2 NetworkManager[26394]: <info> NetworkManager (ver=
sion 0.8.1-43.el6) is starting...
Oct 22 07:22:16 hornet2 NetworkManager[26394]: <info> Read config file /e=
tc/NetworkManager/NetworkManager.conf
Oct 22 07:22:16 hornet2 NetworkManager[26394]: <info> trying to start the=
 modem manager...
Oct 22 07:22:16 hornet2 modem-manager: ModemManager (version 0.4.0-3.git2=
0100628.el6) starting...
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Ericsson MBM
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin SimTech
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin MotoC
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Option High-Speed
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Nokia
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Option
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Gobi
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Sierra
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin AnyData
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Novatel
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin ZTE
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Huawei
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Longcheer
Oct 22 07:22:16 hornet2 modem-manager: Loaded plugin Generic
Oct 22 07:22:16 hornet2 modem-manager: (ttyS0) opening serial device...
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Found user 'avahi' (UID 70) =
and group 'avahi' (GID 70).
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Successfully dropped root pr=
ivileges.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: avahi-daemon 0.6.25 starting=
 up.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: WARNING: No NSS support for =
mDNS detected, consider installing nss-mdns!
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Successfully called chroot()=
=2E
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Successfully dropped remaini=
ng capabilities.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Loading service file /servic=
es/ssh.service.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Joining mDNS multicast group=
 on interface eth1.IPv4 with address 192.168.1.123.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: New relevant interface eth1.=
IPv4 for mDNS.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Network interface enumeratio=
n completed.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Registering new address reco=
rd for 2002:18b5:2d58:0:ea39:35ff:fe63:2a93 on eth1.*.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Registering new address reco=
rd for 192.168.1.123 on eth1.IPv4.
Oct 22 07:22:16 hornet2 avahi-daemon[26406]: Registering HINFO record wit=
h values 'X86_64'/'LINUX'.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> monitoring kernel f=
irmware directory '/lib/firmware'.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Bonding/Bridging/VL=
AN support disabled
Oct 22 07:22:17 hornet2 rpc.statd[26424]: Version 1.2.3 starting
Oct 22 07:22:17 hornet2 sm-notify[26425]: Version 1.2.3 starting
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh: Acquired D-Bu=
s service com.redhat.ifcfgrh1
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Loaded plugin ifcfg=
-rh: (c) 2007 - 2008 Red Hat, Inc.  To report bugs please use the Network=
Manager mailing list.
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh: parsing /etc/=
sysconfig/network-scripts/ifcfg-lo ...=20
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh: parsing /etc/=
sysconfig/network-scripts/ifcfg-eth1 ...=20
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh:     read conn=
ection 'System eth1'
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh: parsing /etc/=
sysconfig/network-scripts/ifcfg-eth0 ...=20
Oct 22 07:22:17 hornet2 NetworkManager[26394]:    ifcfg-rh:     read conn=
ection 'System eth0'
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> WiFi enabled by rad=
io killswitch; enabled by state file
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> WWAN enabled by rad=
io killswitch; enabled by state file
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> WiMAX enabled by ra=
dio killswitch; enabled by state file
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Networking is enabl=
ed by state file
Oct 22 07:22:17 hornet2 kernel: 8021q: 802.1Q VLAN Support v1.8
Oct 22 07:22:17 hornet2 kernel: 8021q: adding VLAN 0 to HW filter on devi=
ce eth1
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): carrier is =
OFF
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): new Etherne=
t device (driver: 'e1000e' ifindex: 2)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): exported as=
 /org/freedesktop/NetworkManager/Devices/0
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): now managed=

Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): device stat=
e change: 1 -> 2 (reason 2)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): bringing up=
 device.
Oct 22 07:22:17 hornet2 avahi-daemon[26406]: Server startup complete. Hos=
t name is hornet2.local. Local service cookie is 2505238406.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): preparing d=
evice.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth0): deactivatin=
g device (reason: 2).
Oct 22 07:22:17 hornet2 kernel: IPv6: ADDRCONF(NETDEV_UP): eth0: link is =
not ready
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): carrier is =
ON
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): new Etherne=
t device (driver: 'e1000e' ifindex: 3)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): exported as=
 /org/freedesktop/NetworkManager/Devices/1
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): now managed=

Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): device stat=
e change: 1 -> 2 (reason 41)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): preparing d=
evice.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) s=
tarting connection 'System eth1'
Oct 22 07:22:17 hornet2 NetworkManager[26394]: (nm-device.c:3281):nm_devi=
ce_activate: runtime check failed: (priv->state =3D=3D NM_DEVICE_STATE_DI=
SCONNECTED)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): device stat=
e change: 2 -> 7 (reason 0)
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 3 of 5 (IP Configure Start) scheduled.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> modem-manager is no=
w available
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Trying to start the=
 supplicant...
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 3 of 5 (IP Configure Start) started...
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) B=
eginning DHCPv4 transaction
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> dhclient started wi=
th pid 26462
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) D=
HCPv4 will time out in 45 seconds
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 3 of 5 (IP Configure Start) complete.
Oct 22 07:22:17 hornet2 dhclient[26462]: Internet Systems Consortium DHCP=
 Client 4.1.1-P1
Oct 22 07:22:17 hornet2 dhclient[26462]: Copyright 2004-2010 Internet Sys=
tems Consortium.
Oct 22 07:22:17 hornet2 dhclient[26462]: All rights reserved.
Oct 22 07:22:17 hornet2 dhclient[26462]: For info, please visit https://w=
ww.isc.org/software/dhcp/
Oct 22 07:22:17 hornet2 dhclient[26462]:=20
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> (eth1): DHCPv4 stat=
e changed nbi -> preinit
Oct 22 07:22:17 hornet2 dhclient[26462]: Listening on LPF/eth1/e8:39:35:6=
3:2a:93
Oct 22 07:22:17 hornet2 dhclient[26462]: Sending on   LPF/eth1/e8:39:35:6=
3:2a:93
Oct 22 07:22:17 hornet2 dhclient[26462]: Sending on   Socket/fallback
Oct 22 07:22:17 hornet2 kernel: RPC: Registered named UNIX socket transpo=
rt module.
Oct 22 07:22:17 hornet2 kernel: RPC: Registered udp transport module.
Oct 22 07:22:17 hornet2 kernel: RPC: Registered tcp transport module.
Oct 22 07:22:17 hornet2 kernel: RPC: Registered tcp NFSv4.1 backchannel t=
ransport module.
Oct 22 07:22:17 hornet2 NetworkManager[26394]: <info> wpa_supplicant star=
ted
Oct 22 07:22:18 hornet2 avahi-daemon[26406]: Service "hornet2" (/services=
/ssh.service) successfully established.
Oct 22 07:22:19 hornet2 cpuspeed: Disabling performance cpu frequency sca=
ling governor
Oct 22 07:22:19 hornet2 cpuspeed: Enabling performance cpu frequency scal=
ing governor
Oct 22 07:22:20 hornet2 pcscd: pcscdaemon.c:506:main() pcsc-lite 1.5.2 da=
emon ready.
Oct 22 07:22:21 hornet2 dhclient[26462]: DHCPREQUEST on eth1 to 255.255.2=
55.255 port 67 (xid=3D0x6fa823d3)
Oct 22 07:22:21 hornet2 dhclient[26462]: DHCPACK from 192.168.1.1 (xid=3D=
0x6fa823d3)
Oct 22 07:22:21 hornet2 dhclient[26462]: bound to 192.168.1.123 -- renewa=
l in 36411 seconds.
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> (eth1): DHCPv4 stat=
e changed preinit -> reboot
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 4 of 5 (IP4 Configure Get) scheduled...
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 4 of 5 (IP4 Configure Get) started...
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   address 192.168.1=
=2E123
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   prefix 24 (255.25=
5.255.0)
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   gateway 192.168.1=
=2E1
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   nameserver '192.1=
68.1.1'
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   nameserver '97.81=
=2E22.195'
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info>   nameserver '71.92=
=2E29.130'
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 5 of 5 (IP Configure Commit) scheduled...
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 4 of 5 (IP4 Configure Get) complete.
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 5 of 5 (IP Configure Commit) started...
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> (eth1): device stat=
e change: 7 -> 8 (reason 0)
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Policy set 'System =
eth1' (eth1) as default for IPv4 routing and DNS.
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) s=
uccessful, device activated.
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> Activation (eth1) S=
tage 5 of 5 (IP Configure Commit) complete.
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> (eth0): carrier now=
 ON (device state 2)
Oct 22 07:22:21 hornet2 NetworkManager[26394]: <info> (eth0): device stat=
e change: 2 -> 3 (reason 40)
Oct 22 07:22:21 hornet2 kernel: e1000e: eth0 NIC Link is Up 1000 Mbps Ful=
l Duplex, Flow Control: Rx/Tx
Oct 22 07:22:21 hornet2 kernel: IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link=
 becomes ready
Oct 22 07:22:21 hornet2 automount[26779]: lookup_read_master: lookup(nisp=
lus): couldn't locate nis+ table auto.master
Oct 22 07:22:22 hornet2 avahi-daemon[26406]: Registering new address reco=
rd for fe80::ea39:35ff:fe63:2a94 on eth0.*.
Oct 22 07:22:23 hornet2 abrtd: Init complete, entering main loop
Oct 22 07:22:24 hornet2 qpidd[26949]: 2013-10-22 07:22:24 notice Listenin=
g on TCP/TCP6 port 5672
Oct 22 07:22:24 hornet2 qpidd[26949]: 2013-10-22 07:22:24 notice SSL plug=
in not enabled, you must set --ssl-cert-db to enable it.
Oct 22 07:22:24 hornet2 qpidd[26949]: 2013-10-22 07:22:24 notice Broker r=
unning
Oct 22 07:22:26 hornet2 libvirtd: Could not find keytab file: /etc/libvir=
t/krb5.tab: No such file or directory
Oct 22 07:22:27 hornet2 kernel: Bridge firewalling registered
Oct 22 07:22:27 hornet2 kernel: device virbr0-nic entered promiscuous mod=
e
Oct 22 07:22:27 hornet2 NetworkManager[26394]: <warn> /sys/devices/virtua=
l/net/virbr0-nic: couldn't determine device driver; ignoring...
Oct 22 07:22:27 hornet2 kernel: device virbr0-nic left promiscuous mode
Oct 22 07:22:27 hornet2 kernel: virbr0: port 1(virbr0-nic) entered disabl=
ed state
Oct 22 07:22:27 hornet2 kernel: Ebtables v2.0 registered
Oct 22 07:22:29 hornet2 modem-manager: (ttyS0) closing serial device...
Oct 22 07:22:29 hornet2 modem-manager: (ttyS0) opening serial device...
Oct 22 07:22:35 hornet2 modem-manager: (ttyS0) closing serial device...
Oct 22 07:25:10 hornet2 kernel: perf samples too long (2546 > 2500), lowe=
ring kernel.perf_event_max_sample_rate to 50000
Oct 22 07:39:57 hornet2 kernel: perf samples too long (5023 > 5000), lowe=
ring kernel.perf_event_max_sample_rate to 25000
Oct 22 08:09:39 hornet2 kernel: perf samples too long (10062 > 10000), lo=
wering kernel.perf_event_max_sample_rate to 13000
Oct 22 11:05:10 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:05:10 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:05:10 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:10 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:10 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:05:10 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]  [<fffffff=
f8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:05:10 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000=
217
Oct 22 11:05:10 hornet2 kernel: RAX: 0000000000000000 RBX: ffffffff81117b=
52 RCX: ffff880c073ca6e8
Oct 22 11:05:10 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:05:10 hornet2 kernel: RBP: ffff88070e521cc8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:05:10 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: 0000000000000d0f
Oct 22 11:05:10 hornet2 kernel: R13: ffff88070e521ce8 R14: 00000000000000=
30 R15: ffff88070e520000
Oct 22 11:05:10 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:05:10 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:10 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:05:10 hornet2 kernel: Stack:
Oct 22 11:05:10 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9 ffff880=
c0f5c9020 0000000000000000
Oct 22 11:05:10 hornet2 kernel: ffff88070e521da8 ffffffff810c4896 0000000=
000000030 ffff88070e521d28
Oct 22 11:05:10 hornet2 kernel: 000000005266940e 0000000000000000 ffff880=
70c264000 ffff880600000001
Oct 22 11:05:10 hornet2 kernel: Call Trace:
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c0ee9>] task_cgroup_from_roo=
t+0x29/0xa0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:05:10 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:05:10 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:05:10 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:05:10 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:05:10 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9 c3=
 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 =
66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84 00 00=
 00 00 00 55=20
Oct 22 11:05:11 hornet2 abrtd: Directory 'oops-2013-10-22-11:05:11-26911-=
1' creation detected
Oct 22 11:05:11 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:05:12 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:05:11-26911-1/uid': No such file or directory
Oct 22 11:05:37 hornet2 kernel: nr_pdflush_threads exported in /proc is s=
cheduled for removal
Oct 22 11:05:37 hornet2 kernel: sysctl: The scan_unevictable_pages sysctl=
/node-interface has been disabled for lack of a legitimate use case.  If =
you have one, please send an email to linux-mm@kvack.org.
Oct 22 11:05:38 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:05:38 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:05:38 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:38 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:38 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:05:38 hornet2 kernel: RIP: 0010:[<ffffffff810c0f28>]  [<fffffff=
f810c0f28>] task_cgroup_from_root+0x68/0xa0
Oct 22 11:05:38 hornet2 kernel: RSP: 0018:ffff88070e521cd8  EFLAGS: 00000=
287
Oct 22 11:05:38 hornet2 kernel: RAX: ffff880c12a1f060 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:05:38 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:05:38 hornet2 kernel: RBP: ffff88070e521ce8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:05:38 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: ffffffff81117b52
Oct 22 11:05:38 hornet2 kernel: R13: ffff88070e521cc8 R14: 0000000000000d=
0f R15: ffff88070e521ce8
Oct 22 11:05:38 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:05:38 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:38 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:05:38 hornet2 kernel: Stack:
Oct 22 11:05:38 hornet2 kernel: ffff8806f97ee8d0 0000000000000000 ffff880=
70e521da8 ffffffff810c4896
Oct 22 11:05:38 hornet2 kernel: 0000000000000030 ffff88070e521d28 0000000=
05266940e 0000000000000000
Oct 22 11:05:38 hornet2 kernel: ffff88070c264000 ffff880600000001 0000000=
000000000 0000000000000000
Oct 22 11:05:38 hornet2 kernel: Call Trace:
Oct 22 11:05:38 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:05:38 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:05:38 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:05:38 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:05:38 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:05:38 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:05:38 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:05:38 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:05:38 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:05:38 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:05:38 hornet2 kernel: Code: 12 f0 ff 05 c3 5d 98 00 48 85 c0 74=
 3c 5b 41 5c c9 c3 90 48 8b 41 28 48 83 c1 28 48 8d 50 e0 48 39 c1 74 21 =
0f 1f 80 00 00 00 00 <48> 8b 40 e0 4c 39 a0 a8 00 00 00 74 c9 48 8b 42 20=
 48 8d 50 e0=20
Oct 22 11:05:38 hornet2 abrtd: Directory 'oops-2013-10-22-11:05:38-26911-=
1' creation detected
Oct 22 11:05:38 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:05:46 hornet2 kernel: INFO: rcu_sched self-detected stall on CP=
U { 8}  (t=3D60001 jiffies g=3D163763 c=3D163762 q=3D126471)
Oct 22 11:05:46 hornet2 kernel: INFO: rcu_sched detected stalls on CPUs/t=
asks: { 8} (detected by 13, t=3D60002 jiffies, g=3D163763, c=3D163762, q=3D=
126471)
Oct 22 11:05:46 hornet2 kernel: sending NMI to all CPUs:
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 0
Oct 22 11:05:46 hornet2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffffffff81a10480 ti: ffffffff81a000=
00 task.ti: ffffffff81a00000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffffffff81a01df8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffffffff81a00010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffffffff81a01e38 R08: 00000000000020=
00 R09: 00000000000196c9
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8fae3c00730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40aaa75e18 R14: 00000000000000=
00 R15: ffffffff81a00010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c00000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 000000070d29e0=
00 CR4: 00000000000407f0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713c12d00 0000000000000202 fffffff=
f81a01e38 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffffffff81a01e88 ffffe8fae3c00730 fffffff=
f81a78a40 00000c40aaa75ddb
Oct 22 11:05:46 hornet2 kernel: ffffffff81a01e88 ffffffff814385c3 fffffff=
f81a01e78 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81537827>] rest_init+0x77/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81ae0019>] start_kernel+0x3d8/0=
x3e5
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81adfa6f>] ? repair_env_string+=
0x5b/0x5b
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81adf59d>] x86_64_start_reserva=
tions+0x2a/0x2c
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81adf6d8>] x86_64_start_kernel+=
0x139/0x140
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 1
Oct 22 11:05:46 hornet2 kernel: CPU: 1 PID: 0 Comm: swapper/1 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071055d8b0 ti: ffff88071058a0=
00 task.ti: ffff88071058a000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff88071058bdd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff88071058a010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff88071058be18 R08: 00000000000020=
00 R09: 00000000002a9e1b
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c20730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40a012cd4a R14: 00000000000000=
00 R15: ffff88071058a010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c20000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 0000003526275010 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713c32d00 0000000000000202 ffff880=
71058be18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff88071058be68 ffffe8fae3c20730 fffffff=
f81a78a40 00000c40a012cd1a
Oct 22 11:05:46 hornet2 kernel: ffff88071058be68 ffffffff814385c3 ffff880=
71058be58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 2
Oct 22 11:05:46 hornet2 kernel: CPU: 2 PID: 0 Comm: swapper/2 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071055e0c0 ti: ffff88071058c0=
00 task.ti: ffff88071058c000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff88071058ddd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff88071058c010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff88071058de18 R08: 00000000000020=
00 R09: 000000000020f128
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c40730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409fd5aca8 R14: 00000000000000=
00 R15: ffff88071058c010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c40000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713c52d00 0000000000000202 ffff880=
71058de18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff88071058de68 ffffe8fae3c40730 fffffff=
f81a78a40 00000c409fd5ac83
Oct 22 11:05:46 hornet2 kernel: ffff88071058de68 ffffffff814385c3 ffff880=
71058de58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 3
Oct 22 11:05:46 hornet2 kernel: CPU: 3 PID: 0 Comm: swapper/3 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071055e8d0 ti: ffff88071058e0=
00 task.ti: ffff88071058e000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff88071058fdd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff88071058e010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff88071058fe18 R08: 00000000000020=
00 R09: 00000000000f4962
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c60730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40aaebc1bc R14: 00000000000000=
00 R15: ffff88071058e010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c60000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000000006dc1e4 CR3: 0000000c0f4990=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713c72d00 0000000000000202 ffff880=
71058fe18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff88071058fe68 ffffe8fae3c60730 fffffff=
f81a78a40 00000c40aaebc199
Oct 22 11:05:46 hornet2 kernel: ffff88071058fe68 ffffffff814385c3 ffff880=
71058fe58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 4
Oct 22 11:05:46 hornet2 kernel: CPU: 4 PID: 0 Comm: swapper/4 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071055f0e0 ti: ffff8807105900=
00 task.ti: ffff880710590000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880710591dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff880710590010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880710591e18 R08: 00000000000020=
00 R09: 00000000002907ca
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c80730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409f7a19c6 R14: 00000000000000=
00 R15: ffff880710590010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c80000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713c92d00 0000000000000202 ffff880=
710591e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff880710591e68 ffffe8fae3c80730 fffffff=
f81a78a40 00000c409f7a1996
Oct 22 11:05:46 hornet2 kernel: ffff880710591e68 ffffffff814385c3 ffff880=
710591e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 5
Oct 22 11:05:46 hornet2 kernel: CPU: 5 PID: 0 Comm: swapper/5 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff880710598000 ti: ffff8807105920=
00 task.ti: ffff880710592000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880710593dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff880710592010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880710593e18 R08: 00000000000020=
00 R09: 00000000002e98e0
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8fae3ca0730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40aaa75815 R14: 00000000000000=
00 R15: ffff880710592010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 0000000001bdbfe8 CR3: 00000006fa5710=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713cb2d00 0000000000000202 ffff880=
710593e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff880710593e68 ffffe8fae3ca0730 fffffff=
f81a78a40 00000c40aaa757de
Oct 22 11:05:46 hornet2 kernel: ffff880710593e68 ffffffff814385c3 ffff880=
710593e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 6
Oct 22 11:05:46 hornet2 kernel: CPU: 6 PID: 0 Comm: swapper/6 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff880710598810 ti: ffff8807105940=
00 task.ti: ffff880710594000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880710595dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff880710594010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880710595e18 R08: 00000000000020=
00 R09: 0000000000008113
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc00730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409f1edec4 R14: 00000000000000=
00 R15: ffff880710594010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c00000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fc12d00 0000000000000202 ffff880=
710595e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff880710595e68 ffffe8ffffc00730 fffffff=
f81a78a40 00000c409f1ede8f
Oct 22 11:05:46 hornet2 kernel: ffff880710595e68 ffffffff814385c3 ffff880=
710595e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 7
Oct 22 11:05:46 hornet2 kernel: CPU: 7 PID: 0 Comm: swapper/7 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff880710599020 ti: ffff8807105960=
00 task.ti: ffff880710596000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880710597dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff880710596010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880710597e18 R08: 00000000000020=
00 R09: 000000000023992e
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: ffff880710597d=
b8 R12: ffffe8ffffc20730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c403581fd5c R14: 00000000000000=
00 R15: ffff880710596010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c20000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00007f3a8e600000 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880710597de8 ffffffff81071228 ffff880=
710597e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff880710597e68 ffffe8ffffc20730 fffffff=
f81a78a40 00000c403581fd24
Oct 22 11:05:46 hornet2 kernel: ffff880710597e68 ffffffff814385c3 ffff880=
710597e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81071228>] ? hrtimer_start+0x18=
/0x20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 8
Oct 22 11:05:46 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff812cbe2b>]  [<fffffff=
f812cbe2b>] cfb_imageblit+0x4ab/0x4e0
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880c2fc43858  EFLAGS: 00000=
046
Oct 22 11:05:46 hornet2 kernel: RAX: ffffc9001a5637bc RBX: ffff880c153b9c=
e0 RCX: 0000000000000000
Oct 22 11:05:46 hornet2 kernel: RDX: 0000000000000000 RSI: 00000000000000=
01 RDI: 0000000000000000
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880c2fc438d8 R08: 0000000000aaaa=
aa R09: 0000000000000001
Oct 22 11:05:46 hornet2 kernel: R10: ffffffff8163ff20 R11: ffffc9001a5638=
a0 R12: 000000000000000a
Oct 22 11:05:46 hornet2 kernel: R13: 0000000000001e00 R14: ffff880c153b9c=
dc R15: 000000000000000c
Oct 22 11:05:46 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffffffff00000020 ffff880c2fc438b8 ffffc90=
01adaac80 00000000810bb132
Oct 22 11:05:46 hornet2 kernel: ffff880c2fc43998 ffff880713810400 ffff880=
c153b91a8 0000000000000009
Oct 22 11:05:46 hornet2 kernel: ffffc9001a563720 00000000153d8b7a ffff880=
c2fc439e8 ffff880713810400
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: <IRQ>=20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c56e8>] bit_putcs+0x398/0x57=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c5a81>] ? soft_cursor+0x1c1/=
0x270
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c52eb>] ? bit_cursor+0x5eb/0=
x650
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812becf6>] fbcon_putcs+0x116/0x=
150
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c5350>] ? bit_cursor+0x650/0=
x650
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c14dc>] fbcon_redraw+0x16c/0=
x1e0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812c17b6>] fbcon_scroll+0x266/0=
xe30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8132c473>] scrup+0x113/0x120
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8132c700>] lf+0x70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8132ecf5>] vt_console_print+0x2=
05/0x390
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109b095>] call_console_drivers=
=2Eclone.2+0xa5/0x100
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109b4a6>] console_unlock+0x236=
/0x280
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109ba75>] vprintk_emit+0x315/0=
x500
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8153e645>] printk+0x4d/0x4f
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810dd0ee>] print_cpu_stall+0xce=
/0x140
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810dd406>] __rcu_pending+0x76/0=
x1d0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810de11d>] rcu_check_callbacks+=
0xed/0x1a0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81056c48>] update_process_times=
+0x48/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adcd9>] tick_sched_handle+0x=
39/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adef4>] tick_sched_timer+0x5=
4/0x90
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810705bd>] __run_hrtimer+0x7d/0=
x1c0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adea0>] ? tick_nohz_handler+=
0xc0/0xc0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810709a6>] hrtimer_interrupt+0x=
106/0x250
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81032c6b>] local_apic_timer_int=
errupt+0x3b/0x60
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8154ce35>] smp_apic_timer_inter=
rupt+0x45/0x5a
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8154bb4a>] apic_timer_interrupt=
+0x6a/0x70
Oct 22 11:05:46 hornet2 kernel: <EOI>=20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c0f0e>] ? task_cgroup_from_r=
oot+0x4e/0xa0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c4896>] ? cgroup_attach_task=
+0xe6/0x3b0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:05:46 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:05:46 hornet2 kernel: Code: 01 00 00 4c 8d 1c 81 48 8b 45 c0 4c=
 89 f3 b9 08 00 00 00 eb 25 0f 1f 00 44 29 c9 0f be 13 d3 fa 21 f2 41 8b =
14 92 44 21 c2 31 fa <89> 10 85 c9 75 05 48 ff c3 b1 08 48 83 c0 04 49 39=
 c3 75 d9 4d=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 9
Oct 22 11:05:46 hornet2 kernel: CPU: 9 PID: 0 Comm: swapper/9 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059a040 ti: ffff8807105a20=
00 task.ti: ffff8807105a2000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105a3dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105a2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105a3e18 R08: 00000000000020=
00 R09: 000000000012accd
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc60730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409ea49fe6 R14: 00000000000000=
00 R15: ffff8807105a2010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c60000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000000006d4460 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fc72d00 0000000000000202 ffff880=
7105a3e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105a3e68 ffffe8ffffc60730 fffffff=
f81a78a40 00000c409ea49fac
Oct 22 11:05:46 hornet2 kernel: ffff8807105a3e68 ffffffff814385c3 ffff880=
7105a3e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 10
Oct 22 11:05:46 hornet2 kernel: CPU: 10 PID: 0 Comm: swapper/10 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059a850 ti: ffff8807105a40=
00 task.ti: ffff8807105a4000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105a5dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105a4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105a5e18 R08: 00000000000020=
00 R09: 00000000002ae072
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc80730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409e677324 R14: 00000000000000=
00 R15: ffff8807105a4010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c80000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000c16a4b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fc92d00 0000000000000202 ffff880=
7105a5e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105a5e68 ffffe8ffffc80730 fffffff=
f81a78a40 00000c409e6772ee
Oct 22 11:05:46 hornet2 kernel: ffff8807105a5e68 ffffffff814385c3 ffff880=
7105a5e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 11
Oct 22 11:05:46 hornet2 kernel: CPU: 11 PID: 0 Comm: swapper/11 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059b060 ti: ffff8807105a60=
00 task.ti: ffff8807105a6000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105a7dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105a6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105a7e18 R08: 00000000000020=
00 R09: 00000000002afbaf
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffca0730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409e2a6424 R14: 00000000000000=
00 R15: ffff8807105a6010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fcb2d00 0000000000000202 ffff880=
7105a7e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105a7e68 ffffe8ffffca0730 fffffff=
f81a78a40 00000c409e2a63f1
Oct 22 11:05:46 hornet2 kernel: ffff8807105a7e68 ffffffff814385c3 ffff880=
7105a7e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 12
Oct 22 11:05:46 hornet2 kernel: CPU: 12 PID: 0 Comm: swapper/12 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059b870 ti: ffff8807105a80=
00 task.ti: ffff8807105a8000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105a9dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105a8010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105a9e18 R08: 00000000000020=
00 R09: 00000000003d0897
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3cc0730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409e0bdb1d R14: 00000000000000=
00 R15: ffff8807105a8010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 0000003526355283 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713cd2d00 0000000000000202 ffff880=
7105a9e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105a9e68 ffffe8fae3cc0730 fffffff=
f81a78a40 00000c409e0bdaea
Oct 22 11:05:46 hornet2 kernel: ffff8807105a9e68 ffffffff814385c3 ffff880=
7105a9e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 13
Oct 22 11:05:46 hornet2 kernel: CPU: 13 PID: 0 Comm: swapper/13 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059c080 ti: ffff8807105aa0=
00 task.ti: ffff8807105aa000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff812702fa>]  [<fffffff=
f812702fa>] delay_tsc+0x2a/0x60
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff880713ce3ca8  EFLAGS: 00000=
083
Oct 22 11:05:46 hornet2 kernel: RAX: 000000001df9904a RBX: 00000000000000=
00 RCX: 000000000000000d
Oct 22 11:05:46 hornet2 kernel: RDX: 000000000000001b RSI: 000000001df990=
2f RDI: 0000000000030b66
Oct 22 11:05:46 hornet2 kernel: RBP: ffff880713ce3ca8 R08: 00000000000000=
0d R09: 0000000000000000
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000800=
00 R12: 0000000000001000
Oct 22 11:05:46 hornet2 kernel: R13: ffffffff81ac1048 R14: 00000000000004=
00 R15: 0000000000000096
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00007f12cce350a0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713ce3cb8 ffffffff812702c8 ffff880=
713ce3cd8 ffffffff810334b2
Oct 22 11:05:46 hornet2 kernel: 0000000000000002 000000000000b024 ffff880=
713ce3d28 ffffffff81033ee0
Oct 22 11:05:46 hornet2 kernel: ffffffff00000005 000000000000000e ffff880=
713ce3d08 0000000000000000
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: <IRQ>=20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff812702c8>] __const_udelay+0x28/=
0x30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810334b2>] native_safe_apic_wai=
t_icr_idle+0x22/0x60
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81033ee0>] default_send_IPI_mas=
k_sequence_phys+0xc0/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810372d7>] physflat_send_IPI_al=
l+0x17/0x20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81033f67>] arch_trigger_all_cpu=
_backtrace+0x57/0x90
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810dd350>] print_other_cpu_stal=
l+0x1f0/0x230
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810dd504>] __rcu_pending+0x174/=
0x1d0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810de11d>] rcu_check_callbacks+=
0xed/0x1a0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81056c48>] update_process_times=
+0x48/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adcd9>] tick_sched_handle+0x=
39/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adef4>] tick_sched_timer+0x5=
4/0x90
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810705bd>] __run_hrtimer+0x7d/0=
x1c0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810adea0>] ? tick_nohz_handler+=
0xc0/0xc0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810709a6>] hrtimer_interrupt+0x=
106/0x250
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81032c6b>] local_apic_timer_int=
errupt+0x3b/0x60
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8154ce35>] smp_apic_timer_inter=
rupt+0x45/0x5a
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8154bb4a>] apic_timer_interrupt=
+0x6a/0x70
Oct 22 11:05:46 hornet2 kernel: <EOI>=20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81438532>] ? poll_idle+0x42/0x9=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8143850c>] ? poll_idle+0x1c/0x9=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: 00 55 48 89 e5 66 66 66 66 90 65 44=
 8b 04 25 20 b0 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 =
8b 0c 25 20 b0 00 00 <44> 39 c1 75 12 0f 1f 00 0f ae e8 0f 31 89 c2 29 f2=
 39 fa 72 e1=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 14
Oct 22 11:05:46 hornet2 kernel: CPU: 14 PID: 0 Comm: swapper/14 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059c890 ti: ffff8807105ac0=
00 task.ti: ffff8807105ac000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105addd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105ac010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105ade18 R08: 00000000000020=
00 R09: 00000000002bbf2c
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000003=
c1 R12: ffffe8fae3d00730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40a056a2e4 R14: 00000000000000=
00 R15: ffff8807105ac010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d00000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 0000000000e0af68 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713d12d00 0000000000000202 ffff880=
7105ade18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105ade68 ffffe8fae3d00730 fffffff=
f81a78a40 00000c40a056a2b0
Oct 22 11:05:46 hornet2 kernel: ffff8807105ade68 ffffffff814385c3 ffff880=
7105ade58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 15
Oct 22 11:05:46 hornet2 kernel: CPU: 15 PID: 0 Comm: swapper/15 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059d0a0 ti: ffff8807105ae0=
00 task.ti: ffff8807105ae000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105afdd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105ae010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105afe18 R08: 00000000000020=
00 R09: 00000000002bea24
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d20730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c40a063f6d7 R14: 00000000000000=
00 R15: ffff8807105ae010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d20000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713d32d00 0000000000000202 ffff880=
7105afe18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105afe68 ffffe8fae3d20730 fffffff=
f81a78a40 00000c40a063f691
Oct 22 11:05:46 hornet2 kernel: ffff8807105afe68 ffffffff814385c3 ffff880=
7105afe58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 16
Oct 22 11:05:46 hornet2 kernel: CPU: 16 PID: 0 Comm: swapper/16 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059d8b0 ti: ffff8807105b00=
00 task.ti: ffff8807105b0000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105b1dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105b0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105b1e18 R08: 00000000000020=
00 R09: 000000000030ef42
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d40730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409d54d911 R14: 00000000000000=
00 R15: ffff8807105b0010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d40000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 0000003526279220 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713d52d00 0000000000000202 ffff880=
7105b1e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105b1e68 ffffe8fae3d40730 fffffff=
f81a78a40 00000c409d54d8dc
Oct 22 11:05:46 hornet2 kernel: ffff8807105b1e68 ffffffff814385c3 ffff880=
7105b1e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 17
Oct 22 11:05:46 hornet2 kernel: CPU: 17 PID: 0 Comm: swapper/17 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059e0c0 ti: ffff8807105b20=
00 task.ti: ffff8807105b2000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105b3dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105b2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105b3e18 R08: 00000000000020=
00 R09: 000000000031b5c0
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d60730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409d36656b R14: 00000000000000=
00 R15: ffff8807105b2010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d60000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00000035262acba0 CR3: 0000000c095bf0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880713d72d00 0000000000000202 ffff880=
7105b3e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105b3e68 ffffe8fae3d60730 fffffff=
f81a78a40 00000c409d366525
Oct 22 11:05:46 hornet2 kernel: ffff8807105b3e68 ffffffff814385c3 ffff880=
7105b3e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 18
Oct 22 11:05:46 hornet2 kernel: CPU: 18 PID: 0 Comm: swapper/18 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059e8d0 ti: ffff8807105b40=
00 task.ti: ffff8807105b4000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105b5dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105b4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105b5e18 R08: 00000000000020=
00 R09: 000000000031e4aa
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffcc0730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409cf93420 R14: 00000000000000=
00 R15: ffff8807105b4010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fcd2d00 0000000000000202 ffff880=
7105b5e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105b5e68 ffffe8ffffcc0730 fffffff=
f81a78a40 00000c409cf933e9
Oct 22 11:05:46 hornet2 kernel: ffff8807105b5e68 ffffffff814385c3 ffff880=
7105b5e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 19
Oct 22 11:05:46 hornet2 kernel: CPU: 19 PID: 0 Comm: swapper/19 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff88071059f0e0 ti: ffff8807105b60=
00 task.ti: ffff8807105b6000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105b7dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105b6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105b7e18 R08: 00000000000020=
00 R09: 0000000000001d60
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffce0730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409cbc5af1 R14: 00000000000000=
00 R15: ffff8807105b6010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 00000006fcf5e0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fcf2d00 0000000000000202 ffff880=
7105b7e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105b7e68 ffffe8ffffce0730 fffffff=
f81a78a40 00000c409cbc5ac0
Oct 22 11:05:46 hornet2 kernel: ffff8807105b7e68 ffffffff814385c3 ffff880=
7105b7e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 20
Oct 22 11:05:46 hornet2 kernel: CPU: 20 PID: 0 Comm: swapper/20 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff8807105b8000 ti: ffff8807105c00=
00 task.ti: ffff8807105c0000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0000:ffff8807105c1dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105c0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105c1e18 R08: 00000000000020=
00 R09: 00000000002cf3c8
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000e7e=
f0 R12: ffffe8ffffd00730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c3fdb74ca19 R14: 00000000000000=
00 R15: ffff8807105c0010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d00000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00007f3aaa6b0000 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff8807105c1de8 ffffffff81071228 ffff880=
7105c1e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105c1e68 ffffe8ffffd00730 fffffff=
f81a78a40 00000c3fdb74c9fb
Oct 22 11:05:46 hornet2 kernel: ffff8807105c1e68 ffffffff814385c3 ffff880=
7105c1e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81071228>] ? hrtimer_start+0x18=
/0x20
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 21
Oct 22 11:05:46 hornet2 kernel: CPU: 21 PID: 0 Comm: swapper/21 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff8807105b8810 ti: ffff8807105c20=
00 task.ti: ffff8807105c2000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438530>]  [<fffffff=
f81438530>] poll_idle+0x40/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105c3dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105c2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105c3e18 R08: 00000000000020=
00 R09: 0000000000327148
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd20730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409c7f209d R14: 00000000000000=
00 R15: ffff8807105c2010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d20000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: 00007f3aa895f000 CR3: 000000070686a0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fd32d00 0000000000000202 ffff880=
7105c3e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105c3e68 ffffe8ffffd20730 fffffff=
f81a78a40 00000c409c7f2066
Oct 22 11:05:46 hornet2 kernel: ffff8807105c3e68 ffffffff814385c3 ffff880=
7105c3e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: 89 d3 e8 c4 d8 c6 ff 49 89 c5 fb 65=
 48 8b 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f =
00 00 0f 1f 44 00 00 <f3> 90 48 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8=
 48 89 c7 e8=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 22
Oct 22 11:05:46 hornet2 kernel: CPU: 22 PID: 0 Comm: swapper/22 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff8807105b9020 ti: ffff8807105c40=
00 task.ti: ffff8807105c4000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105c5dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105c4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105c5e18 R08: 00000000000020=
00 R09: 00000000003275c3
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd40730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409c421d91 R14: 00000000000000=
00 R15: ffff8807105c4010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d40000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fd52d00 0000000000000202 ffff880=
7105c5e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105c5e68 ffffe8ffffd40730 fffffff=
f81a78a40 00000c409c421d60
Oct 22 11:05:46 hornet2 kernel: ffff8807105c5e68 ffffffff814385c3 ffff880=
7105c5e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:46 hornet2 kernel: NMI backtrace for cpu 23
Oct 22 11:05:46 hornet2 kernel: CPU: 23 PID: 0 Comm: swapper/23 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:05:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:05:46 hornet2 kernel: task: ffff8807105b9830 ti: ffff8807105c60=
00 task.ti: ffff8807105c6000
Oct 22 11:05:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:05:46 hornet2 kernel: RSP: 0018:ffff8807105c7dd8  EFLAGS: 00000=
246
Oct 22 11:05:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:05:46 hornet2 kernel: RDX: ffff8807105c6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:05:46 hornet2 kernel: RBP: ffff8807105c7e18 R08: 00000000000020=
00 R09: 000000000032cf07
Oct 22 11:05:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd60730
Oct 22 11:05:46 hornet2 kernel: R13: 00000c409c0515d0 R14: 00000000000000=
00 R15: ffff8807105c6010
Oct 22 11:05:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d60000(0000) knlGS:0000000000000000
Oct 22 11:05:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:05:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000706d1e0=
00 CR4: 00000000000407e0
Oct 22 11:05:46 hornet2 kernel: Stack:
Oct 22 11:05:46 hornet2 kernel: ffff880c2fd72d00 0000000000000202 ffff880=
7105c7e18 ffffffff810a5e24
Oct 22 11:05:46 hornet2 kernel: ffff8807105c7e68 ffffe8ffffd60730 fffffff=
f81a78a40 00000c409c05159c
Oct 22 11:05:46 hornet2 kernel: ffff8807105c7e68 ffffffff814385c3 ffff880=
7105c7e58 ffffffffffffffff
Oct 22 11:05:46 hornet2 kernel: Call Trace:
Oct 22 11:05:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:05:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:05:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:05:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:05:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:05:49 hornet2 abrtd: Sending an email...
Oct 22 11:05:49 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:05:49 hornet2 abrtd: Duplicate: UUID
Oct 22 11:05:49 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:05:49 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:05:11-26911-1', deleting
Oct 22 11:05:49 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:05:38-26911-1/uid': No such file or directory
Oct 22 11:06:07 hornet2 abrtd: Sending an email...
Oct 22 11:06:07 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:06:07 hornet2 abrtd: Duplicate: UUID
Oct 22 11:06:07 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:06:07 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:05:38-26911-1', deleting
Oct 22 11:06:10 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:06:10 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:06:10 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:06:10 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:06:10 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:06:10 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]  [<fffffff=
f8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:06:10 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000=
217
Oct 22 11:06:10 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:06:10 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:06:10 hornet2 kernel: RBP: ffff88070e521cc8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:06:10 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: 0000000000000d0f
Oct 22 11:06:10 hornet2 kernel: R13: ffff88070e521cb8 R14: 00000000000000=
30 R15: ffff88070e520000
Oct 22 11:06:10 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:06:10 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:06:10 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:06:10 hornet2 kernel: Stack:
Oct 22 11:06:10 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9 ffff880=
c0f5cc890 0000000000000000
Oct 22 11:06:10 hornet2 kernel: ffff88070e521da8 ffffffff810c4896 0000000=
000000030 ffff88070e521d28
Oct 22 11:06:10 hornet2 kernel: 000000005266940e 0000000000000000 ffff880=
70c264000 ffff880600000001
Oct 22 11:06:10 hornet2 kernel: Call Trace:
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c0ee9>] task_cgroup_from_roo=
t+0x29/0xa0
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:06:10 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:06:10 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:06:10 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:06:10 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:06:10 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:06:10 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:06:10 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9 c3=
 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 =
66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84 00 00=
 00 00 00 55=20
Oct 22 11:06:12 hornet2 abrtd: Directory 'oops-2013-10-22-11:06:12-26911-=
1' creation detected
Oct 22 11:06:12 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:06:12 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:06:12-26911-1/uid': No such file or directory
Oct 22 11:06:30 hornet2 abrtd: Sending an email...
Oct 22 11:06:31 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:06:31 hornet2 abrtd: Duplicate: UUID
Oct 22 11:06:31 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:06:31 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:06:12-26911-1', deleting
Oct 22 11:06:38 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:06:38 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:06:38 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:06:38 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:06:38 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:06:38 hornet2 kernel: RIP: 0010:[<ffffffff810c0f05>]  [<fffffff=
f810c0f05>] task_cgroup_from_root+0x45/0xa0
Oct 22 11:06:38 hornet2 kernel: RSP: 0018:ffff88070e521cd8  EFLAGS: 00000=
216
Oct 22 11:06:38 hornet2 kernel: RAX: ffff880c0e45f200 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:06:38 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:06:38 hornet2 kernel: RBP: ffff88070e521ce8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:06:38 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: f4f0000000000000
Oct 22 11:06:38 hornet2 kernel: R13: ffff88070e521cc8 R14: 0000000000000d=
0f R15: ffff88070e521cb8
Oct 22 11:06:38 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:06:38 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:06:38 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:06:38 hornet2 kernel: Stack:
Oct 22 11:06:38 hornet2 kernel: ffff880c0f5cd0a0 0000000000000000 ffff880=
70e521da8 ffffffff810c4896
Oct 22 11:06:38 hornet2 kernel: 0000000000000030 ffff88070e521d28 0000000=
05266940e 0000000000000000
Oct 22 11:06:38 hornet2 kernel: ffff88070c264000 ffff880600000001 0000000=
000000000 0000000000000000
Oct 22 11:06:38 hornet2 kernel: Call Trace:
Oct 22 11:06:38 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:06:38 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:06:38 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:06:38 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:06:38 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:06:38 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:06:38 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:06:38 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:06:38 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:06:38 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:06:38 hornet2 kernel: Code: 01 74 6d 48 c7 c7 c8 6c a4 81 e8 77=
 16 48 00 48 8b 8b d8 06 00 00 49 8d 44 24 28 48 81 f9 e0 18 cc 81 75 12 =
f0 ff 05 c3 5d 98 00 <48> 85 c0 74 3c 5b 41 5c c9 c3 90 48 8b 41 28 48 83=
 c1 28 48 8d=20
Oct 22 11:06:39 hornet2 abrtd: Directory 'oops-2013-10-22-11:06:39-26911-=
1' creation detected
Oct 22 11:06:39 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:06:40 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:06:39-26911-1/uid': No such file or directory
Oct 22 11:07:00 hornet2 abrtd: Sending an email...
Oct 22 11:07:00 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:07:00 hornet2 abrtd: Duplicate: UUID
Oct 22 11:07:00 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:07:00 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:06:39-26911-1', deleting
Oct 22 11:07:06 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:07:06 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:07:06 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:07:06 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:07:06 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:07:06 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]  [<fffffff=
f8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:07:06 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000=
217
Oct 22 11:07:06 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:07:06 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:07:06 hornet2 kernel: RBP: ffff88070e521cc8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:07:06 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: 0000000000000d0f
Oct 22 11:07:06 hornet2 kernel: R13: ffff88070e521cb8 R14: 00000000000000=
30 R15: ffff88070e520000
Oct 22 11:07:06 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:07:06 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:07:06 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:07:06 hornet2 kernel: Stack:
Oct 22 11:07:06 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9 ffff880=
c0f5c9830 0000000000000000
Oct 22 11:07:06 hornet2 kernel: ffff88070e521da8 ffffffff810c4896 0000000=
000000030 ffff88070e521d28
Oct 22 11:07:06 hornet2 kernel: 000000005266940e 0000000000000000 ffff880=
70c264000 ffff880600000001
Oct 22 11:07:06 hornet2 kernel: Call Trace:
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c0ee9>] task_cgroup_from_roo=
t+0x29/0xa0
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:07:06 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:07:06 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:07:06 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:07:06 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:07:06 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:07:06 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:06 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9 c3=
 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 =
66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84 00 00=
 00 00 00 55=20
Oct 22 11:07:07 hornet2 abrtd: Directory 'oops-2013-10-22-11:07:07-26911-=
1' creation detected
Oct 22 11:07:07 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:07:08 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:07:07-26911-1/uid': No such file or directory
Oct 22 11:07:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31705 blocked =
for more than 120 seconds.
Oct 22 11:07:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:07:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:07:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31705  31688 0x00000080
Oct 22 11:07:15 hornet2 kernel: ffff880c0812be10 0000000000000082 ffff880=
c0812bfd8 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0812a010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0812bfd8 0000000000012d00 ffff880=
71055f0e0 ffff880c0f5cc890
Oct 22 11:07:15 hornet2 kernel: Call Trace:
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:07:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31706 blocked =
for more than 120 seconds.
Oct 22 11:07:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:07:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:07:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31706  31688 0x00000080
Oct 22 11:07:15 hornet2 kernel: ffff880c0e46fe10 0000000000000082 ffff880=
c0e46ffd8 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0e46e010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0e46ffd8 0000000000012d00 ffff880=
71055e0c0 ffff880c0f5c9020
Oct 22 11:07:15 hornet2 kernel: Call Trace:
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:07:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31707 blocked =
for more than 120 seconds.
Oct 22 11:07:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:07:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:07:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31707  31688 0x00000080
Oct 22 11:07:15 hornet2 kernel: ffff880c0ec01e10 0000000000000082 ffff880=
c0ec01fd8 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0ec00010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0ec01fd8 0000000000012d00 ffff880=
71055d8b0 ffff880c0f5ce0c0
Oct 22 11:07:15 hornet2 kernel: Call Trace:
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:07:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31708 blocked =
for more than 120 seconds.
Oct 22 11:07:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:07:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:07:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31708  31688 0x00000080
Oct 22 11:07:15 hornet2 kernel: ffff880c166dfe10 0000000000000082 ffff880=
c166dffd8 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c166de010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c166dffd8 0000000000012d00 ffff880=
71055e8d0 ffff880c0f5cd0a0
Oct 22 11:07:15 hornet2 kernel: Call Trace:
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:07:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31709 blocked =
for more than 120 seconds.
Oct 22 11:07:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:07:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:07:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31709  31688 0x00000080
Oct 22 11:07:15 hornet2 kernel: ffff880c0e581e10 0000000000000082 ffff880=
c0e581fd8 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0e580010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:07:15 hornet2 kernel: ffff880c0e581fd8 0000000000012d00 fffffff=
f81a10480 ffff880c0f5c9830
Oct 22 11:07:15 hornet2 kernel: Call Trace:
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:07:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:07:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:07:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:25 hornet2 abrtd: Sending an email...
Oct 22 11:07:25 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:07:25 hornet2 abrtd: Duplicate: UUID
Oct 22 11:07:25 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:07:25 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:07:07-26911-1', deleting
Oct 22 11:07:34 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:07:34 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:07:34 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:07:34 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:07:34 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:07:34 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]  [<fffffff=
f8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:07:34 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000=
217
Oct 22 11:07:34 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:07:34 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:07:34 hornet2 kernel: RBP: ffff88070e521cc8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:07:34 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: 0000000000000d0f
Oct 22 11:07:34 hornet2 kernel: R13: ffff88070e521cb8 R14: 00000000000000=
30 R15: ffff88070e520000
Oct 22 11:07:34 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:07:34 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:07:34 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:07:34 hornet2 kernel: Stack:
Oct 22 11:07:34 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9 ffff880=
c0f5ce0c0 0000000000000000
Oct 22 11:07:34 hornet2 kernel: ffff88070e521da8 ffffffff810c4896 0000000=
000000030 ffff88070e521d28
Oct 22 11:07:34 hornet2 kernel: 000000005266940e 0000000000000000 ffff880=
70c264000 ffff880600000001
Oct 22 11:07:34 hornet2 kernel: Call Trace:
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c0ee9>] task_cgroup_from_roo=
t+0x29/0xa0
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:07:34 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:07:34 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:07:34 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:07:34 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:07:34 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:07:34 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:07:34 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9 c3=
 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 =
66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84 00 00=
 00 00 00 55=20
Oct 22 11:07:35 hornet2 abrtd: Directory 'oops-2013-10-22-11:07:35-26911-=
1' creation detected
Oct 22 11:07:35 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:07:36 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:07:35-26911-1/uid': No such file or directory
Oct 22 11:07:53 hornet2 abrtd: Sending an email...
Oct 22 11:07:53 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:07:53 hornet2 abrtd: Duplicate: UUID
Oct 22 11:07:53 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:07:53 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:07:35-26911-1', deleting
Oct 22 11:08:02 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 23s! [=
numad:27384]
Oct 22 11:08:02 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:08:02 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:02 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:02 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:08:02 hornet2 kernel: RIP: 0010:[<ffffffff81542574>]  [<fffffff=
f81542574>] _raw_read_lock+0x14/0x20
Oct 22 11:08:02 hornet2 kernel: RSP: 0018:ffff88070e521cd0  EFLAGS: 00000=
217
Oct 22 11:08:02 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:08:02 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:08:02 hornet2 kernel: RBP: ffff88070e521ce8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:08:02 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: f4f0000000000000
Oct 22 11:08:02 hornet2 kernel: R13: ffff88070e521cc8 R14: 0000000000000d=
0f R15: ffff88070e521cb8
Oct 22 11:08:02 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:02 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:02 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:08:02 hornet2 kernel: Stack:
Oct 22 11:08:02 hornet2 kernel: ffffffff810c0ee9 ffff880c0f5cd0a0 0000000=
000000000 ffff88070e521da8
Oct 22 11:08:02 hornet2 kernel: ffffffff810c4896 0000000000000030 ffff880=
70e521d28 000000005266940e
Oct 22 11:08:02 hornet2 kernel: 0000000000000000 ffff88070c264000 ffff880=
600000001 0000000000000000
Oct 22 11:08:02 hornet2 kernel: Call Trace:
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c0ee9>] ? task_cgroup_from_r=
oot+0x29/0xa0
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:08:02 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:08:02 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:08:02 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:08:02 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:08:02 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:08:02 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:08:02 hornet2 kernel: Code: 78 05 c9 c3 0f 1f 00 f0 ff 07 30 c0=
 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 f0 ff 0f 79 =
05 e8 bd f0 d2 ff c9 <c3> 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66=
 66 66 66 90=20
Oct 22 11:08:03 hornet2 abrtd: Directory 'oops-2013-10-22-11:08:03-26911-=
1' creation detected
Oct 22 11:08:03 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:08:04 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:08:03-26911-1/uid': No such file or directory
Oct 22 11:08:21 hornet2 abrtd: Sending an email...
Oct 22 11:08:21 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:08:21 hornet2 abrtd: Duplicate: UUID
Oct 22 11:08:21 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:08:21 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:08:03-26911-1', deleting
Oct 22 11:08:30 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 23s! [=
numad:27384]
Oct 22 11:08:30 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:08:30 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:30 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:30 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:08:30 hornet2 kernel: RIP: 0010:[<ffffffff8154256c>]  [<fffffff=
f8154256c>] _raw_read_lock+0xc/0x20
Oct 22 11:08:30 hornet2 kernel: RSP: 0018:ffff88070e521cc8  EFLAGS: 00000=
217
Oct 22 11:08:30 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:08:30 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:08:30 hornet2 kernel: RBP: ffff88070e521cc8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:08:30 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: 0000000000000d0f
Oct 22 11:08:30 hornet2 kernel: R13: ffff88070e521cb8 R14: 00000000000000=
30 R15: ffff88070e520000
Oct 22 11:08:30 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:30 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:30 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:08:30 hornet2 kernel: Stack:
Oct 22 11:08:30 hornet2 kernel: ffff88070e521ce8 ffffffff810c0ee9 ffff880=
c0f5ce0c0 0000000000000000
Oct 22 11:08:30 hornet2 kernel: ffff88070e521da8 ffffffff810c4896 0000000=
000000030 ffff88070e521d28
Oct 22 11:08:30 hornet2 kernel: 000000005266940e 0000000000000000 ffff880=
70c264000 ffff880600000001
Oct 22 11:08:30 hornet2 kernel: Call Trace:
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c0ee9>] task_cgroup_from_roo=
t+0x29/0xa0
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:08:30 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:08:30 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:08:30 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:08:30 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:08:30 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:08:30 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:08:30 hornet2 kernel: Code: 17 b8 01 00 00 00 ff ca 78 05 c9 c3=
 0f 1f 00 f0 ff 07 30 c0 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 =
66 66 66 90 f0 ff 0f <79> 05 e8 bd f0 d2 ff c9 c3 66 66 2e 0f 1f 84 00 00=
 00 00 00 55=20
Oct 22 11:08:31 hornet2 abrtd: Directory 'oops-2013-10-22-11:08:31-26911-=
1' creation detected
Oct 22 11:08:31 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:08:32 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:08:31-26911-1/uid': No such file or directory
Oct 22 11:08:46 hornet2 kernel: INFO: rcu_sched self-detected stall on CP=
U { 8}  (t=3D240006 jiffies g=3D163763 c=3D163762 q=3D891356)
Oct 22 11:08:46 hornet2 kernel: INFO: rcu_sched detected stalls on CPUs/t=
asks: { 8} (detected by 2, t=3D240007 jiffies, g=3D163763, c=3D163762, q=3D=
891356)
Oct 22 11:08:46 hornet2 kernel: sending NMI to all CPUs:
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 0
Oct 22 11:08:46 hornet2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffffffff81a10480 ti: ffffffff81a000=
00 task.ti: ffffffff81a00000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffffffff81a01df8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffffffff81a00010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffffffff81a01e38 R08: 00000000000020=
00 R09: 00000000000196c9
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8928c8a1 R14: 00000000000000=
00 R15: ffffffff81a00010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407f0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c12d00 0000000000000202 fffffff=
f81a01e38 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffffffff81a01e88 ffffe8fae3c00730 fffffff=
f81a78a40 00000c6a8928c87c
Oct 22 11:08:46 hornet2 kernel: ffffffff81a01e88 ffffffff814385c3 fffffff=
f81a01e78 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81537827>] rest_init+0x77/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81ae0019>] start_kernel+0x3d8/0=
x3e5
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adfa6f>] ? repair_env_string+=
0x5b/0x5b
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adf59d>] x86_64_start_reserva=
tions+0x2a/0x2c
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adf6d8>] x86_64_start_kernel+=
0x139/0x140
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 1
Oct 22 11:08:46 hornet2 kernel: CPU: 1 PID: 0 Comm: swapper/1 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055d8b0 ti: ffff88071058a0=
00 task.ti: ffff88071058a000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff88071058bdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff88071058a010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff88071058be18 R08: 00000000000020=
00 R09: 00000000002a9e1b
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a88e8b578 R14: 00000000000000=
00 R15: ffff88071058a010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c32d00 0000000000000202 ffff880=
71058be18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff88071058be68 ffffe8fae3c20730 fffffff=
f81a78a40 00000c6a88e8b543
Oct 22 11:08:46 hornet2 kernel: ffff88071058be68 ffffffff814385c3 ffff880=
71058be58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 2
Oct 22 11:08:46 hornet2 kernel: CPU: 2 PID: 0 Comm: swapper/2 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055e0c0 ti: ffff88071058c0=
00 task.ti: ffff88071058c000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81270307>]  [<fffffff=
f81270307>] delay_tsc+0x37/0x60
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880713c43ca8  EFLAGS: 00000=
046
Oct 22 11:08:46 hornet2 kernel: RAX: 00000000bc8a4114 RBX: 00000000000000=
00 RCX: 0000000000000002
Oct 22 11:08:46 hornet2 kernel: RDX: 00000000000018d5 RSI: 00000000bc8a40=
c1 RDI: 0000000000030b66
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880713c43ca8 R08: 00000000000000=
02 R09: 0000000000000000
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000800=
00 R12: 0000000000001000
Oct 22 11:08:46 hornet2 kernel: R13: ffffffff81ac1048 R14: 00000000000004=
00 R15: 0000000000000096
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c43cb8 ffffffff812702c8 ffff880=
713c43cd8 ffffffff810334b2
Oct 22 11:08:46 hornet2 kernel: 0000000000000002 000000000000b024 ffff880=
713c43d28 ffffffff81033ee0
Oct 22 11:08:46 hornet2 kernel: ffffffff00000006 0000000000000003 ffff880=
713c43d08 0000000000000000
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: <IRQ>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812702c8>] __const_udelay+0x28/=
0x30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810334b2>] native_safe_apic_wai=
t_icr_idle+0x22/0x60
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81033ee0>] default_send_IPI_mas=
k_sequence_phys+0xc0/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810372d7>] physflat_send_IPI_al=
l+0x17/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81033f67>] arch_trigger_all_cpu=
_backtrace+0x57/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd350>] print_other_cpu_stal=
l+0x1f0/0x230
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd504>] __rcu_pending+0x174/=
0x1d0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810de11d>] rcu_check_callbacks+=
0xed/0x1a0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81056c48>] update_process_times=
+0x48/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adcd9>] tick_sched_handle+0x=
39/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adef4>] tick_sched_timer+0x5=
4/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810705bd>] __run_hrtimer+0x7d/0=
x1c0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adea0>] ? tick_nohz_handler+=
0xc0/0xc0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810709a6>] hrtimer_interrupt+0x=
106/0x250
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81032c6b>] local_apic_timer_int=
errupt+0x3b/0x60
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154ce35>] smp_apic_timer_inter=
rupt+0x45/0x5a
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154bb4a>] apic_timer_interrupt=
+0x6a/0x70
Oct 22 11:08:46 hornet2 kernel: <EOI>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81438535>] ? poll_idle+0x45/0x9=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8143850c>] ? poll_idle+0x1c/0x9=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: 04 25 20 b0 00 00 0f 1f 00 0f ae e8=
 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 20 b0 00 00 44 39 c1 75 12 0f =
1f 00 0f ae e8 0f 31 <89> c2 29 f2 39 fa 72 e1 c9 c3 29 c6 01 f7 0f 1f 00=
 0f ae e8 0f=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 3
Oct 22 11:08:46 hornet2 kernel: CPU: 3 PID: 0 Comm: swapper/3 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055e8d0 ti: ffff88071058e0=
00 task.ti: ffff88071058e000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff88071058fdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff88071058e010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff88071058fe18 R08: 00000000000020=
00 R09: 00000000000f4962
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed21ca9 R14: 00000000000000=
00 R15: ffff88071058e010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000000006dc1e4 CR3: 0000000c0f4990=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c72d00 0000000000000202 ffff880=
71058fe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff88071058fe68 ffffe8fae3c60730 fffffff=
f81a78a40 00000c6a8ed21c68
Oct 22 11:08:46 hornet2 kernel: ffff88071058fe68 ffffffff814385c3 ffff880=
71058fe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 4
Oct 22 11:08:46 hornet2 kernel: CPU: 4 PID: 0 Comm: swapper/4 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055f0e0 ti: ffff8807105900=
00 task.ti: ffff880710590000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710591dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710590010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710591e18 R08: 00000000000020=
00 R09: 00000000002907ca
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c80730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a88501e73 R14: 00000000000000=
00 R15: ffff880710590010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c80000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007f8cf15440a0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c92d00 0000000000000202 ffff880=
710591e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710591e68 ffffe8fae3c80730 fffffff=
f81a78a40 00000c6a88501e57
Oct 22 11:08:46 hornet2 kernel: ffff880710591e68 ffffffff814385c3 ffff880=
710591e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 5
Oct 22 11:08:46 hornet2 kernel: CPU: 5 PID: 0 Comm: swapper/5 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710598000 ti: ffff8807105920=
00 task.ti: ffff880710592000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710593dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710592010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710593e18 R08: 00000000000020=
00 R09: 00000000002e98e0
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3ca0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8f15be7f R14: 00000000000000=
00 R15: ffff880710592010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000000000d72090 CR3: 0000000c141940=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cb2d00 0000000000000202 ffff880=
710593e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710593e68 ffffe8fae3ca0730 fffffff=
f81a78a40 00000c6a8f15be38
Oct 22 11:08:46 hornet2 kernel: ffff880710593e68 ffffffff814385c3 ffff880=
710593e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 6
Oct 22 11:08:46 hornet2 kernel: CPU: 6 PID: 0 Comm: swapper/6 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710598810 ti: ffff8807105940=
00 task.ti: ffff880710594000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710595dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710594010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710595e18 R08: 00000000000020=
00 R09: 0000000000008113
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87f48400 R14: 00000000000000=
00 R15: ffff880710594010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc12d00 0000000000000202 ffff880=
710595e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710595e68 ffffe8ffffc00730 fffffff=
f81a78a40 00000c6a87f483ca
Oct 22 11:08:46 hornet2 kernel: ffff880710595e68 ffffffff814385c3 ffff880=
710595e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 7
Oct 22 11:08:46 hornet2 kernel: CPU: 7 PID: 0 Comm: swapper/7 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710599020 ti: ffff8807105960=
00 task.ti: ffff880710596000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710597dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710596010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710597e18 R08: 00000000000020=
00 R09: 000000000023992e
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87b783ee R14: 00000000000000=
00 R15: ffff880710596010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc32d00 0000000000000202 ffff880=
710597e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710597e68 ffffe8ffffc20730 fffffff=
f81a78a40 00000c6a87b783b6
Oct 22 11:08:46 hornet2 kernel: ffff880710597e68 ffffffff814385c3 ffff880=
710597e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 8
Oct 22 11:08:46 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff812cbe26>]  [<fffffff=
f812cbe26>] cfb_imageblit+0x4a6/0x4e0
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880c2fc43828  EFLAGS: 00000=
002
Oct 22 11:08:46 hornet2 kernel: RAX: ffffc9001ac19338 RBX: ffff880c153b82=
f7 RCX: 0000000000000001
Oct 22 11:08:46 hornet2 kernel: RDX: 00000000ffffffff RSI: 00000000000000=
01 RDI: 0000000000000000
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880c2fc438a8 R08: 0000000000aaaa=
aa R09: 0000000000000001
Oct 22 11:08:46 hornet2 kernel: R10: ffffffff8163ff20 R11: ffffc9001ac194=
40 R12: 0000000000000006
Oct 22 11:08:46 hornet2 kernel: R13: 0000000000001e00 R14: ffff880c153b82=
d8 R15: 0000000000000028
Oct 22 11:08:46 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffffffffffffffff 0000000000000001 0000000=
000000014 0000000081c1b620
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc43968 ffffffff8126f360 fffffff=
f00000020 ffff880c2fc438b8
Oct 22 11:08:46 hornet2 kernel: ffffc9001ac18f40 00000000810bb132 ffff880=
c2fc43998 ffff880713810400
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: <IRQ>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8126f360>] ? sprintf+0x40/0x50
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c56e8>] bit_putcs+0x398/0x57=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8126d5ef>] ? string+0x4f/0xe0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c5a81>] ? soft_cursor+0x1c1/=
0x270
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c52eb>] ? bit_cursor+0x5eb/0=
x650
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812becf6>] fbcon_putcs+0x116/0x=
150
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c5350>] ? bit_cursor+0x650/0=
x650
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c14dc>] fbcon_redraw+0x16c/0=
x1e0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812c17b6>] fbcon_scroll+0x266/0=
xe30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8132c473>] scrup+0x113/0x120
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8132c700>] lf+0x70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8132ecf5>] vt_console_print+0x2=
05/0x390
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109b095>] call_console_drivers=
=2Eclone.2+0xa5/0x100
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109b1ce>] console_cont_flush.c=
lone.0+0xde/0x180
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109b2a0>] console_unlock+0x30/=
0x280
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109ba75>] vprintk_emit+0x315/0=
x500
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8153e645>] printk+0x4d/0x4f
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd0ee>] print_cpu_stall+0xce=
/0x140
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd406>] __rcu_pending+0x76/0=
x1d0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810de11d>] rcu_check_callbacks+=
0xed/0x1a0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81056c48>] update_process_times=
+0x48/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adcd9>] tick_sched_handle+0x=
39/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adef4>] tick_sched_timer+0x5=
4/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810705bd>] __run_hrtimer+0x7d/0=
x1c0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adea0>] ? tick_nohz_handler+=
0xc0/0xc0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810709a6>] hrtimer_interrupt+0x=
106/0x250
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81032c6b>] local_apic_timer_int=
errupt+0x3b/0x60
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154ce35>] smp_apic_timer_inter=
rupt+0x45/0x5a
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154bb4a>] apic_timer_interrupt=
+0x6a/0x70
Oct 22 11:08:46 hornet2 kernel: <EOI>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c0f05>] ? task_cgroup_from_r=
oot+0x45/0xa0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c0ee9>] ? task_cgroup_from_r=
oot+0x29/0xa0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:08:46 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:08:46 hornet2 kernel: Code: cc 44 8b ab 30 01 00 00 4c 8d 1c 81=
 48 8b 45 c0 4c 89 f3 b9 08 00 00 00 eb 25 0f 1f 00 44 29 c9 0f be 13 d3 =
fa 21 f2 41 8b 14 92 <44> 21 c2 31 fa 89 10 85 c9 75 05 48 ff c3 b1 08 48=
 83 c0 04 49=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 9
Oct 22 11:08:46 hornet2 kernel: CPU: 9 PID: 0 Comm: swapper/9 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059a040 ti: ffff8807105a20=
00 task.ti: ffff8807105a2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a3e18 R08: 00000000000020=
00 R09: 000000000012accd
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a877a8817 R14: 00000000000000=
00 R15: ffff8807105a2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000000006d4460 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc72d00 0000000000000202 ffff880=
7105a3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a3e68 ffffe8ffffc60730 fffffff=
f81a78a40 00000c6a877a87e6
Oct 22 11:08:46 hornet2 kernel: ffff8807105a3e68 ffffffff814385c3 ffff880=
7105a3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 10
Oct 22 11:08:46 hornet2 kernel: CPU: 10 PID: 0 Comm: swapper/10 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059a850 ti: ffff8807105a40=
00 task.ti: ffff8807105a4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a5e18 R08: 00000000000020=
00 R09: 00000000002ae072
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc80730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a873d6c89 R14: 00000000000000=
00 R15: ffff8807105a4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c80000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc9a4000020 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc92d00 0000000000000202 ffff880=
7105a5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a5e68 ffffe8ffffc80730 fffffff=
f81a78a40 00000c6a873d6c61
Oct 22 11:08:46 hornet2 kernel: ffff8807105a5e68 ffffffff814385c3 ffff880=
7105a5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 11
Oct 22 11:08:46 hornet2 kernel: CPU: 11 PID: 0 Comm: swapper/11 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059b060 ti: ffff8807105a60=
00 task.ti: ffff8807105a6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a7e18 R08: 00000000000020=
00 R09: 00000000002afbaf
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffca0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87006d77 R14: 00000000000000=
00 R15: ffff8807105a6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc988000020 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcb2d00 0000000000000202 ffff880=
7105a7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a7e68 ffffe8ffffca0730 fffffff=
f81a78a40 00000c6a87006d54
Oct 22 11:08:46 hornet2 kernel: ffff8807105a7e68 ffffffff814385c3 ffff880=
7105a7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 12
Oct 22 11:08:46 hornet2 kernel: CPU: 12 PID: 0 Comm: swapper/12 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059b870 ti: ffff8807105a80=
00 task.ti: ffff8807105a8000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a9dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a8010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a9e18 R08: 00000000000020=
00 R09: 00000000003d0897
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3cc0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ecedae9 R14: 00000000000000=
00 R15: ffff8807105a8010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cd2d00 0000000000000202 ffff880=
7105a9e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a9e68 ffffe8fae3cc0730 fffffff=
f81a78a40 00000c6a8ecedaaf
Oct 22 11:08:46 hornet2 kernel: ffff8807105a9e68 ffffffff814385c3 ffff880=
7105a9e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 13
Oct 22 11:08:46 hornet2 kernel: CPU: 13 PID: 0 Comm: swapper/13 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059c080 ti: ffff8807105aa0=
00 task.ti: ffff8807105aa000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105abdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105aa010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105abe18 R08: 00000000000020=
00 R09: 0000000000112867
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3ce0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8e5ebea0 R14: 00000000000000=
00 R15: ffff8807105aa010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cf2d00 0000000000000202 ffff880=
7105abe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105abe68 ffffe8fae3ce0730 fffffff=
f81a78a40 00000c6a8e5ebe5c
Oct 22 11:08:46 hornet2 kernel: ffff8807105abe68 ffffffff814385c3 ffff880=
7105abe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 14
Oct 22 11:08:46 hornet2 kernel: CPU: 14 PID: 0 Comm: swapper/14 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059c890 ti: ffff8807105ac0=
00 task.ti: ffff8807105ac000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105addd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105ac010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105ade18 R08: 00000000000020=
00 R09: 00000000002bbf2c
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a868661cd R14: 00000000000000=
00 R15: ffff8807105ac010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d12d00 0000000000000202 ffff880=
7105ade18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105ade68 ffffe8fae3d00730 fffffff=
f81a78a40 00000c6a868661a0
Oct 22 11:08:46 hornet2 kernel: ffff8807105ade68 ffffffff814385c3 ffff880=
7105ade58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 15
Oct 22 11:08:46 hornet2 kernel: CPU: 15 PID: 0 Comm: swapper/15 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059d0a0 ti: ffff8807105ae0=
00 task.ti: ffff8807105ae000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105afdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105ae010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105afe18 R08: 00000000000020=
00 R09: 00000000002bea24
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a86496b92 R14: 00000000000000=
00 R15: ffff8807105ae010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d32d00 0000000000000202 ffff880=
7105afe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105afe68 ffffe8fae3d20730 fffffff=
f81a78a40 00000c6a86496b4c
Oct 22 11:08:46 hornet2 kernel: ffff8807105afe68 ffffffff814385c3 ffff880=
7105afe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 16
Oct 22 11:08:46 hornet2 kernel: CPU: 16 PID: 0 Comm: swapper/16 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059d8b0 ti: ffff8807105b00=
00 task.ti: ffff8807105b0000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b1dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b1e18 R08: 00000000000020=
00 R09: 000000000030ef42
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d40730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed27924 R14: 00000000000000=
00 R15: ffff8807105b0010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000003526279220 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d52d00 0000000000000202 ffff880=
7105b1e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b1e68 ffffe8fae3d40730 fffffff=
f81a78a40 00000c6a8ed278ea
Oct 22 11:08:46 hornet2 kernel: ffff8807105b1e68 ffffffff814385c3 ffff880=
7105b1e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 17
Oct 22 11:08:46 hornet2 kernel: CPU: 17 PID: 0 Comm: swapper/17 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059e0c0 ti: ffff8807105b20=
00 task.ti: ffff8807105b2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b3e18 R08: 00000000000020=
00 R09: 000000000031b5c0
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed9eb52 R14: 00000000000000=
00 R15: ffff8807105b2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acba0 CR3: 00000006d96330=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d72d00 0000000000000202 ffff880=
7105b3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b3e68 ffffe8fae3d60730 fffffff=
f81a78a40 00000c6a8ed9eb0b
Oct 22 11:08:46 hornet2 kernel: ffff8807105b3e68 ffffffff814385c3 ffff880=
7105b3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 18
Oct 22 11:08:46 hornet2 kernel: CPU: 18 PID: 0 Comm: swapper/18 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059e8d0 ti: ffff8807105b40=
00 task.ti: ffff8807105b4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b5e18 R08: 00000000000020=
00 R09: 000000000031e4aa
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffcc0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a85cf37a7 R14: 00000000000000=
00 R15: ffff8807105b4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcd2d00 0000000000000202 ffff880=
7105b5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b5e68 ffffe8ffffcc0730 fffffff=
f81a78a40 00000c6a85cf3767
Oct 22 11:08:46 hornet2 kernel: ffff8807105b5e68 ffffffff814385c3 ffff880=
7105b5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 19
Oct 22 11:08:46 hornet2 kernel: CPU: 19 PID: 0 Comm: swapper/19 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059f0e0 ti: ffff8807105b60=
00 task.ti: ffff8807105b6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b7e18 R08: 00000000000020=
00 R09: 0000000000001d60
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffce0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8592326d R14: 00000000000000=
00 R15: ffff8807105b6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000003526275010 CR3: 00000006fcf5e0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcf2d00 0000000000000202 ffff880=
7105b7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b7e68 ffffe8ffffce0730 fffffff=
f81a78a40 00000c6a8592324a
Oct 22 11:08:46 hornet2 kernel: ffff8807105b7e68 ffffffff814385c3 ffff880=
7105b7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 20
Oct 22 11:08:46 hornet2 kernel: CPU: 20 PID: 0 Comm: swapper/20 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b8000 ti: ffff8807105c00=
00 task.ti: ffff8807105c0000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0000:ffff8807105c1dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c1e18 R08: 00000000000020=
00 R09: 00000000002cf3c8
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000e7e=
f0 R12: ffffe8ffffd00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c69c44ac51d R14: 00000000000000=
00 R15: ffff8807105c0010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007f3aaa6b0000 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1de8 ffffffff81071228 ffff880=
7105c1e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1e68 ffffe8ffffd00730 fffffff=
f81a78a40 00000c69c44ac4fe
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1e68 ffffffff814385c3 ffff880=
7105c1e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81071228>] ? hrtimer_start+0x18=
/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 21
Oct 22 11:08:46 hornet2 kernel: CPU: 21 PID: 0 Comm: swapper/21 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b8810 ti: ffff8807105c20=
00 task.ti: ffff8807105c2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c3e18 R08: 00000000000020=
00 R09: 0000000000327148
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8555349e R14: 00000000000000=
00 R15: ffff8807105c2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd32d00 0000000000000202 ffff880=
7105c3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c3e68 ffffe8ffffd20730 fffffff=
f81a78a40 00000c6a85553465
Oct 22 11:08:46 hornet2 kernel: ffff8807105c3e68 ffffffff814385c3 ffff880=
7105c3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 22
Oct 22 11:08:46 hornet2 kernel: CPU: 22 PID: 0 Comm: swapper/22 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b9020 ti: ffff8807105c40=
00 task.ti: ffff8807105c4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c5e18 R08: 00000000000020=
00 R09: 00000000003275c3
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd40730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a85181ebd R14: 00000000000000=
00 R15: ffff8807105c4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc9bd9f6cb0 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd52d00 0000000000000202 ffff880=
7105c5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c5e68 ffffe8ffffd40730 fffffff=
f81a78a40 00000c6a85181e8a
Oct 22 11:08:46 hornet2 kernel: ffff8807105c5e68 ffffffff814385c3 ffff880=
7105c5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 23
Oct 22 11:08:46 hornet2 kernel: CPU: 23 PID: 0 Comm: swapper/23 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b9830 ti: ffff8807105c60=
00 task.ti: ffff8807105c6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c7e18 R08: 00000000000020=
00 R09: 000000000032cf07
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a84db1e0e R14: 00000000000000=
00 R15: ffff8807105c6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000706d1e0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd72d00 0000000000000202 ffff880=
7105c7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c7e68 ffffe8ffffd60730 fffffff=
f81a78a40 00000c6a84db1dda
Oct 22 11:08:46 hornet2 kernel: ffff8807105c7e68 ffffffff814385c3 ffff880=
7105c7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: sending NMI to all CPUs:
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 0
Oct 22 11:08:46 hornet2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffffffff81a10480 ti: ffffffff81a000=
00 task.ti: ffffffff81a00000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffffffff81a01df8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffffffff81a00010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffffffff81a01e38 R08: 00000000000020=
00 R09: 00000000000196c9
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8928c8a1 R14: 00000000000000=
00 R15: ffffffff81a00010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407f0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c12d00 0000000000000202 fffffff=
f81a01e38 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffffffff81a01e88 ffffe8fae3c00730 fffffff=
f81a78a40 00000c6a8928c87c
Oct 22 11:08:46 hornet2 kernel: ffffffff81a01e88 ffffffff814385c3 fffffff=
f81a01e78 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81537827>] rest_init+0x77/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81ae0019>] start_kernel+0x3d8/0=
x3e5
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adfa6f>] ? repair_env_string+=
0x5b/0x5b
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adf59d>] x86_64_start_reserva=
tions+0x2a/0x2c
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81adf6d8>] x86_64_start_kernel+=
0x139/0x140
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 1
Oct 22 11:08:46 hornet2 kernel: CPU: 1 PID: 0 Comm: swapper/1 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055d8b0 ti: ffff88071058a0=
00 task.ti: ffff88071058a000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff88071058bdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff88071058a010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff88071058be18 R08: 00000000000020=
00 R09: 00000000002a9e1b
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a88e8b578 R14: 00000000000000=
00 R15: ffff88071058a010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c32d00 0000000000000202 ffff880=
71058be18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff88071058be68 ffffe8fae3c20730 fffffff=
f81a78a40 00000c6a88e8b543
Oct 22 11:08:46 hornet2 kernel: ffff88071058be68 ffffffff814385c3 ffff880=
71058be58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 2
Oct 22 11:08:46 hornet2 kernel: CPU: 2 PID: 0 Comm: swapper/2 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055e0c0 ti: ffff88071058c0=
00 task.ti: ffff88071058c000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff88071058ddd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff88071058c010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff88071058de18 R08: 00000000000020=
00 R09: 000000000020f128
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c40730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a9440215e R14: 00000000000000=
00 R15: ffff88071058c010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c52d00 0000000000000202 ffff880=
71058de18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff88071058de68 ffffe8fae3c40730 fffffff=
f81a78a40 00000c6a9440213f
Oct 22 11:08:46 hornet2 kernel: ffff88071058de68 ffffffff814385c3 ffff880=
71058de58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 3
Oct 22 11:08:46 hornet2 kernel: CPU: 3 PID: 0 Comm: swapper/3 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055e8d0 ti: ffff88071058e0=
00 task.ti: ffff88071058e000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff88071058fdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff88071058e010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff88071058fe18 R08: 00000000000020=
00 R09: 00000000000f4962
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed21ca9 R14: 00000000000000=
00 R15: ffff88071058e010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000000006dc1e4 CR3: 0000000c0f4990=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c72d00 0000000000000202 ffff880=
71058fe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff88071058fe68 ffffe8fae3c60730 fffffff=
f81a78a40 00000c6a8ed21c68
Oct 22 11:08:46 hornet2 kernel: ffff88071058fe68 ffffffff814385c3 ffff880=
71058fe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 4
Oct 22 11:08:46 hornet2 kernel: CPU: 4 PID: 0 Comm: swapper/4 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071055f0e0 ti: ffff8807105900=
00 task.ti: ffff880710590000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710591dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710590010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710591e18 R08: 00000000000020=
00 R09: 00000000002907ca
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3c80730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a88501e73 R14: 00000000000000=
00 R15: ffff880710590010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
c80000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007f8cf15440a0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713c92d00 0000000000000202 ffff880=
710591e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710591e68 ffffe8fae3c80730 fffffff=
f81a78a40 00000c6a88501e57
Oct 22 11:08:46 hornet2 kernel: ffff880710591e68 ffffffff814385c3 ffff880=
710591e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 5
Oct 22 11:08:46 hornet2 kernel: CPU: 5 PID: 0 Comm: swapper/5 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710598000 ti: ffff8807105920=
00 task.ti: ffff880710592000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710593dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710592010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710593e18 R08: 00000000000020=
00 R09: 00000000002e98e0
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3ca0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8f15be7f R14: 00000000000000=
00 R15: ffff880710592010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000000000d72090 CR3: 0000000c141940=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cb2d00 0000000000000202 ffff880=
710593e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710593e68 ffffe8fae3ca0730 fffffff=
f81a78a40 00000c6a8f15be38
Oct 22 11:08:46 hornet2 kernel: ffff880710593e68 ffffffff814385c3 ffff880=
710593e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 6
Oct 22 11:08:46 hornet2 kernel: CPU: 6 PID: 0 Comm: swapper/6 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710598810 ti: ffff8807105940=
00 task.ti: ffff880710594000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710595dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710594010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710595e18 R08: 00000000000020=
00 R09: 0000000000008113
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87f48400 R14: 00000000000000=
00 R15: ffff880710594010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000706ba50=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc12d00 0000000000000202 ffff880=
710595e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710595e68 ffffe8ffffc00730 fffffff=
f81a78a40 00000c6a87f483ca
Oct 22 11:08:46 hornet2 kernel: ffff880710595e68 ffffffff814385c3 ffff880=
710595e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 7
Oct 22 11:08:46 hornet2 kernel: CPU: 7 PID: 0 Comm: swapper/7 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff880710599020 ti: ffff8807105960=
00 task.ti: ffff880710596000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880710597dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff880710596010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880710597e18 R08: 00000000000020=
00 R09: 000000000023992e
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87b783ee R14: 00000000000000=
00 R15: ffff880710596010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc32d00 0000000000000202 ffff880=
710597e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff880710597e68 ffffe8ffffc20730 fffffff=
f81a78a40 00000c6a87b783b6
Oct 22 11:08:46 hornet2 kernel: ffff880710597e68 ffffffff814385c3 ffff880=
710597e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 8
Oct 22 11:08:46 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff812702f2>]  [<fffffff=
f812702f2>] delay_tsc+0x22/0x60
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff880c2fc43cc8  EFLAGS: 00000=
087
Oct 22 11:08:46 hornet2 kernel: RAX: 00000000bd141dc8 RBX: 00000000000000=
00 RCX: 0000000000000026
Oct 22 11:08:46 hornet2 kernel: RDX: 0000000000000021 RSI: 00000000bd141d=
a7 RDI: 0000000000030c70
Oct 22 11:08:46 hornet2 kernel: RBP: ffff880c2fc43cc8 R08: 00000000000000=
08 R09: 0000000000000000
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000d0c R11: 0000000000000d=
0c R12: 0000000000001000
Oct 22 11:08:46 hornet2 kernel: R13: ffffffff81ac1048 R14: 00000000000004=
00 R15: 0000000000000092
Oct 22 11:08:46 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc43cd8 ffffffff812702c8 ffff880=
c2fc43cf8 ffffffff810334b2
Oct 22 11:08:46 hornet2 kernel: 0000000000000002 000000000000b024 ffff880=
c2fc43d48 ffffffff81033ee0
Oct 22 11:08:46 hornet2 kernel: 0000000000000026 0000000000000009 ffff880=
c2fc43d28 0000000000000000
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: <IRQ>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff812702c8>] __const_udelay+0x28/=
0x30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810334b2>] native_safe_apic_wai=
t_icr_idle+0x22/0x60
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81033ee0>] default_send_IPI_mas=
k_sequence_phys+0xc0/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810372d7>] physflat_send_IPI_al=
l+0x17/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81033f67>] arch_trigger_all_cpu=
_backtrace+0x57/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd0f3>] print_cpu_stall+0xd3=
/0x140
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810dd406>] __rcu_pending+0x76/0=
x1d0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810de11d>] rcu_check_callbacks+=
0xed/0x1a0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81056c48>] update_process_times=
+0x48/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adcd9>] tick_sched_handle+0x=
39/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adef4>] tick_sched_timer+0x5=
4/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810705bd>] __run_hrtimer+0x7d/0=
x1c0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810adea0>] ? tick_nohz_handler+=
0xc0/0xc0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810709a6>] hrtimer_interrupt+0x=
106/0x250
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81032c6b>] local_apic_timer_int=
errupt+0x3b/0x60
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154ce35>] smp_apic_timer_inter=
rupt+0x45/0x5a
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154bb4a>] apic_timer_interrupt=
+0x6a/0x70
Oct 22 11:08:46 hornet2 kernel: <EOI>=20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c0f05>] ? task_cgroup_from_r=
oot+0x45/0xa0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c0ee9>] ? task_cgroup_from_r=
oot+0x29/0xa0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:08:46 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:08:46 hornet2 kernel: Code: 00 c9 c3 66 0f 1f 44 00 00 55 48 89=
 e5 66 66 66 66 90 65 44 8b 04 25 20 b0 00 00 0f 1f 00 0f ae e8 0f 31 89 =
c6 eb 11 66 90 f3 90 <65> 8b 0c 25 20 b0 00 00 44 39 c1 75 12 0f 1f 00 0f=
 ae e8 0f 31=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 9
Oct 22 11:08:46 hornet2 kernel: CPU: 9 PID: 0 Comm: swapper/9 Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059a040 ti: ffff8807105a20=
00 task.ti: ffff8807105a2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a3e18 R08: 00000000000020=
00 R09: 000000000012accd
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a877a8817 R14: 00000000000000=
00 R15: ffff8807105a2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000000006d4460 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc72d00 0000000000000202 ffff880=
7105a3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a3e68 ffffe8ffffc60730 fffffff=
f81a78a40 00000c6a877a87e6
Oct 22 11:08:46 hornet2 kernel: ffff8807105a3e68 ffffffff814385c3 ffff880=
7105a3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 10
Oct 22 11:08:46 hornet2 kernel: CPU: 10 PID: 0 Comm: swapper/10 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059a850 ti: ffff8807105a40=
00 task.ti: ffff8807105a4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a5e18 R08: 00000000000020=
00 R09: 00000000002ae072
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffc80730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a873d6c89 R14: 00000000000000=
00 R15: ffff8807105a4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
c80000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc9a4000020 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fc92d00 0000000000000202 ffff880=
7105a5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a5e68 ffffe8ffffc80730 fffffff=
f81a78a40 00000c6a873d6c61
Oct 22 11:08:46 hornet2 kernel: ffff8807105a5e68 ffffffff814385c3 ffff880=
7105a5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 11
Oct 22 11:08:46 hornet2 kernel: CPU: 11 PID: 0 Comm: swapper/11 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059b060 ti: ffff8807105a60=
00 task.ti: ffff8807105a6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a7e18 R08: 00000000000020=
00 R09: 00000000002afbaf
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffca0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a87006d77 R14: 00000000000000=
00 R15: ffff8807105a6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ca0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc988000020 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcb2d00 0000000000000202 ffff880=
7105a7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a7e68 ffffe8ffffca0730 fffffff=
f81a78a40 00000c6a87006d54
Oct 22 11:08:46 hornet2 kernel: ffff8807105a7e68 ffffffff814385c3 ffff880=
7105a7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 12
Oct 22 11:08:46 hornet2 kernel: CPU: 12 PID: 0 Comm: swapper/12 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059b870 ti: ffff8807105a80=
00 task.ti: ffff8807105a8000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105a9dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105a8010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105a9e18 R08: 00000000000020=
00 R09: 00000000003d0897
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3cc0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ecedae9 R14: 00000000000000=
00 R15: ffff8807105a8010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cd2d00 0000000000000202 ffff880=
7105a9e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105a9e68 ffffe8fae3cc0730 fffffff=
f81a78a40 00000c6a8ecedaaf
Oct 22 11:08:46 hornet2 kernel: ffff8807105a9e68 ffffffff814385c3 ffff880=
7105a9e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 13
Oct 22 11:08:46 hornet2 kernel: CPU: 13 PID: 0 Comm: swapper/13 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059c080 ti: ffff8807105aa0=
00 task.ti: ffff8807105aa000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105abdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105aa010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105abe18 R08: 00000000000020=
00 R09: 0000000000112867
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3ce0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8e5ebea0 R14: 00000000000000=
00 R15: ffff8807105aa010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713cf2d00 0000000000000202 ffff880=
7105abe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105abe68 ffffe8fae3ce0730 fffffff=
f81a78a40 00000c6a8e5ebe5c
Oct 22 11:08:46 hornet2 kernel: ffff8807105abe68 ffffffff814385c3 ffff880=
7105abe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 14
Oct 22 11:08:46 hornet2 kernel: CPU: 14 PID: 0 Comm: swapper/14 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059c890 ti: ffff8807105ac0=
00 task.ti: ffff8807105ac000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105addd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105ac010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105ade18 R08: 00000000000020=
00 R09: 00000000002bbf2c
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a868661cd R14: 00000000000000=
00 R15: ffff8807105ac010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d12d00 0000000000000202 ffff880=
7105ade18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105ade68 ffffe8fae3d00730 fffffff=
f81a78a40 00000c6a868661a0
Oct 22 11:08:46 hornet2 kernel: ffff8807105ade68 ffffffff814385c3 ffff880=
7105ade58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 15
Oct 22 11:08:46 hornet2 kernel: CPU: 15 PID: 0 Comm: swapper/15 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059d0a0 ti: ffff8807105ae0=
00 task.ti: ffff8807105ae000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105afdd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105ae010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105afe18 R08: 00000000000020=
00 R09: 00000000002bea24
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a86496b92 R14: 00000000000000=
00 R15: ffff8807105ae010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d32d00 0000000000000202 ffff880=
7105afe18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105afe68 ffffe8fae3d20730 fffffff=
f81a78a40 00000c6a86496b4c
Oct 22 11:08:46 hornet2 kernel: ffff8807105afe68 ffffffff814385c3 ffff880=
7105afe58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 16
Oct 22 11:08:46 hornet2 kernel: CPU: 16 PID: 0 Comm: swapper/16 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059d8b0 ti: ffff8807105b00=
00 task.ti: ffff8807105b0000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b1dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b1e18 R08: 00000000000020=
00 R09: 000000000030ef42
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d40730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed27924 R14: 00000000000000=
00 R15: ffff8807105b0010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000003526279220 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d52d00 0000000000000202 ffff880=
7105b1e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b1e68 ffffe8fae3d40730 fffffff=
f81a78a40 00000c6a8ed278ea
Oct 22 11:08:46 hornet2 kernel: ffff8807105b1e68 ffffffff814385c3 ffff880=
7105b1e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 17
Oct 22 11:08:46 hornet2 kernel: CPU: 17 PID: 0 Comm: swapper/17 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059e0c0 ti: ffff8807105b20=
00 task.ti: ffff8807105b2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b3e18 R08: 00000000000020=
00 R09: 000000000031b5c0
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
01 R12: ffffe8fae3d60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8ed9eb52 R14: 00000000000000=
00 R15: ffff8807105b2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880713=
d60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acba0 CR3: 00000006d96330=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880713d72d00 0000000000000202 ffff880=
7105b3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b3e68 ffffe8fae3d60730 fffffff=
f81a78a40 00000c6a8ed9eb0b
Oct 22 11:08:46 hornet2 kernel: ffff8807105b3e68 ffffffff814385c3 ffff880=
7105b3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 18
Oct 22 11:08:46 hornet2 kernel: CPU: 18 PID: 0 Comm: swapper/18 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059e8d0 ti: ffff8807105b40=
00 task.ti: ffff8807105b4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b5e18 R08: 00000000000020=
00 R09: 000000000031e4aa
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffcc0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a85cf37a7 R14: 00000000000000=
00 R15: ffff8807105b4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
cc0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcd2d00 0000000000000202 ffff880=
7105b5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b5e68 ffffe8ffffcc0730 fffffff=
f81a78a40 00000c6a85cf3767
Oct 22 11:08:46 hornet2 kernel: ffff8807105b5e68 ffffffff814385c3 ffff880=
7105b5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 19
Oct 22 11:08:46 hornet2 kernel: CPU: 19 PID: 0 Comm: swapper/19 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff88071059f0e0 ti: ffff8807105b60=
00 task.ti: ffff8807105b6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105b7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105b6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105b7e18 R08: 00000000000020=
00 R09: 0000000000001d60
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffce0730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8592326d R14: 00000000000000=
00 R15: ffff8807105b6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
ce0000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 0000003526275010 CR3: 00000006fcf5e0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fcf2d00 0000000000000202 ffff880=
7105b7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105b7e68 ffffe8ffffce0730 fffffff=
f81a78a40 00000c6a8592324a
Oct 22 11:08:46 hornet2 kernel: ffff8807105b7e68 ffffffff814385c3 ffff880=
7105b7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 20
Oct 22 11:08:46 hornet2 kernel: CPU: 20 PID: 0 Comm: swapper/20 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b8000 ti: ffff8807105c00=
00 task.ti: ffff8807105c0000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0000:ffff8807105c1dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c0010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c1e18 R08: 00000000000020=
00 R09: 00000000002cf3c8
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000e7e=
f0 R12: ffffe8ffffd00730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c69c44ac51d R14: 00000000000000=
00 R15: ffff8807105c0010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d00000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007f3aaa6b0000 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1de8 ffffffff81071228 ffff880=
7105c1e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1e68 ffffe8ffffd00730 fffffff=
f81a78a40 00000c69c44ac4fe
Oct 22 11:08:46 hornet2 kernel: ffff8807105c1e68 ffffffff814385c3 ffff880=
7105c1e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81071228>] ? hrtimer_start+0x18=
/0x20
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 21
Oct 22 11:08:46 hornet2 kernel: CPU: 21 PID: 0 Comm: swapper/21 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b8810 ti: ffff8807105c20=
00 task.ti: ffff8807105c2000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438535>]  [<fffffff=
f81438535>] poll_idle+0x45/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c3dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c2010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c3e18 R08: 00000000000020=
00 R09: 0000000000327148
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd20730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a8555349e R14: 00000000000000=
00 R15: ffff8807105c2010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d20000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000001a0b0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd32d00 0000000000000202 ffff880=
7105c3e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c3e68 ffffe8ffffd20730 fffffff=
f81a78a40 00000c6a85553465
Oct 22 11:08:46 hornet2 kernel: ffff8807105c3e68 ffffffff814385c3 ffff880=
7105c3e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: c6 ff 49 89 c5 fb 65 48 8b 14 25 08=
 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 0f 1f 44 =
00 00 f3 90 48 8b 02 <a8> 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89 c7 e8 b7=
 67 c1 ff 48=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 22
Oct 22 11:08:46 hornet2 kernel: CPU: 22 PID: 0 Comm: swapper/22 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b9020 ti: ffff8807105c40=
00 task.ti: ffff8807105c4000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c5dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c4010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c5e18 R08: 00000000000020=
00 R09: 00000000003275c3
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd40730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a85181ebd R14: 00000000000000=
00 R15: ffff8807105c4010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d40000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00007fc9bd9f6cb0 CR3: 0000000c164850=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd52d00 0000000000000202 ffff880=
7105c5e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c5e68 ffffe8ffffd40730 fffffff=
f81a78a40 00000c6a85181e8a
Oct 22 11:08:46 hornet2 kernel: ffff8807105c5e68 ffffffff814385c3 ffff880=
7105c5e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:46 hornet2 kernel: NMI backtrace for cpu 23
Oct 22 11:08:46 hornet2 kernel: CPU: 23 PID: 0 Comm: swapper/23 Not taint=
ed 3.12.0-rc3+ #1
Oct 22 11:08:46 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:08:46 hornet2 kernel: task: ffff8807105b9830 ti: ffff8807105c60=
00 task.ti: ffff8807105c6000
Oct 22 11:08:46 hornet2 kernel: RIP: 0010:[<ffffffff81438532>]  [<fffffff=
f81438532>] poll_idle+0x42/0x90
Oct 22 11:08:46 hornet2 kernel: RSP: 0018:ffff8807105c7dd8  EFLAGS: 00000=
246
Oct 22 11:08:46 hornet2 kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000017
Oct 22 11:08:46 hornet2 kernel: RDX: ffff8807105c6010 RSI: ffffffff81a78a=
40 RDI: ffffffff81a13980
Oct 22 11:08:46 hornet2 kernel: RBP: ffff8807105c7e18 R08: 00000000000020=
00 R09: 000000000032cf07
Oct 22 11:08:46 hornet2 kernel: R10: 0000000000000000 R11: 00000000000000=
00 R12: ffffe8ffffd60730
Oct 22 11:08:46 hornet2 kernel: R13: 00000c6a84db1e0e R14: 00000000000000=
00 R15: ffff8807105c6010
Oct 22 11:08:46 hornet2 kernel: FS:  0000000000000000(0000) GS:ffff880c2f=
d60000(0000) knlGS:0000000000000000
Oct 22 11:08:46 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:08:46 hornet2 kernel: CR2: 00000035262acee0 CR3: 0000000706d1e0=
00 CR4: 00000000000407e0
Oct 22 11:08:46 hornet2 kernel: Stack:
Oct 22 11:08:46 hornet2 kernel: ffff880c2fd72d00 0000000000000202 ffff880=
7105c7e18 ffffffff810a5e24
Oct 22 11:08:46 hornet2 kernel: ffff8807105c7e68 ffffe8ffffd60730 fffffff=
f81a78a40 00000c6a84db1dda
Oct 22 11:08:46 hornet2 kernel: ffff8807105c7e68 ffffffff814385c3 ffff880=
7105c7e58 ffffffffffffffff
Oct 22 11:08:46 hornet2 kernel: Call Trace:
Oct 22 11:08:46 hornet2 kernel: [<ffffffff810a5e24>] ? ktime_get+0x54/0xe=
0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814385c3>] cpuidle_enter_state+=
0x43/0xd0
Oct 22 11:08:46 hornet2 kernel: [<ffffffff814389af>] cpuidle_idle_call+0x=
cf/0x160
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8100c58e>] arch_cpu_idle+0xe/0x=
30
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109cff9>] cpu_idle_loop+0x69/0=
x200
Oct 22 11:08:46 hornet2 kernel: [<ffffffff8109d200>] cpu_startup_entry+0x=
70/0x80
Oct 22 11:08:46 hornet2 kernel: [<ffffffff81031b87>] start_secondary+0xc7=
/0xd0
Oct 22 11:08:46 hornet2 kernel: Code: e8 c4 d8 c6 ff 49 89 c5 fb 65 48 8b=
 14 25 08 b8 00 00 48 8b 82 38 e0 ff ff a8 08 75 15 48 81 ea c8 1f 00 00 =
0f 1f 44 00 00 f3 90 <48> 8b 02 a8 08 74 f7 e8 92 d8 c6 ff 4c 29 e8 48 89=
 c7 e8 b7 67=20
Oct 22 11:08:51 hornet2 abrtd: Sending an email...
Oct 22 11:08:51 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:08:52 hornet2 abrtd: Duplicate: UUID
Oct 22 11:08:52 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:08:52 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:08:31-26911-1', deleting
Oct 22 11:09:10 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 23s! [=
numad:27384]
Oct 22 11:09:10 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:09:10 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:09:10 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:09:10 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:09:10 hornet2 kernel: RIP: 0010:[<ffffffff81542574>]  [<fffffff=
f81542574>] _raw_read_lock+0x14/0x20
Oct 22 11:09:10 hornet2 kernel: RSP: 0018:ffff88070e521cd0  EFLAGS: 00000=
217
Oct 22 11:09:10 hornet2 kernel: RAX: 0000000000000000 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:09:10 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:09:10 hornet2 kernel: RBP: ffff88070e521ce8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:09:10 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: f4f0000000000000
Oct 22 11:09:10 hornet2 kernel: R13: ffff88070e521cc8 R14: 0000000000000d=
0f R15: ffff88070e521cb8
Oct 22 11:09:10 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:09:10 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:09:10 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:09:10 hornet2 kernel: Stack:
Oct 22 11:09:10 hornet2 kernel: ffffffff810c0ee9 ffff880c0f5ce0c0 0000000=
000000000 ffff88070e521da8
Oct 22 11:09:10 hornet2 kernel: ffffffff810c4896 0000000000000030 ffff880=
70e521d28 000000005266940e
Oct 22 11:09:10 hornet2 kernel: 0000000000000000 ffff88070c264000 ffff880=
600000001 0000000000000000
Oct 22 11:09:10 hornet2 kernel: Call Trace:
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c0ee9>] ? task_cgroup_from_r=
oot+0x29/0xa0
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:09:10 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:09:10 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:09:10 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:09:10 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:09:10 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:09:10 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:10 hornet2 kernel: Code: 78 05 c9 c3 0f 1f 00 f0 ff 07 30 c0=
 c9 c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 f0 ff 0f 79 =
05 e8 bd f0 d2 ff c9 <c3> 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66=
 66 66 66 90=20
Oct 22 11:09:11 hornet2 abrtd: Directory 'oops-2013-10-22-11:09:11-26911-=
1' creation detected
Oct 22 11:09:11 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:09:12 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:09:11-26911-1/uid': No such file or directory
Oct 22 11:09:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31705 blocked =
for more than 120 seconds.
Oct 22 11:09:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:09:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:09:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31705  31688 0x00000080
Oct 22 11:09:15 hornet2 kernel: ffff880c0812be10 0000000000000082 ffff880=
c0812bfd8 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0812a010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0812bfd8 0000000000012d00 ffff880=
71055f0e0 ffff880c0f5cc890
Oct 22 11:09:15 hornet2 kernel: Call Trace:
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:09:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31706 blocked =
for more than 120 seconds.
Oct 22 11:09:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:09:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:09:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31706  31688 0x00000080
Oct 22 11:09:15 hornet2 kernel: ffff880c0e46fe10 0000000000000082 ffff880=
c0e46ffd8 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0e46e010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0e46ffd8 0000000000012d00 ffff880=
71055e0c0 ffff880c0f5c9020
Oct 22 11:09:15 hornet2 kernel: Call Trace:
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:09:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31707 blocked =
for more than 120 seconds.
Oct 22 11:09:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:09:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:09:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31707  31688 0x00000080
Oct 22 11:09:15 hornet2 kernel: ffff880c0ec01e10 0000000000000082 ffff880=
c0ec01fd8 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0ec00010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0ec01fd8 0000000000012d00 ffff880=
71055d8b0 ffff880c0f5ce0c0
Oct 22 11:09:15 hornet2 kernel: Call Trace:
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:09:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31708 blocked =
for more than 120 seconds.
Oct 22 11:09:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:09:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:09:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31708  31688 0x00000080
Oct 22 11:09:15 hornet2 kernel: ffff880c166dfe10 0000000000000082 ffff880=
c166dffd8 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c166de010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c166dffd8 0000000000012d00 ffff880=
71055e8d0 ffff880c0f5cd0a0
Oct 22 11:09:15 hornet2 kernel: Call Trace:
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:09:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:15 hornet2 kernel: INFO: task numa02_SMT_HARD:31709 blocked =
for more than 120 seconds.
Oct 22 11:09:15 hornet2 kernel:      Not tainted 3.12.0-rc3+ #1
Oct 22 11:09:15 hornet2 kernel: "echo 0 > /proc/sys/kernel/hung_task_time=
out_secs" disables this message.
Oct 22 11:09:15 hornet2 kernel: numa02_SMT_HARD D ffffffff8160b180     0 =
31709  31688 0x00000080
Oct 22 11:09:15 hornet2 kernel: ffff880c0e581e10 0000000000000082 ffff880=
c0e581fd8 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0e580010 0000000000012d00 0000000=
000012d00 0000000000012d00
Oct 22 11:09:15 hornet2 kernel: ffff880c0e581fd8 0000000000012d00 fffffff=
f81a10480 ffff880c0f5c9830
Oct 22 11:09:15 hornet2 kernel: Call Trace:
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540e69>] schedule+0x29/0x70
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81542105>] rwsem_down_read_fail=
ed+0x95/0xf0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81271664>] call_rwsem_down_read=
_failed+0x14/0x30
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81540084>] ? down_read+0x24/0x3=
0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8105c684>] exit_signals+0x24/0x=
130
Oct 22 11:09:15 hornet2 kernel: [<ffffffff81072846>] ? blocking_notifier_=
call_chain+0x16/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d532>] do_exit+0xb2/0x470
Oct 22 11:09:15 hornet2 kernel: [<ffffffff810d4076>] ? __audit_syscall_ex=
it+0x216/0x2c0
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8104d9e7>] SyS_exit+0x17/0x20
Oct 22 11:09:15 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:32 hornet2 abrtd: Sending an email...
Oct 22 11:09:32 hornet2 abrtd: Email was sent to: root@localhost
Oct 22 11:09:32 hornet2 abrtd: Duplicate: UUID
Oct 22 11:09:32 hornet2 abrtd: DUP_OF_DIR: /var/spool/abrt/oops-2013-06-2=
0-08:07:16-9684-1
Oct 22 11:09:32 hornet2 abrtd: Corrupted or bad directory '/var/spool/abr=
t/oops-2013-10-22-11:09:11-26911-1', deleting
Oct 22 11:09:38 hornet2 kernel: BUG: soft lockup - CPU#8 stuck for 22s! [=
numad:27384]
Oct 22 11:09:38 hornet2 kernel: Modules linked in: ebtable_nat ebtables x=
t_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc ipt_RE=
JECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJEC=
T nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter =
ip6_tables ipv6 ext2 vhost_net macvtap macvlan vhost tun kvm_intel kvm ui=
nput hp_wmi sparse_keymap rfkill snd_usb_audio snd_usbmidi_lib snd_rawmid=
i acpi_cpufreq freq_table iTCO_wdt iTCO_vendor_support sg microcode serio=
_raw pcspkr sb_edac edac_core wmi i2c_i801 lpc_ich mfd_core xhci_hcd e100=
0e ptp pps_core ioatdma dca snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_time=
r snd soundcore snd_page_alloc ext4 jbd2 mbcache sr_mod cdrom sd_mod crc_=
t10dif crct10dif_common firewire_ohci firewire_core crc_itu_t ahci libahc=
i pata_acpi ata_generic isci libsas scsi_transport_sas radeon ttm drm_kms=
_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
Oct 22 11:09:38 hornet2 kernel: CPU: 8 PID: 27384 Comm: numad Not tainted=
 3.12.0-rc3+ #1
Oct 22 11:09:38 hornet2 kernel: Hardware name: Hewlett-Packard HP Z620 Wo=
rkstation/158A, BIOS J61 v03.15 05/09/2013
Oct 22 11:09:38 hornet2 kernel: task: ffff88070e9c60c0 ti: ffff88070e5200=
00 task.ti: ffff88070e520000
Oct 22 11:09:38 hornet2 kernel: RIP: 0010:[<ffffffff810c0f05>]  [<fffffff=
f810c0f05>] task_cgroup_from_root+0x45/0xa0
Oct 22 11:09:38 hornet2 kernel: RSP: 0018:ffff88070e521cd8  EFLAGS: 00000=
216
Oct 22 11:09:38 hornet2 kernel: RAX: ffff880c0e45f200 RBX: f4f00000000000=
00 RCX: ffff880c073ca6e8
Oct 22 11:09:38 hornet2 kernel: RDX: ffff880c12a1f040 RSI: ffff88070c2640=
00 RDI: ffffffff81a46cc8
Oct 22 11:09:38 hornet2 kernel: RBP: ffff88070e521ce8 R08: ffff880c2fc55b=
a0 R09: ffff880c030fa000
Oct 22 11:09:38 hornet2 kernel: R10: f4f0000000000000 R11: f0000000000000=
00 R12: f4f0000000000000
Oct 22 11:09:38 hornet2 kernel: R13: ffff88070e521cc8 R14: 0000000000000d=
0f R15: ffff88070e521cb8
Oct 22 11:09:38 hornet2 kernel: FS:  00007f5cf7023700(0000) GS:ffff880c2f=
c40000(0000) knlGS:0000000000000000
Oct 22 11:09:38 hornet2 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
Oct 22 11:09:38 hornet2 kernel: CR2: ffffffffff600400 CR3: 000000070f3570=
00 CR4: 00000000000407e0
Oct 22 11:09:38 hornet2 kernel: Stack:
Oct 22 11:09:38 hornet2 kernel: ffff880c0f5c9830 0000000000000000 ffff880=
70e521da8 ffffffff810c4896
Oct 22 11:09:38 hornet2 kernel: 0000000000000030 ffff88070e521d28 0000000=
05266940e 0000000000000000
Oct 22 11:09:38 hornet2 kernel: ffff88070c264000 ffff880600000001 0000000=
000000000 0000000000000000
Oct 22 11:09:38 hornet2 kernel: Call Trace:
Oct 22 11:09:38 hornet2 kernel: [<ffffffff810c4896>] cgroup_attach_task+0=
xe6/0x3b0
Oct 22 11:09:38 hornet2 kernel: [<ffffffff810c4ccf>] attach_task_by_pid+0=
x16f/0x1b0
Oct 22 11:09:38 hornet2 kernel: [<ffffffff810c4d26>] cgroup_tasks_write+0=
x16/0x20
Oct 22 11:09:38 hornet2 kernel: [<ffffffff810c1b3c>] cgroup_write_X64+0xe=
c/0x150
Oct 22 11:09:38 hornet2 kernel: [<ffffffff81210cb3>] ? security_file_perm=
ission+0x23/0x90
Oct 22 11:09:38 hornet2 kernel: [<ffffffff810c4338>] cgroup_file_write+0x=
58/0xc0
Oct 22 11:09:38 hornet2 kernel: [<ffffffff81178683>] ? file_start_write+0=
x33/0x40
Oct 22 11:09:38 hornet2 kernel: [<ffffffff81178c68>] vfs_write+0xc8/0x170=

Oct 22 11:09:38 hornet2 kernel: [<ffffffff8117927f>] SyS_write+0x5f/0xb0
Oct 22 11:09:38 hornet2 kernel: [<ffffffff8154af92>] system_call_fastpath=
+0x16/0x1b
Oct 22 11:09:38 hornet2 kernel: Code: 01 74 6d 48 c7 c7 c8 6c a4 81 e8 77=
 16 48 00 48 8b 8b d8 06 00 00 49 8d 44 24 28 48 81 f9 e0 18 cc 81 75 12 =
f0 ff 05 c3 5d 98 00 <48> 85 c0 74 3c 5b 41 5c c9 c3 90 48 8b 41 28 48 83=
 c1 28 48 8d=20
Oct 22 11:09:39 hornet2 abrtd: Directory 'oops-2013-10-22-11:09:39-26911-=
1' creation detected
Oct 22 11:09:39 hornet2 abrt-dump-oops: Reported 1 kernel oopses to Abrt
Oct 22 11:09:40 hornet2 abrtd: Can't open file '/var/spool/abrt/oops-2013=
-10-22-11:09:39-26911-1/uid': No such file or directory

--------------010704090003070803020605--
