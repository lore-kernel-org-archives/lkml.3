Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3FFPiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3FFPh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:37:59 -0400
Date: Thu, 6 Jun 2013 17:37:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 11/16] perf util: Parse header_page to get proper long
 size
Message-ID: <20130606153737.GA1011@krava.brq.redhat.com>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
 <1370323231-14022-12-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370323231-14022-12-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:20:26PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The header_page file describes the format of the ring buffer page
> which is used by ftrace (not perf).  And size of "commit" field (I
> guess it's older name was 'size') represents the real size of long
> type used for kernel.  So update the pevent's long size.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-read.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index fa45fca2a2d3..f2112270c663 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -212,6 +212,7 @@ static int read_ftrace_printk(struct pevent *pevent)
>  static int read_header_files(struct pevent *pevent)
>  {
>  	unsigned long long size;
> +	char *header_page;
>  	char buf[BUFSIZ];
>  	int ret = 0;
>  
> @@ -224,7 +225,26 @@ static int read_header_files(struct pevent *pevent)
>  	}
>  
>  	size = read8(pevent);
> -	skip(size);
> +
> +	header_page = malloc(size);
> +	if (header_page == NULL)
> +		return -1;
> +
> +	if (do_read(header_page, size) < 0) {
> +		pr_debug("did not read header page");
> +		free(header_page);
> +		return -1;
> +	}
> +
> +	if (!pevent_parse_header_page(pevent, header_page, size,
> +				      pevent_get_long_size(pevent))) {
> +		/*
> +		 * The commit field in the page is of type long,
> +		 * use that instead, since it represents the kernel.
> +		 */
> +		pevent_set_long_size(pevent, pevent->header_page_size_size);
> +	}
> +	free(header_page);

any reason why not merge this one with
  83ae6eb perf util: Skip reading header_event file

jirka
