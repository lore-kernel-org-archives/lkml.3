Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaAPM6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:58:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36522 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbaAPM6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:58:10 -0500
Date: Thu, 16 Jan 2014 12:57:27 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
Message-ID: <20140116125727.GI30257@mudshark.cambridge.arm.com>
References: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
 <20140116115634.GE30257@mudshark.cambridge.arm.com>
 <CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 12:26:53PM +0000, Jean Pihet wrote:
> On 16 January 2014 12:56, Will Deacon <will.deacon@arm.com> wrote:
> > In your previous series, compat backtracing is actually split out into a
> > separate function (compat_user_backtrace), so it would be more consistent to
> > have a compat_user_stack_pointer macro, rather than add this check here.
> 
> Do you mean this change instead?

I don't think so...

> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index 569b2187..9b88d2e 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -185,7 +185,8 @@ static inline bool arch_perf_have_user_stack_dump(void)
>         return true;
>  }
> 
> -#define perf_user_stack_pointer(regs) user_stack_pointer(regs)
> +#define perf_user_stack_pointer(regs) \
> +       (!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)

This doesn't belong in core code; compat_user_mode and the fields of regs
are arm64-specific. So I suppose you need to rework your original patch to
call compat_user_stack_pointer (which we already define in compat.h for
arm64) if compat_user_mode(regs)).

The problem there is the inconsistency with respect to the regs argument:

  user_stack_pointer(regs)	// Returns user stack pointer for regs
  current_user_stack_pointer()	// Returns current user stack pointer
  compat_user_stack_pointer()	// Doesn't take a regs argument!

On top of that, x86 treats those last two functions differently when current
is a compat task.

So the simplest thing would be to make compat_user_stack_pointer expand to
user_stack_pointer(current_pt_regs()) on arm64 and merge that in with your
original patch fixing user_stack_pointer.

Will
