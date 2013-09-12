Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3ILUbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:31:24 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:53492 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3ILUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:31:20 -0400
Date: Thu, 12 Sep 2013 22:31:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912203116.GD32644@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912200236.GC11400@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Sep 12, 2013 at 12:58:28PM -0700, David Ahern escreveu:
> > On 9/12/13 11:43 AM, Arnaldo Carvalho de Melo wrote:
> >
> > > Its something that annoys me as well, but not so much as to make me 
> > > figure out how to make those be done only if some source file 
> > > changed.
> > 
> > Jiri and I have both taken stabs at a config-based build rather than 
> > probing. Just need to finish it.
> 
> But even then it would be nice to have a:
> 
> make autoconfig
> 
> That is what we have now, but only then we would try to do all that 
> probing. Caching it somehow, as Ingo suggested, would get the best of 
> both worlds.

Caching should be relatively straightforward: I'd suggest splitting up all 
the feature tests current present in tools/perf/config/feature-tests.mak 
into separate .c files which build into working binaries.

Instead of having 20 testcases crammed into a single Makefile:

comet:~/tip/tools/perf> git grep -w main config/feature-tests.mak 
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(int argc, char *argv[])
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)
config/feature-tests.mak:int main(void)

Why not put those into 20x standalone .c files and try to build them as an 
explicit make command attempt from within the main Makefile? If the build 
fails then the feature flag is set to off, if it succeeds it's defined.

That makes feature tests generally easier to debug, easier to understand 
and generally easier to extend as well.

'Feature test binaries' that are already built will be 'cached' 
automatically, and the result of their build attempt will be a quick 
success.

This is relatively simple, well-known, powerful and I see no reason why it 
wouldn't work. No separate config language or special files are needed - 
just .c files, binaries and a Makefile.

'make clean' would get rid of the binaries.

[ It could even be made to work against package removal if we really 
  wanted to: if there's a common, known include file related to the 
  feature (such as /usr/include/libaudit.h), then that include file
  could be added to the feature-test binary's list of dependencies. If the
  package is removed and the include file goes away, then the dependency
  breaks automatically and the binary is 'rebuilt', auto-detecting the
  failed dependency. ]

Thanks,

	Ingo
