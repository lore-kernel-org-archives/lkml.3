Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3FYNOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3FYNOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:14:34 -0400
Date: Tue, 25 Jun 2013 15:13:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/15] perf tools: fix parse_events_terms() freeing local
 variable on error path
Message-ID: <20130625131359.GC23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-7-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372079772-20803-7-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:16:03PM +0300, Adrian Hunter wrote:
> The list_head is on the stack, so just free the rest of the list.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/pmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 4c6f9c4..def64d4 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -194,7 +194,8 @@ static int pmu_alias_terms(struct perf_pmu_alias *alias,
>  	list_for_each_entry(term, &alias->terms, list) {
>  		ret = parse_events_term__clone(&clone, term);
>  		if (ret) {
> -			parse_events__free_terms(&list);
> +			list_for_each_entry_safe(term, clone, &list, list)
> +				free(term);

Could you please add __parse_events__free_terms doing this
and being called from parse_events__free_terms as you did
for __perf_evlist__munmap in the other patch.

thanks,
jirka
