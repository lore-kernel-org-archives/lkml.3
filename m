Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3KLOlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:41:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3KLOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:41:19 -0500
Date: Tue, 12 Nov 2013 11:41:01 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock
 event period test
Message-ID: <20131112144101.GF11239@ghostprotocols.net>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
 <1384201353-23863-11-git-send-email-acme@infradead.org>
 <5281D3B8.2030104@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5281D3B8.2030104@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 12, 2013 at 09:07:36AM +0200, Adrian Hunter escreveu:
> On 11/11/13 22:22, Arnaldo Carvalho de Melo wrote:
> > We were using it at 10 kHz, which doesn't work in machines where somehow
> > the max freq was auto reduced by the kernel:
> >
> > [root@ssdandy ~]# perf test 19
> > 19: Test software clock events have valid period values    : FAILED!
> > [root@ssdandy ~]# perf test -v 19
> > 19: Test software clock events have valid period values    :
> > --- start ---
> > Couldn't open evlist: Invalid argument
> > ---- end ----
> > Test software clock events have valid period values: FAILED!
> > [root@ssdandy ~]#
> >
> > [root@ssdandy ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
> > 7000
> >
> > Reducing it to 500 Hz should be good enough for this test and also
> > shouldn't affect what it is testing.
> >
> > But warn the user if it fails, informing the knob and the freq tried.
> 
> Doesn't work for me:
> 
> ./perf test -v 19
> 19: Test software clock events have valid period values    :
> --- start ---
> mmap size 528384B
> mmap size 528384B
> All (0) samples have period value of 1!
> ---- end ----
> Test software clock events have valid period values: FAILED!
> 
> But this fixes it:
> 
> diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
> index 93a7139..6664a7c 100644
> --- a/tools/perf/tests/sw-clock.c
> +++ b/tools/perf/tests/sw-clock.c
> @@ -9,7 +9,7 @@
>  #include "util/cpumap.h"
>  #include "util/thread_map.h"
>  
> -#define NR_LOOPS  1000000
> +#define NR_LOOPS  10000000

Lower frequency, need to generate more noise, ugh. Adding that, but I
think this test needs to be reworked, Namhyung?

- Arnaldo
