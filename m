Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaANOVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:21:52 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62547 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaANOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:21:50 -0500
Subject: Re: [PATCH] perf tools: Fix build error on zfree()
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20140113180022.GC5318@ghostprotocols.net>
References: <1389276479-9047-1-git-send-email-namhyung@kernel.org>
	 <20140113180022.GC5318@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jan 2014 23:21:42 +0900
Message-ID: <1389709302.1744.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-13 (월), 15:00 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Jan 09, 2014 at 11:07:59PM +0900, Namhyung Kim escreveu:
> > It failed to build perf on my ubuntu 10.04 box (gcc 4.4.3):
> > 
> >     CC       util/strlist.o
> >   cc1: warnings being treated as errors
> >   util/strlist.c: In function ‘str_node__delete’:
> >   util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
> >   util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
> >     CC       util/strfilter.o
> >   make: *** [util/strlist.o] Error 1
> > 
> >     CC       util/srcline.o
> >   cc1: warnings being treated as errors
> >   util/srcline.c: In function ‘addr2line_init’:
> >   util/srcline.c:132: error: dereferencing type-punned pointer will break strict-aliasing rules
> >   util/srcline.c:132: error: dereferencing type-punned pointer will break strict-aliasing rules
> >   util/srcline.c: In function ‘addr2line_cleanup’:
> >   util/srcline.c:143: error: dereferencing type-punned pointer will break strict-aliasing rules
> >   util/srcline.c:143: error: dereferencing type-punned pointer will break strict-aliasing rules
> >   make: *** [util/srcline.o] Error 1
> > 
> > It seems it only allows to remove 'const' qualifier.
> 
> Humm, I just tried building it here on:
> 
> acme@ubuntu13:~/git/linux$ uname -a
> Linux ubuntu13 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9 16:20:46 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> acme@ubuntu13:~/git/linux$ cat /etc/debian_version 
> wheezy/sid
> acme@ubuntu13:~/git/linux$
> 
> acme@ubuntu13:~/git/linux$ make O=/tmp/build/perf -C tools/perf install
> make: Entering directory `/home/acme/git/linux/tools/perf'
>   BUILD:   Doing 'make -j4' parallel build
> 
> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ OFF ]
> ...                fortify-source: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ OFF ]
> ...                  gtk2-infobar: [ OFF ]
> ...                      libaudit: [ OFF ]
> ...                        libbfd: [ OFF ]
> ...                        libelf: [ OFF ]
> ...             libelf-getphdrnum: [ OFF ]
> ...                   libelf-mmap: [ OFF ]
> ...                       libnuma: [ OFF ]
> ...                       libperl: [ OFF ]
> ...                     libpython: [ OFF ]
> ...             libpython-version: [ OFF ]
> ...                      libslang: [ OFF ]
> ...                     libunwind: [ OFF ]
> ...                       on-exit: [ on  ]
> ...            stackprotector-all: [ on  ]
> ...                       timerfd: [ on  ]
> 
> config/Makefile:276: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
> config/Makefile:327: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1
> config/Makefile:350: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
> config/Makefile:364: slang not found, disables TUI support. Please install slang-devel or libslang-dev
> config/Makefile:377: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> config/Makefile:438: The path '/usr/bin/python-config' is not executable.
> config/Makefile:442: No python-config tool was found
> config/Makefile:442: Python support will not be built
> config/Makefile:532: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
>   MKDIR    /tmp/build/perf/arch
> <SNIP>
>   CC       /tmp/build/perf/util/strlist.o
> <SNIP>
>   CC       /tmp/build/perf/util/parse-events.o
>   CC       /tmp/build/perf/util/parse-events-flex.o
>   AR       /tmp/build/perf/libperf.a
>   LINK     /tmp/build/perf/perf
>   INSTALL  binaries
>   INSTALL  libexec
>   INSTALL  perf-archive
>   INSTALL  perf_completion-script
>   INSTALL  tests
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> acme@ubuntu13:~/git/linux$ 
> 
> Works just fine, can you provide more details about your system? Is it 32-bit?

Nope, it's a 64-bit machine.

$ uname -a 
Linux leonhard 2.6.32-45-generic #104-Ubuntu SMP Tue Feb 19 21:20:09 UTC
2013 x86_64 GNU/Linux

$ cat /etc/debian_version 
squeeze/sid

$ make
  BUILD:   Doing 'make -j4' parallel build

Auto-detecting system features:
...                     backtrace: [ on  ]
...                         dwarf: [ on  ]
...                fortify-source: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...             libelf-getphdrnum: [ OFF ]
...                   libelf-mmap: [ on  ]
...                       libnuma: [ OFF ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ OFF ]
...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]

config/Makefile:327: No libunwind found, disabling post unwind support.
Please install libunwind-dev[el] >= 1.1
config/Makefile:532: No numa.h found, disables 'perf bench numa mem'
benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
  GEN      common-cmds.h
<SNIP>
  CC       util/strlist.o
  CC       util/string.o
cc1: warnings being treated as errors
util/strlist.c: In function ‘str_node__delete’:
util/strlist.c:42: error: dereferencing type-punned pointer will break
strict-aliasing rules
util/strlist.c:42: error: dereferencing type-punned pointer will break
strict-aliasing rules
make[1]: *** [util/strlist.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2

$ gcc --version
gcc (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.


Thanks,
Namhyung



