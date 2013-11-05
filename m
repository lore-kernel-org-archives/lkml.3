Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3KEIFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:05:55 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49753 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3KEIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:05:54 -0500
Date: Tue, 5 Nov 2013 09:05:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Howard Cochran <hcochran@lexmark.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/29] perf/core improvements and fixes
Message-ID: <20131105080549.GA10030@gmail.com>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
 <20131104201613.GA19839@gmail.com>
 <20131105075228.GA8271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105075228.GA8271@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Now it displays the spammy auto-detection all the time:
> 
> comet:~/tip/tools/perf> make
>   BUILD:   Doing 'make -j12' parallel build
> 
> Auto-detecting system features:
> ...                     backtrace: [ on  ]
> ...                         dwarf: [ on  ]
> ...                fortify-source: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                  gtk2-infobar: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...             libelf-getphdrnum: [ on  ]
> ...                   libelf-mmap: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...             libpython-version: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...                       on-exit: [ on  ]
> ...                stackprotector: [ on  ]
> ...            stackprotector-all: [ on  ]
> 
> maybe a new testcase fails on my box, but is not properly displayed?

Hm, a 'make clean' cleaned up the condition and it now works as expected. 

So what happened is that GCC got upgraded from 4.8.1 to 4.8.2 and 
test-all.c failed to build:

  comet:~/tip/tools/perf/config/feature-checks> make -i
  make: *** No rule to make target `/usr/lib/gcc/x86_64-redhat-linux/4.8.1/include/limits.h', needed by `test-all'.  Stop.

but the individual testcases got built successfully and the perf build was 
fine and correct - it's just that the test-all.c .d file never got updated 
due to the broken dependency.

I think Namhyung warned about this during the feature-detection 
discussion, and I dismissed the concern - but Namhyung was right, it's a 
real problem.

I think to fix this we should automatically clean out potentially stale .d 
files automatically after testcase build failures (be it test-all.c or any 
other testcase)?

That would still preserve all the good roles of these dependencies and it 
would preserve the build speed and detection of system library changes.

Thanks,

	Ingo
