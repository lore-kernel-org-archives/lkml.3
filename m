Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3A3FmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:42:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48624 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3A3FmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:42:05 -0500
Date: Wed, 30 Jan 2013 06:42:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Backlund <tmb@mageia.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf 3.8-rc build failure:  undefined reference to `strlcpy'
Message-ID: <20130130054200.GK30965@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Backlund <tmb@mageia.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>
References: <51074E9D.3040803@mageia.org>
 <20130129103722.GE14444@pd.tnic>
 <87ehh3v2jo.fsf@sejong.aot.lge.com>
 <20130130032831.GA30965@pd.tnic>
 <87a9rruv3x.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a9rruv3x.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 01:56:34PM +0900, Namhyung Kim wrote:
> That's because the toplevel Makefile resets MAKEFLAGS in the middle:

That was me: ea01fa9f63aef

> 
> Makefile:1330
>   # Clear a bunch of variables before executing the submake

and I added this because there was a problem AFAICR. And why I added it,
is not documented in the patch commit message, crap.

>   tools/: FORCE
>   	$(Q)mkdir -p $(objtree)/tools
>   	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
>   
>   tools/%: FORCE
>   	$(Q)mkdir -p $(objtree)/tools
>   	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
>
> So why should it be reset in the first place?

Oh yeah, it was some interaction with the toplevel Makefile that caused
issues. Here's one, if you remove MAKEFLAGS= above and dump it in the
target, here's what you get:

$ make -j9 tools/perf_clean
MAKEFLAGS: --no-print-directory -Rr --jobserver-fds=5,7 -j -I /w/kernel/linux-2.6
    DESCEND perf
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
    SUBDIR ../lib/traceevent/
*.o *~ libtraceevent.a libtraceevent.so *.a *.so ep_version.h .*.d
/bin/sh: 1: *.o: not found
make[4]: *** [clean] Error 127
make[3]: *** [sub-make] Error 2
make[2]: *** [/w/kernel/linux-2.6/tools/perf/libtraceevent.a-clean] Error 2
make[1]: *** [perf_clean] Error 2
make: *** [tools/perf_clean] Error 2

The "rm -f" is missing at the beginning of the line because kbuild does
remove build files differently.

If you leave it in, it works fine:

    DESCEND perf
    SUBDIR ../lib/traceevent/
rm -f *.o *~ libtraceevent.a libtraceevent.so *.a *.so ep_version.h .*.d
...

> > Oh, and one more thing, there's tools/scripts/Makefile.include which
> > looks at -s already and perf/Makefile includes it so you probably want
> > to put your change there so that all tools use it.
> 
> Are you suggesting that moving "try-cc" to the Makefile.include?

Forget it, I got confused with the QUIET_* thingies in
<tools/scripts/Makefile.include>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
