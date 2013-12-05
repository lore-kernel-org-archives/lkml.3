Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3LEJZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:25:10 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:40870 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3LEJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:25:06 -0500
Date: Thu, 5 Dec 2013 10:25:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 28/28] perf tools: Add udis86 disassembler feature check
Message-ID: <20131205092502.GA16653@gmail.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
 <1386076182-14484-29-git-send-email-jolsa@redhat.com>
 <20131204185024.GC14788@ghostprotocols.net>
 <20131205080513.GA1251@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205080513.GA1251@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Dec 04, 2013 at 03:50:24PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Dec 03, 2013 at 02:09:42PM +0100, Jiri Olsa escreveu:
> > > Adding udis86 disassembler feature check which support
> > > is needed for kvm:kvm_emulate_insn tracepoint.
> > >  
> > > +$(call feature_check,udis86)
> > > +ifeq ($(feature-udis86), 1)
> > > +  LIBTRACEEVENT_CFLAGS += -DHAVE_UDIS86
> > > +  EXTLIBS += -ludis86
> > > +else
> > > +  msg := $(warning No udis86 support.);
> > > +endif
> > 
> > That is really an incomplete message, what package should I install?
> > Perhaps we should add this there then:
> > 
> > http://bit.ly/1hyrN52
> 
> nice :-)
> 
> > 
> > Wow, that was easy, but yeah, could be made easier 8-) ;-P
> 
> so something like:
> No udis86 found. Please install udis86-devel.
> 
> or:
> No udis86 found, disabling kvm tracepoints instruction disassembly. Please install udis86-devel.

1)

So, the first problem I can see is in the output:

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
...             libelf-getphdrnum: [ on  ]
...                   libelf-mmap: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]

config/Makefile:421: No udis86 support.

such a 'no XYZ support' message should only occur if a feature test 
failed. _If_ we decide that 'udis86' support is required for a full 
perf build then there should be a new line saying something like:

...                        udis86: [ OFF ]

2)

The other problem I see is that I think we should start adding the 
install-suggestions to the feature-check lines themselves.

On .deb based systems it should say something like:

...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]
...                        udis86: [ OFF ]    # apt-get install udis86-dev

On RPM based systems it should say something like:

...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]
...                        udis86: [ OFF ]    # yum install udis86-devel

Or so. I think we can maintain package suggestion strings for these 
two main distro variants.

The package install strings should probably be maintained together 
with the list of feature names in some table/list format. Such lookup 
tables can be implemented either in Make via:

  http://www.gnu.org/savannah-checkouts/gnu/make/manual/html_node/Computed-Names.html

Or via a shell command in the makefile, using Bash associative arrays 
or such.

Thanks,

	Ingo
