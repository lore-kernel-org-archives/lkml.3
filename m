Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaCGHVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:21:40 -0500
Received: from www84.your-server.de ([213.133.104.84]:38550 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCGHVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:21:39 -0500
Message-ID: <1394176888.1018.3.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 08:21:28 +0100
In-Reply-To: <20140307013833.GD8427@localhost>
References: <20140307013833.GD8427@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

i have build a kernel with the config, but my kvm is unable to start it.
I will try to find a way to test your kernek config.

One thing is the crash point:

The function sysenter_setup was modified by Andy, maybe he has an idea
what fails.

- Stefani

Am Freitag, den 07.03.2014, 09:38 +0800 schrieb Fengguang Wu:
> Hi Stefani,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
> commit 4dea8e4824b363c53f320d328040d7c6c5921419
> Author:     Stefani Seibold <stefani@seibold.net>
> AuthorDate: Mon Mar 3 22:12:20 2014 +0100
> Commit:     H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed Mar 5 14:02:38 2014 -0800
> 
>     x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
>     
>     This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
>     
>     For 32 bit programs running on a 32 bit kernel, the same mechanism is
>     used as for 64 bit programs running on a 64 bit kernel.
>     
>     Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>     Signed-off-by: Stefani Seibold <stefani@seibold.net>
>     Link: http://lkml.kernel.org/r/1393881143-3569-10-git-send-email-stefani@seibold.net
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> +--------------------------------------------+------------+
> |                                            | 4dea8e4824 |
> +--------------------------------------------+------------+
> | boot_successes                             | 0          |
> | boot_failures                              | 19         |
> | BUG:unable_to_handle_kernel_paging_request | 19         |
> | Oops:PREEMPT_SMP_DEBUG_PAGEALLOC           | 19         |
> | EIP_is_at_sysenter_setup                   | 19         |
> | Kernel_panic-not_syncing:Fatal_exception   | 19         |
> +--------------------------------------------+------------+
> 
> [    0.004009] pid_max: default: 4096 minimum: 301
> [    0.009099] Mount-cache hash table entries: 512
> [    0.014838] mce: CPU supports 10 MCE banks
> [    0.015243] BUG: unable to handle kernel paging request at d34bd000
> [    0.016000] IP: [<c182dbca>] sysenter_setup+0x9a/0x2d4
> [    0.016000] *pdpt = 00000000018a4001 *pde = 0000000013bea067 *pte = 80000000134bd060 
> [    0.016000] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.016000] Modules linked in:
> [    0.016000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5-03765-gd478a96 #2
> [    0.016000] task: c17997c0 ti: c178e000 task.ti: c178e000
> [    0.016000] EIP: 0060:[<c182dbca>] EFLAGS: 00210212 CPU: 0
> [    0.016000] EIP is at sysenter_setup+0x9a/0x2d4
> [    0.016000] EAX: 078bfbfd EBX: d34bc000 ECX: 00000004 EDX: 00001004
> [    0.016000] ESI: c186740c EDI: d34bd000 EBP: c178ff98 ESP: c178ff74
> [    0.016000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.016000] CR0: 8005003b CR2: d34bd000 CR3: 018a7000 CR4: 000006f0
> [    0.016000] Stack:
> [    0.016000]  00200202 c1dbb0f0 00000f61 00000800 80002001 078bfbfd 00000000 00000000
> [    0.016000]  c18a8800 c178ffa0 c1821144 c178ffbc c182117d 00000000 c178ffbc 00000000
> [    0.016000]  00000000 c18a8800 c178ffec c181ab11 00000101 ffffffff ffffffff c181a549
> [    0.016000] Call Trace:
> [    0.016000]  [<c1821144>] identify_boot_cpu+0x17/0x28
> [    0.016000]  [<c182117d>] check_bugs+0xe/0x160
> [    0.016000]  [<c181ab11>] start_kernel+0x401/0x470
> [    0.016000]  [<c181a549>] ? repair_env_string+0x51/0x51
> [    0.016000]  [<c181a364>] i386_start_kernel+0x12e/0x131
> [    0.016000] Code: f6 c4 08 74 12 ba 10 74 86 c1 81 ea 0c 64 86 c1 be 0c 64 86 c1 eb 10 ba 0c 64 86 c1 81 ea 1c 54 86 c1 be 1c 54 86 c1 89 df 89 d1 <f3> a4 89 d8 e8 8b fe ff ff b9 04 00 00 00 ba d6 c2 6e c1 89 d8
> [    0.016000] EIP: [<c182dbca>] sysenter_setup+0x9a/0x2d4 SS:ESP 0068:c178ff74
> [    0.016000] CR2: 00000000d34bd000
> [    0.016000] ---[ end trace db4b7fde7786bb07 ]---
> [    0.016000] Kernel panic - not syncing: Fatal exception
> 
> git bisect start d478a960edf1ea61ca31a07a48a8771f043dba78 0414855fdc4a40da05221fc6062cccbc0c30f169 --
> git bisect  bad 6c2191ad9b6225860eef70a77d300c3d5ad39182  # 05:55      0-     15  Merge 'digsig/for-mimi' into devel-hourly-2014030618
> git bisect good 61ca01b5aa63605e033f1826dcceb41421aa72cd  # 06:03     20+      0  Merge 'ubifs/master' into devel-hourly-2014030618
> git bisect  bad 53dca0b5f0e257f00b91fc3be98fb47c07d20cfc  # 06:11      0-     16  Merge 'tip/x86/vdso' into devel-hourly-2014030618
> git bisect good f25ed0ebc194a51042a5392ca821de2ff6661275  # 06:20     20+      0  Merge 'slave-dma/next' into devel-hourly-2014030618
> git bisect good e0099b8165e2525541d7844e29e8838824b3601e  # 06:23     20+      0  Merge 'pcmoore-selinux/next' into devel-hourly-2014030618
> git bisect good c24bf54683dd0098e878a0cf40e2667e46a39a0a  # 06:29     20+      0  Merge 'renesas/next' into devel-hourly-2014030618
> git bisect good 6543ca6fee7d3b314bda69b83fd429ed3e336645  # 06:35     20+      0  x86, vdso: Cleanup __vdso_gettimeofday()
> git bisect  bad 4dea8e4824b363c53f320d328040d7c6c5921419  # 06:37      0-     15  x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
> git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 06:41     20+      0  x86, vdso: Patch alternatives in the 32-bit VDSO
> # first bad commit: [4dea8e4824b363c53f320d328040d7c6c5921419] x86, vdso: Add 32 bit VDSO time support for 32 bit kernel
> git bisect good 8272416968a9bd8244515179625cdeffd7c2c90a  # 06:43     60+      0  x86, vdso: Patch alternatives in the 32-bit VDSO
> git bisect  bad d478a960edf1ea61ca31a07a48a8771f043dba78  # 06:43      0-     19  0day head guard for 'devel-hourly-2014030618'
> git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 06:56     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect good 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 06:59     60+     69  Add linux-next specific files for 20140306
> 
> Thanks,
> Fengguang
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com


