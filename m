Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab3FNCIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:08:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49207 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FNCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:08:42 -0400
X-AuditID: 9c930179-b7c79ae0000022e6-fe-51ba7b28ddd7
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 4/4] perf tools: Retry mapping buffers readonly on EACCES
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
	<1369991785-10499-5-git-send-email-rric@kernel.org>
Date: Fri, 14 Jun 2013 11:08:40 +0900
In-Reply-To: <1369991785-10499-5-git-send-email-rric@kernel.org> (Robert
	Richter's message of "Fri, 31 May 2013 11:16:25 +0200")
Message-ID: <87ip1h30lz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Fri, 31 May 2013 11:16:25 +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
>
> Persistent event buffers may only be mmapped readonly. Thus, retry
> mapping it readonly if mmap returns EACCES after trying to mmap
> writable.
>
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  tools/perf/builtin-record.c | 7 ++++++-
>  tools/perf/builtin-top.c    | 8 ++++++--
>  tools/perf/perf.h           | 1 +
>  3 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index cdf58ec..916776d 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -255,7 +255,12 @@ try_again:
>  		goto out;
>  	}
>  
> -	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
> +try_again2:
> +	if (perf_evlist__mmap(evlist, opts->mmap_pages, opts->mmap_ro) < 0) {
> +		if (!opts->mmap_ro && errno == EACCES) {
> +			opts->mmap_ro = true;
> +			goto try_again2;
> +		}
>  		if (errno == EPERM) {
>  			pr_err("Permission error mapping pages.\n"
>  			       "Consider increasing "
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 67bdb9f..2a5757d 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -899,8 +899,12 @@ try_again:
>  			goto out_err;
>  		}
>  	}
> -
> -	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
> +try_again2:
> +	if (perf_evlist__mmap(evlist, opts->mmap_pages, opts->mmap_ro) < 0) {
> +		if (!opts->mmap_ro && errno == EACCES) {
> +			opts->mmap_ro = true;
> +			goto try_again2;
> +		}
>  		ui__error("Failed to mmap with %d (%s)\n",
>  			    errno, strerror(errno));
>  		goto out_err;


You will need this also:


@@ -161,7 +161,8 @@ static int perf_record__mmap_read(struct perf_record *rec,
        }
 
        md->prev = old;
-       perf_mmap__write_tail(md, old);
+       if (!rec->opts.mmap_ro)
+               perf_mmap__write_tail(md, old);
 
 out:
        return rc;


-- 
Thanks,
Namhyung
