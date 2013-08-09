Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968182Ab3HIQpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:45:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56024 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968112Ab3HIQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:45:54 -0400
Date: Fri, 9 Aug 2013 18:45:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130809164548.GD13339@somewhere>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
 <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
 <20130806154314.GA398@redhat.com>
 <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
 <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
 <20130807192734.GA8395@redhat.com>
 <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
 <20130808154107.GA28971@redhat.com>
 <20130808165427.GC32049@somewhere>
 <20130808181521.GA11138@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808181521.GA11138@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 08:15:21PM +0200, Oleg Nesterov wrote:
> On 08/08, Frederic Weisbecker wrote:
> >
> > I'm all for fixing this. May be we can start by backporting a patch that
> > ignores the value of gen_len for instruction breakpoints in x86?
> 
> Or perhaps we can start with the something like below.

(commented on the diff below)

> 
> But probably we should move "attr.bp_len == HW_BREAKPOINT_LEN_1" check
> from arch_build_bp_info() to its caller, arch_validate_hwbkpt_settings().
> 
> Because:
> 
> > But this bp_len
> > should rather be used for range breakpoints on archs that support it.
> 
> Yes, exactly, and we already have the patches for amd, so bp->len can
> be actually != 1 but currently we can't support because it is checked
> in arch_build_bp_info().

Hmm, but how moving that to arch_validate_hwbkpt_seetings() would solve
the issue?

> 
> Oleg.
> 
> --- x/arch/x86/kernel/hw_breakpoint.c
> +++ x/arch/x86/kernel/hw_breakpoint.c
> @@ -208,19 +208,16 @@ int arch_bp_generic_fields(int x86_len, 
>  {
>  	/* Type */
>  	switch (x86_type) {
> -	case X86_BREAKPOINT_EXECUTE:
> -		if (x86_len != X86_BREAKPOINT_LEN_X)
> -			return -EINVAL;
> -
> -		*gen_type = HW_BREAKPOINT_X;
> -		*gen_len = sizeof(long);
> -		return 0;
>  	case X86_BREAKPOINT_WRITE:
>  		*gen_type = HW_BREAKPOINT_W;
>  		break;
>  	case X86_BREAKPOINT_RW:
>  		*gen_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
>  		break;
> +	case X86_BREAKPOINT_EXECUTE:
> +		*gen_type = HW_BREAKPOINT_X;
> +		if (x86_len == X86_BREAKPOINT_LEN_1)
> +
>			break;
>  	default:
>  		return -EINVAL;
>  	}
> @@ -265,15 +262,11 @@ static int arch_build_bp_info(struct per
>  		break;
>  	case HW_BREAKPOINT_X:
>  		info->type = X86_BREAKPOINT_EXECUTE;
> -		/*
> -		 * x86 inst breakpoints need to have a specific undefined len.
> -		 * But we still need to check userspace is not trying to setup
> -		 * an unsupported length, to get a range breakpoint for example.
> -		 */
> -		if (bp->attr.bp_len == sizeof(long)) {
> -			info->len = X86_BREAKPOINT_LEN_X;
> -			return 0;
> -		}
> +		/* until we change tools/perf */
> +		if (bp->attr.bp_len == sizeof(long))
> +			bp->attr.bp_len = HW_BREAKPOINT_LEN_1;

Too bad we need to keep that compatibility around. Do you think this could be
a problem for AMD range breakpoints?

We can also fix the tools, then may be we'll be able to remove the kernel hack
compatibility in a few years.

Oh I need to check other archs as well.

thanks.

> +		if (bp->attr.bp_len == HW_BREAKPOINT_LEN_1)
> +			break;
>  	default:
>  		return -EINVAL;
>  	}
> 
