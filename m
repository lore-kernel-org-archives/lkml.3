Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3IQHQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:16:48 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46201 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IQHQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:16:45 -0400
Date: Tue, 17 Sep 2013 09:16:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
Message-ID: <20130917071641.GD20661@gmail.com>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
 <20130912203658.GA3216@gmail.com>
 <20130913124354.GB4844@somewhere>
 <20130914061148.GF364@gmail.com>
 <87li2wq9gx.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li2wq9gx.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

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
> 
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

Btw., 

> 
>   # echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> 
> and run perf report on the cpu.
> 
>   $ taskset -c 3 time -p perf --no-pager report --stdio -i perf.data.big > /dev/null

Btw., for such things you could use 'perf stat --null --sync --repeat 3', 
which will not use the PMU or even perf events, it only uses precise 
timers to measure execution time:

   $ taskset -c 3 perf stat --null --sync --repeat 3 -p perf --no-pager report --stdio -i perf.data.big > /dev/null

> I ran it multiple times for each case and the results did not vary much.

(perf stat --repeat will print a nice stddev as well.)

>         baseline	    v1            v2              v3
>   ----------------------------------------------------------
>   real    380.17	 12.63 	       10.02		9.03
>   user    378.86	 11.95 	        9.66		8.69
>   sys       0.70	  0.65 	        0.33		0.34

(Alas perf stat --null does not print a system/user time split. Might be 
nice to implement that.)

The numbers look pretty nice, a 40x speedup. Especially with the progress 
bar displayed this should be within a human-tolerable runtime.

Still it would be nice to look at some stats: number of records, number of 
call chain entries, average call chain depth, tree size, max tree depth, 
etc. - so that we get a processing cost estimation of how much we spend on 
a single call chain entry, on average.

If any of those values is suspiciously high then maybe we could cull the 
callchain depth by default, people rarely look beyond a couple of entries: 
but this gets tricky when people sort in the reverse direction though - in 
that case the deepest entries are just as valuable as well to the end 
result.

Thanks,

	Ingo
