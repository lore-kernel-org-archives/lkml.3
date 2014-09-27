Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaI0KXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:23:41 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45414 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaI0KXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:23:38 -0400
Date: Sat, 27 Sep 2014 11:23:35 +0100
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: Hang in blkdev_get
Message-ID: <20140927102335.GA1938@hobo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I plugged a USB disk in, then did "dd if=iso of=/dev/disk/by-id/usb...".
I got the following in dmesg:

[39752.343246] INFO: task systemd-udevd:160 blocked for more than 120 seconds.
[39752.343249]       Not tainted 3.14.4-1-ARCH #1
[39752.343250] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[39752.343251] systemd-udevd   D 0000000000000000     0   160      1 0x00000000
[39752.343254]  ffff8802132dbb00 0000000000000086 ffff8802132dbad0 ffff8802136ace80
[39752.343256]  00000000000146c0 ffff8802132dbfd8 00000000000146c0 ffff8802136ace80
[39752.343257]  0000000000000000 0000000000000001 ffff8802136ace80 ffffffff810a0d40
[39752.343259] Call Trace:
[39752.343265]  [<ffffffff810a0d40>] ? wake_up_process+0x50/0x50
[39752.343267]  [<ffffffff8150c2dd>] ? wait_for_completion+0x1d/0x20
[39752.343270]  [<ffffffff810875b9>] ? flush_work+0xe9/0x170
[39752.343271]  [<ffffffff810853c0>] ? work_busy+0x80/0x80
[39752.343273]  [<ffffffff8150b729>] schedule+0x29/0x70
[39752.343275]  [<ffffffff8150bba6>] schedule_preempt_disabled+0x16/0x20
[39752.343277]  [<ffffffff8150d5f5>] __mutex_lock_slowpath+0x175/0x230
[39752.343288]  [<ffffffff8150d6c7>] mutex_lock+0x17/0x30
[39752.343290]  [<ffffffff811f672b>] __blkdev_get+0x7b/0x4d0
[39752.343291]  [<ffffffff811f6f70>] ? blkdev_get_by_dev+0x50/0x50
[39752.343293]  [<ffffffff811f6bd0>] blkdev_get+0x50/0x3a0
[39752.343294]  [<ffffffff811f6f70>] ? blkdev_get_by_dev+0x50/0x50
[39752.343295]  [<ffffffff811f6fcb>] blkdev_open+0x5b/0x80
[39752.343297]  [<ffffffff811b85a7>] do_dentry_open+0x1c7/0x2d0
[39752.343298]  [<ffffffff811b8a51>] finish_open+0x31/0x50
[39752.343301]  [<ffffffff811c9342>] do_last.isra.36+0x612/0xe30
[39752.343303]  [<ffffffff811c9c27>] path_openat+0xc7/0x6e0
[39752.343305]  [<ffffffff81184919>] ? free_pages_and_swap_cache+0xb9/0xe0
[39752.343307]  [<ffffffff8116dd85>] ? tlb_finish_mmu+0x45/0x50
[39752.343309]  [<ffffffff811cb44d>] do_filp_open+0x4d/0xc0
[39752.343311]  [<ffffffff811d8317>] ? __alloc_fd+0xa7/0x130
[39752.343313]  [<ffffffff811b9cfe>] do_sys_open+0x14e/0x250
[39752.343314]  [<ffffffff811b9e1e>] SyS_open+0x1e/0x20
[39752.343317]  [<ffffffff81517769>] system_call_fastpath+0x16/0x1b

Running with strace, I see dd opening the device:
open("/dev/disk/by-id/usb-General_UDisk_1403221019040573621805-0:0", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3

and then udevd get a message that the device has changed, and tries to
open it (I think it does this to apply ownership and permissions to the
device):
open("/sys/devices/pci0000:00/0000:00:14.0/usb3/3-5/3-5:1.0/host6/target6:0:0/6:0:0:0/block/sdc/uevent", O_RDONLY|O_CLOEXEC) = 12
open("/dev/sdc", O_RDONLY|O_NONBLOCK|O_NOFOLLOW|O_CLOEXEC

This open then hangs until the dd process finishes.

This is reproducible every time (3.14 and 3.16).  I also saw the following:

[40384.517801] usb 3-5: USB disconnect, device number 4
[40455.060211] sdc: detected capacity change from 1012924416 to 0
[40455.060231] ------------[ cut here ]------------
[40455.060235] WARNING: CPU: 3 PID: 160 at fs/sysfs/group.c:216 sysfs_remove_group+0x99/0xa0()
[40455.060236] sysfs group ffffffff81897ba0 not found for kobject 'target5:0:0'
[40455.060237] Modules linked in: usb_storage fuse snd_hda_codec_realtek
snd_hda_codec_generic coretemp x86_pkg_temp_thermal intel_powerclamp
kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel mousedev
ghash_clmulni_intel eeepc_wmi asus_wmi aesni_intel sparse_keymap
led_class aes_x86_64 rfkill hwmon lrw gf128mul glue_helper snd_hda_intel
iTCO_wdt ablk_helper iTCO_vendor_support cryptd evdev snd_hda_codec
r8169 mac_hid i915 snd_hwdep microcode mii serio_raw pcspkr snd_pcm
i2c_i801 thermal fan drm_kms_helper snd_timer drm tpm_infineon snd
tpm_tis intel_gtt battery i2c_algo_bit soundcore i2c_core tpm video wmi
shpchp mei_me button lpc_ich mei processor ext4 crc16 mbcache jbd2
hid_generic usbhid hid sd_mod crc_t10dif crct10dif_common atkbd libps2
ahci libahci ehci_pci xhci_hcd ehci_hcd libata scsi_mod
[40455.060276]  usbcore usb_common i8042 serio
[40455.060279] CPU: 3 PID: 160 Comm: systemd-udevd Not tainted 3.14.4-1-ARCH #1
[40455.060280] Hardware name: ASUS All Series/H81M-K, BIOS 1002 08/12/2014
[40455.060281]  0000000000000000 000000002eac7960 ffff8802132dbb80 ffffffff8150996e
[40455.060283]  ffff8802132dbbc8 ffff8802132dbbb8 ffffffff8106ab2d 0000000000000000
[40455.060284]  ffffffff81897ba0 ffff8800d2621c38 ffff880212ea4000 ffff880212ea4100
[40455.060286] Call Trace:
[40455.060289]  [<ffffffff8150996e>] dump_stack+0x4d/0x6f
[40455.060291]  [<ffffffff8106ab2d>] warn_slowpath_common+0x7d/0xa0
[40455.060293]  [<ffffffff8106abac>] warn_slowpath_fmt+0x5c/0x80
[40455.060294]  [<ffffffff812346e8>] ? kernfs_find_and_get_ns+0x48/0x60
[40455.060296]  [<ffffffff81232fb9>] sysfs_remove_group+0x99/0xa0
[40455.060299]  [<ffffffff8139e783>] dpm_sysfs_remove+0x43/0x50
[40455.060301]  [<ffffffff81393c35>] device_del+0x45/0x1d0
[40455.060306]  [<ffffffffa00c0067>] scsi_target_reap_usercontext+0x27/0x40 [scsi_mod]
[40455.060318]  [<ffffffff81087297>] execute_in_process_context+0x67/0x70
[40455.060322]  [<ffffffffa00c13a4>] scsi_target_reap+0xc4/0xe0 [scsi_mod]
[40455.060326]  [<ffffffffa00c33b4>] scsi_device_dev_release_usercontext+0x174/0x1a0 [scsi_mod]
[40455.060327]  [<ffffffff81087297>] execute_in_process_context+0x67/0x70
[40455.060331]  [<ffffffffa00c323c>] scsi_device_dev_release+0x1c/0x20 [scsi_mod]
[40455.060332]  [<ffffffff813930c2>] device_release+0x32/0xa0
[40455.060335]  [<ffffffff8129af4a>] kobject_release+0x7a/0x1c0
[40455.060337]  [<ffffffff8129b0bd>] kobject_put+0x2d/0x60
[40455.060338]  [<ffffffff81393507>] put_device+0x17/0x20
[40455.060341]  [<ffffffffa00b6a1a>] scsi_device_put+0x3a/0x50 [scsi_mod]
[40455.060344]  [<ffffffffa01f5810>] scsi_disk_put+0x30/0x50 [sd_mod]
[40455.060347]  [<ffffffffa01f6821>] sd_release+0x31/0x70 [sd_mod]
[40455.060348]  [<ffffffff811f6672>] __blkdev_put+0x182/0x1c0
[40455.060350]  [<ffffffff811f703c>] blkdev_put+0x4c/0x150
[40455.060351]  [<ffffffff811f71f5>] blkdev_close+0x25/0x30
[40455.060353]  [<ffffffff811bc50c>] __fput+0x9c/0x240
[40455.060354]  [<ffffffff811bc6fe>] ____fput+0xe/0x10
[40455.060356]  [<ffffffff8108c24f>] task_work_run+0xaf/0xe0
[40455.060358]  [<ffffffff81016c55>] do_notify_resume+0x95/0xa0
[40455.060360]  [<ffffffff815179a0>] int_signal+0x12/0x17
[40455.060361] ---[ end trace e6961ef54dbee30c ]---


Can anyone shed light on the cause of these messages?  They don't really
cause a problem, other than udevd being blocked for the duration of the
writing.

Thanks
-- 
Ross Lagerwall
