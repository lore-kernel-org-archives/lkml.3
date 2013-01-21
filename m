Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3AUE5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:57:25 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54255 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3AUE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:57:25 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-16-50fccab2ed53
From: Namhyung Kim <namhyung@kernel.org>
To: Colin King <colin.king@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf evsel: fix NULL pointer deference when evsel->counts is NULL
Date: Mon, 21 Jan 2013 13:53:21 +0900
References: <1358613414-13005-1-git-send-email-colin.king@canonical.com>
Message-ID: <871udfkua5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Colin,

On Sat, 19 Jan 2013 16:36:54 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> __perf_evsel__read_on_cpu() only bails out with -ENOMEM if
> evsel->counts is NULL and perf_evsel__alloc_counts() has returned
> an error.  If perf_evsel__alloc_counts() does not return an error
> we get an NULL pointer deference on evsel->counts->cpu[cpu]
> if evsel->counts is NULL.

perf_evsel__alloc_counts() should allocate evsel->counts when it sees
evsel->counts is NULL and return negative error code if the allocation
fails.

So I don't see any problem in current code.  With your code, it won't
try to allocate if ->counts is NULL but overwrite existing ->counts?

Thanks,
Namhyung

>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  tools/perf/util/evsel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1b16dd1..93acd06 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -640,7 +640,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
>  	if (FD(evsel, cpu, thread) < 0)
>  		return -EINVAL;
>  
> -	if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
> +	if (evsel->counts == NULL || perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
>  		return -ENOMEM;
>  
>  	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
