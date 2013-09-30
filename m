Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3I3DNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 23:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab3I3DN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 23:13:27 -0400
Date: Mon, 30 Sep 2013 05:13:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE
 condition
Message-ID: <20130930031306.GB993@krava.redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
 <1380437526.1727.10.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380437526.1727.10.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 03:52:06PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> 2013-09-27 (금), 16:32 +0200, Jiri Olsa:
> > We fail build with NO_DEMANGLE with missing -lbfd externals error.
> > The reason is that we now use bfd code in srcline object:
> >   perf tools: Implement addr2line directly using libbfd
> > 
> > So we need to check/add -lbfd always now.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > ---
> >  tools/perf/config/Makefile | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> > 
> > diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> > index 8b49a00..40a41c6 100644
> > --- a/tools/perf/config/Makefile
> > +++ b/tools/perf/config/Makefile
> > @@ -360,6 +360,13 @@ else
> >    endif
> >  endif
> >  
> > +FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> > +has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> > +ifeq ($(has_bfd),y)
> > +  EXTLIBS += -lbfd
> > +  CFLAGS += -DLIBBFD_SUPPORT
> > +endif
> > +
> >  ifdef NO_DEMANGLE
> >    CFLAGS += -DNO_DEMANGLE
> >  else
> > @@ -367,11 +374,7 @@ else
> >      EXTLIBS += -liberty
> >      CFLAGS += -DHAVE_CPLUS_DEMANGLE
> >    else
> > -    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
> > -    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
> > -    ifeq ($(has_bfd),y)
> > -      EXTLIBS += -lbfd
> > -    else
> > +    ifneq ($(has_bfd),y)
> >        FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
> >        has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
> >        ifeq ($(has_bfd_iberty),y)
> > @@ -397,10 +400,6 @@ else
> >    endif
> >  endif
> >  
> > -ifndef ($(filter -lbfd,$(EXTLIBS)),)
> > -  CFLAGS += -DLIBBFD_SUPPORT
> > -endif
> > -
> >  ifndef NO_STRLCPY
> >    ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
> >      CFLAGS += -DHAVE_STRLCPY
> 
> Is it enough to check on -lbfd only?  I guess libbfd can have additional
> dependencies to libiberty and libz.  If so, this patch can fail to set
> -DLIBBFD_SUPPORT, right?

hum, you're right.. so it's 2 bugs fixed by removing that code ;-)

jirka
