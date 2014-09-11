Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaIKX22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:28:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:44232 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaIKX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:28:27 -0400
Date: Fri, 12 Sep 2014 01:28:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.10.1409120020060.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Qiaowei Ren wrote:

> This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
> commands. These commands can be used to register and unregister MPX
> related resource on the x86 platform.

I cant see anything which is registered/unregistered.
 
> The base of the bounds directory is set into mm_struct during
> PR_MPX_REGISTER command execution. This member can be used to
> check whether one application is mpx enabled.

This changelog is completely useless.

What's the actual point of this prctl?

> +/*
> + * This should only be called when cpuid has been checked
> + * and we are sure that MPX is available.

Groan. Why can't you put that cpuid check into that function right
away instead of adding a worthless comment?

It's obviously more important to have a comment about somthing which
is obvious than explaining what the function is actually doing, right?

> + */
> +static __user void *task_get_bounds_dir(struct task_struct *tsk)
> +{
> +	struct xsave_struct *xsave_buf;
> +
> +	fpu_xsave(&tsk->thread.fpu);
> +	xsave_buf = &(tsk->thread.fpu.state->xsave);
> +	if (!(xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ENABLE_FLAG))
> +		return NULL;

Now this might be understandable with a proper comment. Right now it's
a magic check for something uncomprehensible.

> +	return (void __user *)(unsigned long)(xsave_buf->bndcsr.cfg_reg_u &
> +			MPX_BNDCFG_ADDR_MASK);
> +}
> +
> +int mpx_register(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +
> +	if (!cpu_has_mpx)
> +		return -EINVAL;
> +
> +	/*
> +	 * runtime in the userspace will be responsible for allocation of
> +	 * the bounds directory. Then, it will save the base of the bounds
> +	 * directory into XSAVE/XRSTOR Save Area and enable MPX through
> +	 * XRSTOR instruction.
> +	 *
> +	 * fpu_xsave() is expected to be very expensive. In order to do
> +	 * performance optimization, here we get the base of the bounds
> +	 * directory and then save it into mm_struct to be used in future.
> +	 */

Ah. Now we get some information what this might do. But that does not
make any sense at all.

So all it does is:

    tsk->mm.bd_addr = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;

or:

    tsk->mm.bd_addr = NULL;

So we use that information to check, whether we need to tear down a
VM_MPX flagged region with mpx_unmap(), right?

> +         /*
> +          * Check whether this vma comes from MPX-enabled application.
> +          * If so, release this vma related bound tables.
> +          */
> +         if (mm->bd_addr && !(vma->vm_flags & VM_MPX))
> +                 mpx_unmap(mm, start, end);

You really must be kidding. The application maps that table and never
calls that prctl so do_unmap() will happily ignore it?

The design to support this feature makes no sense at all to me. We
have a special mmap interface, some magic kernel side mapping
functionality and then on top of it a prctl telling the kernel to
ignore/respect it.

All I have seen so far is the hint to read some intel feature
documentation, but no coherent explanation how this patch set makes
use of that very feature. The last patch in the series does not count
as coherent explanation. It merily documents parts of the
implementation details which are required to make use of it but
completely lacks of a coherent description how all of this is supposed
to work.

Despite the fact that this is V8, I can't suppress the feeling that
this is just cobbled together to make it work somehow and we'll deal
with the fallout later. I wouldn't be surprised if some of the fallout
is going to be security related. I have a pretty good idea how to
exploit it even without understanding the non-malicious intent of the
whole thing.

So: NAK to the whole series for now until someone comes up with a
coherent explanation.

Thanks,

	tglx
