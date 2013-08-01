Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3HAN2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:28:40 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49185 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HAN2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:28:38 -0400
Date: Thu, 1 Aug 2013 15:28:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf: Sanitize get_callchain_buffer()
Message-ID: <20130801132833.GA431@somewhere>
References: <1374539466-4799-1-git-send-email-fweisbec@gmail.com>
 <1374539466-4799-3-git-send-email-fweisbec@gmail.com>
 <20130801130146.GE1032@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801130146.GE1032@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:01:46PM +0200, Jiri Olsa wrote:
> On Tue, Jul 23, 2013 at 02:31:00AM +0200, Frederic Weisbecker wrote:
> > In case of allocation failure, get_callchain_buffer() keeps the
> > refcount incremented for the current event.
> > 
> > As a result, when get_callchain_buffers() returns an error,
> > we must cleanup what it did by cancelling its last refcount
> > with a call to put_callchain_buffers().
> > 
> > This is a hack in order to be able to call free_event()
> > after that failure.
> > 
> > The original purpose of that was to simplify the failure
> > path. But this error handling is actually counter intuitive,
> > ugly and not very easy to follow because one expect to
> > see the resources used to perform a service to be cleaned
> > by the callee if case of failure, not by the caller.
> > 
> > So lets clean this up by cancelling the refcount from
> > get_callchain_buffer() in case of failure. And correctly free
> > the event accordingly in perf_event_alloc().
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  kernel/events/callchain.c |    2 ++
> >  kernel/events/core.c      |   41 +++++++++++++++++++++--------------------
> >  2 files changed, 23 insertions(+), 20 deletions(-)
> > 
> > diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> > index c772061..76a8bc5 100644
> > --- a/kernel/events/callchain.c
> > +++ b/kernel/events/callchain.c
> > @@ -117,6 +117,8 @@ int get_callchain_buffers(void)
> >  	err = alloc_callchain_buffers();
> >  exit:
> >  	mutex_unlock(&callchain_mutex);
> > +	if (err)
> > +		atomic_dec(&nr_callchain_events);
> 
> shouldn't we touch this under above lock?

Right, we should move that under the lock, or another user of the callchains may see that we failed
the allocation and simply give up instead of retrying.

> 
> also that above hunk decrements nr_callchain_events
> also for following case:
> 
>         count = atomic_inc_return(&nr_callchain_events);
>         if (WARN_ON_ONCE(count < 1)) {
>                 err = -EINVAL;
>                 goto exit;
>         }
> 
> seems like it screws the count

I'm not sure what you mean here. You mean that it could be negative when the dec is done
outside the lock?

> 
> jirka

