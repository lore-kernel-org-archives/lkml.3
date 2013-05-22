Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3EVQ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:27:52 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543Ab3EVQ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:27:50 -0400
Date: Wed, 22 May 2013 11:27:47 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Russ Anderson <rja@sgi.com>
Subject: [regression, bisected] x86: efi: Pass boot services variable info to
 runtime code
Message-ID: <20130522162747.GA20816@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux crashes on boot on SGI UV systems.  git bisect tracked it
down to commit cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f.  Undoing 
that patch fixes the problem.


http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f

-----------------------------------------------------------
linux$ git bisect bad
cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f is first bad commit
commit cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f
Author: Matthew Garrett <matthew.garrett@nebula.com>
Date:   Mon Apr 15 13:09:46 2013 -0700

    efi: Pass boot services variable info to runtime code

    EFI variables can be flagged as being accessible only within boot services.
    This makes it awkward for us to figure out how much space they use at
    runtime. In theory we could figure this out by simply comparing the results
    from QueryVariableInfo() to the space used by all of our variables, but
    that fails if the platform doesn't garbage collect on every boot. Thankfully,
    calling QueryVariableInfo() while still inside boot services gives a more
    reliable answer. This patch passes that information from the EFI boot stub
    up to the efi platform code.

    Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

:040000 040000 eaaca954c158017931b383d8a7799f0372118fa4 5a2816a34b5393ca1ad49a9ce240e2e5caee3aca M      arch 
-----------------------------------------------------------



The failing output:
-----------------------------------------------------------
[    6.038007] Intel P-state driver initializing.
[    6.043006] Intel pstate controlling: cpu 0
[    6.047700] Intel pstate controlling: cpu 1
[    6.052456] cpuidle: using governor ladder
[    6.057085] cpuidle: using governor menu
[    6.062157] EFI Variables Facility v0.08 2004-May-17
[    6.067731] BUG: unable to handle kernel paging request at 000000007ca95b10
[    6.075519] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
[    6.081363] PGD 0
[    6.083616] Oops: 0000 [#1] SMP
[    6.087240] Modules linked in:
[    6.090656] CPU 1
[    6.092706] Pid: 1, comm: swapper/0 Not tainted 3.9.0-0.55.el7.x86_64 #1 SGI UV2000/ROMLEY
[    6.102129] RIP: 0010:[<ffff88007dbf2140>]  [<ffff88007dbf2140>] 0xffff88007dbf213f
[    6.110681] RSP: 0000:ffff880815913990  EFLAGS: 00010202
[    6.116603] RAX: 000000007ca95ad0 RBX: 000000000000006a RCX: 0000000090000002
[    6.124562] RDX: 0000000003050007 RSI: 0000000000000000 RDI: ffff88007dbf6ea8
[    6.132520] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    6.140478] R10: 0000000000003638 R11: ffff880815913b8e R12: 0000000003050007
[    6.148436] R13: 0000000090000002 R14: ffff880815913e00 R15: 0000000000000000
[    6.156394] FS:  0000000000000000(0000) GS:ffff8817bec00000(0000) knlGS:0000000000000000
[    6.165418] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.171826] CR2: 000000007ca95b10 CR3: 00000000018e6000 CR4: 00000000000407e0
[    6.179785] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.187743] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.195702] Process swapper/0 (pid: 1, threadinfo ffff880815912000, task ffff880815928000)
[    6.204919] Stack:
[    6.207160]  00000000ffffffff 0000000000000010 0000000000000041 0000000000000040
[    6.215456]  ffffea005e447dc0 0000000000000001 002212d000000000 0000000000000246
[    6.223752]  ffff8817befd4d80 0000000000000002 0000000000000000 00000000002012d0
[    6.232048] Call Trace:
[    6.234799]  [<ffffffff8113c647>] ? __alloc_pages_nodemask+0x157/0xa00
[    6.242096]  [<ffffffff812f02df>] ? idr_get_empty_slot+0x16f/0x3c0
[    6.248997]  [<ffffffff812f7972>] ? put_dec+0x72/0x90
[    6.254633]  [<ffffffff812f076c>] ? ida_get_new_above+0x6c/0x290
[    6.261340]  [<ffffffff8120d0b5>] ? sysfs_link_sibling+0xb5/0xe0
[    6.268040]  [<ffffffff8120d7b1>] ? __sysfs_add_one+0x71/0x110
[    6.274545]  [<ffffffff8120d9d3>] ? sysfs_addrm_finish+0x33/0xc0
[    6.281245]  [<ffffffff8120dadd>] ? create_dir+0x7d/0xd0
[    6.287171]  [<ffffffff8120de72>] ? sysfs_create_dir+0x92/0xf0
[    6.293690]  [<ffffffff81058a23>] ? efi_call3+0x43/0x80
[    6.299517]  [<ffffffff8105832a>] ? virt_efi_get_next_variable+0x3a/0x1a0
[    6.307095]  [<ffffffff814b27e3>] ? register_efivars+0xd3/0x530
[    6.313710]  [<ffffffff81a4d042>] ? dmi_sysfs_register_handle+0x1c7/0x1c7
[    6.321280]  [<ffffffff81a4d0f5>] ? efivars_init+0xb3/0xff
[    6.327405]  [<ffffffff8100210a>] ? do_one_initcall+0x10a/0x160
[    6.334026]  [<ffffffff81a0e064>] ? kernel_init_freeable+0x181/0x207
[    6.341115]  [<ffffffff81a0d887>] ? do_early_param+0x88/0x88
[    6.347445]  [<ffffffff815e0340>] ? rest_init+0x80/0x80
[    6.353274]  [<ffffffff815e034e>] ? kernel_init+0xe/0x180
[    6.359307]  [<ffffffff8160acac>] ? ret_from_fork+0x7c/0xb0
[    6.365522]  [<ffffffff815e0340>] ? rest_init+0x80/0x80
[    6.371347] Code: 8b d8 e8 e4 fa ff ff 84 c0 75 0f 48 8b 15 61 58 00 00 48 8b 4c 24 30 ff 52 48 48 8b c3 eb 58 48 8b 05 4d 58 00 00 48 85 c0 74 42 <48> 83 78 40 00 74 3b 48 83 78 48 00 74 34 48 8d 53 14 4c 8d 44
[    6.393044] RIP  [<ffff88007dbf2140>] 0xffff88007dbf213f
[    6.398978]  RSP <ffff880815913990>
[    6.406605] ---[ end trace 18f487bf56d8bf90 ]---
[    6.411785] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
-----------------------------------------------------------
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
