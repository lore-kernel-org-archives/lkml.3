Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbaKXVXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:23:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:41113 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKXVXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:23:14 -0500
Date: Mon, 24 Nov 2014 18:23:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: perf/branch-history branch build broken with NO_DEMANGLE=1 perf
 hists browser: Print overhead percent value for first-level callchain
Message-ID: <20141124212308.GE13167@kernel.org>
References: <20141124145227.GE18625@kernel.org>
 <20141124152312.GA13167@kernel.org>
 <20141124152541.GB13167@kernel.org>
 <20141124153204.GC13167@kernel.org>
 <20141124154841.GD13167@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141124154841.GD13167@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 24, 2014 at 12:48:41PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Nov 24, 2014 at 12:32:04PM -0300, Arnaldo Carvalho de Melo escreveu:
> > >        ^
> > > In file included from util/srcline.c:11:0:
> > > util/symbol.h:35:21: note: previous definition of ‘bfd_demangle’ was
> > > here
> > >  static inline char *bfd_demangle(void __maybe_unused *v,
> > >                      ^
> > > make[1]: *** [util/srcline.o] Error 1
> > > make: *** [util/srcline.o] Error 2
> > > make: Leaving directory `/home/git/linux/tools/perf'
> > > [acme@zoo linux]$ 
> > 
> > bisected it down to:
> 
> What I have is on the perf/branch-history branch, we can't both include
> bfd.h and symbol.h when NO_DEMANGLE=1, probably we should just move the
> stub inline to symbol-elf.c, its only user, but I have to check further,
> lunch time tho.

Fixed, pushed it out on my perf/core and perf/branch-history branches.

--branch-history stuff still on a separate branch because it explodes:

[root@zoo acme]# perf record -a -g -b sleep 2s
[ perf record: Woken up 7 times to write data ]
[ perf record: Captured and wrote 3.033 MB perf.data (~132504 samples) ]
[root@zoo acme]# perf report --stdio --branch-history
# To display the perf.data header info, please use --header/--header-only options.
#
BFD: Dwarf Error: Offset (2585882475) greater than or equal to .debug_str size (44321517).
BFD: Dwarf Error: Could not find abbrev number 11800.
<BIG SNIP>
BFD: Dwarf Error: Offset (83496016) greater than or equal to .debug_str size (44321517).
BFD: Dwarf Error: Offset (48628447) greater than or equal to .debug_str size (44321517).
(END)Segmentation fault (core dumped)
[root@zoo acme]# 

Will investigate this later today/tomorrow, if nobody finds a fix in the meantime.

- Arnaldo
