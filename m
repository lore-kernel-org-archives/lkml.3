Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaDXGrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:47:25 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47169 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaDXGrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:47:23 -0400
Date: Thu, 24 Apr 2014 08:47:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140424064718.GD1104@gmail.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
 <20140423145325.GB27585@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423145325.GB27585@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Apr 23, 2014 at 03:14:33PM +0200, Ingo Molnar wrote:
> > 
> > (Just reporting two bugs I found today - unrelated to your the 
> > perf/urgent pull request.)
> > 
> > 1)
> > 
> > Even when the most modern unwind library is found, the autodetection 
> > is spammy:
> > 
> > 
> >  Auto-detecting system features:
> >  ...                         dwarf: [ on  ]
> >  ...                         glibc: [ on  ]
> >  ...                          gtk2: [ on  ]
> >  ...                      libaudit: [ on  ]
> >  ...                        libbfd: [ on  ]
> >  ...                        libelf: [ on  ]
> >  ...                       libnuma: [ on  ]
> >  ...                       libperl: [ on  ]
> >  ...                     libpython: [ on  ]
> >  ...                      libslang: [ on  ]
> >  ...                     libunwind: [ on  ]
> >  ...            libdw-dwarf-unwind: [ on  ]
> >  ...     DWARF post unwind library: libunwind
> > 
> > The 'DWARF post unwind library' line is somewhat superfluous. I 
> > realize that it prints out the library selected - but that's obvious 
> > from the 'libdw-dwarf-unwind' line above it already, right?
> > 
> > Furthermore, it breaks the autodetection output format.
> > 
> > 2)
> > 
> > On latest Ubuntu (14.04) the tip:master build fails with:
> > 
> >  /usr/bin/ld: cannot find -liberty
> >  collect2: error: ld returned 1 exit status
> > 
> > The autodetection sequence reports all green entries, so something's 
> > funky going on there.
> 
> we add -liberty once -lbfd is detected, I guess we
> assumed that was common case
> 
>   perf tools: fix BFD detection on opensuse
>   commit 280e7c48c3b873e4987a63da276ecab25383f494
>   Author: Andi Kleen <ak@linux.intel.com>
>   Date:   Sat Jan 11 11:42:51 2014 -0800
> 
> could you please try patch below? it adds that only
> if thats detected
> 
> 'make VF=1' should display more status now
> 
> Andi,
> could you please try that on opensuse?
> 
> thanks,
> jirka
> 
> 
> ---
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index ee21fa9..f511658 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -186,7 +186,10 @@ VF_FEATURE_TESTS =			\
>  	stackprotector-all		\
>  	timerfd				\
>  	libunwind-debug-frame		\
> -	bionic
> +	bionic				\
> +	liberty				\
> +	liberty-z			\
> +	cplus-demangle

In any case, your patch fixes the bug. With VF=1 I get this output:

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...     DWARF post unwind library: libunwind
...                     backtrace: [ on  ]
...                fortify-source: [ on  ]
...                  gtk2-infobar: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                   libelf-mmap: [ on  ]
...             libpython-version: [ on  ]
...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]
...         libunwind-debug-frame: [ OFF ]
...                        bionic: [ OFF ]
...                       liberty: [ OFF ]
...                     liberty-z: [ OFF ]
...                cplus-demangle: [ OFF ]

So yes, your obervation that it's the -liberty +libbfd combination is 
correct.

Tested-by: Ingo Molnar <mingo@kernel.org>

Btw., when reading the patch and the Makefile it was not obvious to me 
what 'VF' stood for. It's pretty clear what CORE_FEATURE_TESTS and 
LIB_FEATURE_TESTS means, but there's no comment for VF_FEATURE_TESTS 
and the name is not self-explanatory.

I figured it out from a bit of git log digging that its purpose is to 
generate the 'verbose feature check' output. But the variable is not 
commented and the features it lists overlaps CORE_FEATURE_TESTS and 
LIB_FEATURE_TESTS - so perhaps a bit more explanation (and possible 
reduction in duplication) might be useful?

If it said ALL_FEATURE_TESTS and used $(CORE_FEATURE_TESTS) as a 
baseline then that would be self-explanatory.

(In a separate patch from the fix.)

Thanks,

	Ingo
