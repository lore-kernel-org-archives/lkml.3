Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3K1OEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3K1OEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:04:07 -0500
Date: Thu, 28 Nov 2013 12:03:44 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/7] perf record: Use perf_data_file__write for output
 file
Message-ID: <20131128140344.GB3603@infradead.org>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
 <1385634619-8129-7-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385634619-8129-7-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 28, 2013 at 11:30:18AM +0100, Jiri Olsa escreveu:
> Changing the file output code to use the newly
> added perf_data_file__write interface.
> 
> No functional change intended.

But there is one, if we fail the pr_err() will not be called, will some
warning be emitter later on?

If so, we should make it clear in the changelog. Lemme check by looking
at that code...

There are several places where the return of this function is propagated
and handled with relevant error messages, but at least one, the most
important, doesn't, i.e. this would be the only message the user would
receive, can you verify that?

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index d93e2ee..1be39e2 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -76,24 +76,17 @@ struct perf_record {
>  	long			samples;
>  };
>  
> -static int perf_record__write(struct perf_record *rec, void *buf, size_t size)
> +static ssize_t perf_record__write(struct perf_record *rec,
> +				  void *buf, size_t size)
>  {
> -	struct perf_data_file *file = &rec->file;
> -
> -	while (size) {
> -		ssize_t ret = write(file->fd, buf, size);
> -
> -		if (ret < 0) {
> -			pr_err("failed to write perf data, error: %m\n");
> -			return -1;
> -		}
> -
> -		size -= ret;
> -		buf += ret;
> +	struct perf_session *session = rec->session;
> +	ssize_t ret;
>  
> -		rec->bytes_written += ret;
> -	}
> +	ret = perf_data_file__write(session->file, buf, size);
> +	if (ret < 0)
> +		return -1;
>  
> +	rec->bytes_written += ret;
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
