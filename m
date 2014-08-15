Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaHOTdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:33:43 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34463 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHOTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:33:42 -0400
Date: Fri, 15 Aug 2014 12:33:34 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140815193144.GG18411@ld-irv-0074>
References: <20140814222119.GD18411@ld-irv-0074>
 <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 15, 2014 at 02:30:49AM -0700, Jeff Kirsher wrote:
> Funny that you bring this up because I have ~60 patches in my queue to
> resolve several thousand of these warnings.  Half of the patches
> actually resolve warnings that can be resolved and the other half
> implement compiler diagnostic control macros to help silence warnings.
> All these were the work of a co-worker Mark Rustad, below is the patch
> he put together to implement the compiler diagnostic control macros.

While fixing warnings is usually a good thing (at least when done right;
there are plenty of ways to fight with the compiler over silly things,
but that's another discussion), I think that my issue is still
orthogonal to the one you're addressing. In my estimation, it is
impossible to guarantee that the entire kernel (including drivers) will
build without any warnings, across all levels of warning verbosity.
Thus, even with a valiant effort to fix or annotate all warnings, we
still won't get to the point where I can build 'make ARCH=mips W=1', if
-Werror is active.

Besides, when testing *new* code, it's even more likely to have new
warnings, and I'd like to see as many as possible, without -Werror
getting in the way.

So I still think -Werror is fundamentally wrong in some cases, and I
would like to pursue some approach like in my original post.

BTW, for a little more context: I realize the output of 'make W=[123]'
may not be very useful on its own, sometimes, but it's actually pretty
useful to quickly catch potential issues in new code, by diff'ing the
warnings in the before/after build logs. In this case, it's not helpful
at all if the first build "fails" due to dubious warnings. I'm doing
this in the context of Aiaiai [1]. Right now, I have to keep around a
few local patches to remove -Werror from arch/{mips,sh}.

> commit 7b9aace02b2405f0714bc08c424b72e6962f1c2e
> Author: Mark Rustad <mark.d.rustad@intel.com>
> Date:   Fri Aug 15 01:43:44 2014 -0700
> 
>     compiler: Add diagnostic control macros
> 
>     Add macros to control diagnostic messages where needed. These
>     are used to silence warning messages that are expected, normal
>     and do not indicate any sort of problem. Reducing the stream
>     of messages in this way helps possible problems to stand out.
> 
>     The macros provided are:
>         DIAG_PUSH() - to save diagnostic settings
>         DIAG_POP() - to restore diagnostic settings
>         DIAG_IGNORE(option) - to ignore a particular warning
>         DIAG_GCC_IGNORE(option) - DIAG_IGNORE for gcc only
>         DIAG_CLANG_IGNORE(option) - DIAG_IGNORE for clang only
> 
>     Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> 
> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> index d1e49d5..039b112 100644
> --- a/include/linux/compiler-clang.h
> +++ b/include/linux/compiler-clang.h
> @@ -10,3 +10,29 @@
>  #undef uninitialized_var
>  #define uninitialized_var(x) x = *(&(x))
>  #endif
> +
> +/*
> + * Provide macros to manipulate diagnostic messages when possible.
> + * DIAG_PUSH pushes the diagnostic settings
> + * DIAG_POP pops the diagnostic settings
> + * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
> + *
> + * Example:
> + *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
> + *    struct timespec ns_to_timespec(const s64 nsec)
> + *    {
> + *        ...
> + *    }
> + *    DIAG_POP
> + *
> + * Will prevent the warning on compilation of the function. Other
> + * steps are necessary to do the same thing for the call sites.
> + */

While I do not want to disparage your/Mark's work here, my first thought
about this kind of annotation is that it seems to be a pretty big burden
to have to annotate all code with these sorts of things. While it could
help for some core parts of the kernel that can be closely scrutinized
and defended against false/useless warnings, from my perspective it
seems like people are bound to get it wrong when it comes to the long
tail of scattered device drivers.

But I'm not really the right voice for that topic. Feel free to send
your work and see what the rest of the community thinks.

Thanks,
Brian

[1] http://lwn.net/Articles/488992/
    http://git.infradead.org/aiaiai.git
