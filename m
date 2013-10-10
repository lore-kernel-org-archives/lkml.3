Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3JJIQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:16:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65273 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3JJIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:16:45 -0400
X-AuditID: 9c930179-b7c78ae000003065-2b-5256626a8abf
From: Namhyung Kim <namhyung@kernel.org>
To: Felipe Pena <felipensp@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf/util: Fix memory leak in trace-event-info.c
References: <1381372135-4408-1-git-send-email-felipensp@gmail.com>
Date: Thu, 10 Oct 2013 17:16:41 +0900
In-Reply-To: <1381372135-4408-1-git-send-email-felipensp@gmail.com> (Felipe
	Pena's message of "Wed, 9 Oct 2013 23:28:55 -0300")
Message-ID: <87txgpczh2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed,  9 Oct 2013 23:28:55 -0300, Felipe Pena wrote:
> Fix for a memory leak on tracing_data_get() function when returning NULL explicitly

Thanks for fixing this bug.  Please see comment below.

>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  tools/perf/util/trace-event-info.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index f3c9e55..06f8624 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -518,13 +518,13 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  			 "/tmp/perf-XXXXXX");
>  		if (!mkstemp(tdata->temp_file)) {
>  			pr_debug("Can't make temp file");
> -			return NULL;
> +			goto err_tdata;
>  		}
>
>  		temp_fd = open(tdata->temp_file, O_RDWR);
>  		if (temp_fd < 0) {
>  			pr_debug("Can't read '%s'", tdata->temp_file);
> -			return NULL;
> +			goto err_tdata;
>  		}
>
>  		/*
> @@ -569,6 +569,10 @@ out:
>
>  	put_tracepoints_path(tps);
>  	return tdata;
> +
> +err_tdata:
> +	free(tdata);
> +	return NULL;
>  }

It should call put_tracepoints_path() too in case of error.  So I
suggest that setting err to an appropriate code and goto if (err) block
above put_tracepoints_path().

Thanks,
Namhyung
