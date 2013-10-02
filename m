Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3JBKSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:18:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45434 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JBKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:18:30 -0400
Date: Wed, 2 Oct 2013 12:18:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/8] perf callchain: Convert children list to rbtree
Message-ID: <20131002101826.GC7941@localhost.localdomain>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
 <1380185890-25758-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380185890-25758-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 05:58:03PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current collapse stage has a scalability problem which can be
> reproduced easily with parallel kernel build.  This is because it
> needs to traverse every children of callchain linearly during the
> collapse/merge stage.  Convert it to rbtree reduced the overhead
> significantly.
> 
> On my 400MB perf.data file which recorded with make -j32 kernel build:
> 
>   $ time perf --no-pager report --stdio > /dev/null
> 
> before:
>   real	6m22.073s
>   user	6m18.683s
>   sys	0m0.706s
> 
> after:
>   real	0m20.780s
>   user	0m19.962s
>   sys	0m0.689s
> 
> During the perf report the overhead on append_chain_children went down
> from 96.69% to 18.16%:
> 
>   -  18.16%  perf  perf                [.] append_chain_children
>      - append_chain_children
>         - 77.48% append_chain_children
>            + 69.79% merge_chain_branch
>            - 22.96% append_chain_children
>               + 67.44% merge_chain_branch
>               + 30.15% append_chain_children
>               + 2.41% callchain_append
>            + 7.25% callchain_append
>         + 12.26% callchain_append
>         + 10.22% merge_chain_branch
>   +  11.58%  perf  perf                [.] dso__find_symbol
>   +   8.02%  perf  perf                [.] sort__comm_cmp
>   +   5.48%  perf  libc-2.17.so        [.] malloc_consolidate
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Link: http://lkml.kernel.org/n/tip-d9tcfow6stbrp4btvgs51y67@git.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Have you tested this patchset when collapsing is not used?
There are fair chances that this patchset does not only improve collapsing
but also callchain insertion in general. So it's probably a win in any case. But
still it would be nice to make sure that it's the case because we are getting
rid of collapsing anyway.

The test that could tell us about that is to run "perf report -s sym" and compare the
time it takes to complete before and after this patch, because "-s sym" shouldn't
involve collapses.

Sorting by anything that is not comm should do the trick in fact.

Thanks.
