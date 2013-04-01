Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3DAXHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:07:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab3DAXHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:07:17 -0400
Date: Tue, 2 Apr 2013 01:06:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/27] perf tools: Move compiler and linker flags check
 into config/Makefile
Message-ID: <20130401230627.GD20943@krava.redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
 <1364843930-17974-6-git-send-email-jolsa@redhat.com>
 <1364854825.1728.19.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364854825.1728.19.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:20:25AM +0900, Namhyung Kim wrote:
> 2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> > Moving compiler and linker flags check into config/Makefile.
> 
> [SNIP]
> 
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index 8dd3320..dcae71b 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -52,6 +52,20 @@ include config/utilities.mak
> >  #
> >  # Define NO_LIBNUMA if you do not want numa perf benchmark
> >  
> > +ifeq ($(srctree),)
> > +srctree := $(patsubst %/,%,$(dir $(shell pwd)))
> > +srctree := $(patsubst %/,%,$(dir $(srctree)))
> > +#$(info Determined 'srctree' to be $(srctree))
> > +endif
> > +
> > +ifneq ($(objtree),)
> > +#$(info Determined 'objtree' to be $(objtree))
> > +endif
> > +
> > +ifneq ($(OUTPUT),)
> > +#$(info Determined 'OUTPUT' to be $(OUTPUT))
> > +endif
> > +
> 
> Question, what's the difference between objtree and OUTPUT?

check top stuff at 'tools/scripts/Makefile.include'

OUTPUT ties with $(subdir), while objtree is pure $(O)

I didn't use the 'tools/scripts/Makefile.include' include
the Makefile.kbuild, just defined OUTPUT variable

The Makefile.kbuild processing is allways based on git tree root,
and all binaries are prefixed $(objtree) or $(obj-perf) and all
source code is prefixed with $(srctree) or $(src-perf)

> 
> 
> > +ifndef PERF_DEBUG
> > +	CFLAGS_OPTIMIZE = -O6
> > +endif
> 
> Is this -O6 really supported by gcc?

hmm, no doc.. and quick google found just your question ;)

> 
> > +
> > +ifdef PARSER_DEBUG
> > +	PARSER_DEBUG_BISON  := -t
> > +	PARSER_DEBUG_FLEX   := -d
> > +	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
> > +endif
> > +
> > +CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
> 
> Please break this line into multiple CFLAGS += ... lines as Sam said.
> 

ok

SNIP

> > +
> > +BASIC_CFLAGS = \
> > +	-Iutil/include \
> > +	-Iarch/$(ARCH)/include \
> > +	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
> > +	-I$(srctree)/arch/$(ARCH)/include/uapi \
> > +	-I$(srctree)/arch/$(ARCH)/include \
> > +	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
> > +	-I$(srctree)/include/uapi \
> > +	-I$(srctree)/include \
> > +	-I$(OUTPUT)util \
> > +	-Iutil \
> > +	-I. \
> > +	-I$(TRACE_EVENT_DIR) \
> > +	-I../lib/ \mktemp
> > +	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> 
> And this too.  Btw do we really need this many include directories?
> 
ok, I tried to sort it out in another patch:
    perf tools: Switch to full patch C include directories

thanks,
jirka
