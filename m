Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaKAXSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:18:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33416 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaKAXS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:18:27 -0400
Date: Sat, 1 Nov 2014 16:18:24 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Subject: Re: EFI-related general protection faults
Message-ID: <20141101231824.GB14247@dispater.uplinklabs.net>
References: <20141101130058.GA27241@croesus.uplinklabs.net>
 <20141101131659.GB27241@croesus.uplinklabs.net>
 <20141101214344.GA14247@dispater.uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141101214344.GA14247@dispater.uplinklabs.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Nov 1, 2014 at 2:43 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Nov 1, 2014 at 6:17 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>> On Sat, Nov 1, 2014 at 6:00 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>>> I've been getting general protection faults in EFI modules at boot time
>>> across several machines. I originally thought it was just an EFI quirk
>>> on one machine so I blacklisted the rtc-efi module (which was the
>>> offender at the time), but I've seen it elsewhere since. Once this
>>> happens, the system is only half-usable and needs to reboot. It's also
>>> sadly not 100% reproducible at every boot.
>>>
>>> From what I've observed, it only occurs at boot time when the various
>>> EFI modules are initializing. I haven't yet tested whether I can
>>> trigger it just by unloading/reloading EFI modules repeatedly, but seems
>>> like it'd be worth a shot.
>>>
>>> In two of the three traces below, it seems to happen while two EFI
>>> modules are loading at the same time (rtc_efi and efivars), so perhaps
>>> there's some common data initialization that's racy?
>>
>> Neat. If I do these in two separate shells simultaneously,
>>
>> # while true; do rmmod rtc_efi; modprobe rtc_efi; done
>> # while true; do rmmod efivars; modprobe efivars; done
>>
>> then it faults:
>>
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>> Nov 01 06:10:04 osprey kernel: EFI Variables Facility v0.08 2004-May-17
>> Nov 01 06:10:04 osprey kernel: general protection fault: 0000 [#1] SMP
>> Nov 01 06:10:04 osprey kernel: Modules linked in: rtc_efi(+) efivars(+) sch_sfq bridge stp llc it87 hwmon_vid joydev hid_generic ecb btusb sch_fq_codel bluetooth usbhid hid nls_cp437 vfat fat iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 r8169 cryptd lpc_ich mfd_core mii fan thermal battery tpm_tis tpm evdev snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore acpi_cpufreq processor usbip_host usbip_core msr vhost_scsi target_core_mod crct10dif_generic crct10dif_pclmul configfs vhost_net tun vhost macvtap macvlan kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common
>> Nov 01 06:10:04 osprey kernel:  ahci libahci libata crc32c_intel ehci_pci xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 intel_gtt i2c_algo_bit video drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button [last unloaded: rtc_efi]
>> Nov 01 06:10:04 osprey kernel: CPU: 4 PID: 13264 Comm: modprobe Not tainted 3.17.2-1-ec2 #1
>> Nov 01 06:10:04 osprey kernel: Hardware name: GIGABYTE M4HM87P-00/M4HM87P-00, BIOS F5 06/23/2014
>> Nov 01 06:10:04 osprey kernel: task: ffff880401729d60 ti: ffff8803f869c000 task.ti: ffff8803f869c000
>> Nov 01 06:10:04 osprey kernel: RIP: 0010:[<ffffffff81067dbe>]  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>> Nov 01 06:10:04 osprey kernel: RSP: 0018:ffff8803f869f9b0  EFLAGS: 00010002
>> Nov 01 06:10:04 osprey kernel: RAX: 0000000000000000 RBX: ffff8803f869fb60 RCX: 0000000000000000
>> Nov 01 06:10:04 osprey kernel: RDX: 0000000080020020 RSI: ffff8803f869fb60 RDI: fffffffef0fe3990
>> Nov 01 06:10:04 osprey kernel: RBP: ffff8803f869fa80 R08: ffff8803f869fa90 R09: 000000000000001e
>> Nov 01 06:10:04 osprey kernel: R10: fffffffef0ff7f58 R11: ffff8803f869f8c0 R12: 0000000000000286
>> Nov 01 06:10:04 osprey kernel: R13: ffff8803f869fb61 R14: ffff8803f869fa90 R15: ffffffffa40cafd8
>> Nov 01 06:10:04 osprey kernel: FS:  00007fdd75904700(0000) GS:ffff88041eb00000(0000) knlGS:0000000000000000
>> Nov 01 06:10:04 osprey kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Nov 01 06:10:04 osprey kernel: CR2: 00007fdd7593a4e1 CR3: 000000000009a000 CR4: 00000000001407e0
>> Nov 01 06:10:04 osprey kernel: Stack:
>> Nov 01 06:10:04 osprey kernel:  ffff8803f869fb60 ffff8803f869fa80 ffff8803f869fb60 fffffffef0fe3990
>> Nov 01 06:10:04 osprey kernel:  0000000000000286 ffff8803f869fb60 ffff8803f869fa58 0000000080050033
>> Nov 01 06:10:04 osprey kernel:  0000000000000000 0000000000000000 0000000000000000 0000000000ff0000
>> Nov 01 06:10:04 osprey kernel: Call Trace:
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813fd701>] ? virt_efi_get_wakeup_time+0x51/0x80
>> Nov 01 06:10:04 osprey kernel:  [<ffffffffa40cf302>] 0xffffffffa40cf302
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff81537722>] ? mutex_lock_interruptible+0x12/0x50
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813e6806>] __rtc_read_alarm+0x96/0x3d0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff812ba204>] ? ida_pre_get+0x54/0xf0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff811bcd22>] ? kmem_cache_alloc_trace+0x1d2/0x200
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813e51e8>] ? rtc_device_register+0x58/0x2e0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813e532d>] rtc_device_register+0x19d/0x2e0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813e5554>] devm_rtc_device_register+0x54/0x90
>> Nov 01 06:10:04 osprey kernel:  [<ffffffffa40d1026>] __this_module+0x1a66/0x1a7a [rtc_efi]
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813aec6d>] platform_drv_probe+0x2d/0x80
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813acd1e>] driver_probe_device+0x8e/0x270
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813acfcb>] __driver_attach+0x8b/0x90
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813acf40>] ? __device_attach+0x40/0x40
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813aaedb>] bus_for_each_dev+0x6b/0xb0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813ac97e>] driver_attach+0x1e/0x20
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813ac4d8>] bus_add_driver+0x178/0x230
>> Nov 01 06:10:04 osprey kernel:  [<ffffffffa40d103a>] ? __this_module+0x1a7a/0x1a7a [rtc_efi]
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813ad7d4>] driver_register+0x64/0xf0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813aebca>] __platform_driver_register+0x4a/0x50
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff813aed04>] platform_driver_probe+0x24/0xc0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffffa40d1051>] init_module+0x17/0x19 [rtc_efi]
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff810020fc>] do_one_initcall+0x8c/0x1c0
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff811a2422>] ? __vunmap+0xa2/0x100
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff810ec79c>] load_module+0x1c5c/0x2330
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff810e9800>] ? store_uevent+0x40/0x40
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff810ea4b1>] ? copy_module_from_fd.isra.39+0x111/0x170
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff810ecfae>] SyS_finit_module+0x7e/0x80
>> Nov 01 06:10:04 osprey kernel:  [<ffffffff8153afad>] system_call_fastpath+0x1a/0x1f
>> Nov 01 06:10:04 osprey kernel: Code: b7 9d 00 41 0f 20 df 4c 89 3d 97 b7 9d 00 4c 8b 3d 98 b7 9d 00 41 0f 22 df ff d7 80 3d 93 b7 9d 00 00 74 41 4c 8b 3d 7a b7 9d 00 <41> 0f 22 df 4c 8b 3d 67 b7 9d 00 4c 89 3d 60 b7 9d 00 4c 89 35
>> Nov 01 06:10:04 osprey kernel: RIP  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>> Nov 01 06:10:04 osprey kernel:  RSP <ffff8803f869f9b0>
>> Nov 01 06:10:04 osprey kernel: ---[ end trace 79e03743f6538bd5 ]---
>> Nov 01 06:10:04 osprey kernel: EFI Variables Facility v0.08 2004-May-17
>> Nov 01 06:10:04 osprey kernel: EFI Variables Facility v0.08 2004-May-17
>> Nov 01 06:10:04 osprey kernel: EFI Variables Facility v0.08 2004-May-17
>>
>> So now I have a repro, which should make it a whole lot easier to do a
>> bisection. But first, sleep. :)
>>
>>> From the logs I've dug up so far, only 3.17 and later seem to have this
>>> issue. But I can't be certain when the problem was introduced, as I
>>> haven't done a bisection yet.
>
> OK, so it seems the reason I didn't see it on earlier kernels is because
> CONFIG_DRV_RTC_EFI was marked IA64-only until 3.17. If I patch in the
> changes that make it depend on EFI rather than IA64, then I can
> reproduce the fault on 3.14.x:
>
>
>         general protection fault: 0000 [#1] SMP
>         Modules linked in: rtc_efi(+) efivars sch_sfq bridge stp llc it87 hwmon_vid sch_fq_codel joydev hid_generic btusb bluetooth usbhid 6lowpan_iphc hid nls_cp437 vfat fat iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp crc32_pclmul ghash_clmulni_intel aesni_intel r8169 i2c_i801 mii snd_hda_codec_realtek snd_hda_codec_generic aes_x86_64 lrw gf128mul snd_hda_codec_hdmi glue_helper ablk_helper cryptd lpc_ich mfd_core thermal fan tpm_tis snd_hda_intel battery tpm snd_hda_codec snd_hwdep snd_pcm snd_timer evdev snd soundcore acpi_cpufreq processor usbip_host(C) usbip_core(C) msr vhost_scsi target_core_mod crct10dif_generic crct10dif_pclmul configfs vhost_net tun vhost macvtap macvlan kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common ahci
>          libahci libata ehci_pci crc32c_intel xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 video intel_gtt i2c_algo_bit drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button [last unloaded: rtc_efi]
>         CPU: 5 PID: 896 Comm: modprobe Tainted: G         C   3.14.23-1-ec2-lts #1
>         Hardware name: GIGABYTE M4HM87P-00/M4HM87P-00, BIOS F5 06/23/2014
>         task: ffff8804022057f0 ti: ffff880036ad0000 task.ti: ffff880036ad0000
>         RIP: 0010:[<ffffffff81064086>]  [<ffffffff81064086>] efi_call2+0x76/0xe0
>         RSP: 0018:ffff880036ad1990  EFLAGS: 00010002
>         RAX: 0000000000000000 RBX: ffff880036ad1a68 RCX: 0000000000000cfc
>         RDX: 0000000080000cfc RSI: ffff880036ad1a68 RDI: fffffffef11e3660
>         RBP: ffff880036ad1a48 R08: 0000000000000000 R09: 00000000000000dc
>         R10: fffffffef11f7f58 R11: ffff880036ad18e0 R12: 0000000000000282
>         R13: ffff880036ad1a5c R14: ffffffffa0c0b5c0 R15: ffffffffa0c06b78
>         FS:  00007f623e7e5700(0000) GS:ffff88041eb40000(0000) knlGS:0000000000000000
>         CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>         CR2: 00000000004140f0 CR3: 000000000009a000 CR4: 00000000001407e0
>         Stack:
>          0000000000000003 ffff880036ad1a68 ffff880036ad1a48 ffff880036ad1a68
>          ffff880036ad1a28 0000000080050033 0000000000000000 0000000000000000
>          0000000000000000 0000000000ff0000 0000000000000000 0000000000000000
>         Call Trace:
>          [<ffffffff81063512>] ? virt_efi_get_time+0x42/0x60
>          [<ffffffffa0c0b364>] 0xffffffffa0c0b363
>          [<ffffffff813c542a>] __rtc_read_time.isra.3+0x4a/0x60
>          [<ffffffff813c5479>] rtc_read_time+0x39/0x50
>          [<ffffffff813c5b75>] __rtc_read_alarm+0x25/0x350
>          [<ffffffff811af192>] ? kmem_cache_alloc_trace+0x1d2/0x200
>          [<ffffffff813c45e8>] ? rtc_device_register+0x58/0x2e0
>          [<ffffffff813c472d>] rtc_device_register+0x19d/0x2e0
>          [<ffffffff813c4934>] ? devm_rtc_device_register+0x34/0x90
>          [<ffffffff813c48e0>] ? rtc_device_unregister+0x70/0x70
>          [<ffffffff813c4954>] devm_rtc_device_register+0x54/0x90
>          [<ffffffffa0c0d026>] __this_module+0x1a66/0x1a7e [rtc_efi]
>          [<ffffffff8139a9e5>] platform_drv_probe+0x45/0xb0
>          [<ffffffff813986b2>] ? driver_sysfs_add+0x82/0xb0
>          [<ffffffff81398b9e>] driver_probe_device+0x8e/0x270
>          [<ffffffff81398e4b>] __driver_attach+0x8b/0x90
>          [<ffffffff81398dc0>] ? __device_attach+0x40/0x40
>          [<ffffffff81396cdb>] bus_for_each_dev+0x6b/0xb0
>          [<ffffffff813987ae>] driver_attach+0x1e/0x20
>          [<ffffffff813982d8>] bus_add_driver+0x178/0x230
>          [<ffffffffa0c0d03e>] ? __this_module+0x1a7e/0x1a7e [rtc_efi]
>          [<ffffffff81399524>] driver_register+0x64/0xf0
>          [<ffffffffa0c0d03e>] ? __this_module+0x1a7e/0x1a7e [rtc_efi]
>          [<ffffffff8139a90a>] __platform_driver_register+0x4a/0x50
>          [<ffffffff8139aa94>] platform_driver_probe+0x24/0xc0
>          [<ffffffffa0c0d03e>] ? __this_module+0x1a7e/0x1a7e [rtc_efi]
>          [<ffffffffa0c0d055>] init_module+0x17/0x19 [rtc_efi]
>          [<ffffffff8100216a>] do_one_initcall+0xfa/0x160
>          [<ffffffff81092a92>] ? __blocking_notifier_call_chain+0x52/0x60
>          [<ffffffff810e7b38>] load_module+0x1c08/0x22d0
>          [<ffffffff810e4c60>] ? store_uevent+0x40/0x40
>          [<ffffffff810e58a9>] ? copy_module_from_fd.isra.38+0x119/0x170
>          [<ffffffff810e833e>] SyS_finit_module+0x7e/0x80
>          [<ffffffff8150feed>] system_call_fastpath+0x1a/0x1f
>         Code: 5a 9d 00 41 0f 20 df 4c 89 3d 3f 5a 9d 00 4c 8b 3d 40 5a 9d 00 41 0f 22 df ff d7 80 3d 3b 5a 9d 00 00 74 41 4c 8b 3d 22 5a 9d 00 <41> 0f 22 df 4c 8b 3d 0f 5a 9d 00 4c 89 3d 08 5a 9d 00 4c 89 35
>         RIP  [<ffffffff81064086>] efi_call2+0x76/0xe0
>          RSP <ffff880036ad1990>
>         ---[ end trace c7920c8dddd4fab9 ]---
>
>
> So it looks like this bug has just been latent for a long time, waiting
> for a second driver to expose it.
>
> Matt, you seem to be the one most frequently touching
> arch/x86/platform/efi/efi_stub_64.S, any ideas on what's broken here?
>
>         Code: 5a 9d 00 41 0f 20 df 4c 89 3d 3f 5a 9d 00 4c 8b 3d 40 5a 9d 00 41 0f 22 df ff d7 80 3d 3b 5a 9d 00 00 74 41 4c 8b 3d 22 5a 9d 00 <41> 0f 22 df 4c 8b 3d 0f 5a 9d 00 4c 89 3d 08 5a 9d 00 4c 89 35
>         All code
>         ========
>            0:   5a                      pop    %rdx
>            1:   9d                      popfq
>            2:   00 41 0f                add    %al,0xf(%rcx)
>            5:   20 df                   and    %bl,%bh
>            7:   4c 89 3d 3f 5a 9d 00    mov    %r15,0x9d5a3f(%rip)        # 0x9d5a4d
>            e:   4c 8b 3d 40 5a 9d 00    mov    0x9d5a40(%rip),%r15        # 0x9d5a55
>           15:   41 0f 22 df             mov    %r15,%cr3
>           19:   ff d7                   callq  *%rdi
>           1b:   80 3d 3b 5a 9d 00 00    cmpb   $0x0,0x9d5a3b(%rip)        # 0x9d5a5d
>           22:   74 41                   je     0x65
>           24:   4c 8b 3d 22 5a 9d 00    mov    0x9d5a22(%rip),%r15        # 0x9d5a4d
>           2b:*  41 0f 22 df             mov    %r15,%cr3                <-- trapping instruction
>           2f:   4c 8b 3d 0f 5a 9d 00    mov    0x9d5a0f(%rip),%r15        # 0x9d5a45
>           36:   4c 89 3d 08 5a 9d 00    mov    %r15,0x9d5a08(%rip)        # 0x9d5a45
>           3d:   4c                      rex.WR
>           3e:   89                      .byte 0x89
>           3f:   35                      .byte 0x35
>
>         Code starting with the faulting instruction
>         ===========================================
>            0:   41 0f 22 df             mov    %r15,%cr3
>            4:   4c 8b 3d 0f 5a 9d 00    mov    0x9d5a0f(%rip),%r15        # 0x9d5a1a
>            b:   4c 89 3d 08 5a 9d 00    mov    %r15,0x9d5a08(%rip)        # 0x9d5a1a
>           12:   4c                      rex.WR
>           13:   89                      .byte 0x89
>           14:   35                      .byte 0x35
>
> In every case it's faulted on the same instruction, attempting to restore cr3
> after the call.

A cherry pick of this commit from mfleming/efi.git makes everything
happier:

commit 161485e8273001e56b2f20755ad9b6217b601fb3
Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon Aug 4 18:16:00 2014 +0200

    efi: Implement mandatory locking for UEFI Runtime Services
   
    According to section 7.1 of the UEFI spec, Runtime Services are not fully
    reentrant, and there are particular combinations of calls that need to be
    serialized. Use a spinlock to serialize all Runtime Services with respect
    to all others, even if this is more than strictly needed.
   
    We've managed to get away without requiring a runtime services lock
    until now because most of the interactions with EFI involve EFI
    variables, and those operations are already serialised with
    __efivars->lock.
   
    Some of the assumptions underlying the decision whether locks are
    needed or not (e.g., SetVariable() against ResetSystem()) may not
    apply universally to all [new] architectures that implement UEFI.
    Rather than try to reason our way out of this, let's just implement at
    least what the spec requires in terms of locking.
   
    Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

But that seems a bit heavy-handed and I'm not sure it's a good candidate
for -stable...

>
>>> Hopefully someone has some ideas before I dive deeper.
>>>
>>>
>>> I've seen this one across two machines now:
>>>
>>>         general protection fault: 0000 [#1] SMP
>>>         Modules linked in: rtc_efi(+) efivars serio_raw iwldvm(+) mac80211 wmi tpm_tis(+) tpm thinkpad_acpi(+) battery nvram ac iwlwifi snd_hda_intel(+) i2c_i801(+) snd_hda_controller btusb(+) snd_hda_codec snd_hwdep bluetooth snd_pcm cfg80211 e1000e(+) snd_timer snd soundcore ptp lpc_ich mfd_core pps_core thermal evdev processor sch_fq_codel usbip_host usbip_core msr efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common crc32c_intel ahci libahci libata scsi_mod ehci_pci sdhci_pci xhci_hcd ehci_hcd sdhci mmc_core usbcore usb_common i915 button intel_gtt i2c_algo_bit video drm_kms_helper drm i2c_core
>>>         CPU: 0 PID: 195 Comm: systemd-udevd Not tainted 3.17.2-1-ec2 #1
>>>         Hardware name: LENOVO 2306CTO/2306CTO, BIOS G2ET95WW (2.55 ) 07/09/2013
>>>         task: ffff880406823ac0 ti: ffff880407ed8000 task.ti: ffff880407ed8000
>>>         RIP: 0010:[<ffffffff81067dbe>]  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>>>         RSP: 0018:ffff880407edb970  EFLAGS: 00010002
>>>         RAX: 0000000000000000 RBX: ffff880407edba50 RCX: 0000000000000000
>>>         RDX: ffff880407edba44 RSI: ffff880407edba50 RDI: fffffffefa23dad8
>>>         RBP: ffff880407edba30 R08: 0000000000000000 R09: ffff880407edba4f
>>>         R10: ffff880407edba50 R11: ffff880407edb908 R12: 0000000000000282
>>>         R13: ffff880407edba44 R14: ffffffffa07285c0 R15: ffffffffa0723fd8
>>>         FS:  00007f07716577c0(0000) GS:ffff88041e200000(0000) knlGS:0000000000000000
>>>         CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>         CR2: 00007f0772d91fc0 CR3: 0000000000053000 CR4: 00000000001407f0
>>>         Stack:
>>>          ffff880407edba50 ffff880407edba50 ffff880487edbae3 ffffffff818035cc
>>>          0000000000000282 ffff880407edbad8 ffff880407edba10 0000000080050033
>>>          0000000000000000 0000000000000000 0000000000000000 0000000000ff0000
>>>         Call Trace:
>>>          [<ffffffff813fd7d9>] ? virt_efi_get_time+0x49/0x70
>>>          [<ffffffffa0728364>] 0xffffffffa0728364
>>>          [<ffffffff813e605a>] __rtc_read_time.isra.3+0x4a/0x60
>>>          [<ffffffff813e60a9>] rtc_read_time+0x39/0x50
>>>          [<ffffffff813e6795>] __rtc_read_alarm+0x25/0x3d0
>>>          [<ffffffff812ba27a>] ? ida_pre_get+0xca/0xf0
>>>          [<ffffffff811bcd22>] ? kmem_cache_alloc_trace+0x1d2/0x200
>>>          [<ffffffff813e51e8>] ? rtc_device_register+0x58/0x2e0
>>>          [<ffffffff813e532d>] rtc_device_register+0x19d/0x2e0
>>>          [<ffffffff813e5534>] ? devm_rtc_device_register+0x34/0x90
>>>          [<ffffffff813e54e0>] ? rtc_device_unregister+0x70/0x70
>>>          [<ffffffff813e5554>] devm_rtc_device_register+0x54/0x90
>>>          [<ffffffffa072a026>] __this_module+0x1a66/0x1a7a [rtc_efi]
>>>          [<ffffffff813aec6d>] platform_drv_probe+0x2d/0x80
>>>          [<ffffffff813acd1e>] driver_probe_device+0x8e/0x270
>>>          [<ffffffff813acfcb>] __driver_attach+0x8b/0x90
>>>          [<ffffffff813acf40>] ? __device_attach+0x40/0x40
>>>          [<ffffffff813aaedb>] bus_for_each_dev+0x6b/0xb0
>>>          [<ffffffff813ac97e>] driver_attach+0x1e/0x20
>>>          [<ffffffff813ac4d8>] bus_add_driver+0x178/0x230
>>>          [<ffffffffa072a03a>] ? __this_module+0x1a7a/0x1a7a [rtc_efi]
>>>          [<ffffffff813ad7d4>] driver_register+0x64/0xf0
>>>          [<ffffffff813aebca>] __platform_driver_register+0x4a/0x50
>>>          [<ffffffff813aed04>] platform_driver_probe+0x24/0xc0
>>>          [<ffffffffa072a051>] init_module+0x17/0x19 [rtc_efi]
>>>          [<ffffffff810020fc>] do_one_initcall+0x8c/0x1c0
>>>          [<ffffffff811a2422>] ? __vunmap+0xa2/0x100
>>>          [<ffffffff810ec79c>] load_module+0x1c5c/0x2330
>>>          [<ffffffff810e9800>] ? store_uevent+0x40/0x40
>>>          [<ffffffff810ea4b1>] ? copy_module_from_fd.isra.39+0x111/0x170
>>>          [<ffffffff810ecfae>] SyS_finit_module+0x7e/0x80
>>>          [<ffffffff8153afad>] system_call_fastpath+0x1a/0x1f
>>>         Code: b7 9d 00 41 0f 20 df 4c 89 3d 97 b7 9d 00 4c 8b 3d 98 b7 9d 00 41 0f 22 df ff d7 80 3d 93 b7 9d 00 00 74 41 4c 8b 3d 7a b7 9d 00 <41> 0f 22 df 4c 8b 3d 67 b7 9d 00 4c 89 3d 60 b7 9d 00 4c 89 35
>>>         RIP  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>>>          RSP <ffff880407edb970>
>>>         ---[ end trace 6aba1dee290210d8 ]---
>>>
>>>
>>> Another machine, same fault location:
>>>
>>>         general protection fault: 0000 [#1] SMP
>>>         Modules linked in: rtc_efi(+) efivars(+) r8169(+) lpc_ich mfd_core mii thermal fan tpm_tis battery tpm evdev snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore acpi_cpufreq processor usbip_host(+) usbip_core msr vhost_scsi target_core_mod crct10dif_generic crct10dif_pclmul configfs vhost_net tun vhost macvtap macvlan kvm_intel kvm efivarfs ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common ahci libahci libata ehci_pci crc32c_intel xhci_hcd ehci_hcd scsi_mod usbcore usb_common i915 intel_gtt i2c_algo_bit video drm_kms_helper drm i2c_core e1000e ptp pps_core ipmi_poweroff ipmi_msghandler button
>>>         CPU: 1 PID: 209 Comm: systemd-udevd Not tainted 3.17.2-1-ec2 #1
>>>         Hardware name: GIGABYTE M4HM87P-00/M4HM87P-00, BIOS F5 06/23/2014
>>>         task: ffff88040580d820 ti: ffff880405300000 task.ti: ffff880405300000
>>>         RIP: 0010:[<ffffffff81067dbe>]  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>>>         RSP: 0018:ffff880405303970  EFLAGS: 00010002
>>>         RAX: 0000000000000000 RBX: ffff880405303a50 RCX: 0000000000000cfc
>>>         RDX: 0000000080000cfc RSI: ffff880405303a50 RDI: fffffffef13e3660
>>>         RBP: ffff880405303a30 R08: 0000000000000000 R09: 00000000000000dc
>>>         R10: fffffffef13f7f58 R11: ffff8804053038c0 R12: 0000000000000282
>>>         R13: ffff880405303a44 R14: ffffffffa07135c0 R15: ffffffffa070efd8
>>>         FS:  00007febee66d7c0(0000) GS:ffff88041ea40000(0000) knlGS:0000000000000000
>>>         CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>         CR2: 00007febee68a000 CR3: 000000000009a000 CR4: 00000000001407e0
>>>         Stack:
>>>          0000000000000003 ffff880405303a50 ffff880405303a30 ffff880405303a50
>>>          0000000000000282 ffff880405303ad8 ffff880405303a10 0000000080050033
>>>          0000000000000000 0000000000000000 0000000000000000 0000000000ff0000
>>>         Call Trace:
>>>          [<ffffffff813fd7d9>] ? virt_efi_get_time+0x49/0x70
>>>          [<ffffffffa0713364>] 0xffffffffa0713364
>>>          [<ffffffff813e605a>] __rtc_read_time.isra.3+0x4a/0x60
>>>          [<ffffffff813e60a9>] rtc_read_time+0x39/0x50
>>>          [<ffffffff813e6795>] __rtc_read_alarm+0x25/0x3d0
>>>          [<ffffffff812ba27a>] ? ida_pre_get+0xca/0xf0
>>>          [<ffffffff811bcd22>] ? kmem_cache_alloc_trace+0x1d2/0x200
>>>          [<ffffffff813e51e8>] ? rtc_device_register+0x58/0x2e0
>>>          [<ffffffff813e532d>] rtc_device_register+0x19d/0x2e0
>>>          [<ffffffff813e5534>] ? devm_rtc_device_register+0x34/0x90
>>>          [<ffffffff813e54e0>] ? rtc_device_unregister+0x70/0x70
>>>          [<ffffffff813e5554>] devm_rtc_device_register+0x54/0x90
>>>          [<ffffffffa0715026>] __this_module+0x1a66/0x1a7a [rtc_efi]
>>>          [<ffffffff813aec6d>] platform_drv_probe+0x2d/0x80
>>>          [<ffffffff813acd1e>] driver_probe_device+0x8e/0x270
>>>          [<ffffffff813acfcb>] __driver_attach+0x8b/0x90
>>>          [<ffffffff813acf40>] ? __device_attach+0x40/0x40
>>>          [<ffffffff813aaedb>] bus_for_each_dev+0x6b/0xb0
>>>          [<ffffffff813ac97e>] driver_attach+0x1e/0x20
>>>          [<ffffffff813ac4d8>] bus_add_driver+0x178/0x230
>>>          [<ffffffffa071503a>] ? __this_module+0x1a7a/0x1a7a [rtc_efi]
>>>          [<ffffffff813ad7d4>] driver_register+0x64/0xf0
>>>          [<ffffffff813aebca>] __platform_driver_register+0x4a/0x50
>>>          [<ffffffff813aed04>] platform_driver_probe+0x24/0xc0
>>>          [<ffffffffa0715051>] init_module+0x17/0x19 [rtc_efi]
>>>          [<ffffffff810020fc>] do_one_initcall+0x8c/0x1c0
>>>          [<ffffffff811a2422>] ? __vunmap+0xa2/0x100
>>>          [<ffffffff810ec79c>] load_module+0x1c5c/0x2330
>>>          [<ffffffff810e9800>] ? store_uevent+0x40/0x40
>>>          [<ffffffff810ea4b1>] ? copy_module_from_fd.isra.39+0x111/0x170
>>>          [<ffffffff810ecfae>] SyS_finit_module+0x7e/0x80
>>>          [<ffffffff8153afad>] system_call_fastpath+0x1a/0x1f
>>>         Code: b7 9d 00 41 0f 20 df 4c 89 3d 97 b7 9d 00 4c 8b 3d 98 b7 9d 00 41 0f 22 df ff d7 80 3d 93 b7 9d 00 00 74 41 4c 8b 3d 7a b7 9d 00 <41> 0f 22 df 4c 8b 3d 67 b7 9d 00 4c 89 3d 60 b7 9d 00 4c 89 35
>>>         RIP  [<ffffffff81067dbe>] efi_call+0x8e/0x100
>>>          RSP <ffff880405303970>
>>>         ---[ end trace 2cb803f9f526dfba ]---
>>>
>>>
>>> And on another system a few days ago (this time faulting in efivars):
>>>
>>>         EFI Variables Facility v0.08 2004-May-17
>>>         general protection fault: 0000 [#1] SMP
>>>         Modules linked in: rtc_efi(+) efivars(+) lpc_ich pps_core(+) mfd_core thermal fan battery tpm_tis(+) tpm acpi_cpufreq wmi video intel_smartconnect processor button sch_fq_codel zfs(PO) zunicode(PO) zcommon(PO) znvpair(PO) zavl(PO) spl(O) vboxnetflt(O) pci_stub vboxpci(O) vboxnetadp(O) vboxdrv(O) usbip_host usbip_core msr efivarfs usbhid hid ext4 crc16 jbd2 mbcache sd_mod crc_t10dif crct10dif_common ehci_pci xhci_hcd ehci_hcd ahci libahci crc32c_intel libata usbcore scsi_mod usb_common nvidia(PO) drm i2c_core
>>>         CPU: 3 PID: 307 Comm: systemd-udevd Tainted: P           O   3.17.1-1-ec2 #1
>>>         Hardware name: MSI MS-7821/Z87-G45 GAMING (MS-7821), BIOS V1.9 07/21/2014
>>>         task: ffff8807ebd41d60 ti: ffff8807e7708000 task.ti: ffff8807e7708000
>>>         RIP: 0010:[<ffffffff81064dbe>]  [<ffffffff81064dbe>] efi_call+0x8e/0x100
>>>         rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc1
>>>         RSP: 0018:ffff8807e770bbe0  EFLAGS: 00010002
>>>         RAX: 0000000000000000 RBX: ffff8807e770bcd8 RCX: 00000000000000a1
>>>         RDX: 00000000800200a1 RSI: ffff8807e770bcd8 RDI: fffffffeeedeb7cc
>>>         RBP: ffff8807e770bca0 R08: 0000000000000010 R09: ffff8807e770bce0
>>>         R10: ffff8800dce04818 R11: ffff8807e770bcd8 R12: ffff8800dce04800
>>>         R13: ffff8807e770bce0 R14: ffffffffa1233fd8 R15: ffff8807e7707a90
>>>         FS:  00007f0523fba7c0(0000) GS:ffff88081ecc0000(0000) knlGS:0000000000000000
>>>         CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>         CR2: 00007fc84f622020 CR3: 000000000009b000 CR4: 00000000001407e0
>>>         DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>         DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>         Stack:
>>>          ffff8807e770bcd8 ffff8807e770bcd8 ffffffff81ac4a30 ffff8807edf28d20
>>>          ffffea001fcaa400 ffff8800dce04800 ffff8807e770bc80 0000000080050033
>>>          0000000000000000 0000000000000000 0000000000000000 0000000000ff0000
>>>         Call Trace:
>>>          [<ffffffff813fa260>] ? virt_efi_get_next_variable+0x40/0x60
>>>          [<ffffffffa1233fd8>] ? __crc_efivars_sysfs_init+0xfffffffeefb0402c/0xfffffffeefb04144 [efivars]
>>>          [<ffffffff813f8648>] efivar_init+0x98/0x3b0
>>>          [<ffffffffa1233ac0>] ? __crc_efivars_sysfs_init+0xfffffffeefb03b14/0xfffffffeefb04144 [efivars]
>>>          [<ffffffff812b8ba9>] ? kset_register+0x59/0x70
>>>          [<ffffffffa1234170>] ? cleanup_module+0x80/0x80 [efivars]
>>>          [<ffffffffa12341fd>] init_module+0x8d/0x227 [efivars]
>>>          [<ffffffff810020fc>] do_one_initcall+0x8c/0x1c0
>>>          [<ffffffff8119f4c2>] ? __vunmap+0xa2/0x100
>>>          [<ffffffff810e979c>] load_module+0x1c5c/0x2330
>>>          [<ffffffff810e6800>] ? store_uevent+0x40/0x40
>>>          [<ffffffff810e74b1>] ? copy_module_from_fd.isra.39+0x111/0x170
>>>          [<ffffffff810e9fae>] SyS_finit_module+0x7e/0x80
>>>          [<ffffffff81537f2d>] system_call_fastpath+0x1a/0x1f
>>>         Code: e4 9d 00 41 0f 20 df 4c 89 3d 97 e4 9d 00 4c 8b 3d 98 e4 9d 00 41 0f 22 df ff d7 80 3d 93 e4 9d 00 00 74 41 4c 8b 3d 7a e4 9d 00 <41> 0f 22 df 4c 8b 3d 67 e4 9d 00 4c 89 3d 60 e4 9d 00 4c 89 35
>>>         RIP  [<ffffffff81064dbe>] efi_call+0x8e/0x100
>>>          RSP <ffff8807e770bbe0>
>>>         ---[ end trace 141a767a77620d11 ]---

