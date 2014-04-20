Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaDTFhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 01:37:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64231 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaDTFhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 01:37:35 -0400
Message-ID: <53535D1C.200@lwfinger.net>
Date: Sun, 20 Apr 2014 00:37:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Gong Chen <gong.chen@intel.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Bug in 3.15-rc1: Scheduling while atomic splats filling log -
 bisected to commit 27f6c57
References: <53502886.6020107@lwfinger.net>
In-Reply-To: <53502886.6020107@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 02:16 PM, Larry Finger wrote:
> On kernel 3.15-rc1, I get log entries for scheduling while atomic. These BUG
> splats are repeated many times, and start early in the boot. I tried to bisect
> this problem, but the bug does not always show on every boot, and I must have
> had a faulty kernel boot without error. In any case, I ended up at a merge pull.
> What I can definitively report is that a kernel generated from commit fd1df00 is
> bad.
>
> Fortunately, I have retained the kernels from the bisection onward, and I will
> retry them to see if I reported any of them incorrectly. As far as I know, the
> configuration was unchanged during the bisection.
>
> The logged messages are as follows:
>
> 2014-04-16T10:51:25.205576-05:00 larrylap systemd[1]: Starting Name Service
> Cache Daemon...
> 2014-04-16T10:51:25.197425-05:00 larrylap kernel: [   27.176133] Call Trace:
> 2014-04-16T10:51:25.205599-05:00 larrylap kernel: [   27.176139]
> [<ffffffff81607386>] dump_stack+0x4e/0x71
> 2014-04-16T10:51:25.205605-05:00 larrylap kernel: [   27.176144]
> [<ffffffff816009e2>] __schedule_bug+0x5d/0x6d
> 2014-04-16T10:51:25.205615-05:00 larrylap kernel: [   27.176149]
> [<ffffffff8160a8d5>] __schedule+0x775/0x810
> 2014-04-16T10:51:25.205618-05:00 larrylap kernel: [   27.176154]
> [<ffffffff8160aa34>] schedule+0x24/0x70
> 2014-04-16T10:51:25.205620-05:00 larrylap kernel: [   27.176159]
> [<ffffffff8160adc1>] schedule_preempt_disabled+0x11/0x20
> 2014-04-16T10:51:25.205623-05:00 larrylap kernel: [   27.176164]
> [<ffffffff810941a3>] cpu_startup_entry+0x123/0x430
> 2014-04-16T10:51:25.205625-05:00 larrylap kernel: [   27.176170]
> [<ffffffff8102dcb3>] start_secondary+0x1d3/0x290
> 2014-04-16T10:51:25.205627-05:00 larrylap kernel: [   27.176175]
> [<ffffffff813aa118>] ? acpi_ps_parse_aml+0x186/0x476
> 2014-04-16T10:51:25.205629-05:00 larrylap kernel: [   27.177033] BUG: scheduling
> while atomic: swapper/1/0/0x00000004
> 2014-04-16T10:51:25.205638-05:00 larrylap kernel: [   27.177037] no locks held
> by swapper/1/0.
> 2014-04-16T10:51:25.205641-05:00 larrylap kernel: [   27.177039] Modules linked
> in: arc4 b43 mac80211 cfg80211 snd_hda_codec_generic snd_hda_intel snd_hda_co
> ntroller snd_hda_codec snd_hwdep snd_pcm snd_seq powernow_k8 kvm_amd kvm rfkill
> bcma snd_timer snd_seq_device snd r852 pcspkr ssb serio_raw sdhci_pci sm_comm
> on sdhci nand forcedeth mmc_core sg mtd r592 nand_ids nand_bch memstick bch
> nand_ecc sr_mod cdrom soundcore battery ac autofs4 nouveau ttm drm_kms_helper drm
>   i2c_algo_bit i2c_core thermal wmi video processor button thermal_sys hwmon
> ata_generic pata_amd

This bug has now been bisected to commit 27f6c57 by Chen, Gong entitled "x86, 
CMCI: Add proper detection of end of CMCI storms".

The problem may not affect the system during a warm reboot, but it is much more 
likely to show during a cold boot.

My CPUs are as follows:

finger@larrylap:~/wireless-testing> hwinfo --cpu
01: None 00.0: 10103 CPU
   [Created at cpu.374]
   Unique ID: rdCR.j8NaKXDZtZ6
   Hardware Class: cpu
   Arch: X86-64
   Vendor: "AuthenticAMD"
   Model: 15.104.2 "AMD Turion(tm) 64 X2 TL-60"
   Features: 
fpu,vme,de,pse,tsc,msr,pae,mce,cx8,apic,sep,mtrr,pge,mca,cmov,pat,pse36,clflush,mmx,fxsr,sse,sse2,ht,syscall,nx,mmxext,fxsr_opt,rdtscp,lm,3dnowext,3dnow,rep_good,nopl,extd_apicid,pni,cx16,lahf_lm,cmp_legacy,svm,extapic,cr8_legacy,3dnowprefetch,lbrv
   Clock: 800 MHz
   BogoMips: 1600.16
   Cache: 512 kb
   Units/Processor: 2
   Config Status: cfg=no, avail=yes, need=no, active=unknown

02: None 01.0: 10103 CPU
   [Created at cpu.374]
   Unique ID: wkFv.j8NaKXDZtZ6
   Hardware Class: cpu
   Arch: X86-64
   Vendor: "AuthenticAMD"
   Model: 15.104.2 "AMD Turion(tm) 64 X2 TL-60"
   Features: 
fpu,vme,de,pse,tsc,msr,pae,mce,cx8,apic,sep,mtrr,pge,mca,cmov,pat,pse36,clflush,mmx,fxsr,sse,sse2,ht,syscall,nx,mmxext,fxsr_opt,rdtscp,lm,3dnowext,3dnow,rep_good,nopl,extd_apicid,pni,cx16,lahf_lm,cmp_legacy,svm,extapic,cr8_legacy,3dnowprefetch,lbrv
   Clock: 800 MHz
   BogoMips: 1600.16
   Cache: 512 kb
   Units/Processor: 2
   Config Status: cfg=no, avail=yes, need=no, active=unknown
finger@larrylap:~/wireless-testing>

Thank you,

Larry



