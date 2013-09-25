Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3IYT4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:56:35 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39660 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3IYT4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:56:34 -0400
Date: Wed, 25 Sep 2013 12:56:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130925195628.GA1532@roeck-us.net>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:06:25PM -0400, Josh Boyer wrote:
> Hi All,
> 
> Chris has reported[1] an issue with the applesmc driver in the 3.10
> and 3.11 kernels.  This seems to be a bit transient, but the oops is
> consistent across those releases.  This is with a MacBook Pro 4,1.
> The backtrace is below.
> 
> Any ideas on this one?
> 
Some of the bug reports suggest that there are related messages in at least some
of the kernel logs.

Jul 02 22:23:22 f19s.local kernel: applesmc: send_byte(0x04, 0x0300) fail: 0x01
Jul 02 22:23:22 f19s.local kernel: applesmc: : read len fail

This suggests that initialization may be attempted more than once. The key cache
is allocated only once, but the number of keys is read for each attempt.

No idea if that can happen, but if the number of keys can increase after
the first initialization attempt you would have an explanation for the crash.

Guenter


> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1011719
> 
> BUG: unable to handle kernel paging request at ffff880322aed005
> IP: [<ffffffffa05dd345>] applesmc_get_entry_by_index+0x25/0xf0 [applesmc]
> PGD 1fe5067 PUD 0
> Oops: 0000 [#1] SMP
> Modules linked in: b43 coretemp kvm_intel kvm joydev bcma mac80211
> uvcvideo snd_hda_codec_realtek applesmc(+) iTCO_wdt cfg80211
> iTCO_vendor_support microcode input_polldev snd_hda_intel
> snd_hda_codec i2c_i801 videobuf2_vmalloc videobuf2_memops
> videobuf2_core videodev snd_hwdep snd_seq bcm5974 btusb hid_appleir
> snd_seq_device media bluetooth snd_pcm lpc_ich mfd_core rfkill
> snd_page_alloc snd_timer snd apple_bl soundcore shpchp acpi_cpufreq
> mperf nfsd auth_rpcgss nfs_acl lockd isofs squashfs btrfs libcrc32c
> xor zlib_deflate raid6_pq usb_storage nouveau firewire_ohci
> ata_generic pata_acpi firewire_core crc_itu_t sky2 mxm_wmi wmi
> i2c_algo_bit ssb drm_kms_helper mmc_core ttm drm i2c_core video sunrpc
> loop
> CPU: 1 PID: 492 Comm: systemd-udevd Not tainted 3.11.0-300.fc20.x86_64 #1
> Hardware name: Apple Inc. MacBookPro4,1/Mac-F42C89C8, BIOS
> MBP41.88Z.00C1.B03.0802271651 02/27/08
> task: ffff880132a407a0 ti: ffff8801343fe000 task.ti: ffff8801343fe000
> RIP: 0010:[<ffffffffa05dd345>]  [<ffffffffa05dd345>]
> applesmc_get_entry_by_index+0x25/0xf0 [applesmc]
> RSP: 0018:ffff8801343ffa18  EFLAGS: 00010286
> RAX: 0000000026000000 RBX: ffff880322aed000 RCX: ffff8801343ffaf4
> RDX: 0000000072000000 RSI: ffffffffa05df06e RDI: 0000000026000000
> RBP: ffff8801343ffa38 R08: ffff8801343fe000 R09: ffff880132a6c100
> R10: 0000000000000000 R11: 0000000000014180 R12: 0000000026000000
> R13: 000000004c000001 R14: ffffffffa05df06e R15: ffff8801343ffa84
> FS:  00007f6aac863880(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff880322aed005 CR3: 00000001340fa000 CR4: 00000000000007e0
> Stack:
>  000000000004deef ffffffffffffff10 0000000026000000 0000000000000000
>  ffff8801343ffa70 ffffffffa05dd4f1 0000000000000032 0000000000000001
>  ffffffffa05df06e ffff880134be3810 ffffffffa05e0660 ffff8801343ffaa8
> Call Trace:
>  [<ffffffffa05dd4f1>] applesmc_get_lower_bound+0x51/0xa0 [applesmc]
>  [<ffffffffa05dd563>] applesmc_get_entry_by_key+0x23/0xc0 [applesmc]
>  [<ffffffffa05dd9f9>] applesmc_read_key+0x19/0x70 [applesmc]
>  [<ffffffffa05de08f>] applesmc_init_smcreg+0x8f/0x2d0 [applesmc]
>  [<ffffffffa05de2e2>] applesmc_probe+0x12/0x30 [applesmc]
>  [<ffffffff813f41dc>] platform_drv_probe+0x3c/0x70
>  [<ffffffff813f18b2>] ? driver_sysfs_add+0x82/0xb0
>  [<ffffffff813f1f77>] driver_probe_device+0x87/0x390
>  [<ffffffff813f2280>] ? driver_probe_device+0x390/0x390
>  [<ffffffff813f22bb>] __device_attach+0x3b/0x40
>  [<ffffffff813eff73>] bus_for_each_drv+0x63/0xa0
>  [<ffffffff813f1e78>] device_attach+0x88/0xa0
>  [<ffffffff813f11e8>] bus_probe_device+0x98/0xc0
>  [<ffffffff813eeeb4>] device_add+0x4c4/0x7a0
>  [<ffffffff813f3cb1>] platform_device_add+0xd1/0x2d0
>  [<ffffffff813f4430>] platform_device_register_full+0xe0/0x120
>  [<ffffffffa05e3000>] ? 0xffffffffa05e2fff
>  [<ffffffffa05e3098>] applesmc_init+0x98/0x1000 [applesmc]
>  [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
>  [<ffffffff81052483>] ? set_memory_nx+0x43/0x50
>  [<ffffffff810cc58d>] load_module+0x1bbd/0x2660
>  [<ffffffff810c8890>] ? store_uevent+0x40/0x40
>  [<ffffffff810cd1a6>] SyS_finit_module+0x86/0xb0
>  [<ffffffff81652cd9>] system_call_fastpath+0x16/0x1b
> Code: 84 00 00 00 00 00 66 66 66 66 90 55 48 63 c7 48 8d 14 40 48 89
> e5 41 54 41 89 fc 53 48 8d 1c 90 48 83 ec 10 48 03 1d 03 33 00 00 <80>
> 7b 05 00 48 89 d8 74 12 48 83 c4 10 5b 41 5c 5d c3 66 0f 1f
> RIP  [<ffffffffa05dd345>] applesmc_get_entry_by_index+0x25/0xf0 [applesmc]
>  RSP <ffff8801343ffa18>
> 
