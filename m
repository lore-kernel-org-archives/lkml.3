Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbaCSRUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaCSRT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:19:59 -0400
Date: Wed, 19 Mar 2014 18:19:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Message-ID: <20140319171906.GA11377@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com> <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com> <20140319164907.GA10113@redhat.com> <20140319165747.GC8557@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319165747.GC8557@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19, Peter Zijlstra wrote:
>
> On Wed, Mar 19, 2014 at 05:49:07PM +0100, Oleg Nesterov wrote:
> > +static void add_wait_queue_flag(wait_queue_head_t *q, wait_queue_t *wait)
> > +{
> > +	struct list_head *head = &q->task_list;
> > +	wait_queue_t *excl;
> > +
> > +	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
> > +		if (wait->flags & WQ_FLAG_EXCLUSIVE_HEAD) {
> > +			list_for_each_entry(excl, head, task_list)
> > +				if (excl->flags & WQ_FLAG_EXCLUSIVE) {
> > +					head = &excl->task_list;
> > +					break;
> > +				}
>
> I prefer an extra pair of { } here,

OK,

> but the main concern would be the
> cost of that iteration.

Yes.

This change assumes that we do not mix exclusive and !exclusive, in
this case list_for_each_entry() is cheap, the list is either empty
or the first entry is WQ_FLAG_EXCLUSIVE.

Otherwise the user should blame itself, but the code still will work
correctly.

Or we can do

	if (WQ_FLAG_EXCLUSIVE_HEAD) {
		WARN_ON(!list_empty(head) &&
			(list_first_entry(...)-flags & WQ_FLAG_EXCLUSIVE));
		...
	}

> Other than that, yes something like that would do I suppose.

OK, I'll try to test/cleanup/resend tomorrow.

Oleg.

