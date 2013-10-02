Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3JBG2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:28:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3JBG2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:28:39 -0400
Date: Wed, 2 Oct 2013 08:28:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20131002062835.GE31122@gmail.com>
References: <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <87zjqsmcma.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjqsmcma.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ingo,
> 
> On Mon, 30 Sep 2013 18:42:10 +0200, Ingo Molnar wrote:
> > This series (with combo patch attached) implements (much) faster 
> > perf-tools feature-auto-detection.
> >
> > I used 3 tricks to implement feature auto-dependencies and to speed up 
> > feature detection:
> >
> >   - standalone Makefile in config/feature-checks/ built in parallel
> >
> >   - split-out standalone .c files in config/feature-checks/*.c
> >
> >   - used GCC's auto-dependency generation feature (-MD) to track the
> >     effects of system library addition/removal.
> 
> I have a memory that this could lead to a nasty build failure.  Please 
> see the commit b6f4f804108b ("tools lib traceevent: Do not generate 
> dependency for system header files").

I think that at least the 'make clean' failure was just a buggy Makefile. 
To quote the build error from the commit:

   comet:~/tip/tools/lib/traceevent> make clean
   make: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.7.0/include/stddef.h', needed by `.trace-seq

It suggests that the 'clean' target depended on .d dependency files - 
that's a fundamentally incorrect use of -M/-MD auto-dependencies.

> The problem is that it turned out to depend on some compiler headers 
> which are located under some directory with a version number.  If so, 
> when compiler upgraded to a new version, it cannot find the original 
> dependencies so fail to build.
> 
>  $ cat config/feature-checks/test-libelf.d
>   test-libelf: test-libelf.c /usr/include/libelf.h /usr/include/sys/types.h \
>    /usr/include/features.h /usr/include/stdc-predef.h \
>    /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
>    /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h \
>    /usr/include/bits/types.h /usr/include/bits/typesizes.h \
>    /usr/include/time.h \
>    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include/stddef.h \
>    /usr/include/endian.h /usr/include/bits/endian.h \
>    /usr/include/bits/byteswap.h /usr/include/bits/byteswap-16.h \
>    /usr/include/sys/select.h /usr/include/bits/select.h \
>    /usr/include/bits/sigset.h /usr/include/bits/time.h \
>    /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h \
>    /usr/include/elf.h \
>    /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include/stdint.h \
>    /usr/include/stdint.h /usr/include/bits/wchar.h
> 
> In this case we are using this for feature-checking, so I guess it'd 
> fail to check the feature after upgrade.

The dependencies are re-made by GCC if a target fails and is rebuilt - and 
that should include the new header locations.

I checked out the parent commit (8f7c1d07ade5) which still had full -M, 
and this is how it utilized dependencies:

# let .d file also depends on the source and header files
define check_deps
                @set -e; $(RM) $@; \
                $(CC) -M $(CFLAGS) $< > $@.$$$$; \
                sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
                $(RM) $@.$$$$
endef

that's not a very robust method either: .d files should be generated via 
-MD not via -M and should be included directly into the Makefile, like I 
did it in my patch:

-include *.d */*.d

and the .d files themselves are never added as dependencies - they are 
re-made by compilation automatically, not by any explicit Makefile rule.  
Adding them as dependencies risks circular dependencies, because the only 
method to rebuild a .d file is to actually meet the dependencies of a .c 
target.

So if done properly I don't think the build failure cited in that 
changelog can trigger.

Now, I cannot vouch for -MD blindly, without having seen a lot more 
testing, so we might still be forced to disable or limit that auto-dep 
trick, but the reasons cited in b6f4f804108b don't seem to be a GCC bug 
but a Makefile bug - they just weren't fully understood back then.

Thanks,

	Ingo
