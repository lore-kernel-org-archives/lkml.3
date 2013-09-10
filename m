Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3IJL6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:58:47 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54759 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IJL6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:58:46 -0400
Date: Tue, 10 Sep 2013 13:58:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 0/3] perf tools: Fix scalability problem on callchain
 merging
Message-ID: <20130910115841.GC28268@somewhere>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:24:15PM +0900, Namhyung Kim wrote:
> Hello,
> 
> Linus reported that perf report was stuck in after "processing time
> ordered events".  It turned out that merging/collapsing the callchain
> takes most of time to look up a matching callchain.  Since it did a
> linear search for the lookup, it took more than 95% of time during the
> processing huge file that contains callchains.
> 
> This patchset tries to fix the problem by
> 
>  1. converting children list to a rbtree
>  2. add UI progress window to inform user
> 
> With this patch, processing time of 400MB perf.data file went down
> from 380s to 20s.

Even if we get rid of hists collapsing, this may still bring value on
performance. One way to test is to sort by pid or by sym and compare
before and after the patchset. pid/sym shouldn't make use of collapses.

Thanks.

> 
> Thanks,
> Namhyung
> 
> 
> Namhyung Kim (3):
>   perf callchain: Convert children list to rbtree
>   perf ui/progress: Add new helper functions for progress bar
>   perf tools: Show progress on histogram collapsing
> 
>  tools/perf/builtin-annotate.c |   2 +-
>  tools/perf/builtin-diff.c     |   2 +-
>  tools/perf/builtin-report.c   |  10 ++-
>  tools/perf/builtin-top.c      |   4 +-
>  tools/perf/tests/hists_link.c |   2 +-
>  tools/perf/ui/progress.c      |  18 +++++
>  tools/perf/ui/progress.h      |  10 +++
>  tools/perf/util/callchain.c   | 151 ++++++++++++++++++++++++++++++++----------
>  tools/perf/util/callchain.h   |   5 +-
>  tools/perf/util/hist.c        |   5 +-
>  tools/perf/util/hist.h        |   3 +-
>  tools/perf/util/session.c     |  22 +++---
>  12 files changed, 173 insertions(+), 61 deletions(-)
> 
> -- 
> 1.7.11.7
> 
