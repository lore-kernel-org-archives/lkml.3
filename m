Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936814Ab3DIOye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:54:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761866Ab3DIOyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:54:33 -0400
Date: Tue, 9 Apr 2013 16:50:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes/tracing: generalize struct
	uprobe_trace_entry_head
Message-ID: <20130409145054.GA22913@redhat.com>
References: <20130329181548.GA20700@redhat.com> <1365436535.25498.12.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365436535.25498.12.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Steven Rostedt wrote:
>
> On Fri, 2013-03-29 at 19:15 +0100, Oleg Nesterov wrote:
> >
> > @@ -491,20 +502,19 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> >  	struct uprobe_trace_entry_head *entry;
> >  	struct ring_buffer_event *event;
> >  	struct ring_buffer *buffer;
> > -	u8 *data;
> > +	void *data;
> >  	int size, i;
> >  	struct ftrace_event_call *call = &tu->call;
> >
> > -	size = sizeof(*entry) + tu->size;
> > -
> > +	size = SIZEOF_TRACE_ENTRY(1) + tu->size;
>
> That '1' is confusing. When I first looked at this code, I thought it
> was a bug as it should have been '0' (thinking of arrays). And then I
> realized that you want the entry *after* the element.
>
> Instead of '1' and I assume '2' for ret probes, how about defining an
> enum:
>
> enum {
> 	UPROBE_NORM	= 1,
> 	UPROBE_RET	= 2,
> };
>
> and then you can have;
>
> 	size = SIZEOF_TRACE_ENTRY(UPROBE_NORM);
>
> and later:
>
> 	size = SIZEOF_TRACE_ENTRY(UPROBE_RET);
>
> Same goes for DATAOF_TRACE_ENTRY().
>
> This would make it a lot easier to understand and review, and much less
> bug prone when we have to deal with two different types of
> uprobe_trace_entry_head's.

OK, will do.

Or. Instead of enum we can use "bool is_return". So, instead of

	if (is_ret_probe(tu))
		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_RETPROBE);
	else
		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_NORMAL);

we can do

	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));

What do you like more?

Oleg.

