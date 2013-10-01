Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3JAMFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:05:02 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39302 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3JAMFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:05:00 -0400
Date: Tue, 1 Oct 2013 14:04:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf autodep: Remove strlcpy feature check, add __weak
 strlcpy implementation
Message-ID: <20131001120455.GA8001@gmail.com>
References: <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
 <20131001113456.GA31331@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001113456.GA31331@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Overhead is down from 0.600 secs to 0.540 secs. The only remaining thing 
> is the libperl bug, I'll have a look at that next.

So, libperl detection works fine here, once I've installed the prereq 
package on Fedora, "perl-ExtUtils-Embed":

  comet:~/tip/tools/perf> make Makefile

Auto-detecting system features:

...            stackprotector-all: [ on  ]
...         volatile-register-var: [ on  ]
...                fortify-source: [ on  ]
...                        libelf: [ on  ]
...                   libelf-mmap: [ on  ]
...                         glibc: [ on  ]
...                         dwarf: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                     libunwind: [ on  ]
...                      libaudit: [ on  ]
...                      libslang: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                        libbfd: [ on  ]
...                       on-exit: [ on  ]
...                     backtrace: [ on  ]
...                       libnuma: [ on  ]

Time is down to 0.480 sec because there are no build failures now, only 
Make re-checking the dependencies of already built binaries.

And the actual feature check is roughly 0.330 msecs of that:

 comet:~/tip/tools/perf/config/feature-checks> time ( make -j >/dev/null; \
 for N in stackprotector-all volatile-register-var fortify-source libelf \
 libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 \
 gtk2-infobar libperl libpython libpython-version libbfd on-exit backtrace \
 libnuma; do make test-$N >/dev/null; done )

 real    0m0.330s
 user    0m0.290s
 sys     0m0.031s

With 0.150 msecs spent elsewhere.

So there's more speedups possible I think, for example we could construct 
an 'optimistic' testcase that is generated live and includes a 
concatenation of all the testcases.

If the build of that file succeeds then we have a really efficient 
fast-path both in the first-build and in the repeat-build case.

If that build fails then we do the more finegrained feature check.

Thoughts?

Thanks,

	Ingo
