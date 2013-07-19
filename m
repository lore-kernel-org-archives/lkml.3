Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3GSRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab3GSRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:25:55 -0400
Date: Fri, 19 Jul 2013 19:20:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tracing: Simplify trace_array_get()
Message-ID: <20130719172053.GA4845@redhat.com>
References: <20130719155041.GA19501@redhat.com> <20130719155101.GA19509@redhat.com> <1374251217.3356.12.camel@gandalf.local.home> <20130719163312.GA21544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719163312.GA21544@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19, Oleg Nesterov wrote:
>
> On 07/19, Steven Rostedt wrote:
> >
> > On Fri, 2013-07-19 at 17:51 +0200, Oleg Nesterov wrote:
> > >  	mutex_lock(&trace_types_lock);
> > > -	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> > > -		if (tr == this_tr) {
> > > -			tr->ref++;
> > > -			ret = 0;
> > > -			break;
> > > -		}
> > > +	if (!list_empty(&this_tr->list)) {
> >
> > Because this_tr can be freed outside the lock. Accessing this_tr->list
> > can cause a crash.
>
> Aaah, indeed.
>
> Thanks Steven!

Yes. But unless I missed something again this logic doesn't look exactly
correct. Because it seems that trace_array_get() can succeed when it
shoudn't.

trace_array_get() can race with instance_delete() + new_instance_create(),
and _create()->kzalloc() can return the same memory which was freed by
_delete().

No?

Oleg.

