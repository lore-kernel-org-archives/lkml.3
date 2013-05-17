Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3EQOkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:40:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab3EQOkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:40:01 -0400
Date: Fri, 17 May 2013 16:39:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/9] perf report: Don't be bothered with locking when
 adding hist entries
Message-ID: <20130517143944.GF3848@krava.brq.redhat.com>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
 <1368497347-9628-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368497347-9628-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:09:03AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The perf report is single-threaded, so no need to grab a lock.
> Although the fast path of pthread_mutex_[un]lock() is very fast,
> there's ~3% gain by eliminating it when we have huge sample data.
> 
>   $ perf record -a -F 100000 -o perf.data.bench -- perf bench sched all
>   $ perf record -e cycles:upp -o perf.data.before -- \
>   > perf report -i perf.data.bench --stdio > /dev/null
>   ... apply this patch ...
>   $ perf record -e cycles:upp -o perf.data.after -- \
>   > perf report -i perf.data.bench --stdio > /dev/null
>   $ perf diff perf.data.{before,after} | grep pthread
>              +0.02%  libpthread-2.15.so  [.] _pthread_cleanup_push_defer
>              +0.02%  libpthread-2.15.so  [.] _pthread_cleanup_pop_restore
>      0.05%   -0.05%  perf                [.] pthread_mutex_unlock@plt
>      0.05%   -0.05%  perf                [.] pthread_mutex_lock@plt
>      1.01%   -1.01%  libpthread-2.15.so  [.] pthread_mutex_lock
>      1.68%   -1.68%  libpthread-2.15.so  [.] __pthread_mutex_unlock_usercnt
>      0.05%   -0.05%  libpthread-2.15.so  [.] pthread_mutex_unlock
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 4 ----
>  1 file changed, 4 deletions(-)

nice :)

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka
