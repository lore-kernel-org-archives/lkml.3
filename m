Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaEGMhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbaEGMhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:37:39 -0400
Date: Wed, 7 May 2014 14:36:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 2/3] perf tests: Add dwarf unwind test on ARM
Message-ID: <20140507123636.GD2019@krava.brq.redhat.com>
References: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
 <1399389979-11279-3-git-send-email-jean.pihet@linaro.org>
 <20140507120603.GC2019@krava.brq.redhat.com>
 <CAFrcx1=-Q7t3ShLy=Ky9RNFfvMb=tdgSLh6bqFDXp59auXetFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=-Q7t3ShLy=Ky9RNFfvMb=tdgSLh6bqFDXp59auXetFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:24:53PM +0200, Jean Pihet wrote:
> Hi Jiri,
> 
> On 7 May 2014 14:06, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Tue, May 06, 2014 at 05:26:18PM +0200, Jean Pihet wrote:
> >
> SNIP
> >
> > there's a memory leak of 'buf' already fixed fox x86:
> >
> >   perf tests x86: Fix memory leak in sample_ustack()
> >   commit 763d7f5f2718f085bab5a9e63308349728f3ad12
> >   Author: Masanari Iida <standby24x7@gmail.com>
> >   Date:   Sun Apr 20 00:16:41 2014 +0900
> >
> > jirka
> 
> Ok
> 
> Here is the diff between the x86 and the ARM implementations:
> $ diff -urN tools/perf/arch/arm64/tests/dwarf-unwind.c
> tools/perf/arch/x86/tests/dwarf-unwind.c
> --- tools/perf/arch/arm64/tests/dwarf-unwind.c    2014-05-06
> 17:31:17.507961045 +0200
> +++ tools/perf/arch/x86/tests/dwarf-unwind.c    2014-05-06
> 16:52:00.589776839 +0200
> @@ -21,11 +21,12 @@
>          return -1;
>      }
> 
> -    sp = (unsigned long) regs[PERF_REG_ARM64_SP];
> +    sp = (unsigned long) regs[PERF_REG_X86_SP];
> 
> -    map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
> +    map = map_groups__find(thread->mg, MAP__VARIABLE, (u64) sp);
>      if (!map) {
>          pr_debug("failed to get stack map\n");
> +        free(buf);
>          return -1;
>      }
> 
> Which leads to a few questions:
> - the map_groups__find parameters need to be fixed too, right?

the reason for this is following commit:
  6392b4e perf x86: Fix perf to use non-executable stack, again

which also adds global link flags: -Wl,-z,noexecstack 
so I'm guessing arm is affected too

> - the free(buf) needs to be fixed,
> - given that the remaining difference in the file is just a register
> macro, it is worth to factor the code in a single file. Does that make
> sense? If worthwhile I can do that once the ARM and ARM64 support is
> merged in.

we can do the code factoring later here, np

thanks,
jirka
