Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3JBGus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:50:48 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42274 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3JBGuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:50:46 -0400
Date: Wed, 2 Oct 2013 08:50:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Speed up git-version test on re-make
Message-ID: <20131002065042.GA5097@gmail.com>
References: <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
 <20131001113456.GA31331@gmail.com>
 <20131001144618.GA8970@gmail.com>
 <87txh0mao8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txh0mao8.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue, 1 Oct 2013 16:46:18 +0200, Ingo Molnar wrote:
> 
> [SNIP]
> >  
> > -$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
> > +$(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
> >  	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
> > +	@touch $(OUTPUT)PERF-VERSION-FILE
> >  
> >  CC = $(CROSS_COMPILE)gcc
> >  AR = $(CROSS_COMPILE)ar
> > @@ -813,7 +814,17 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-c
> >  	$(RM) $(OUTPUT)util/*-flex*
> >  	$(python-clean)
> >  
> > +#
> > +# Trick: if ../../.git does not exist - we are building out of tree for example,
> > +# then force version regeneration:
> > +#
> > +ifeq ($(wildcard ../../.git/HEAD),) 
> > +    GIT-HEAD-PHONY = ../../.git/HEAD
> > +else 
> > +    GIT-HEAD-PHONY =
> > +endif
> > +
> >  .PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
> >  .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
> > -.PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
> > +.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS
> >  
> 
> I found an unrelated bug.  When I tried to build perf out of tree after 
> 'make perf-targz-src-pkg' it cannot get any version number.
> 
>       GEN common-cmds.h
>       * new build flags or prefix
>   make[1]: *** No rule to make target `kernelversion'.  Stop.
>   PERF_VERSION = 
>       ...
>       AR libperf.a
>       LINK perf
> 
>   $ ./perf --version
>   perf version 

Is this unrelated to my patches?

> It looks like we should save and pass the result of 'make kernelversion' 
> to the tarball.

Or we could simply generate PERF-VERSION-FILE and save it into the 
tarball?

Then it will be the most accurate version we can determine at the point 
when the tarball is generated.

Thanks,

	Ingo
