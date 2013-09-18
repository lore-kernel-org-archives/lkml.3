Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3IRPNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3IRPNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:13:14 -0400
Date: Wed, 18 Sep 2013 12:12:53 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] perf tools: New comm infrastructure
Message-ID: <20130918151253.GC3891@infradead.org>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
 <20130912203658.GA3216@gmail.com>
 <20130913124354.GB4844@somewhere>
 <20130914061148.GF364@gmail.com>
 <87li2wq9gx.fsf@sejong.aot.lge.com>
 <20130918142038.GA3891@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918142038.GA3891@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 18, 2013 at 11:20:38AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Sep 17, 2013 at 02:54:22PM +0900, Namhyung Kim escreveu:
> > On Sat, 14 Sep 2013 08:11:49 +0200, Ingo Molnar wrote:
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >> My patches and Namhyung's should improve the comm situation a lot but we 
> > >> can't do much miracle. The only way would be perhaps to be able to limit 
> > >
> > >> 
> > >> Now may be we can find other big contention point in perf. It's possible 
> > >> we also have some endless loop somewhere.
> > >
> > > Well, it was the 100,000+ step linear list walk that was causing 90% of 
> > > the slowness here. Namhyung's patch should dramatically improve that. I 
> > > guess time for someone to post a combined tree so that it can be tested 
> > > all together?

> > I pushed combined tree to 'perf/callchain-v2' branch in my tree

> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

> But you did it for some old tree, as I tried running it now and since my
> big perf.data file has PERF_RECORD_MMAP2 records, I can't try it with
> your branch, working on cherry picking those changesets, since a plain
> rebase didn't work.

Cherry picking just:

commit ad3c9edd70122c8776bc0735287daba3945e328a
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Mon Sep 9 17:05:38 2013 +0900

    perf callchain: Convert children list to rbtree

I go from too-long-to-wait to:

[root@sandy ~]# echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
[acme@sandy linux]$ taskset -c 3 perf stat --null --sync --repeat 3 perf report -i perf.data.make-j8-kernel > /dev/null

 Performance counter stats for 'perf report -i perf.data.make-j8-kernel' (3 runs):

      79.158464654 seconds time elapsed                                          ( +-  0.15% )

[acme@sandy linux]$
[acme@sandy linux]$ ls -lah perf.data.make-j8-kernel 
-rw-------. 1 acme acme 2.3G Sep 16 11:56 perf.data.make-j8-kernel

Looking at the other patches, modulo the ones that do the progress bar updating
while collapsing, as they clash with a patch from Jiri Olsa.

- Arnaldo
