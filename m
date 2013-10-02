Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3JBJ0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3JBJ0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:26:32 -0400
Date: Wed, 2 Oct 2013 11:26:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20131002092608.GA10099@krava.brq.redhat.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930164210.GA22342@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 06:42:10PM +0200, Ingo Molnar wrote:
> 
> This series (with combo patch attached) implements (much) faster 
> perf-tools feature-auto-detection.
> 
> I used 3 tricks to implement feature auto-dependencies and to speed up 
> feature detection:
> 
>   - standalone Makefile in config/feature-checks/ built in parallel
> 
>   - split-out standalone .c files in config/feature-checks/*.c
> 
>   - used GCC's auto-dependency generation feature (-MD) to track the
>     effects of system library addition/removal.
> 
> Before the changes a fully cached re-build of an already built tree took 
> 2.6 second:
> 
>     $ perf stat --null --sync --repeat 3 -a make Makefile
> 
>        2.669467209 seconds time elapsed                                          ( +-  0.07% )
> 
> After the changes it takes only 0.6 seconds:
> 
>        0.599161560 seconds time elapsed                                          ( +-  0.25% )

nice!

> 
> So the empty build got 4.4x faster.
> 

SNIP

>  ifdef NO_DEMANGLE
>    CFLAGS += -DNO_DEMANGLE
>  else
> -  ifdef HAVE_CPLUS_DEMANGLE
> +  ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
>      EXTLIBS += -liberty
> -    CFLAGS += -DHAVE_CPLUS_DEMANGLE
> +    CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
>    else
>      FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> -    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> -    ifeq ($(has_bfd),y)
> +    ifeq ($(feature-libbfd), 1)
>        EXTLIBS += -lbfd
>      else
>        FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
> @@ -388,7 +410,7 @@ else
>            has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
>            ifeq ($(has_cplus_demangle),y)
>              EXTLIBS += -liberty
> -            CFLAGS += -DHAVE_CPLUS_DEMANGLE
> +            CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
>            else
>              msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
>              CFLAGS += -DNO_DEMANGLE
> @@ -400,30 +422,29 @@ else
>  endif

Why not add tests for has_bfd_iberty/has_bfd_iberty_z/has_cplus_demangle?

We could remove the config/feature-tests.mak completely
and other cleanup like remove try-cc.

jirka
