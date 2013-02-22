Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3BVMvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:51:37 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45646 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3BVMvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:51:36 -0500
Message-ID: <1361537491.5807.9.camel@thor.lan>
Subject: [3.8.0-rc1] BUG in __split_huge_page_pmd() at mm/huge_memory.c:2743
 ( was Re: bug report for 3.8.0-rc1+)
From: Peter Hurley <peter@hurleysoftware.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, NKoc <nazim@ucanlinux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 22 Feb 2013 07:51:31 -0500
In-Reply-To: <512741E2.3050607@ucanlinux.com>
References: <512741E2.3050607@ucanlinux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

I thought you might be interested in this.

HEAD is now at a49f0d1... Linux 3.8-rc1
peter@thor:~/src/kernels/mainline$ sed = mm/huge_memory.c | sed 'N;s/\n/ /' | sed -n '2730,2744p'
2730 		spin_unlock(&mm->page_table_lock);
2731 		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
2732 		return;
2733 	}
2734 	page = pmd_page(*pmd);
2735 	VM_BUG_ON(!page_count(page));
2736 	get_page(page);
2737 	spin_unlock(&mm->page_table_lock);
2738 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
2739 
2740 	split_huge_page(page);
2741 
2742 	put_page(page);
2743 	BUG_ON(pmd_trans_huge(*pmd));
2744 }

Regards,
Peter Hurley


On Fri, 2013-02-22 at 12:01 +0200, NKoc wrote:
> Feb 22 10:44:16 nkoc kernel: ------------[ cut here ]------------
> Feb 22 10:44:16 nkoc kernel: kernel BUG at mm/huge_memory.c:2743!
> Feb 22 10:44:16 nkoc kernel: invalid opcode: 0000 [#1] SMP
> Feb 22 10:44:16 nkoc kernel: Modules linked in: snd_seq_dummy 
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
> snd_mixer_oss ipv6 ppdev lp parport_pc parport fuse snd_hda_codec_hdmi 
> snd_hda_codec_via snd_hda_intel snd_hda_codec i915 intel_agp snd_hwdep 
> snd_pcm rtl8723ae rtlwifi joydev zd1211rw mac80211 intel_gtt 
> drm_kms_helper hid_generic usbhid hid snd_page_alloc snd_timer cfg80211 
> r8169 btusb drm snd bluetooth acpi_cpufreq mperf agpgart freq_table 
> processor psmouse i2c_i801 thermal rfkill serio_raw i2c_algo_bit video 
> mii i2c_core lpc_ich mei evdev soundcore thermal_sys coretemp mfd_core 
> hwmon wmi button battery ac crc32c_intel microcode loop
> Feb 22 10:44:16 nkoc kernel: Pid: 2616, comm: thunderbird Tainted: 
> P             3.8.0-rc1+ #1 EXPER KARIZMA/W240EU/W250EUQ/W270EUQ
> Feb 22 10:44:16 nkoc kernel: EIP: 0060:[<c10e54cc>] EFLAGS: 00210282 CPU: 1
> Feb 22 10:44:16 nkoc kernel: EIP is at __split_huge_page_pmd+0x1fc/0x220
> Feb 22 10:44:16 nkoc kernel: EAX: f6934000 EBX: f6934000 ECX: 00000002 EDX: ef42eaf8
> Feb 22 10:44:16 nkoc kernel: ESI: 00000000 EDI: afbf8000 EBP: 00000000 ESP: f1d75e68
> Feb 22 10:44:16 nkoc kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Feb 22 10:44:16 nkoc kernel: CR0: 80050033 CR2: a23fb00c CR3: 2f42e000 CR4: 000407d0
> Feb 22 10:44:16 nkoc kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> Feb 22 10:44:16 nkoc kernel: DR6: ffff0ff0 DR7: 00000400
> Feb 22 10:44:16 nkoc kernel: Process thunderbird (pid: 2616, ti=f1d74000 task=f4edc000 task.ti=f1d74000)
> Feb 22 10:44:16 nkoc kernel: Stack:
> Feb 22 10:44:16 nkoc kernel:  afc00000 c10b5531 f494d6c0 af800000 ef42eaf8 c10b8568 afbf9000 afbf9000
> Feb 22 10:44:16 nkoc kernel:  afbf8000 afbf8000 c10ca112 f6630f54 afbf9000 f1d75f14 00000001 00000001
> Feb 22 10:44:16 nkoc kernel:  f1d45420 ef42eaf8 f4edc000 f1d75ef0 ef42eaf8 afbf9000 afbf8fff a9a63000
> Feb 22 10:44:16 nkoc kernel: Call Trace:
> Feb 22 10:44:16 nkoc kernel:  [<c10b5531>] ? free_hot_cold_page_list+0x21/0x40
> Feb 22 10:44:16 nkoc kernel:  [<c10b8568>] ? release_pages+0x148/0x180
> Feb 22 10:44:16 nkoc kernel:  [<c10ca112>] ? unmap_single_vma+0xf2/0x560
> Feb 22 10:44:16 nkoc kernel:  [<c10caf00>] ? zap_page_range+0x80/0xd0
> Feb 22 10:44:16 nkoc kernel:  [<c107427f>] ? clockevents_program_event+0x9f/0x150
> Feb 22 10:44:16 nkoc kernel:  [<c10c8310>] ? sys_madvise+0x1f0/0x570
> Feb 22 10:44:16 nkoc kernel:  [<c10503d0>] ? hrtimer_interrupt+0x170/0x290
> Feb 22 10:44:16 nkoc kernel:  [<c12c9935>] ? __percpu_counter_add+0x65/0xb0
> Feb 22 10:44:16 nkoc kernel:  [<c17f142f>] ? syscall_call+0x7/0xb
> Feb 22 10:44:16 nkoc kernel:  [<c17f0000>] ? __schedule+0x240/0x720
> Feb 22 10:44:16 nkoc kernel: Code: 4b 69 ff ff 89 d8 e8 64 32 fd ff 84 
> c0 0f 85 c2 fe ff ff e9 b9 fe ff ff 8b 0c 24 8b 54 24 0c e8 bb 68 ff ff 
> e9 50 fe ff ff 0f 0b <0f> 0b 8b 0c 24 8b 54 24 0c 8b 44 24 08 e8 12 69 
> ff ff e9 a9 fe
> Feb 22 10:44:16 nkoc kernel: EIP: [<c10e54cc>] 
> __split_huge_page_pmd+0x1fc/0x220 SS:ESP 0068:f1d75e68
> Feb 22 10:44:16 nkoc kernel: ---[ end trace e8618ddbef619686 ]---



