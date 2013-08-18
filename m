Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3HRBIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:08:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42799 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752159Ab3HRBII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:08:08 -0400
Date: Sat, 17 Aug 2013 21:08:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
cc: Peter Wu <lekensteyn@gmail.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [3.11-rc5..] NULL pointer dereference in bdi_writeback_workfn
Message-ID: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding this message to Tejun and Jens, because it concerns a bug in 
the block layer.

Alan Stern

---------- Forwarded message ----------
Date: Sun, 18 Aug 2013 00:12:10 +0200
From: Peter Wu <lekensteyn@gmail.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [3.11-rc5..] NULL pointer dereference,
     lockup after XHCI device dropped out

Hi,

I hit a BUG followed by a lockup when trying to wipe a new external USB 3.0
1TB 2.5" "Western Digital My Passport" (WDBBEP0010BBK-EESN) HDD.
The following command is used (with sudo):

    dd if=/dev/zero of=/dev/sdd bs=1M

In another shell, I kept sending a USR1 signal to watch progress (maybe
not related, but mentioned for completeness):

    while killall -USR1 dd; do sleep 30; done

While doing this over SSH, another KDE session was open with someone
playing the Java game Minecraft.

I have so far reproduced this lockup three times. The first time, the
lock-up occured after:

    84838+0 records in
    84838+0 records out
    88959090688 bytes (89 GB) copied, 789.707 s, 113 MB/s

I have no logs from the first lockup. The second time (after a reboot):

    388514+1 records in
    388514+1 records out
    407386685440 bytes (407 GB) copied, 3881.25 s, 105 MB/s

The second log part (not "third lockup log") below is from this session.
I omitted the remaining lines that are printed when the CPU got hung.

The third BUG occured 22 minutes (156 GB) after rebooting and running
dd and has similar log entries to the previous lock-up. This kernel used
the same kernel sources, but with XHCI debugging enabled.  No
differences were noticable in the console output, other than the missing
"xHCI xhci_drop_endpoint called with disabled ep" message in the new
logs. See the first console output below.

I have no idea why the USB 3.0 HDD would drop out, but that should
not trigger a NULL pointer dereference anyhow.

The desktop was running kernel v3.11-rc5-35-gf1d6e17 plus three r8169
patches that are unrelated to this issue and has 24 GB RAM and a i5-2320
CPU. I do not know how to easily reproduce this bug, the current
"reproduction" method described above takes time.

One possibly related bug is https://bugzilla.kernel.org/show_bug.cgi?id=51641,
but I do not have a panic. Any ideas? If you want me to test something
or open a new bug, let me know.

Regards,
Peter
--

=== third lockup log ===
[   17.724296] usb 6-2: new SuperSpeed USB device number 2 using xhci_hcd
[   17.746522] usb 6-2: Parent hub missing LPM exit latency info.  Power management will be impacted.
[   17.759786] usb 6-2: New USB device found, idVendor=1058, idProduct=0748
[   17.766494] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[   17.773628] usb 6-2: Product: My Passport 0748
[   17.778071] usb 6-2: Manufacturer: Western Digital
[   17.782868] usb 6-2: SerialNumber: 575842314133334E35383439
[   17.790595] usb-storage 6-2:1.0: USB Mass Storage device detected
[   17.796995] scsi9 : usb-storage 6-2:1.0
[   18.800604] scsi 9:0:0:0: Direct-Access     WD       My Passport 0748 1022 PQ: 0 ANSI: 6
[   18.808994] scsi 9:0:0:1: Enclosure         WD       SES Device       1022 PQ: 0 ANSI: 6
[   18.817618] sd 9:0:0:0: Attached scsi generic sg4 type 0
[   18.819416] sd 9:0:0:0: [sdd] Spinning up disk...
[   18.827943] scsi 9:0:0:1: Attached scsi generic sg5 type 13
[   19.823185] ..ready
[   20.828276] sd 9:0:0:0: [sdd] 1953458176 512-byte logical blocks: (1.00 TB/931 GiB)
[   20.836548] sd 9:0:0:0: [sdd] Write Protect is off
[   20.841352] sd 9:0:0:0: [sdd] Mode Sense: 47 00 10 08
[   20.847172] sd 9:0:0:0: [sdd] No Caching mode page present
[   20.852674] sd 9:0:0:0: [sdd] Assuming drive cache: write through
[   20.860714] sd 9:0:0:0: [sdd] No Caching mode page present
[   20.866208] sd 9:0:0:0: [sdd] Assuming drive cache: write through
[   20.885996]  sdd: unknown partition table
[   20.891706] sd 9:0:0:0: [sdd] No Caching mode page present
[   20.897214] sd 9:0:0:0: [sdd] Assuming drive cache: write through
[   20.903310] sd 9:0:0:0: [sdd] Attached SCSI disk
[ 1355.971539] usb 6-2: USB disconnect, device number 2
[ 1385.834230] sd 9:0:0:0: Device offlined - not ready after error recovery
[ 1385.842002] sd 9:0:0:0: [sdd] Unhandled error code
[ 1385.846811] sd 9:0:0:0: [sdd]  
[ 1385.849980] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 1385.856015] sd 9:0:0:0: [sdd] CDB: 
[ 1385.859518] Write(10): 2a 00 10 4f eb 00 00 00 f0 00
[ 1385.864748] end_request: I/O error, dev sdd, sector 273672960
[ 1385.870509] quiet_error: 6 callbacks suppressed
[ 1385.875047] Buffer I/O error on device sdd, logical block 34209120
[ 1385.881240] lost page write due to I/O error on sdd
[ 1385.886144] Buffer I/O error on device sdd, logical block 34209121
[ 1385.892326] lost page write due to I/O error on sdd
[ 1385.897221] Buffer I/O error on device sdd, logical block 34209122
[ 1385.903405] lost page write due to I/O error on sdd
[ 1385.908290] Buffer I/O error on device sdd, logical block 34209123
[ 1385.914478] lost page write due to I/O error on sdd
[ 1385.919372] Buffer I/O error on device sdd, logical block 34209124
[ 1385.925557] lost page write due to I/O error on sdd
[ 1385.930448] Buffer I/O error on device sdd, logical block 34209125
[ 1385.936630] lost page write due to I/O error on sdd
[ 1385.941530] Buffer I/O error on device sdd, logical block 34209126
[ 1385.947719] lost page write due to I/O error on sdd
[ 1385.952622] Buffer I/O error on device sdd, logical block 34209127
[ 1385.958814] lost page write due to I/O error on sdd
[ 1385.963700] Buffer I/O error on device sdd, logical block 34209128
[ 1385.969889] lost page write due to I/O error on sdd
[ 1385.974774] Buffer I/O error on device sdd, logical block 34209129
[ 1385.980964] lost page write due to I/O error on sdd
[ 1385.992099] sd 9:0:0:0: [sdd] Unhandled error code
[ 1385.996909] sd 9:0:0:0: [sdd]  
[ 1386.000068] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 1386.006077] sd 9:0:0:0: [sdd] CDB: 
[ 1386.009570] Write(10): 2a 00 10 4f eb f0 00 00 f0 00
[ 1386.014766] end_request: I/O error, dev sdd, sector 273673200
[ 1400.017504] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[ 1400.026504] IP: [<ffffffff811b090d>] bdi_writeback_workfn+0x3d/0x460
[ 1400.033931] PGD 57fd0c067 PUD 582747067 
[ 1400.038920] Oops: 0000 [#1] SMP 
[ 1400.043201] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek joydev hid_generic hid_logitech_dj snd_hda_intel mxm_wmi snd_hda_codec snd_hwdep snd_pcm nls_iso8859_1 snd_seq_midi snd_seq_midi_event usbhid usb_storage snd_rawmidi hid snd_seq snd_seq_device snd_timer psmouse serio_raw snd lpc_ich soundcore snd_page_alloc it87 hwmon_vid coretemp wmi mac_hid r8169 eeprom_93cx6 mii pci_stub i915 ahci libahci drm_kms_helper drm i2c_algo_bit video
[ 1400.090474] CPU: 0 PID: 6 Comm: kworker/u8:0 Not tainted 3.11.0-rc5-usbdbg-00259-gd5f955d #1
[ 1400.100072] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 1400.111496] Workqueue: writeback bdi_writeback_workfn
[ 1400.117724] task: ffff8806035f9fb0 ti: ffff880603602000 task.ti: ffff880603602000
[ 1400.126354] RIP: 0010:[<ffffffff811b090d>]  [<ffffffff811b090d>] bdi_writeback_workfn+0x3d/0x460
[ 1400.136355] RSP: 0018:ffff880603603c98  EFLAGS: 00010292
[ 1400.142800] RAX: 0000000000000000 RBX: ffff8805fdf526a8 RCX: 0000000000000000
[ 1400.151090] RDX: ffff8806035fa6c8 RSI: ffff8805fdf52690 RDI: ffff8805fdf526a8
[ 1400.159388] RBP: ffff880603603d58 R08: 0000000000000002 R09: 0000000000000000
[ 1400.167709] R10: 0000000000000001 R11: 000000000000037b R12: ffff8806034e0080
[ 1400.175996] R13: ffff8806030f0b00 R14: ffff880606814000 R15: 0000000000000000
[ 1400.184283] FS:  0000000000000000(0000) GS:ffff88061f200000(0000) knlGS:0000000000000000
[ 1400.193535] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1400.200420] CR2: 0000000000000050 CR3: 000000057e5c3000 CR4: 00000000000407f0
[ 1400.208721] Stack:
[ 1400.211874]  ffff8806035f9fb0 ffff8806035f9fb0 0000000000000000 ffff8805fdf52410
[ 1400.220513]  ffff8805fdf526a8 0000000000000002 ffff880603603d58 ffff8805fdf52690
[ 1400.229146]  0000000000000000 ffffffff8106539f ffff880600000000 0000000000000002
[ 1400.237789] Call Trace:
[ 1400.241388]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1400.248553]  [<ffffffff81065401>] process_one_work+0x1d1/0x570
[ 1400.255537]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1400.255541]  [<ffffffff810665eb>] worker_thread+0x11b/0x370
[ 1400.255542]  [<ffffffff810664d0>] ? manage_workers.isra.19+0x170/0x170
[ 1400.255544]  [<ffffffff8106d3ca>] kthread+0xea/0xf0
[ 1400.255547]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1400.255550]  [<ffffffff8166875c>] ret_from_fork+0x7c/0xb0
[ 1400.255551]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1400.255565] Code: 55 41 54 53 48 81 ec 98 00 00 00 48 8b 47 e8 48 89 b5 78 ff ff ff 48 89 bd 60 ff ff ff 48 89 85 58 ff ff ff 48 8b 80 08 04 00 00 <48> 8b 70 50 48 85 f6 0f 84 30 03 00 00 31 c0 48 c7 c7 25 c0 a0 
[ 1400.255568] RIP  [<ffffffff811b090d>] bdi_writeback_workfn+0x3d/0x460
[ 1400.255568]  RSP <ffff880603603c98>
[ 1400.255569] CR2: 0000000000000050
[ 1400.266465] ---[ end trace ad75804411adabda ]---
[ 1400.266520] BUG: unable to handle kernel paging request at ffffffffffffffa8
[ 1400.266524] IP: [<ffffffff8106dc00>] kthread_data+0x10/0x20
[ 1400.266526] PGD 1c0c067 PUD 1c0e067 PMD 0 
[ 1400.266527] Oops: 0000 [#2] SMP
[ 1400.266543] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek joydev hid_generic hid_logitech_dj snd_hda_intel mxm_wmi snd_hda_codec snd_hwdep snd_pcm nls_iso8859_1 snd_seq_midi snd_seq_midi_event usbhid usb_storage snd_rawmidi hid snd_seq snd_seq_device snd_timer psmouse serio_raw snd lpc_ich soundcore snd_page_alloc it87 hwmon_vid coretemp wmi mac_hid r8169 eeprom_93cx6 mii pci_stub i915 ahci libahci drm_kms_helper drm i2c_algo_bit video
[ 1400.266545] CPU: 1 PID: 6 Comm: kworker/u8:0 Tainted: G      D      3.11.0-rc5-usbdbg-00259-gd5f955d #1
[ 1400.266545] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 1400.266551] task: ffff8806035f9fb0 ti: ffff880603602000 task.ti: ffff880603602000
[ 1400.266553] RIP: 0010:[<ffffffff8106dc00>]  [<ffffffff8106dc00>] kthread_data+0x10/0x20
[ 1400.266554] RSP: 0018:ffff880603603898  EFLAGS: 00010046
[ 1400.266554] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
[ 1400.266555] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8806035f9fb0
[ 1400.266555] RBP: ffff880603603898 R08: 0000000000000000 R09: 0000000000000000
[ 1400.266556] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[ 1400.266556] R13: 0000000000000001 R14: ffff8806035f9fb0 R15: ffff8806035f9fa0
[ 1400.266557] FS:  0000000000000000(0000) GS:ffff88061f280000(0000) knlGS:0000000000000000
[ 1400.266558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1400.266559] CR2: 0000000000000028 CR3: 00000005d8fd0000 CR4: 00000000000407e0
[ 1400.266559] Stack:
[ 1400.266561]  ffff8806036038b8 ffffffff81066c06 ffff8806035f9fb0 ffff88061f293fc0
[ 1400.266562]  ffff880603603928 ffffffff8165c812 ffff8805fcd83508 0000000000013fc0
[ 1400.266564]  ffff880603603fd8 ffff880603603fd8 0000000000013fc0 ffff8806035f9fb0
[ 1400.266564] Call Trace:
[ 1400.266567]  [<ffffffff81066c06>] wq_worker_sleeping+0x16/0x90
[ 1400.266570]  [<ffffffff8165c812>] __schedule+0x602/0x870
[ 1400.266571]  [<ffffffff8165caa9>] schedule+0x29/0x70
[ 1400.266574]  [<ffffffff81049147>] do_exit+0x727/0xa90
[ 1400.266576]  [<ffffffff81660895>] oops_end+0x95/0xd0
[ 1400.266579]  [<ffffffff8164cf4c>] no_context+0x1e4/0x1f3
[ 1400.266581]  [<ffffffff810a9a34>] ? mark_held_locks+0x74/0x140
[ 1400.266583]  [<ffffffff8164cfd3>] __bad_area_nosemaphore+0x78/0x1d1
[ 1400.266585]  [<ffffffff8164d13f>] bad_area_nosemaphore+0x13/0x15
[ 1400.266587]  [<ffffffff816638ee>] __do_page_fault+0x35e/0x590
[ 1400.266589]  [<ffffffff810aaf8b>] ? __lock_acquire+0x3eb/0xab0
[ 1400.266592]  [<ffffffff8131d12d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1400.266594]  [<ffffffff81663b2e>] do_page_fault+0xe/0x10
[ 1400.266595]  [<ffffffff8165fce2>] page_fault+0x22/0x30
[ 1400.266598]  [<ffffffff811b090d>] ? bdi_writeback_workfn+0x3d/0x460
[ 1400.266600]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1400.266601]  [<ffffffff81065401>] process_one_work+0x1d1/0x570
[ 1400.266602]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1400.266604]  [<ffffffff810665eb>] worker_thread+0x11b/0x370
[ 1400.266605]  [<ffffffff810664d0>] ? manage_workers.isra.19+0x170/0x170
[ 1400.266606]  [<ffffffff8106d3ca>] kthread+0xea/0xf0
[ 1400.266609]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1400.266610]  [<ffffffff8166875c>] ret_from_fork+0x7c/0xb0
[ 1400.266612]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1400.266625] Code: 00 48 89 e5 5d 48 8b 40 98 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 90 03 00 00 55 48 89 e5 <48> 8b 40 a8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[ 1400.266626] RIP  [<ffffffff8106dc00>] kthread_data+0x10/0x20
[ 1400.266627]  RSP <ffff880603603898>
[ 1400.266627] CR2: ffffffffffffffa8
[ 1400.266628] ---[ end trace ad75804411adabdb ]---
[ 1400.266629] Fixing recursive fault but reboot is needed!
[ 1416.357430] ------------[ cut here ]------------
[ 1416.362051] WARNING: CPU: 1 PID: 6 at /home/pc/Linux-src/linux/kernel/watchdog.c:245 watchdog_overflow_callback+0x9e/0xd0()
[ 1416.373169] Watchdog detected hard LOCKUP on cpu 1
[ 1416.377779] Modules linked in: kvm_intel kvm dm_crypt binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek joydev hid_generic hid_logitech_dj snd_hda_intel mxm_wmi snd_hda_codec snd_hwdep snd_pcm nls_iso8859_1 snd_seq_midi
 snd_seq_midi_event usbhid usb_storage snd_rawmidi hid snd_seq snd_seq_device snd_timer psmouse serio_raw snd lpc_ich soundcore snd_page_alloc it87 hwmon_vid coretemp wmi mac_hid r8169 eeprom_93cx6 mii pci_stub i915 ahci liba
hci drm_kms_helper drm i2c_algo_bit video
[ 1416.421523] CPU: 1 PID: 6 Comm: kworker/u8:0 Tainted: G      D      3.11.0-rc5-usbdbg-00259-gd5f955d #1
[ 1416.430896] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 1416.441161]  0000000000000009 ffff88061f287b98 ffffffff81654e80 0000000000000000
[ 1416.448614]  ffff88061f287be8 ffff88061f287bd8 ffffffff81047741 0000000000000000
[ 1416.456066]  ffff880603648000 0000000000000000 ffff88061f287d20 0000000000000000
[ 1416.463516] Call Trace:
[ 1416.465959]  <NMI>  [<ffffffff81654e80>] dump_stack+0x55/0x76
[ 1416.471723]  [<ffffffff81047741>] warn_slowpath_common+0x81/0xa0
[ 1416.477735]  [<ffffffff810477a6>] warn_slowpath_fmt+0x46/0x50
[ 1416.483478]  [<ffffffff810d8ff0>] ? watchdog_enable_all_cpus.part.1+0x50/0x50
[ 1416.490599]  [<ffffffff810d908e>] watchdog_overflow_callback+0x9e/0xd0
[ 1416.497124]  [<ffffffff8111b1d2>] __perf_event_overflow+0x92/0x280
[ 1416.503302]  [<ffffffff81119ea7>] ? perf_event_update_userpage+0x117/0x1a0
[ 1416.510172]  [<ffffffff81119d90>] ? perf_event_task_disable+0x90/0x90
[ 1416.516600]  [<ffffffff8111be54>] perf_event_overflow+0x14/0x20
[ 1416.522519]  [<ffffffff8101a5c6>] intel_pmu_handle_irq+0x1b6/0x3b0
[ 1416.528698]  [<ffffffff8166151b>] perf_event_nmi_handler+0x2b/0x50
[ 1416.534873]  [<ffffffff81660a8a>] nmi_handle.isra.3+0xca/0x210
[ 1416.540694]  [<ffffffff816609c5>] ? nmi_handle.isra.3+0x5/0x210
[ 1416.546604]  [<ffffffff81661540>] ? perf_event_nmi_handler+0x50/0x50
[ 1416.552945]  [<ffffffff81660d49>] default_do_nmi+0xe9/0x240
[ 1416.558507]  [<ffffffff81660f60>] do_nmi+0xc0/0x100
[ 1416.563376]  [<ffffffff81660097>] end_repeat_nmi+0x1e/0x2e
[ 1416.568854]  [<ffffffff8131bbab>] ? delay_tsc+0x2b/0x90
[ 1416.574077]  [<ffffffff8131bbab>] ? delay_tsc+0x2b/0x90
[ 1416.579291]  [<ffffffff8131bbab>] ? delay_tsc+0x2b/0x90
[ 1416.584508]  <<EOE>>  [<ffffffff8131babf>] __delay+0xf/0x20
[ 1416.590104]  [<ffffffff81324531>] do_raw_spin_lock+0xf1/0x150
[ 1416.595839]  [<ffffffff8165eedf>] _raw_spin_lock_irq+0x4f/0x60
[ 1416.601670]  [<ffffffff8165c2c7>] ? __schedule+0xb7/0x870
[ 1416.607061]  [<ffffffff8165c2c7>] __schedule+0xb7/0x870
[ 1416.612284]  [<ffffffff8165caa9>] schedule+0x29/0x70
[ 1416.617240]  [<ffffffff810494a1>] do_exit+0xa81/0xa90
[ 1416.622284]  [<ffffffff81098bfd>] ? kmsg_dump+0x11d/0x140
[ 1416.627680]  [<ffffffff81098b04>] ? kmsg_dump+0x24/0x140
[ 1416.632990]  [<ffffffff81660895>] oops_end+0x95/0xd0
[ 1416.637946]  [<ffffffff8164cf4c>] no_context+0x1e4/0x1f3
[ 1416.643259]  [<ffffffff811c7664>] ? fsnotify_clear_marks_by_inode+0x34/0x130
[ 1416.650311]  [<ffffffff8164cfd3>] __bad_area_nosemaphore+0x78/0x1d1
[ 1416.656574]  [<ffffffff8164d13f>] bad_area_nosemaphore+0x13/0x15
[ 1416.662571]  [<ffffffff816638ee>] __do_page_fault+0x35e/0x590
[ 1416.668322]  [<ffffffff81092af7>] ? cpuacct_charge+0x97/0xd0
[ 1416.673971]  [<ffffffff81092b0f>] ? cpuacct_charge+0xaf/0xd0
[ 1416.679620]  [<ffffffff81092a65>] ? cpuacct_charge+0x5/0xd0
[ 1416.685183]  [<ffffffff813f75fc>] ? mix_pool_bytes.constprop.15+0x4c/0xf0
[ 1416.691964]  [<ffffffff810853bc>] ? update_curr+0xec/0x1a0
[ 1416.697449]  [<ffffffff8131d12d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1416.703973]  [<ffffffff81663b2e>] do_page_fault+0xe/0x10
[ 1416.709285]  [<ffffffff8165fce2>] page_fault+0x22/0x30
[ 1416.714423]  [<ffffffff8106dc00>] ? kthread_data+0x10/0x20
[ 1416.719898]  [<ffffffff81066c06>] wq_worker_sleeping+0x16/0x90
[ 1416.725719]  [<ffffffff8165c812>] __schedule+0x602/0x870
[ 1416.731022]  [<ffffffff8165caa9>] schedule+0x29/0x70
[ 1416.735979]  [<ffffffff81049147>] do_exit+0x727/0xa90
[ 1416.741021]  [<ffffffff81660895>] oops_end+0x95/0xd0
[ 1416.745975]  [<ffffffff8164cf4c>] no_context+0x1e4/0x1f3
[ 1416.751279]  [<ffffffff810a9a34>] ? mark_held_locks+0x74/0x140
[ 1416.757109]  [<ffffffff8164cfd3>] __bad_area_nosemaphore+0x78/0x1d1
[ 1416.763365]  [<ffffffff8164d13f>] bad_area_nosemaphore+0x13/0x15
[ 1416.769360]  [<ffffffff816638ee>] __do_page_fault+0x35e/0x590
[ 1416.775095]  [<ffffffff810aaf8b>] ? __lock_acquire+0x3eb/0xab0
[ 1416.780918]  [<ffffffff8131d12d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1416.787432]  [<ffffffff81663b2e>] do_page_fault+0xe/0x10
[ 1416.792743]  [<ffffffff8165fce2>] page_fault+0x22/0x30
[ 1416.797874]  [<ffffffff811b090d>] ? bdi_writeback_workfn+0x3d/0x460
[ 1416.804137]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1416.810131]  [<ffffffff81065401>] process_one_work+0x1d1/0x570
[ 1416.815954]  [<ffffffff8106539f>] ? process_one_work+0x16f/0x570
[ 1416.821950]  [<ffffffff810665eb>] worker_thread+0x11b/0x370
[ 1416.827520]  [<ffffffff810664d0>] ? manage_workers.isra.19+0x170/0x170
[ 1416.834035]  [<ffffffff8106d3ca>] kthread+0xea/0xf0
[ 1416.838906]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1416.845429]  [<ffffffff8166875c>] ret_from_fork+0x7c/0xb0
[ 1416.850817]  [<ffffffff8106d2e0>] ? kthread_create_on_node+0x160/0x160
[ 1416.857331] ---[ end trace ad75804411adabdc ]---
[ 1416.861941] perf samples too long (3942479 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 1416.871324] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 513.895 msecs


=== second lockup log ===
[  336.897004] audit_printk_skb: 6 callbacks suppressed
[  336.901995] type=1400 audit(1376734238.080:17): apparmor="DENIED" operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=1281 comm="cupsd" pid=1281 comm="cupsd" capability=36  capname="block_suspend"
[ 4134.215608] usb 6-2: device not accepting address 2, error -22
[ 4134.307673] usb 6-2: USB disconnect, device number 2
[ 4134.315521] sd 9:0:0:0: [sdd] Unhandled error code
[ 4134.320344] sd 9:0:0:0: [sdd]  
[ 4134.323495] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 4134.327984] sd 9:0:0:0: [sdd] Unhandled error code
[ 4134.327986] sd 9:0:0:0: [sdd]  
[ 4134.327986] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 4134.327987] sd 9:0:0:0: [sdd] CDB: 
[ 4134.327993] Write(10): 2a 00 2f 51 19 c0 00 00 f0 00
[ 4134.328039] end_request: I/O error, dev sdd, sector 793844160
[ 4134.328041] Buffer I/O error on device sdd, logical block 99230520
[ 4134.328042] lost page write due to I/O error on sdd
[ 4134.328044] Buffer I/O error on device sdd, logical block 99230521
[ 4134.328045] lost page write due to I/O error on sdd
[ 4134.328046] Buffer I/O error on device sdd, logical block 99230522
[ 4134.328047] lost page write due to I/O error on sdd
[ 4134.328048] Buffer I/O error on device sdd, logical block 99230523
[ 4134.328049] lost page write due to I/O error on sdd
[ 4134.328050] Buffer I/O error on device sdd, logical block 99230524
[ 4134.328050] lost page write due to I/O error on sdd
[ 4134.328052] Buffer I/O error on device sdd, logical block 99230525
[ 4134.328052] lost page write due to I/O error on sdd
[ 4134.328054] Buffer I/O error on device sdd, logical block 99230526
[ 4134.328054] lost page write due to I/O error on sdd
[ 4134.328056] Buffer I/O error on device sdd, logical block 99230527
[ 4134.328056] lost page write due to I/O error on sdd
[ 4134.328058] Buffer I/O error on device sdd, logical block 99230528
[ 4134.328058] lost page write due to I/O error on sdd
[ 4134.456987] sd 9:0:0:0: [sdd] CDB: 
[ 4134.460483] Write(10): 2a 00 2f 51 18 d0 00 00 f0 00
[ 4134.465657] end_request: I/O error, dev sdd, sector 793843920
[ 4148.479522] xhci_hcd 0000:05:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff8805fda1a600
[ 4148.486394] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[ 4148.486400] IP: [<ffffffff811afeec>] bdi_writeback_workfn+0x2c/0x240
[ 4148.486402] PGD 5fee04067 PUD 5fee03067 PMD 0 
[ 4148.486403] Oops: 0000 [#1] SMP 
[ 4148.486419] Modules linked in: kvm_intel kvm binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek nls_iso8859_1 joydev hid_generic hid_logitech_dj mxm_wmi snd_hda_intel usb_storage snd_hda_codec usbhid snd_hwdep hid snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq psmouse lpc_ich serio_raw snd_seq_device snd_timer snd soundcore snd_page_alloc wmi mac_hid it87 hwmon_vid coretemp r8169 eeprom_93cx6 mii pci_stub i915 drm_kms_helper ahci libahci drm i2c_algo_bit video
[ 4148.486421] CPU: 0 PID: 4120 Comm: kworker/u8:2 Not tainted 3.11.0-rc5-cold-00259-gd5f955d #1
[ 4148.486422] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4148.486424] Workqueue: writeback bdi_writeback_workfn
[ 4148.486425] task: ffff88059a1a0000 ti: ffff8803fad76000 task.ti: ffff8803fad76000
[ 4148.486427] RIP: 0010:[<ffffffff811afeec>]  [<ffffffff811afeec>] bdi_writeback_workfn+0x2c/0x240
[ 4148.486428] RSP: 0018:ffff8803fad77d08  EFLAGS: 00010292
[ 4148.486429] RAX: 0000000000000000 RBX: ffff8805fbbf8d60 RCX: 0000000000000000
[ 4148.486429] RDX: ffff88059a1a0718 RSI: 0000000000702000 RDI: ffff8805fbbf8ff8
[ 4148.486430] RBP: ffff8803fad77d68 R08: 0000000000000002 R09: 0000000000000000
[ 4148.486430] R10: 0000000000000001 R11: 0000000000000368 R12: ffff8805fbbf8ff8
[ 4148.486431] R13: ffff8806030f1b00 R14: 0000000000000000 R15: ffff8805fbbf8fe0
[ 4148.486432] FS:  0000000000000000(0000) GS:ffff88061f200000(0000) knlGS:0000000000000000
[ 4148.486433] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4148.486433] CR2: 0000000000000050 CR3: 00000005fee05000 CR4: 00000000000407f0
[ 4148.486434] Stack:
[ 4148.486436]  ffff88059a1a0000 ffff8805fbbf8ff8 ffff8805fbbf8ff8 00000000810aa86d
[ 4148.486437]  0000000000000000 ffff8803fad77d98 ffff8803fad77d48 ffff88048d56f580
[ 4148.486438]  ffff8805fbbf8ff8 ffff8806030f1b00 0000000000000000 0000000000000100
[ 4148.486439] Call Trace:
[ 4148.486443]  [<ffffffff81065f04>] process_one_work+0x1f4/0x550
[ 4148.486444]  [<ffffffff81065ea2>] ? process_one_work+0x192/0x550
[ 4148.486446]  [<ffffffff81066c71>] worker_thread+0x121/0x3a0
[ 4148.486447]  [<ffffffff81066b50>] ? manage_workers.isra.23+0x2a0/0x2a0
[ 4148.486449]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4148.486451]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4148.486453]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4148.486454]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4148.486467] Code: 66 66 66 90 55 48 89 e5 41 57 49 89 ff 49 83 ef 18 41 56 41 55 41 54 53 48 83 ec 38 48 8b 5f e8 48 89 7d b0 48 8b 83 08 04 00 00 <48> 8b 70 50 48 85 f6 0f 84 30 01 00 00 31 c0 48 c7 c7 39 d0 a0 
[ 4148.486468] RIP  [<ffffffff811afeec>] bdi_writeback_workfn+0x2c/0x240
[ 4148.486469]  RSP <ffff8803fad77d08>
[ 4148.486469] CR2: 0000000000000050
[ 4148.492858] ---[ end trace cb80c0fefa920c1c ]---
[ 4148.492921] BUG: unable to handle kernel paging request at ffffffffffffffa8
[ 4148.492925] IP: [<ffffffff8106e350>] kthread_data+0x10/0x20
[ 4148.492927] PGD 1c0c067 PUD 1c0e067 PMD 0 
[ 4148.492928] Oops: 0000 [#2] SMP 
[ 4148.492944] Modules linked in: kvm_intel kvm binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek nls_iso8859_1 joydev hid_generic hid_logitech_dj mxm_wmi snd_hda_intel usb_storage snd_hda_codec usbhid snd_hwdep hid snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq psmouse lpc_ich serio_raw snd_seq_device snd_timer snd soundcore snd_page_alloc wmi mac_hid it87 hwmon_vid coretemp r8169 eeprom_93cx6 mii pci_stub i915 drm_kms_helper ahci libahci drm i2c_algo_bit video
[ 4148.492946] CPU: 0 PID: 4120 Comm: kworker/u8:2 Tainted: G      D      3.11.0-rc5-cold-00259-gd5f955d #1
[ 4148.492947] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4148.492953] task: ffff88059a1a0000 ti: ffff8803fad76000 task.ti: ffff8803fad76000
[ 4148.492956] RIP: 0010:[<ffffffff8106e350>]  [<ffffffff8106e350>] kthread_data+0x10/0x20
[ 4148.492956] RSP: 0018:ffff8803fad77938  EFLAGS: 00010096
[ 4148.492957] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81e5ec00
[ 4148.492958] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88059a1a0000
[ 4148.492959] RBP: ffff8803fad77938 R08: 0000000000000000 R09: 0000000000000000
[ 4148.492960] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 4148.492960] R13: ffff88059a1a03e8 R14: ffff88059a1a0000 R15: 0000000000030001
[ 4148.492962] FS:  0000000000000000(0000) GS:ffff88061f200000(0000) knlGS:0000000000000000
[ 4148.492963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4148.492964] CR2: 0000000000000028 CR3: 00000005fee05000 CR4: 00000000000407f0
[ 4148.492965] Stack:
[ 4148.492969]  ffff8803fad77958 ffffffff81066f75 ffff8803fad77958 ffff88061f213f80
[ 4148.492973]  ffff8803fad779d8 ffffffff8165eb0f ffff8803fad77988 0000000000000000
[ 4148.492976]  ffff8803fad77fd8 ffff8803fad77fd8 ffff8803fad77fd8 ffff8803fad77fd8
[ 4148.492977] Call Trace:
[ 4148.492981]  [<ffffffff81066f75>] wq_worker_sleeping+0x15/0xa0
[ 4148.492986]  [<ffffffff8165eb0f>] __schedule+0x60f/0x740
[ 4148.492988]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4148.492991]  [<ffffffff8104aa7d>] do_exit+0x2ad/0x470
[ 4148.492994]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4148.492996]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4148.492998]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4148.493000]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4148.493001]  [<ffffffff8164dc9e>] bad_area_nosemaphore+0x13/0x15
[ 4148.493003]  [<ffffffff8166578e>] __do_page_fault+0x34e/0x550
[ 4148.493005]  [<ffffffff810abb3b>] ? __lock_acquire+0x3eb/0xab0
[ 4148.493008]  [<ffffffff8131cbad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 4148.493009]  [<ffffffff8166599e>] do_page_fault+0xe/0x10
[ 4148.493010]  [<ffffffff81661ce2>] page_fault+0x22/0x30
[ 4148.493014]  [<ffffffff811afeec>] ? bdi_writeback_workfn+0x2c/0x240
[ 4148.493016]  [<ffffffff81065f04>] process_one_work+0x1f4/0x550
[ 4148.493017]  [<ffffffff81065ea2>] ? process_one_work+0x192/0x550
[ 4148.493019]  [<ffffffff81066c71>] worker_thread+0x121/0x3a0
[ 4148.493021]  [<ffffffff81066b50>] ? manage_workers.isra.23+0x2a0/0x2a0
[ 4148.493023]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4148.493025]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4148.493027]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4148.493029]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4148.493053] Code: 00 48 89 e5 5d 48 8b 40 98 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 90 03 00 00 55 48 89 e5 <48> 8b 40 a8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 
[ 4148.493055] RIP  [<ffffffff8106e350>] kthread_data+0x10/0x20
[ 4148.493056]  RSP <ffff8803fad77938>
[ 4148.493057] CR2: ffffffffffffffa8
[ 4148.493058] ---[ end trace cb80c0fefa920c1d ]---
[ 4148.493059] Fixing recursive fault but reboot is needed!
[ 4149.125035] xhci_hcd 0000:05:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff8805fda1a640
[ 4168.318458] ------------[ cut here ]------------
[ 4168.323077] WARNING: CPU: 3 PID: 22 at /home/pc/Linux-src/linux/kernel/watchdog.c:245 watchdog_overflow_callback+0x9e/0xd0()
[ 4168.334273] Watchdog detected hard LOCKUP on cpu 3
[ 4168.338883] Modules linked in: kvm_intel kvm binfmt_misc dm_crypt snd_hda_codec_hdmi snd_hda_codec_realtek nls_iso8859_1 joydev hid_generic hid_logitech_dj mxm_wmi snd_hda_intel usb_storage snd_hda_codec usbhid snd_hwdep hid snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq psmouse lpc_ich serio_raw snd_seq_device snd_timer snd soundcore snd_page_alloc wmi mac_hid it87 hwmon_vid coretemp r8169 eeprom_93cx6 mii pci_stub i915 drm_kms_helper ahci libahci drm i2c_algo_bit video
[ 4168.382620] CPU: 3 PID: 22 Comm: migration/3 Tainted: G      D      3.11.0-rc5-cold-00259-gd5f955d #1
[ 4168.391829] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4168.402069]  0000000000000009 ffff88061f386bb8 ffffffff81656d8d 0000000000000000
[ 4168.409518]  ffff88061f386c08 ffff88061f386bf8 ffffffff81047e41 0000000000000000
[ 4168.416970]  ffff880603710000 0000000000000000 ffff88061f386d40 0000000000000000
[ 4168.424420] Call Trace:
[ 4168.426865]  <NMI>  [<ffffffff81656d8d>] dump_stack+0x55/0x76
[ 4168.432637]  [<ffffffff81047e41>] warn_slowpath_common+0x81/0xa0
[ 4168.438639]  [<ffffffff81047ea6>] warn_slowpath_fmt+0x46/0x50
[ 4168.444375]  [<ffffffff810d9b80>] ? watchdog_enable_all_cpus.part.1+0x50/0x50
[ 4168.451504]  [<ffffffff810d9c1e>] watchdog_overflow_callback+0x9e/0xd0
[ 4168.458020]  [<ffffffff8111bc32>] __perf_event_overflow+0x92/0x280
[ 4168.464190]  [<ffffffff8111a907>] ? perf_event_update_userpage+0x117/0x1a0
[ 4168.471060]  [<ffffffff8111a7f0>] ? perf_event_task_disable+0x90/0x90
[ 4168.477489]  [<ffffffff8111c8b4>] perf_event_overflow+0x14/0x20
[ 4168.483407]  [<ffffffff8101aa76>] intel_pmu_handle_irq+0x1b6/0x3b0
[ 4168.489583]  [<ffffffff816634c4>] perf_event_nmi_handler+0x34/0x60
[ 4168.495751]  [<ffffffff81662aa8>] nmi_handle.isra.3+0xc8/0x1f0
[ 4168.501575]  [<ffffffff816629e5>] ? nmi_handle.isra.3+0x5/0x1f0
[ 4168.507482]  [<ffffffff81662cd0>] do_nmi+0x100/0x370
[ 4168.512437]  [<ffffffff81662097>] end_repeat_nmi+0x1e/0x2e
[ 4168.517914]  [<ffffffff81323f21>] ? do_raw_spin_lock+0x101/0x150
[ 4168.523909]  [<ffffffff81323f21>] ? do_raw_spin_lock+0x101/0x150
[ 4168.529913]  [<ffffffff81323f21>] ? do_raw_spin_lock+0x101/0x150
[ 4168.535908]  <<EOE>>  [<ffffffff81660d09>] _raw_spin_lock+0x49/0x50
[ 4168.542192]  [<ffffffff8107d357>] ? __migrate_task+0x97/0x190
[ 4168.547935]  [<ffffffff8107d357>] __migrate_task+0x97/0x190
[ 4168.553506]  [<ffffffff8107d450>] ? __migrate_task+0x190/0x190
[ 4168.559336]  [<ffffffff8107d47a>] migration_cpu_stop+0x2a/0x40
[ 4168.565159]  [<ffffffff810cc9b1>] ? cpu_stop_should_run+0x31/0x60
[ 4168.571247]  [<ffffffff810ccaed>] cpu_stopper_thread+0x9d/0x160
[ 4168.577157]  [<ffffffff810cc9c8>] ? cpu_stop_should_run+0x48/0x60
[ 4168.583241]  [<ffffffff810aa94d>] ? trace_hardirqs_on+0xd/0x10
[ 4168.589071]  [<ffffffff81076bf0>] smpboot_thread_fn+0x160/0x1f0
[ 4168.594978]  [<ffffffff81076a90>] ? lg_local_lock+0x80/0x80
[ 4168.600542]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4168.605410]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4168.611753]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4168.617141]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4168.623481] ---[ end trace cb80c0fefa920c1e ]---
[ 4168.628091] perf samples too long (2420229 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 4168.637465] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 319.008 msecs
[ 4178.014082] perf samples too long (2401326 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[ 4187.398910] perf samples too long (2382572 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
[ 4196.784840] perf samples too long (2363963 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
[ 4206.169691] perf samples too long (2345499 > 40000), lowering kernel.perf_event_max_sample_rate to 3250
[ 4209.123651] INFO: rcu_sched detected stalls on CPUs/tasks: { 0 3} (detected by 2, t=15002 jiffies, g=44392, c=44391, q=217)
[ 4209.134848] sending NMI to all CPUs:
[ 4209.138419] perf samples too long (2327177 > 76923), lowering kernel.perf_event_max_sample_rate to 1750
[ 4209.138420] NMI backtrace for cpu 0
[ 4209.138421] CPU: 0 PID: 4120 Comm: kworker/u8:2 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4209.138422] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4209.138428] task: ffff88059a1a0000 ti: ffff8803fad76000 task.ti: ffff8803fad76000
[ 4209.138430] RIP: 0010:[<ffffffff8131b62b>]  [<ffffffff8131b62b>] delay_tsc+0x2b/0x90
[ 4209.138431] RSP: 0018:ffff8803fad77518  EFLAGS: 00000006
[ 4209.138432] RAX: 000000006009be45 RBX: ffff88061f213f80 RCX: 0000000000000000
[ 4209.138432] RDX: 0000000000000b81 RSI: 000000006009bdee RDI: 0000000000000001
[ 4209.138433] RBP: ffff8803fad77518 R08: 0000000000000000 R09: ffff8803fad77fd8
[ 4209.138433] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000093bdf870
[ 4209.138434] R13: 00000000b26645d8 R14: ffff88059a1a0000 R15: 0000000000030001
[ 4209.138435] FS:  0000000000000000(0000) GS:ffff88061f200000(0000) knlGS:0000000000000000
[ 4209.138435] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4209.138436] CR2: 0000000000000028 CR3: 00000005fee05000 CR4: 00000000000407f0
[ 4209.138436] Stack:
[ 4209.138438]  ffff8803fad77528 ffffffff8131b53f ffff8803fad77558 ffffffff81323f11
[ 4209.138439]  0000000000000000 ffff88061f213f80 0000000000000000 ffff8803fad77888
[ 4209.138440]  ffff8803fad77588 ffffffff81660ebf ffffffff8165e5b5 0000000000000000
[ 4209.138441] Call Trace:
[ 4209.138442]  [<ffffffff8131b53f>] __delay+0xf/0x20
[ 4209.138443]  [<ffffffff81323f11>] do_raw_spin_lock+0xf1/0x150
[ 4209.138445]  [<ffffffff81660ebf>] _raw_spin_lock_irq+0x4f/0x60
[ 4209.138447]  [<ffffffff8165e5b5>] ? __schedule+0xb5/0x740
[ 4209.138448]  [<ffffffff8165e5b5>] __schedule+0xb5/0x740
[ 4209.138450]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4209.138452]  [<ffffffff8104ac0c>] do_exit+0x43c/0x470
[ 4209.138454]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4209.138456]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4209.138458]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4209.138459]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4209.138462]  [<ffffffff811c6ae4>] ? fsnotify_clear_marks_by_inode+0x34/0x130
[ 4209.138464]  [<ffffffff8164dc9e>] bad_area_nosemaphore+0x13/0x15
[ 4209.138466]  [<ffffffff8166578e>] __do_page_fault+0x34e/0x550
[ 4209.138467]  [<ffffffff810935b7>] ? cpuacct_charge+0xa7/0xd0
[ 4209.138468]  [<ffffffff81093515>] ? cpuacct_charge+0x5/0xd0
[ 4209.138470]  [<ffffffff81086601>] ? update_curr+0x141/0x220
[ 4209.138471]  [<ffffffff8131cbad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 4209.138473]  [<ffffffff8166599e>] do_page_fault+0xe/0x10
[ 4209.138474]  [<ffffffff81661ce2>] page_fault+0x22/0x30
[ 4209.138476]  [<ffffffff8106e350>] ? kthread_data+0x10/0x20
[ 4209.138478]  [<ffffffff81066f75>] wq_worker_sleeping+0x15/0xa0
[ 4209.138480]  [<ffffffff8165eb0f>] __schedule+0x60f/0x740
[ 4209.138481]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4209.138482]  [<ffffffff8104aa7d>] do_exit+0x2ad/0x470
[ 4209.138484]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4209.138485]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4209.138486]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4209.138488]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4209.138489]  [<ffffffff8164dc9e>] bad_area_nosemaphore+0x13/0x15
[ 4209.138491]  [<ffffffff8166578e>] __do_page_fault+0x34e/0x550
[ 4209.138492]  [<ffffffff810abb3b>] ? __lock_acquire+0x3eb/0xab0
[ 4209.138493]  [<ffffffff8131cbad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 4209.138495]  [<ffffffff8166599e>] do_page_fault+0xe/0x10
[ 4209.138496]  [<ffffffff81661ce2>] page_fault+0x22/0x30
[ 4209.138499]  [<ffffffff811afeec>] ? bdi_writeback_workfn+0x2c/0x240
[ 4209.138500]  [<ffffffff81065f04>] process_one_work+0x1f4/0x550
[ 4209.138502]  [<ffffffff81065ea2>] ? process_one_work+0x192/0x550
[ 4209.138503]  [<ffffffff81066c71>] worker_thread+0x121/0x3a0
[ 4209.138505]  [<ffffffff81066b50>] ? manage_workers.isra.23+0x2a0/0x2a0
[ 4209.138506]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4209.138507]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4209.138508]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4209.138509]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4209.138522] Code: 66 66 66 66 90 55 65 4c 8b 0c 25 30 ba 00 00 48 89 e5 41 83 81 44 e0 ff ff 01 65 44 8b 04 25 64 b0 00 00 66 66 90 0f ae e8 0f 31 <89> c6 eb 1f 90 49 8d 91 28 e0 ff ff 83 6a 1c 01 f3 90 83 42 1c 
[ 4209.138524] NMI backtrace for cpu 1
[ 4209.138525] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4209.138526] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4209.138527] task: ffff88060360bf60 ti: ffff880603614000 task.ti: ffff880603614000
[ 4209.138529] RIP: 0010:[<ffffffff8131b656>]  [<ffffffff8131b656>] delay_tsc+0x56/0x90
[ 4209.138530] RSP: 0018:ffff88061f283d88  EFLAGS: 00000006
[ 4209.138531] RAX: 000000006009be45 RBX: ffff88061f213f80 RCX: 0000000000000000
[ 4209.138531] RDX: 0000000000000b81 RSI: 000000006009be2a RDI: 0000000000000001
[ 4209.138532] RBP: ffff88061f283d88 R08: 0000000000000001 R09: ffff880603615fd8
[ 4209.138532] R10: 0000000000000000 R11: 0000000000000000 R12: 000000008dc64408
[ 4209.138533] R13: 00000000b26645d8 R14: ffffffff81e5ecc0 R15: 0000000000000001
[ 4209.138534] FS:  0000000000000000(0000) GS:ffff88061f280000(0000) knlGS:0000000000000000
[ 4209.138534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4209.138535] CR2: 00007f671af00be0 CR3: 0000000001c0b000 CR4: 00000000000407e0
[ 4209.138535] Stack:
[ 4209.138537]  ffff88061f283d98 ffffffff8131b53f ffff88061f283dc8 ffffffff81323f11
[ 4209.138539]  ffffffff81ceb240 ffff88061f213f80 ffffffff81ceb240 0000000000000001
[ 4209.138540]  ffff88061f283df8 ffffffff81660d09 ffffffff8108db6e 0000000000000000
[ 4209.138540] Call Trace:
[ 4209.138541]  <IRQ> 
[ 4209.138542]  [<ffffffff8131b53f>] __delay+0xf/0x20
[ 4209.138544]  [<ffffffff81323f11>] do_raw_spin_lock+0xf1/0x150
[ 4209.138545]  [<ffffffff81660d09>] _raw_spin_lock+0x49/0x50
[ 4209.138547]  [<ffffffff8108db6e>] ? do_sched_rt_period_timer+0x11e/0x330
[ 4209.138549]  [<ffffffff8108db6e>] do_sched_rt_period_timer+0x11e/0x330
[ 4209.138551]  [<ffffffff81071706>] ? __run_hrtimer+0x66/0x230
[ 4209.138552]  [<ffffffff8108ddaa>] sched_rt_period_timer+0x2a/0x60
[ 4209.138554]  [<ffffffff81071714>] __run_hrtimer+0x74/0x230
[ 4209.138555]  [<ffffffff8108dd80>] ? do_sched_rt_period_timer+0x330/0x330
[ 4209.138557]  [<ffffffff81071f97>] hrtimer_interrupt+0xf7/0x240
[ 4209.138559]  [<ffffffff8102b32b>] local_apic_timer_interrupt+0x3b/0x70
[ 4209.138561]  [<ffffffff8166c3e5>] smp_apic_timer_interrupt+0x45/0x60
[ 4209.138562]  [<ffffffff8166b06f>] apic_timer_interrupt+0x6f/0x80
[ 4209.138563]  <EOI> 
[ 4209.138564]  [<ffffffff81071e96>] ? hrtimer_get_next_event+0xb6/0xc0
[ 4209.138567]  [<ffffffff8151e943>] ? cpuidle_enter_state+0x63/0xe0
[ 4209.138569]  [<ffffffff8151e93f>] ? cpuidle_enter_state+0x5f/0xe0
[ 4209.138571]  [<ffffffff81520316>] ? menu_select+0x206/0x3f0
[ 4209.138572]  [<ffffffff8151ea80>] cpuidle_idle_call+0xc0/0x270
[ 4209.138574]  [<ffffffff81665a15>] ? atomic_notifier_call_chain+0x5/0xa0
[ 4209.138576]  [<ffffffff8100b98e>] arch_cpu_idle+0xe/0x30
[ 4209.138578]  [<ffffffff81099a5e>] cpu_startup_entry+0xce/0x2a0
[ 4209.138579]  [<ffffffff81029b22>] start_secondary+0x1e2/0x240
[ 4209.138593] Code: 89 c6 eb 1f 90 49 8d 91 28 e0 ff ff 83 6a 1c 01 f3 90 83 42 1c 01 65 8b 0c 25 64 b0 00 00 41 39 c8 75 22 66 66 90 0f ae e8 0f 31 <89> c2 29 f2 39 fa 72 d2 65 48 8b 04 25 30 ba 00 00 83 a8 44 e0 
[ 4209.138593] NMI backtrace for cpu 2
[ 4209.138595] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4209.138595] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4209.138596] task: ffff88060360df10 ti: ffff880603616000 task.ti: ffff880603616000
[ 4209.138599] RIP: 0010:[<ffffffff8131e220>]  [<ffffffff8131e220>] kasprintf+0x40/0x40
[ 4209.138600] RSP: 0018:ffff88061f303d40  EFLAGS: 00000092
[ 4209.138600] RAX: ffff88060360df10 RBX: 0000000000002710 RCX: ffffffff81c20840
[ 4209.138601] RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff81cead40
[ 4209.138601] RBP: ffff88061f303d58 R08: 0000000000000002 R09: 0000000000000000
[ 4209.138602] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000002
[ 4209.138602] R13: 00000000000000d9 R14: ffffffff81ceb260 R15: 0000000000000082
[ 4209.138603] FS:  0000000000000000(0000) GS:ffff88061f300000(0000) knlGS:0000000000000000
[ 4209.138604] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4209.138605] CR2: 000000000061ac88 CR3: 0000000001c0b000 CR4: 00000000000407e0
[ 4209.138605] Stack:
[ 4209.138607]  ffffffff8102d130 0000000000000000 ffffffff81c4fcc0 ffff88061f303da8
[ 4209.138608]  ffffffff810e15e7 ffff880603631e00 0000000000000082 ffff88061f303de8
[ 4209.138609]  ffff88061f30e0e0 ffffffff81c4fcc0 ffffffff81c4fcc0 0000000000000002
[ 4209.138610] Call Trace:
[ 4209.138611]  <IRQ> 
[ 4209.138613]  [<ffffffff8102d130>] ? arch_trigger_all_cpu_backtrace+0x80/0x90
[ 4209.138616]  [<ffffffff810e15e7>] print_other_cpu_stall+0x1f7/0x230
[ 4209.138618]  [<ffffffff810e3814>] __rcu_pending+0x174/0x1d0
[ 4209.138620]  [<ffffffff8109c632>] ? update_wall_time+0x22/0x600
[ 4209.138621]  [<ffffffff810e452d>] rcu_check_callbacks+0xed/0x1f0
[ 4209.138623]  [<ffffffff810575ab>] update_process_times+0x4b/0x80
[ 4209.138625]  [<ffffffff810a4b25>] tick_sched_handle.isra.15+0x25/0x60
[ 4209.138626]  [<ffffffff810a4ba5>] tick_sched_timer+0x45/0x70
[ 4209.138628]  [<ffffffff81071714>] __run_hrtimer+0x74/0x230
[ 4209.138629]  [<ffffffff810a4b60>] ? tick_sched_handle.isra.15+0x60/0x60
[ 4209.138631]  [<ffffffff81071f97>] hrtimer_interrupt+0xf7/0x240
[ 4209.138633]  [<ffffffff8102b32b>] local_apic_timer_interrupt+0x3b/0x70
[ 4209.138634]  [<ffffffff8166c3e5>] smp_apic_timer_interrupt+0x45/0x60
[ 4209.138636]  [<ffffffff8166b06f>] apic_timer_interrupt+0x6f/0x80
[ 4209.138636]  <EOI> 
[ 4209.138638]  [<ffffffff8151e943>] ? cpuidle_enter_state+0x63/0xe0
[ 4209.138640]  [<ffffffff8151e93f>] ? cpuidle_enter_state+0x5f/0xe0
[ 4209.138641]  [<ffffffff81520316>] ? menu_select+0x206/0x3f0
[ 4209.138643]  [<ffffffff8151ea80>] cpuidle_idle_call+0xc0/0x270
[ 4209.138645]  [<ffffffff81665a15>] ? atomic_notifier_call_chain+0x5/0xa0
[ 4209.138646]  [<ffffffff8100b98e>] arch_cpu_idle+0xe/0x30
[ 4209.138648]  [<ffffffff81099a5e>] cpu_startup_entry+0xce/0x2a0
[ 4209.138649]  [<ffffffff81029b22>] start_secondary+0x1e2/0x240
[ 4209.138662] Code: 89 4d e8 4c 89 45 f0 48 89 45 c0 48 8d 45 d0 4c 89 4d f8 c7 45 b8 10 00 00 00 48 89 45 c8 e8 48 ff ff ff c9 c3 66 0f 1f 44 00 00 <8d> 4e 3f 85 f6 55 0f 49 ce 48 89 e5 c1 f9 06 85 c9 7e 61 31 c0 
[ 4210.103199] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 964.779 msecs
[ 4210.111447] NMI backtrace for cpu 3
[ 4210.114929] CPU: 3 PID: 22 Comm: migration/3 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4210.124130] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4210.134370] task: ffff8806036f8000 ti: ffff880603700000 task.ti: ffff880603700000
[ 4210.141838] RIP: 0010:[<ffffffff8131b62d>]  [<ffffffff8131b62d>] delay_tsc+0x2d/0x90
[ 4210.149583] RSP: 0018:ffff880603701c38  EFLAGS: 00000002
[ 4210.154886] RAX: 000000006009be42 RBX: ffff88061f213f80 RCX: 0000000000000000
[ 4210.162007] RDX: 0000000000000b81 RSI: 000000006009be42 RDI: 0000000000000001
[ 4210.169130] RBP: ffff880603701c38 R08: 0000000000000003 R09: ffff880603701fd8
[ 4210.176252] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000914e3837
[ 4210.183374] R13: 00000000b26645d8 R14: 0000000000000000 R15: 0000000000000003
[ 4210.190494] FS:  0000000000000000(0000) GS:ffff88061f380000(0000) knlGS:0000000000000000
[ 4210.198568] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4210.204304] CR2: 00007fa845341044 CR3: 00000005fccf6000 CR4: 00000000000407e0
[ 4210.211425] Stack:
[ 4210.213437]  ffff880603701c48 ffffffff8131b53f ffff880603701c78 ffffffff81323f11
[ 4210.220887]  ffff88061f213f80 ffff88061f213f80 ffff88061f213f80 ffff8805fd5a1fb0
[ 4210.228337]  ffff880603701ca8 ffffffff81660d09 ffffffff8107d357 ffff880603701fd8
[ 4210.235789] Call Trace:
[ 4210.238233]  [<ffffffff8131b53f>] __delay+0xf/0x20
[ 4210.243014]  [<ffffffff81323f11>] do_raw_spin_lock+0xf1/0x150
[ 4210.248752]  [<ffffffff81660d09>] _raw_spin_lock+0x49/0x50
[ 4210.254228]  [<ffffffff8107d357>] ? __migrate_task+0x97/0x190
[ 4210.259963]  [<ffffffff8107d357>] __migrate_task+0x97/0x190
[ 4210.265524]  [<ffffffff8107d450>] ? __migrate_task+0x190/0x190
[ 4210.271347]  [<ffffffff8107d47a>] migration_cpu_stop+0x2a/0x40
[ 4210.277168]  [<ffffffff810cc9b1>] ? cpu_stop_should_run+0x31/0x60
[ 4210.283250]  [<ffffffff810ccaed>] cpu_stopper_thread+0x9d/0x160
[ 4210.289160]  [<ffffffff810cc9c8>] ? cpu_stop_should_run+0x48/0x60
[ 4210.295243]  [<ffffffff810aa94d>] ? trace_hardirqs_on+0xd/0x10
[ 4210.301073]  [<ffffffff81076bf0>] smpboot_thread_fn+0x160/0x1f0
[ 4210.306981]  [<ffffffff81076a90>] ? lg_local_lock+0x80/0x80
[ 4210.312544]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4210.317412]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4210.323754]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4210.329144]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4210.335485] Code: 66 66 90 55 65 4c 8b 0c 25 30 ba 00 00 48 89 e5 41 83 81 44 e0 ff ff 01 65 44 8b 04 25 64 b0 00 00 66 66 90 0f ae e8 0f 31 89 c6 <eb> 1f 90 49 8d 91 28 e0 ff ff 83 6a 1c 01 f3 90 83 42 1c 01 65 
[ 4215.753418] perf samples too long (2309006 > 142857), lowering kernel.perf_event_max_sample_rate to 1000
[ 4222.105428] BUG: spinlock lockup suspected on CPU#0, kworker/u8:2/4120
[ 4222.111952]  lock: 0xffff88061f213f80, .magic: dead4ead, .owner: kworker/u8:2/4120, .owner_cpu: 0
[ 4222.120810] CPU: 0 PID: 4120 Comm: kworker/u8:2 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4222.130271] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4222.140515]  ffff88061f213f80 ffff8803fad77508 ffffffff81656d8d 0000000000000000
[ 4222.147969]  ffff88059a1a0000 ffff8803fad77528 ffffffff81656e3a ffff88061f213f80
[ 4222.155421]  00000000b26645d8 ffff8803fad77558 ffffffff81323e93 0000000000000000
[ 4222.162873] Call Trace:
[ 4222.165317]  [<ffffffff81656d8d>] dump_stack+0x55/0x76
[ 4222.170446]  [<ffffffff81656e3a>] spin_dump+0x8c/0x91
[ 4222.175487]  [<ffffffff81323e93>] do_raw_spin_lock+0x73/0x150
[ 4222.181225]  [<ffffffff81660ebf>] _raw_spin_lock_irq+0x4f/0x60
[ 4222.187055]  [<ffffffff8165e5b5>] ? __schedule+0xb5/0x740
[ 4222.192444]  [<ffffffff8165e5b5>] __schedule+0xb5/0x740
[ 4222.197669]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4222.202631]  [<ffffffff8104ac0c>] do_exit+0x43c/0x470
[ 4222.207675]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4222.212984]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4222.217941]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4222.223242]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4222.229585]  [<ffffffff811c6ae4>] ? fsnotify_clear_marks_by_inode+0x34/0x130
[ 4222.236621]  [<ffffffff8164dc9e>] bad_area_nosemaphore+0x13/0x15
[ 4222.242625]  [<ffffffff8166578e>] __do_page_fault+0x34e/0x550
[ 4222.248360]  [<ffffffff810935b7>] ? cpuacct_charge+0xa7/0xd0
[ 4222.254009]  [<ffffffff81093515>] ? cpuacct_charge+0x5/0xd0
[ 4222.259572]  [<ffffffff81086601>] ? update_curr+0x141/0x220
[ 4222.265141]  [<ffffffff8131cbad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 4222.271656]  [<ffffffff8166599e>] do_page_fault+0xe/0x10
[ 4222.276959]  [<ffffffff81661ce2>] page_fault+0x22/0x30
[ 4222.282088]  [<ffffffff8106e350>] ? kthread_data+0x10/0x20
[ 4222.287564]  [<ffffffff81066f75>] wq_worker_sleeping+0x15/0xa0
[ 4222.293385]  [<ffffffff8165eb0f>] __schedule+0x60f/0x740
[ 4222.298687]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4222.303643]  [<ffffffff8104aa7d>] do_exit+0x2ad/0x470
[ 4222.308686]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4222.313988]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4222.318945]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4222.324246]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4222.330589]  [<ffffffff8164dc9e>] bad_area_nosemaphore+0x13/0x15
[ 4222.336582]  [<ffffffff8166578e>] __do_page_fault+0x34e/0x550
[ 4222.342318]  [<ffffffff810abb3b>] ? __lock_acquire+0x3eb/0xab0
[ 4222.348142]  [<ffffffff8131cbad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 4222.354666]  [<ffffffff8166599e>] do_page_fault+0xe/0x10
[ 4222.359976]  [<ffffffff81661ce2>] page_fault+0x22/0x30
[ 4222.365106]  [<ffffffff811afeec>] ? bdi_writeback_workfn+0x2c/0x240
[ 4222.371368]  [<ffffffff81065f04>] process_one_work+0x1f4/0x550
[ 4222.377191]  [<ffffffff81065ea2>] ? process_one_work+0x192/0x550
[ 4222.383185]  [<ffffffff81066c71>] worker_thread+0x121/0x3a0
[ 4222.388750]  [<ffffffff81066b50>] ? manage_workers.isra.23+0x2a0/0x2a0
[ 4222.395271]  [<ffffffff8106e30a>] kthread+0xea/0xf0
[ 4222.400141]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4222.406485]  [<ffffffff8166a35c>] ret_from_fork+0x7c/0xb0
[ 4222.411880]  [<ffffffff8106e220>] ? flush_kthread_worker+0x150/0x150
[ 4222.418222] sending NMI to all CPUs:
[ 4222.421792] perf samples too long (2290970 > 250000), lowering kernel.perf_event_max_sample_rate to 500
[ 4222.421794] NMI backtrace for cpu 1
[ 4222.421795] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4222.421795] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4222.421796] task: ffff88060360bf60 ti: ffff880603614000 task.ti: ffff880603614000
[ 4222.421798] RIP: 0010:[<ffffffff8131b658>]  [<ffffffff8131b658>] delay_tsc+0x58/0x90
[ 4222.421798] RSP: 0018:ffff88061f283d88  EFLAGS: 00000006
[ 4222.421799] RAX: 00000000a2a9027f RBX: ffff88061f213f80 RCX: 0000000000000000
[ 4222.421800] RDX: 00000000a2a9027f RSI: 00000000a2a90264 RDI: 0000000000000001
[ 4222.421800] RBP: ffff88061f283d88 R08: 0000000000000001 R09: ffff880603615fd8
[ 4222.421801] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ad2e0214
[ 4222.421801] R13: 00000000b26645d8 R14: ffffffff81e5ecc0 R15: 0000000000000001
[ 4222.421802] FS:  0000000000000000(0000) GS:ffff88061f280000(0000) knlGS:0000000000000000
[ 4222.421803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4222.421803] CR2: 00007f671af00be0 CR3: 0000000001c0b000 CR4: 00000000000407e0
[ 4222.421804] Stack:
[ 4222.421805]  ffff88061f283d98 ffffffff8131b53f ffff88061f283dc8 ffffffff81323f11
[ 4222.421806]  ffffffff81ceb240 ffff88061f213f80 ffffffff81ceb240 0000000000000001
[ 4222.421808]  ffff88061f283df8 ffffffff81660d09 ffffffff8108db6e 0000000000000000
[ 4222.421808] Call Trace:
[ 4222.421809]  <IRQ> 
[ 4222.421809]  [<ffffffff8131b53f>] __delay+0xf/0x20
[ 4222.421811]  [<ffffffff81323f11>] do_raw_spin_lock+0xf1/0x150
[ 4222.421812]  [<ffffffff81660d09>] _raw_spin_lock+0x49/0x50
[ 4222.421814]  [<ffffffff8108db6e>] ? do_sched_rt_period_timer+0x11e/0x330
[ 4222.421816]  [<ffffffff8108db6e>] do_sched_rt_period_timer+0x11e/0x330
[ 4222.421817]  [<ffffffff81071706>] ? __run_hrtimer+0x66/0x230
[ 4222.421819]  [<ffffffff8108ddaa>] sched_rt_period_timer+0x2a/0x60
[ 4222.421820]  [<ffffffff81071714>] __run_hrtimer+0x74/0x230
[ 4222.421822]  [<ffffffff8108dd80>] ? do_sched_rt_period_timer+0x330/0x330
[ 4222.421823]  [<ffffffff81071f97>] hrtimer_interrupt+0xf7/0x240
[ 4222.421825]  [<ffffffff8102b32b>] local_apic_timer_interrupt+0x3b/0x70
[ 4222.421827]  [<ffffffff8166c3e5>] smp_apic_timer_interrupt+0x45/0x60
[ 4222.421828]  [<ffffffff8166b06f>] apic_timer_interrupt+0x6f/0x80
[ 4222.421829]  <EOI> 
[ 4222.421830]  [<ffffffff81071e96>] ? hrtimer_get_next_event+0xb6/0xc0
[ 4222.421832]  [<ffffffff8151e943>] ? cpuidle_enter_state+0x63/0xe0
[ 4222.421834]  [<ffffffff8151e93f>] ? cpuidle_enter_state+0x5f/0xe0
[ 4222.421836]  [<ffffffff81520316>] ? menu_select+0x206/0x3f0
[ 4222.421837]  [<ffffffff8151ea80>] cpuidle_idle_call+0xc0/0x270
[ 4222.421839]  [<ffffffff81665a15>] ? atomic_notifier_call_chain+0x5/0xa0
[ 4222.421841]  [<ffffffff8100b98e>] arch_cpu_idle+0xe/0x30
[ 4222.421842]  [<ffffffff81099a5e>] cpu_startup_entry+0xce/0x2a0
[ 4222.421844]  [<ffffffff81029b22>] start_secondary+0x1e2/0x240
[ 4222.421857] Code: eb 1f 90 49 8d 91 28 e0 ff ff 83 6a 1c 01 f3 90 83 42 1c 01 65 8b 0c 25 64 b0 00 00 41 39 c8 75 22 66 66 90 0f ae e8 0f 31 89 c2 <29> f2 39 fa 72 d2 65 48 8b 04 25 30 ba 00 00 83 a8 44 e0 ff ff 
[ 4222.421857] NMI backtrace for cpu 0
[ 4222.421858] CPU: 0 PID: 4120 Comm: kworker/u8:2 Tainted: G      D W    3.11.0-rc5-cold-00259-gd5f955d #1
[ 4222.421859] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
[ 4222.421863] task: ffff88059a1a0000 ti: ffff8803fad76000 task.ti: ffff8803fad76000
[ 4222.421865] RIP: 0010:[<ffffffff8131b606>]  [<ffffffff8131b606>] delay_tsc+0x6/0x90
[ 4222.421865] RSP: 0018:ffff8803fad774f8  EFLAGS: 00000807
[ 4222.421866] RAX: 000000003b724300 RBX: 0000000000002710 RCX: 00000000016d5cb8
[ 4222.421867] RDX: 00000000002d4e25 RSI: 0000000000000100 RDI: 00000000002d4e26
[ 4222.421867] RBP: ffff8803fad77508 R08: 0000000000000002 R09: 0000000000000000
[ 4222.421868] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000b26645d8
[ 4222.421868] R13: 00000000b26645d8 R14: ffff88059a1a0000 R15: 0000000000030001
[ 4222.421869] FS:  0000000000000000(0000) GS:ffff88061f200000(0000) knlGS:0000000000000000
[ 4222.421870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4222.421870] CR2: 0000000000000028 CR3: 00000005fee05000 CR4: 00000000000407f0
[ 4222.421870] Stack:
[ 4222.421872]  ffff8803fad77508 ffffffff8131b57c ffff8803fad77528 ffffffff8102d11a
[ 4222.421873]  0000000000000000 ffff88061f213f80 ffff8803fad77558 ffffffff81323e98
[ 4222.421874]  0000000000000000 ffff88061f213f80 0000000000000000 ffff8803fad77888
[ 4222.421875] Call Trace:
[ 4222.421876]  [<ffffffff8131b57c>] ? __const_udelay+0x2c/0x30
[ 4222.421878]  [<ffffffff8102d11a>] arch_trigger_all_cpu_backtrace+0x6a/0x90
[ 4222.421879]  [<ffffffff81323e98>] do_raw_spin_lock+0x78/0x150
[ 4222.421880]  [<ffffffff81660ebf>] _raw_spin_lock_irq+0x4f/0x60
[ 4222.421882]  [<ffffffff8165e5b5>] ? __schedule+0xb5/0x740
[ 4222.421883]  [<ffffffff8165e5b5>] __schedule+0xb5/0x740
[ 4222.421885]  [<ffffffff8165f709>] schedule+0x29/0x70
[ 4222.421886]  [<ffffffff8104ac0c>] do_exit+0x43c/0x470
[ 4222.421887]  [<ffffffff81099575>] ? kmsg_dump+0x25/0x120
[ 4222.421888]  [<ffffffff816628a9>] oops_end+0xa9/0xf0
[ 4222.421890]  [<ffffffff8164da88>] no_context+0x140/0x14f
[ 4222.421891]  [<ffffffff8164dc6c>] __bad_area_nosemaphore+0x1d5/0x1f4
[ 4222.421893]  [<ffffffff811c6ae4>] ? fsnotify_clear_marks_by_inode+0x34/0x130

