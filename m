Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3FYIlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:41:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51626 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3FYIls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:41:48 -0400
Date: Tue, 25 Jun 2013 10:41:35 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130625084135.GA21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
 <20130624094458.GO28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624094458.GO28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 11:44:58, Peter Zijlstra wrote:
> > +static void del_persistent_event(int cpu, struct perf_event_attr *attr)
> > +{
> > +	struct pers_event_desc *desc, *tmp;
> > +	struct perf_event *event = NULL;
> > +
> > +	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
> > +		if (desc->attr->config == attr->config) {
> 
> attr->config might not be enough; you might also want to compare type,
> config1, config2, and possible bp_type as well; although I think we want
> to avoid having hwbp style persistent events, but then what do I know.

[ I would call this what it is: perf_add_persistent_tracepoint(), or
so :-) ]

We chosed a tracepoint-only implementation as a first try and since
this is our use case. The goal is to have support for any event type.

I also was thinking of comparing the whole attr structure. But since
attr are similar (or almost identical) only you can't compare each
member of attr and need exceptions (e.g. cpu number). These exceptions
are ugly and depending on the specific use case.

I rather tend to assign unique identifiers to each persistent event
and then use attr->config to select the event, e.g.:

		if (desc->unique_id == attr->config) ...

Tracepoints have this unique id in it already, thus tp only first.

The change can be made without breaking ABI, since the event setup is
described in sysfs.

-Robert

> 
> > +			event = desc->event;
> > +			break;
> > +		}
> > +	}
