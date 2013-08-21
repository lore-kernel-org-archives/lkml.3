Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3HUCl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:41:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3HUCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:41:56 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=2OzRHhLI-igA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IuSzSYa--aEA:10 a=6IzRx_vaAAAA:8 a=kgrn1oOA9ISpIZpqNwsA:9 a=CjuIK1q_8ugA:10 a=WYjQ3DCYG8cA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 22:41:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Message-ID: <20130820224153.5667495b@gandalf.local.home>
In-Reply-To: <20130821021900.GB4051@kmo-pixel>
References: <20130820111602.3cea203c@gandalf.local.home>
	<20130821021900.GB4051@kmo-pixel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 19:19:00 -0700
Kent Overstreet <kmo@daterainc.com> wrote:

> On Tue, Aug 20, 2013 at 11:16:02AM -0400, Steven Rostedt wrote:
> > 

> I _really_ disagree with this approach.

I had a feeling you would love it.

> 
> I get that there's a problem, but the bcache code REALLY IS USING THE
> RWSEM AS A LOCK; the answer isn't to open code the lock!

Actually, it is using it as a semaphore. The problem with Linux
was that it only had spin locks and semaphores. People would use the
semaphore as either a completion or a mutex. Luckily, we created both
of those and replaced 90% of all semaphores with either a mutex or a
completion.

The rwsem, sorta has the same issue. But it was pretty much always used
as a read/write sleeping lock. It was not used as a semaphore. But it
seems that the bcache really does use it as a semaphore here as it
isn't just a mutex location. It's a special kind of completion, but the
completion is in a strange way.

> 
> Apologies to Christoph for getting distracted and not responding when
> you started to explain what the issues were for RT. I'm not really
> convinced they're that insurmountable (one of the issues was debugging,
> which the _non_owner() stuff always handled just fine), but I'll take it
> on faith that this usage is incompatible with rwsems + the RT
> functionality since I haven't actually had time to dig into it.

The thing is, RT requires priority inheritance. When a task blocks on a
rwsem, it has to boost the owner of that rwsem otherwise it risks
unbounded priority inversion.

I have a hack that actually implements a work around for non_owner, but
it adds overhead to all locks to do so.

> 
> So assuming that's the case, IMO the sanest thing to do is make a new
> type of lock - "rwsem_non_process" or somesuch - and use _that_ in
> bcache. Not open coding the lock.

I actually started that, but decided this was the easier patch to send.
Don't worry, I was expecting this email. No surprises here ;-)

This email was taken from Andrew Morton's play book (I see you Cc'd
him, I forgot to). It's one of these patches of "It's so bad that the
owner of the code will fix the issue out of fear that this patch may
make it in".


> 
> It can even live in the bcache code if we want since there currently
> wouldn't be any other users, I don't really care. But open coding it?
> Come on... makes me wonder what other code in the kernel is open coding
> locks because it couldn't release it in the same process context that
> took the lock for whatever reason.

Most cases just have completions. This looks like a case where "don't
do something while transaction is taking place". Which can usually get
away with a wait event.

> 
> Also, nack this patch because increasing the number of atomic ops to
> shared cachelines in our fast path. If it does end up being open coded,
> I'll make a more efficient version.

Perhaps I can whip up a "struct rwsem_non_owner" and have a very
limited API for that, and then you can use that.

Thanks,

-- Steve
