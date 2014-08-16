Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaHPEe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 00:34:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45464 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaHPEeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 00:34:25 -0400
Date: Fri, 15 Aug 2014 21:34:15 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Mark D Rustad <mrustad@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Overriding -Werror
Message-ID: <20140816043415.GL11952@brian-ubuntu>
References: <20140814222119.GD18411@ld-irv-0074>
 <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com>
 <20140815193144.GG18411@ld-irv-0074>
 <46D9023C-636A-4A09-88DC-9061567B1BAC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D9023C-636A-4A09-88DC-9061567B1BAC@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

(BTW, your mailer is creating some pretty long, unwrapped lines. I've
rewrapped them when quoting below.)

On Fri, Aug 15, 2014 at 08:36:07PM -0700, Mark D Rustad wrote:
> On Aug 15, 2014, at 12:33 PM, Brian Norris <computersforpeace@gmail.com> wrote:
> > On Fri, Aug 15, 2014 at 02:30:49AM -0700, Jeff Kirsher wrote:
> >> Funny that you bring this up because I have ~60 patches in my queue to
> >> resolve several thousand of these warnings.  Half of the patches
> >> actually resolve warnings that can be resolved and the other half
> >> implement compiler diagnostic control macros to help silence warnings.
> >> All these were the work of a co-worker Mark Rustad, below is the patch
> >> he put together to implement the compiler diagnostic control macros.
> > 
> > While fixing warnings is usually a good thing (at least when done right;
> > there are plenty of ways to fight with the compiler over silly things,
> > but that's another discussion),
> 
> I have said at some presentations on the subject that resolving
> warnings is not something you want an intern to do.

Nice.

> > I think that my issue is still
> > orthogonal to the one you're addressing. In my estimation, it is
> > impossible to guarantee that the entire kernel (including drivers) will
> > build without any warnings, across all levels of warning verbosity.
> > Thus, even with a valiant effort to fix or annotate all warnings, we
> > still won't get to the point where I can build 'make ARCH=mips W=1', if
> > -Werror is active.
> 
> Actually, some years ago, I got a MIPS Linux kernel to compile clean
> with even more warnings than W=12 provides.

Congrats!

> It can be done, but it certainly is not a state that is required and
> cannot be maintained across all configurations, architectures and
> compiler versions. This is the real world.

Right, and this is the crux of why I would like to have the option of
disabling -Werror systematically.

> > Besides, when testing *new* code, it's even more likely to have new
> > warnings, and I'd like to see as many as possible, without -Werror
> > getting in the way.
> 
> I have to say that I rather like -Werror.

It has its uses. I think it can be a pretty good option whenever the
compiler's warning level is kept to a reasonable level.

-Wextra, for instance, enables a lot of warnings that can be problematic
for little practical benefit (like -Wsign-compare, which notably is
explicitly overridden for x86).

> One thing that not a lot of people are aware of is that you can
> selectively allow some warnings. -Wno-error=shadow would allow shadow
> warnings to be reported without being treated as errors.

That's interesting. I glazed over this option because I misinterpreted
the second sentence of this note in the gcc manpage:

  "Note that specifying -Werror=foo automatically implies -Wfoo.
  However, -Wno-error=foo does not imply anything."

[ Really, -Wno-error=foo doesn't imply anything? So why does it exist? ;) ]

But now that you mention it, I think it could work as a hack for my
builds right now, since it isn't overridden by a blanket -Werror found
later on the command linie. So if I do

  make ARCH=mips W=1 KCFLAGS="-Wno-error=...(long list of warnings that break the build)..."

then I can systematically perform the build-tests I'd like.

> > So I still think -Werror is fundamentally wrong in some cases, and I
> > would like to pursue some approach like in my original post.
> > 
> > BTW, for a little more context: I realize the output of 'make W=[123]'
> > may not be very useful on its own, sometimes, but it's actually pretty
> > useful to quickly catch potential issues in new code, by diff'ing the
> > warnings in the before/after build logs. In this case, it's not helpful
> > at all if the first build "fails" due to dubious warnings. I'm doing
> > this in the context of Aiaiai [1]. Right now, I have to keep around a
> > few local patches to remove -Werror from arch/{mips,sh}.
> 
> The problem is that when a kernel build throws over 125,000 warnings,
> it just becomes completely useless. That was what kind of set me off.

Yeah that's bad. But it *still* can provide a helpful diff for tools
like Aiaiai. The difference between 125,000 and 125,001 warnings still
can be determined automatically for new code, although it's not helpful
if every "new" warning is actually just because you used a new core
header that causes a lot of warnings.

> I did wind up pushing this rock further up the hill than I really
> meant to. Still, I got the build under 1,400 warnings, and I now know
> how to address most of them in a systematic way.
> 
> >> commit 7b9aace02b2405f0714bc08c424b72e6962f1c2e
> >> Author: Mark Rustad <mark.d.rustad@intel.com>
> >> Date:   Fri Aug 15 01:43:44 2014 -0700
> >> 
> >>    compiler: Add diagnostic control macros
> >> 
> >>    Add macros to control diagnostic messages where needed. These
> >>    are used to silence warning messages that are expected, normal
> >>    and do not indicate any sort of problem. Reducing the stream
> >>    of messages in this way helps possible problems to stand out.
> >> 
> >>    The macros provided are:
> >>        DIAG_PUSH() - to save diagnostic settings
> >>        DIAG_POP() - to restore diagnostic settings
> >>        DIAG_IGNORE(option) - to ignore a particular warning
> >>        DIAG_GCC_IGNORE(option) - DIAG_IGNORE for gcc only
> >>        DIAG_CLANG_IGNORE(option) - DIAG_IGNORE for clang only
> >> 
> >>    Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> >> 
> >> diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> >> index d1e49d5..039b112 100644
> >> --- a/include/linux/compiler-clang.h
> >> +++ b/include/linux/compiler-clang.h
> >> @@ -10,3 +10,29 @@
> >> #undef uninitialized_var
> >> #define uninitialized_var(x) x = *(&(x))
> >> #endif
> >> +
> >> +/*
> >> + * Provide macros to manipulate diagnostic messages when possible.
> >> + * DIAG_PUSH pushes the diagnostic settings
> >> + * DIAG_POP pops the diagnostic settings
> >> + * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
> >> + *
> >> + * Example:
> >> + *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
> >> + *    struct timespec ns_to_timespec(const s64 nsec)
> >> + *    {
> >> + *        ...
> >> + *    }
> >> + *    DIAG_POP
> >> + *
> >> + * Will prevent the warning on compilation of the function. Other
> >> + * steps are necessary to do the same thing for the call sites.
> >> + */
> > 
> > While I do not want to disparage your/Mark's work here, my first thought
> > about this kind of annotation is that it seems to be a pretty big burden
> > to have to annotate all code with these sorts of things.
> 
> I wouldn't suggest annotating everything. However note that the
> annotations can serve as a notice that something has been analyzed and
> deemed ok. That can be useful as long as that is really true. I
> wouldn't take new code from a new developer that included such
> annotations.

Good points. And I'd recommend framing your argument as such if/when you
post your patches for real. Maybe even add comments near the macro
definitions; "with great power comes great responsibility."

Thanks for your thoughts,
Brian
