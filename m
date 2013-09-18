Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3IROVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3IROU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:20:59 -0400
Date: Wed, 18 Sep 2013 11:20:38 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
Message-ID: <20130918142038.GA3891@infradead.org>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
 <20130912203658.GA3216@gmail.com>
 <20130913124354.GB4844@somewhere>
 <20130914061148.GF364@gmail.com>
 <87li2wq9gx.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li2wq9gx.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 17, 2013 at 02:54:22PM +0900, Namhyung Kim escreveu:
> Hi Ingo,
> 
> On Sat, 14 Sep 2013 08:11:49 +0200, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> My patches and Namhyung's should improve the comm situation a lot but we 
> >> can't do much miracle. The only way would be perhaps to be able to limit 
> >> the deepness of the callchain branches.
> >> 
> >> Now may be we can find other big contention point in perf. It's possible 
> >> we also have some endless loop somewhere.
> >
> > Well, it was the 100,000+ step linear list walk that was causing 90% of 
> > the slowness here. Namhyung's patch should dramatically improve that. I 
> > guess time for someone to post a combined tree so that it can be tested 
> > all together?
> 
> I pushed combined tree to 'perf/callchain-v2' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

But you did it for some old tree, as I tried running it now and since my
big perf.data file has PERF_RECORD_MMAP2 records, I can't try it with
your branch, working on cherry picking those changesets, since a plain
rebase didn't work.

- Arnaldo
 
> 
> Please note that I also pushed other versions (v[1-3]).  The v1 is my
> previous rbtree conversion patch, v2 adds Frederic's new comm
> infrastructure series on top and v3 adds my revised patch to refer
> current comm [1] on top of v2.
> 
> I did my own test again among them.  Test data is 400MB perf.data file
> created by parallel kernel build.
> 
>   $ ls -lh perf.data.big
>   -rw-------. 1 namhyung namhyung 400M Sep  9 10:21 perf.data.big
> 
> For more precise result, I changed cpufreq governor to 'performance'
> 
>   # echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> 
> and run perf report on the cpu.
> 
>   $ taskset -c 3 time -p perf --no-pager report --stdio -i perf.data.big > /dev/null
> 
> I ran it multiple times for each case and the results did not vary much.
> 
>         baseline	    v1            v2              v3
>   ----------------------------------------------------------
>   real    380.17	 12.63 	       10.02		9.03
>   user    378.86	 11.95 	        9.66		8.69
>   sys       0.70	  0.65 	        0.33		0.34
> 
> 
> I also tried to cache latest result and reuse it when adding a callchain
> (in callchain_append() function) but it only hits ~5% and did not help
> the performance.
> 
> Thanks,
> Namhyung
> 
> 
> [1] https://lkml.org/lkml/2013/9/16/565
