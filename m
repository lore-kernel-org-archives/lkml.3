Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAZMtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:49:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:28937 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaAZMtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:49:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,724,1384329600"; 
   d="scan'208";a="472617788"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Thread-Topic: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Thread-Index: AQHPGjnO5MG2nTCtrEa+syIX3GXcKpqWMbIAgACyQeA=
Date: Sun, 26 Jan 2014 12:49:24 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014F22A8@SHSMSX102.ccr.corp.intel.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
 <20140126090808.GA30987@gmail.com>
In-Reply-To: <20140126090808.GA30987@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Sunday, January 26, 2014 5:08 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org; Peter Zijlstra; Linus Torvalds; Andrew Morton
> Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
> PR_MPX_RELEASE
> 
> 
> * Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> 
> > @@ -7,6 +9,88 @@
> >  #include <asm/fpu-internal.h>
> >  #include <asm/alternative.h>
> >
> > +static struct mmu_notifier mpx_mn;
> 
> > +static struct mmu_notifier_ops mpx_mmuops = {
> > +	.invalidate_range_end = mpx_invl_range_end, };
> > +
> > +int mpx_init(struct task_struct *tsk) {
> > +	if (!boot_cpu_has(X86_FEATURE_MPX))
> > +		return -EINVAL;
> > +
> > +	/* register mmu_notifier to delallocate the bound tables */
> > +	mpx_mn.ops = &mpx_mmuops;
> > +	mmu_notifier_register(&mpx_mn, current->mm);
> 
> 0)
> 
> I do think MPX should be supported by Linux, but this is the best thing I can say
> about the code at the moment:
> 
> 1)
> 
> The above MMU notifier bit is absolutely disgusting: it adds an
> O(nr_mpx_tasks) overhead to every MMU operation!
> 
> MPX needs to be called from architecture methods. (And the MMU notifier
> should probably be removed, it literally invites such abuse.)
> 
> 2)
> 
> The whole MPX_INIT() macro wrappery is ugly beyond relief.
> 
> 3)
> 
> The kernel/sys.c bits are x86-only, it probably won't even build on other
> architectures.
> 
> 4)
> 
> I also argue that MPX setup should be automatic through the ELF
> loader:
> 
>  - MPX setup could also be initiated through the ELF notes section or
>    so - similar to the executable bit stack attribute in ELF binaries.
>    (See PT_GNU_STACK handling in fs/binfmt_elf.c.)
> 
>  - What is the typical life time of the bounds table? Does user-space
>    get access to it? I don't see where it's discoverable to
>    user-space. (for example for debuggers)
> 
> 5)
> 
> Teardown can be done through regular munmap() if the notifier is eliminated,
> so that step falls away as well.
> 
> 6)
> 
> How many entries are in the bounds table? Because mpx_invl_range_end()
> looks utterly unscalable if it has any size beyond 1-2 entries.
> 
The size of one bound table is 4M bytes for 64bit, and 16K bytes for 32bit. It can not be accessed by user-space, and it will be accessed automatically by hardware.

When #BR faults come, and the entry of the bound directory is invalid, one bound table have to be allocated to save value of the bounds. It is what the second patch does. As for the lifetime of the bound tables, we can see the following case:
  User application use malloc or mmap to dynamically allocate memory. when address in the memory region is first accessed, related entry in the bound directory will be checked and it should be invalid. Then one new bound table will be allocated.
  After a time, this memory area is released, and so the bound tables related with this memory area become meaningless and may be released. If we don't release these unnecessary bound tables, it will save the workload of allocation of new bound tables when the memory area related with the entry of the bound directory is allocated and accessed again. But in this way the loss of virtual space will have to be worried.

Anyway, what this patch does is only that when a piece of address space is unmapped, we destroy/unmap the bounds tables that correspond to that same address space. MMU notifier will add some overhead for those tasks which use MPX. But I have no better way to know when one address space is unmapped, and then destroy the related bounds tables. Do you have any suggestion?

Thanks,
Qiaowei
