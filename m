Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JIOwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:52:03 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:57596 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3JIOwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:52:01 -0400
Date: Wed, 9 Oct 2013 16:51:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [GIT PULL] tools/perf/build: Speed up the perf build system
Message-ID: <20131009145157.GA27139@gmail.com>
References: <20131009070149.GA32023@gmail.com>
 <20131009143830.GA28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009143830.GA28369@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, Oct 09, 2013 at 09:01:49AM +0200, Ingo Molnar escreveu:
> > Arnaldo,
> > 
> > Please pull the tools/perf/build git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.tools/perf/build
> > 
> >    # HEAD: 165108a92fc554d51e73b143b69b77e7c278da78 tools/perf/build: Clean up feature_print_code()
> > 
> > This tree contains the build system speedup series described at:
> > 
> >    https://lkml.org/lkml/2013/10/7/199
> > 
> > Reviewed by David Ahern and Jiri Olsa (thanks guys!).
> 
> One problem I just noticed, and that is not preventing me from merging
> this now, as it has a (obvious) workaround:
> 
> If I try using O= I better make sure the directory it points to exists:
> 
> [acme@sandy linux]$ ls -la tools/perf/*.o tools/perf/util/*.o
> ls: cannot access tools/perf/*.o: No such file or directory
> ls: cannot access tools/perf/util/*.o: No such file or directory
> [acme@sandy linux]$ mkdir -p /tmp/build/perf/
> [acme@sandy linux]$ time make O=/tmp/build/perf -C tools/perf/ install-bin
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
> 
> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ on  ]
> <SNIP>
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> 
> real	0m2.751s
> user	0m4.270s
> sys	0m1.240s
> [acme@sandy linux]$ ls -la tools/perf/*.o tools/perf/util/*.o
> ls: cannot access tools/perf/*.o: No such file or directory
> ls: cannot access tools/perf/util/*.o: No such file or directory
> [acme@sandy linux]$ ls -la /tmp/build/perf/perf
> -rwxrwxr-x. 1 acme acme 9791281 Oct  9 11:32 /tmp/build/perf/perf
> [acme@sandy linux]$
> 
> ---------------------------------------------------------------------------------
> 
> Works as expected, but if I do:
> 
> [acme@sandy linux]$ rm -rf /tmp/build
> [acme@sandy linux]$ time make O=/tmp/build/perf -C tools/perf/ install-bin
> make: Entering directory `/home/acme/git/linux/tools/perf'
>     BUILD: Doing 'make -j8' parallel build
> 
> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> <SNIP>
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> 
> real	0m2.715s
> user	0m4.118s
> sys	0m1.204s
> [acme@sandy linux]$ ls -la tools/perf/*.o tools/perf/util/*.o | wc -l
> 94
> [acme@sandy linux]$ ls -la /tmp/build
> ls: cannot access /tmp/build: No such file or directory
> [acme@sandy linux]$
> 
> ---------------------------------------------------------------------------------
> 
> It silently ignores the O= target, as it doesn't exists.
> 
> Previous, expected behaviour is for the build process to stop, 
> complaining that the target directory doesn't exists.

Yeah. So the reproducer for me is:

 rm -rf /tmp/build
 mkdir -p /tmp/build/perf
 make O=/tmp/build/perf -C tools/perf/ install-bin
 rm -rf /tmp/build
 make O=/tmp/build/perf -C tools/perf/ install-bin

the second install-bin should fail, and on the old tree it fails correctly 
- but with the new tree it pretends that it succeeds.

Looking into it.

Thanks,

	Ingo
