Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967676Ab3DSASJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:18:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:58741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967536Ab3DSASH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,505,1363158000"; 
   d="scan'208";a="320611635"
Message-ID: <51708D3D.9010707@intel.com>
Date: Thu, 18 Apr 2013 17:18:05 -0700
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com> <51701D2E.6060903@console-pimps.org>
In-Reply-To: <51701D2E.6060903@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 09:19 AM, Matt Fleming wrote:
> On 18/04/13 15:51, Darren Hart wrote:
>> I don't believe I have seen a 32-bit EFI system with a BGRT, but then
>> again, I had to look it up today! That said, I suspect the MinnowBoard
>> would benefit from such a thing, so we should have an example of it
>> there in the near future.
>
> That's fine and things will work as-is provided that the BGRT image is
> not in highmem.
>
>> Is this in anyway related to the following patch from Josh Boyer? We're
>> carrying this in the Yocto Project trees currently.
>>
>>      commit 6f3e186bc7721c5b24ad90d4a751cccfccd445e6
>>      Author: Josh Boyer <jwboyer@redhat.com>
>>      Date:   Fri Aug 5 08:47:23 2011 -0400
>>
>>         Add patch to fix 32bit EFI service mapping (rhbz 726701)
>>
>>     Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
>>     Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>
> Yep, it's basically the same fix. My patch just avoids the #ifdef and
> prints an error message if we have EFI Boot services regions we can't
> access directly. The error message will at least be useful if we do
> start seeing BGRT pointers in highmem.
>
> Could you give it a spin on your MinnowBoard?

I've removed the patch I reference above and applied your patch to my
3.8.4 MinnowBoard dev tree. It panics with:

------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x2cb/0x2f0()
Hardware name: Minnow
Modules linked in:
Pid: 0, comm: swapper/0 Not tainted 3.8.4-yocto-standard+ #111
Call Trace:
 [<c102faf3>] warn_slowpath_common+0x73/0xa0
 [<c102752b>] ? __ioremap_caller+0x2cb/0x2f0
 [<c102752b>] ? __ioremap_caller+0x2cb/0x2f0
 [<c102fb43>] warn_slowpath_null+0x23/0x30
 [<c102752b>] __ioremap_caller+0x2cb/0x2f0
 [<c110b248>] ? kmem_cache_alloc_trace+0x58/0x120
 [<c110b33f>] ? sysfs_slab_alias+0x2f/0x80
 [<c165d948>] ? add_preempt_count+0x8/0x80
 [<c165d8c8>] ? sub_preempt_count+0x8/0x80
 [<c10387aa>] ? walk_system_ram_range+0xfa/0x110
 [<c1027599>] ioremap_cache+0x19/0x20
 [<c1932889>] ? efi_ioremap+0x1b/0x23
 [<c1932889>] efi_ioremap+0x1b/0x23
 [<c19326bd>] efi_enter_virtual_mode+0x195/0x346
 [<c19208b8>] start_kernel+0x288/0x30b
 [<c1920462>] ? repair_env_string+0x51/0x51
 [<c19202a2>] i386_start_kernel+0x78/0x7d
---[ end trace f74542647d553317 ]---
efi: ioremap of 0x3DE3F000 failed!
efi: ioremap of 0x3E601000 failed!
efi: ioremap of 0x3E602000 failed!
efi: ioremap of 0x3E609000 failed!
efi: ioremap of 0x3E60C000 failed!
efi: ioremap of 0x3E614000 failed!
efi: ioremap of 0x3E617000 failed!
efi: ioremap of 0x3E621000 failed!
efi: ioremap of 0x3E622000 failed!
efi: ioremap of 0x3E627000 failed!
efi: ioremap of 0x3E628000 failed!
efi: ioremap of 0x3E62D000 failed!
efi: ioremap of 0x3E62E000 failed!
efi: ioremap of 0x3E631000 failed!
efi: ioremap of 0x3E632000 failed!
efi: ioremap of 0x3E63E000 failed!
efi: ioremap of 0x3EA0E000 failed!
efi: ioremap of 0x3EA0F000 failed!
efi: ioremap of 0x3EA11000 failed!
efi: ioremap of 0x3EA1A000 failed!
efi: ioremap of 0x3EA1B000 failed!
efi: ioremap of 0x3EA1D000 failed!
efi: ioremap of 0x3EC0B000 failed!
efi: ioremap of 0x3EC0F000 failed!
efi: ioremap of 0x3F33F000 failed!
efi: ioremap of 0xFED1C000 failed!
------------[ cut here ]------------
kernel BUG at arch/x86/platform/efi/efi.c:933!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in:
Pid: 0, comm: swapper/0 Tainted: G        W    3.8.4-yocto-standard+
#111 Circuitco Minnow/Minnow Board

EIP: 0060:[<c193276c>] EFLAGS: 00010246 CPU: 0
EIP is at efi_enter_virtual_mode+0x244/0x346
EAX: ee012930 EBX: 00000030 ECX: 00000000 EDX: 000000d0
ESI: ffe190b0 EDI: ee012960 EBP: c18adfc4 ESP: c18adf7c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: ffe17000 CR3: 019b4000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process swapper/0 (pid: 0, ti=c18ac000 task=c18b70e0 task.ti=c18ac000)
Stack:
 00000000 80000000 00000000 00040000 00040000 80000000 0000a000 00000000
 0002effe 00000000 00000032 ee012000 fffaa000 00000000 ffe190b0 c195b3c0
 0008a800 c18ae800 c18adfe4 c19208b8 00000113 ffffffff ffffffff c1920462
Call Trace:
 [<c19208b8>] start_kernel+0x288/0x30b
 [<c1920462>] ? repair_env_string+0x51/0x51
 [<c19202a2>] i386_start_kernel+0x78/0x7d
Code: 03 45 e4 89 c7 f3 a4 89 5d e0 8b 1d fc d7 9b c1 01 5d f0 8b 75 f0
39 35 f0 d7 9b c1 0f 87 82 fe ff ff 83 3d a0 be 91 c1 00 75 02 <0f> 0b
8b 1d fc d7 9b c1 8b 75 e0 0f af f3 8b 3d f8 d7 9b c1 e8

EIP: [<c193276c>] efi_enter_virtual_mode+0x244/0x346 SS:ESP 0068:c18adf7c
---[ end trace f74542647d553318 ]---
Kernel panic - not syncing: Attempted to kill the idle task!


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
