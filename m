Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaHBNUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:20:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:41762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaHBNUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:20:19 -0400
Date: Sat, 2 Aug 2014 10:20:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v2 2/2] perf tools: Default to python version 2
Message-ID: <20140802132013.GC13375@kernel.org>
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
 <1406617040-26909-2-git-send-email-namhyung@kernel.org>
 <20140801202149.GB13375@kernel.org>
 <53DCC3F0.6000105@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DCC3F0.6000105@tu-dresden.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 02, 2014 at 12:56:48PM +0200, Thomas Ilsche escreveu:
> 
> Zitat von Arnaldo Carvalho de Melo <acme@kernel.org>:
> 
> > Em Tue, Jul 29, 2014 at 03:57:20PM +0900, Namhyung Kim escreveu:
> >> According to PEP 394 recommendation [1], it's more portable to use
> >> python2 rather than plain python to refer python binary version 2.
> >>
> >> Since there're distros using python3 by default like Arch, and we
> >> don't support python3 (yet), it'd be better using python2 explicitly.
> >>
> >> But older versions (prior to 2.7) seem not to provide python2 but just
> >> python.  Given that it's only old version, try python2 first and then
> >> fallback to python.  It'll ensure that it always points to python 2.x.
> >
> > It should fallback, right?
> 
> Yes.
> 
> > [acme@fedora14 linux]$ ls -la /usr/bin/python2-config
> > ls: cannot access /usr/bin/python2-config: No such file or directory
> > [acme@fedora14 linux]$ ls -la /usr/bin/python-config
> > lrwxrwxrwx. 1 root root 16 Mar 25 09:43 /usr/bin/python-config ->  
> > python2.7-config
> 
> Appearently this fedora package symlinks python -> python2 but does not so for
> python2-config. The Makefile looks for either python2 or python as fallback and
> then assumes that a respective "-config" exists. I think this is a sane assumption.

Maybe the way python was packaged on f14 is problematic, as you
describe, but the fact is that python support is not working on that
platform after this patch.

Could you please try to prepare a patch that does as you suggest so that
I can try?

Thanks,

- Arnaldo
 
> I guess if this needs to be supported, there needs to be another fallback if
> $(PYTHON)-config is not found to try python-config again. However this may
> behave weirdly if someone has python2, no python2-devel but python3-devel
> installed, sets PYTHON=python2 and then still gets a version error. Or we
> somehow only fallback if no PYTHON is specified (not sure how to implemented
> that elegantly).
> 
> Best,
> Thomas
> 
> 
> > [acme@fedora14 linux]$ rpm -qf /usr/bin/python-config
> > python-devel-2.7-8.fc14.1.x86_64
> > [acme@fedora14 linux]$ cat /etc/fedora-release
> > Fedora release 14 (Laughlin)
> > [acme@fedora14 linux]$
> >
> > [acme@fedora14 linux]$ time make O=/tmp/build/perf -C tools/perf install
> > make: Entering directory `/home/acme/git/linux/tools/perf'
> >   BUILD:   Doing 'make -j4' parallel build
> > config/Makefile:126: The path '/usr/bin/python2-config' is not executable.
> > config/Makefile:339: No libdw DWARF unwind found, Please install
> > elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR
> > config/Makefile:481: Missing perl devel files. Disabling perl scripting
> > support, consider installing perl-ExtUtils-Embed
> > config/Makefile:512: No python-config tool was found
> > config/Makefile:512: Python support will not be built
> >
> >> [1] https://www.python.org/dev/peps/pep-0394
> >>
> >> Suggested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> >> Tested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
> >> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >> ---
> >>  tools/perf/config/Makefile | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> >> index e05d8f99424d..60177278a357 100644
> >> --- a/tools/perf/config/Makefile
> >> +++ b/tools/perf/config/Makefile
> >> @@ -121,8 +121,8 @@ ifdef PARSER_DEBUG
> >>  endif
> >>
> >>  ifndef NO_LIBPYTHON
> >> -  override PYTHON := \
> >> -    $(call get-executable-or-default,PYTHON,python)
> >> +  PYTHON2 := $(if $(call get-executable,python2),python2,python)
> >> +  override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON2))
> >>    override PYTHON_CONFIG := \
> >>      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
> >>
> >> --
> >> 2.0.0
> 
> 
> 
> 


