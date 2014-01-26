Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaAZJIU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:08:20 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58075 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaAZJIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:08:12 -0500
Date: Sun, 26 Jan 2014 10:08:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Message-ID: <20140126090808.GA30987@gmail.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> @@ -7,6 +9,88 @@
>  #include <asm/fpu-internal.h>
>  #include <asm/alternative.h>
>  
> +static struct mmu_notifier mpx_mn;

> +static struct mmu_notifier_ops mpx_mmuops = {
> +	.invalidate_range_end = mpx_invl_range_end,
> +};
> +
> +int mpx_init(struct task_struct *tsk)
> +{
> +	if (!boot_cpu_has(X86_FEATURE_MPX))
> +		return -EINVAL;
> +
> +	/* register mmu_notifier to delallocate the bound tables */
> +	mpx_mn.ops = &mpx_mmuops;
> +	mmu_notifier_register(&mpx_mn, current->mm);

0)

I do think MPX should be supported by Linux, but this is the best 
thing I can say about the code at the moment:

1)

The above MMU notifier bit is absolutely disgusting: it adds an 
O(nr_mpx_tasks) overhead to every MMU operation!

MPX needs to be called from architecture methods. (And the MMU 
notifier should probably be removed, it literally invites such abuse.)

2)

The whole MPX_INIT() macro wrappery is ugly beyond relief.

3)

The kernel/sys.c bits are x86-only, it probably won't even build on 
other architectures.

4)

I also argue that MPX setup should be automatic through the ELF 
loader:

 - MPX setup could also be initiated through the ELF notes section or
   so - similar to the executable bit stack attribute in ELF binaries. 
   (See PT_GNU_STACK handling in fs/binfmt_elf.c.)

 - What is the typical life time of the bounds table? Does user-space
   get access to it? I don't see where it's discoverable to
   user-space. (for example for debuggers)

5)

Teardown can be done through regular munmap() if the notifier is 
eliminated, so that step falls away as well.

6)

How many entries are in the bounds table? Because mpx_invl_range_end() 
looks utterly unscalable if it has any size beyond 1-2 entries.

Thanks,

	Ingo
