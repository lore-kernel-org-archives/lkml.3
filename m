Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaAOMLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:11:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:51098 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaAOMLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:11:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,662,1384329600"; 
   d="scan'208";a="459165449"
Date: Wed, 15 Jan 2014 20:10:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
Message-ID: <20140115121057.GA16708@localhost>
References: <20140114133125.GB26942@localhost>
 <CAGXu5jKqx6JYBhHf08ru9B62RdD1A_WX7on64Cw-v1wYKT2jnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKqx6JYBhHf08ru9B62RdD1A_WX7on64Cw-v1wYKT2jnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:26:42AM -0800, Kees Cook wrote:
> On Tue, Jan 14, 2014 at 5:31 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Greetings,
> >
> > I got the below dmesg and the first bad commit is
> >
> > commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
> > Author:     Kees Cook <keescook@chromium.org>
> > AuthorDate: Thu Oct 10 17:18:16 2013 -0700
> > Commit:     H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Sun Oct 13 03:12:19 2013 -0700
> >
> >     x86, kaslr: Select random position from e820 maps
> >
> >     Counts available alignment positions across all e820 maps, and chooses
> >     one randomly for the new kernel base address, making sure not to collide
> >     with unsafe memory areas.
> >
> >     Signed-off-by: Kees Cook <keescook@chromium.org>
> >     Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >
> > Note that there are many other warning/errors and it's not very
> > reproducible, so this report might be wrong.
> >
> > ===================================================
> > PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> > ===================================================
> >
> > +-----------------------------------------------------------+--------------+--------------+
> > |                                                           | 5bfce5ef55cb | 1955a14a5ba6 |
> > +-----------------------------------------------------------+--------------+--------------+
> > | boot_successes                                            | 3948         | 0            |
> > | boot_failures                                             | 52           | 89           |
> > | page_allocation_failure:order:,mode                       | 48           | 2            |
> > | Out_of_memory:Kill_process                                | 7            |              |
> > | BUG:kernel_early_hang_without_any_printk_output           | 1            |              |
> > | BUG:soft_lockup-CPU_stuck_for_s                           | 1            |              |
> > | WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 0            | 85           |
> 
> Does this mean that
> "WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags()" is the
> most common failure condition?

Yes. However I noticed that this warning exists before your commit.
So they should be irrelevant noises.

> > | general_protection_fault:SMP_SMP                          | 0            | 1            |
> > | RIP:__lock_acquire                                        | 0            | 1            |
> > | Kernel_panic-not_syncing:Fatal_exception                  | 0            | 1            |
> > | BUG:kernel_boot_hang                                      | 0            | 2            |
> > | BUG:kernel_boot_crashed                                   | 0            | 1            |
> > +-----------------------------------------------------------+--------------+--------------+
> >
> > The last dmesg is
> >
> > [    0.803796] Initramfs unpacking failed: junk in compressed archive
> > [    0.803796] Initramfs unpacking failed: junk in compressed archive
> >
> > or in some cases
> >
> > [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> > [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> > [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> > [    0.000000] BRK [0x07886000, 0x07886fff] PGTABLE
> > [    0.000000] BRK [0x07887000, 0x07887fff] PGTABLE
> > [    0.000000] BRK [0x07888000, 0x07888fff] PGTABLE
> > PANIC: early exception 0e rip 10:ffffffff86204c6e error 0 cr2 ffffffff81972b28
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00008-g6e6a493 #614
> > PANIC: early exception 0e rip 10:ffffffff86204f22 error 0 cr2 ffffffff81972b28
> 
> I will try to reproduce this, but it's not clear to me what is causing
> the failure. The generated config doesn't look insane to me, so I'm
> not sure what's happening here. Is QEMU doing something unexpected
> with the ordering of where things go for its boot loader?

The PANIC message is very reproducible in some configs (I'll report
one bisect result for it in another email), and it will happen in both
the initrd files I used: the 3.1MB yocto-minimal-x86_64.cgz and the
23MB quantal-core-x86_64.cgz. I'll send you the smaller yocto image.

Thanks,
Fengguang
