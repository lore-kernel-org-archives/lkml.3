Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3F0QNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:13:32 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44856 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0QNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:13:31 -0400
Message-ID: <51CC64A7.6040305@gmail.com>
Date: Thu, 27 Jun 2013 10:13:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-7-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372319707-13892-7-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/13 1:54 AM, Adrian Hunter wrote:
> The list_head is on the stack, so just free the rest of the list.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/parse-events.c | 7 ++++++-
>   tools/perf/util/parse-events.h | 1 +
>   tools/perf/util/pmu.c          | 2 +-
>   3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 995fc25..d9cb055 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1231,12 +1231,17 @@ int parse_events_term__clone(struct parse_events_term **new,
>   			term->val.str, term->val.num);
>   }
>
> -void parse_events__free_terms(struct list_head *terms)
> +void parse_events__free_terms_only(struct list_head *terms)
>   {
>   	struct parse_events_term *term, *h;
>
>   	list_for_each_entry_safe(term, h, terms, list)
>   		free(term);
> +}
> +
> +void parse_events__free_terms(struct list_head *terms)
> +{
> +	parse_events__free_terms_only(terms);
>
>   	free(terms);
>   }

Seems like you can just fix parse_events__free_terms to do the right 
thing and not call free(terms) -- ie., no need for a separate "only" 
function. From there only test_term() needs to do the free(terms) and 
since it mallocs the memory there it is nicely symmetrical.

David
