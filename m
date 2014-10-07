Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaJGE4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:56:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:4744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaJGE4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,667,1406617200"; 
   d="scan'208";a="601576976"
Date: Tue, 7 Oct 2014 12:56:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [perf] BUG: unable to handle kernel NULL pointer dereference at
 00000085
Message-ID: <20141007045633.GA17972@wfg-t540p.sh.intel.com>
References: <20141004134622.GA5214@wfg-t540p.sh.intel.com>
 <20141004172456.GA7509@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004172456.GA7509@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sat, Oct 04, 2014 at 07:24:56PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 04, 2014 at 09:46:22PM +0800, Fengguang Wu wrote:
> > Hi Peter,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core
> > 
> > commit a54b3e27e27c1bb6d2610eade895c04934c2667e
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed Sep 24 13:48:42 2014 +0200
> > Commit:     Peter Zijlstra <peterz@infradead.org>
> > CommitDate: Thu Oct 2 23:11:50 2014 +0200
> > 
> >     perf: improve perf_sample_data struct layout
> >     
> >     This patch reorders fields in the perf_sample_data
> >     struct in order to minimize the number of cachelines
> >     touched in perf_sample_data_init(). It also removes
> >     some intializations which are redundant with the
> >     code in kernel/events/core.c
> >     
> >     Cc: mingo@elte.hu
> >     Cc: ak@linux.intel.com
> >     Cc: jolsa@redhat.com
> >     Cc: acme@redhat.com
> >     Cc: cebbert.lkml@gmail.com
> >     Cc: peterz@infradead.org
> >     
> >     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> >     Link: http://lkml.kernel.org/r/1411559322-16548-7-git-send-email-eranian@google.com
> > 
> 
> > [  267.547006] debug: unmapping init [mem 0xc28f9000-0xc2b03fff]
> > [  267.694378] random: init urandom read with 4 bits of entropy available
> > [  279.465522] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> > [  285.269144] BUG: unable to handle kernel NULL pointer dereference at 00000085
> > [  285.273002] IP: [<c11259a1>] perf_prepare_sample+0x33e/0x496
> > [  285.276062] *pde = 00000000 
> > [  285.279106] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [  285.279106] Modules linked in:
> > [  285.279106] CPU: 1 PID: 1583 Comm: trinity-main Not tainted 3.17.0-rc4-00210-ga54b3e2 #1
> > [  285.279106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> > [  285.279106] task: c9475e80 ti: c9670000 task.ti: c9670000
> > [  285.279106] EIP: 0060:[<c11259a1>] EFLAGS: 00010046 CPU: 1
> > [  285.279106] EIP is at perf_prepare_sample+0x33e/0x496
> > [  285.279106] EAX: 00000000 EBX: 00000000 ECX: 00000049 EDX: 00000000
> > [  285.279106] ESI: cfd71c40 EDI: cfd71b84 EBP: cfd71b58 ESP: cfd71b34
> > [  285.279106]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [  285.279106] CR0: 80050033 CR2: 00000085 CR3: 095b4000 CR4: 000006d0
> > [  285.279106] DR0: 41000043 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > [  285.279106] DR6: ffff0ff0 DR7: 00010602
> 
> Could you try the below patch to confirm it works?

Yes, it fixes the BUG at perf_prepare_sample().

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

The below table shows the details, in which a5679078d6 = a54b3e27e2 + your_fix.

+-------------------------------------------------------+------------+------------+
|                                                       | a54b3e27e2 | a5679078d6 |
+-------------------------------------------------------+------------+------------+
| boot_successes                                        | 227        | 963        |
| boot_failures                                         | 73         | 37         |
| BUG:kernel_boot_hang                                  | 52         | 13         |
| BUG:unable_to_handle_kernel                           | 4          |            |
| Oops                                                  | 4          |            |
| EIP_is_at_perf_prepare_sample                         | 4          |            |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 3          |            |
| backtrace:iterate_dir                                 | 2          |            |
| backtrace:SyS_getdents64                              | 2          |            |
| WARNING:at_fs/proc/generic.c:remove_proc_entry()      | 8          | 18         |
| backtrace:cleanup_net                                 | 8          | 18         |
| backtrace:do_sys_open                                 | 1          |            |
| backtrace:SyS_openat                                  | 1          |            |
| BUG:kernel_test_crashed                               | 9          | 4          |
| backtrace:vfs_fstatat                                 | 1          |            |
| backtrace:SyS_fstatat64                               | 1          |            |
| Kernel_panic-not_syncing:Fatal_exception              | 1          |            |
| BUG:kernel_boot_crashed                               | 0          | 2          |
+-------------------------------------------------------+------------+------------+

Thanks,
Fengguang
