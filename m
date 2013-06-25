Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab3FYNTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab3FYNTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:19:00 -0400
Date: Tue, 25 Jun 2013 15:18:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/15] perf tools: validate perf event header size
Message-ID: <20130625131826.GD23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372079772-20803-10-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:16:06PM +0300, Adrian Hunter wrote:
> 'size' includes the header so must be at least
> 'sizeof(struct perf_event_header)'.  Error out
> immediately if that is not the case.  Also
> don't byte-swap the header until it is actually
> "fetched" from the mmap region.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/session.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 19ea888..7e0d605 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1094,8 +1094,10 @@ more:
>  		perf_event_header__bswap(&event->header);
>  
>  	size = event->header.size;
> -	if (size == 0)
> -		size = 8;
> +	if (size < sizeof(struct perf_event_header)) {
> +		pr_err("bad event header size\n");
> +		goto out_err;
> +	}
>  
>  	if (size > cur_size) {
>  		void *new = realloc(buf, size);
> @@ -1161,12 +1163,12 @@ fetch_mmaped_event(struct perf_session *session,
>  
>  	event = (union perf_event *)(buf + head);
>  
> -	if (session->header.needs_swap)
> -		perf_event_header__bswap(&event->header);
> -
>  	if (head + event->header.size > mmap_size)
>  		return NULL;

dont we need to swap first before using event->header.size?

jirka
