Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3GGRBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 13:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab3GGRBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 13:01:24 -0400
Date: Sun, 7 Jul 2013 19:00:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 6/6] perf parse events: demystify memory allocations
Message-ID: <20130707170048.GG23433@krava.brq.redhat.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
 <1372793245-4136-7-git-send-email-dsahern@gmail.com>
 <20130707152623.GF23433@krava.brq.redhat.com>
 <51D99B19.3090107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D99B19.3090107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 10:45:13AM -0600, David Ahern wrote:
> On 7/7/13 9:26 AM, Jiri Olsa wrote:
> >On Tue, Jul 02, 2013 at 01:27:25PM -0600, David Ahern wrote:
> >>List heads are currently allocated way down the function chain in __add_event
> >>and add_tracepoint and then freed when the scanner code calls
> >>parse_events_update_lists.
> >>
> >>Be more explicit with where memory is allocated and who should free it. With
> >>this patch the list_head is allocated in the scanner code and freed when the
> >>scanner code calls parse_events_update_lists.
> >>
> >
> >SNIP
> >
> >>@@ -266,9 +279,10 @@ event_legacy_mem:
> >>  PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
> >>  {
> >>  	struct parse_events_evlist *data = _data;
> >>-	struct list_head *list = NULL;
> >>+	struct list_head *list;
> >>
> >>-	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
> >>+	ALLOC_LIST(list);
> >>+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> >>  					     (void *) $2, $4));
> >>  	$$ = list;
> >>  }
> >>@@ -276,9 +290,10 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
> >>  PE_PREFIX_MEM PE_VALUE sep_dc
> >>  {
> >>  	struct parse_events_evlist *data = _data;
> >>-	struct list_head *list = NULL;
> >>+	struct list_head *list;
> >>
> >>-	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
> >>+	ALLOC_LIST(list);
> >>+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
> >>  					     (void *) $2, NULL));
> >
> >so who now frees the list if there's an error
> >in parse_events_add_breakpoint?
> 
> According to valgrind that memory is not freed prior to this patch,
> so this one does not introduce new leaks.

I thought this hunk did:


        evsel = perf_evsel__new(attr, (*idx)++);
-       if (!evsel) {
-               free(list);


but I might have missed other cases..

jirka
