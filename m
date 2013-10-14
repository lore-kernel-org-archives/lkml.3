Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750896Ab3JNFHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:07:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:51375 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3JNFHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:07:14 -0400
X-AuditID: 9c93017d-b7b79ae000001729-f6-525b7bfe76e5
From: Namhyung Kim <namhyung@kernel.org>
To: Felipe Pena <felipensp@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/perf/util: Fix memory leak in trace-event-info.c
References: <1381454489-4135-1-git-send-email-felipensp@gmail.com>
Date: Mon, 14 Oct 2013 14:07:09 +0900
In-Reply-To: <1381454489-4135-1-git-send-email-felipensp@gmail.com> (Felipe
	Pena's message of "Thu, 10 Oct 2013 22:21:29 -0300")
Message-ID: <87fvs4bfuq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, 10 Oct 2013 22:21:29 -0300, Felipe Pena wrote:
> Fix for a memory leak on tracing_data_get() function when returning NULL explicitly
>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  tools/perf/util/trace-event-info.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index f3c9e55..2a0c3c9 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -518,13 +518,15 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  			 "/tmp/perf-XXXXXX");
>  		if (!mkstemp(tdata->temp_file)) {
>  			pr_debug("Can't make temp file");
> -			return NULL;
> +			err = -1;
> +			goto err_tdata;
>  		}
>
>  		temp_fd = open(tdata->temp_file, O_RDWR);
>  		if (temp_fd < 0) {
>  			pr_debug("Can't read '%s'", tdata->temp_file);
> -			return NULL;
> +			err = -1;
> +			goto err_tdata;

I'd rather initialize err to -1 at the beginning.  And the malloc of
tdata should also be handled like this.

Thanks,
Namhyung


>  		}
>
>  		/*
> @@ -562,6 +564,7 @@ out:
>  		output_fd = fd;
>  	}
>
> +err_tdata:
>  	if (err) {
>  		free(tdata);
>  		tdata = NULL;
> --
> 1.7.10.4
