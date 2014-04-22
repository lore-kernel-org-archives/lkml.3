Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaDVJ4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:56:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36803 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaDVJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:56:03 -0400
Date: Tue, 22 Apr 2014 11:55:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Fixup for the --percentage change
Message-ID: <20140422095557.GB10813@gmail.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> This patchset tries to fix bugs in percentage handling which is
> recently changed.  The perf top with symbol filter could cause a
> segfault (NULL pointer dereference) if the filter found no entry.
> 
> In this patchset, I moved accounting of various histogram stats to be
> calculated at the time it actually shown to users.  Although I tested
> it on my system for a while, it needs more testing since it'll affect
> behaviors of many commands/usages.
> 
> It's available at 'perf/percentage-v10' branch on my tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments, review and testing are welcomed.
> 
> Thanks,
> Namhyung
> 
> 
> Namhyung Kim (9):
>   perf report: Count number of entries and samples separately
>   perf hists: Introduce hists__add_nr_events()
>   perf tools: Account entry stats when it's added to the output tree
>   perf tools: Introduce hists__inc_dump_events()
>   perf hists: Add missing update on nr_non_filtered_entries
>   perf ui/tui: Fix off-by-one in hist_browser__update_nr_entries()
>   perf ui/tui: Rename hist_browser__update_nr_entries()
>   perf top/tui: Update nr_entries properly after a filter is applied
>   perf hists/tui: Count callchain rows separately
> 
>  tools/perf/builtin-annotate.c  | 27 ++++++--------
>  tools/perf/builtin-report.c    | 51 +++++++++++++-------------
>  tools/perf/builtin-top.c       |  4 ---
>  tools/perf/ui/browsers/hists.c | 81 ++++++++++++++++++++++++++++--------------
>  tools/perf/util/hist.c         | 53 ++++++++++++++++++++-------
>  tools/perf/util/hist.h         |  7 ++++
>  6 files changed, 137 insertions(+), 86 deletions(-)

I gave it some quick testing and after fixing a trivial merge conflict 
in tools/lib/lockdep/Makefile all seems to be working fine.

But while looking at it I remembered one of my old UI complains about 
perf top and report, the hard to read nature of:

   Event count (approx.): 226958779

the values displayed are typically way too large to be easily human 
readable. More importantly, they are also nonsensical! That we have a 
sampling interval and can sum up all the intervals sampled has very 
little meaning to the overwhelming majority of humans looking at the 
data.

And printing that just spams the visual field and confuses people.

People care about the quality and speed of sampling itself, not 
directly the interval of sampling (which will often be variable with 
auto-freq sampling).

So instead of:

  Samples: 42K of event 'cycles', Event count (approx.): 226958779

How about only printing this in 'perf top' and 'perf report':

  Captured 42.1K 'cycles' event samples

Note the extra decimal (which helps monitor smaller changes as well), 
and note the different wording.

Thoughts?

Thanks,

	Ingo
