Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbaCUM7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:59:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760784AbaCUM7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:59:32 -0400
Date: Fri, 21 Mar 2014 07:59:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140321075956.500fe42d@tlielax.poochiereds.net>
In-Reply-To: <CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 12:32:12 +0400
Pavel Shilovsky <piastry@etersoft.ru> wrote:

> 2014-03-21 6:23 GMT+04:00 Steven Rostedt <rostedt@goodmis.org>:
> > On Thu, 20 Mar 2014 17:02:39 -0400
> > Jeff Layton <jlayton@redhat.com> wrote:
> >
> >> Eventually the server should just allow the read to complete even if
> >> the client doesn't respond to the oplock break. It has to since clients
> >> can suddenly drop off the net while holding an oplock. That should
> >> allow everything to unwedge eventually (though it may take a while).
> >>
> >> If that's not happening then I'd be curious as to why...
> >
> > The problem is that the data is being filled in the page and the reader
> > is waiting for the page lock to be released. The kworker for the reader
> > will issue the complete() and unlock the page to wake up the reader.
> >
> > But because the other workqueue callback calls down_read(), and there
> > can be a down_write() waiting for the reader to finish, this
> > down_read() will block on the lock as well (rwsems are fair locks).
> > This blocks the other workqueue callback from issuing the complete and
> > page_unlock() that will wake up the reader that is holding the rwsem
> > with down_read().
> >
> > DEADLOCK.
> 
> Thank you for reporting and clarifying the issue!
> 
> Read and write codepaths both obtain lock_sem for read and then wait
> for cifsiod_wq to complete and release lock_sem. They don't do any
> lock_sem operations inside their work task queued to cifsiod_wq. But
> oplock code can obtain/release lock_sem in its work task. So, that's
> why I agree with Jeff and suggest to move the oplock code to a
> different work queue (cifsioopd_wq?) but leave read and write
> codepaths use cifsiod_wq.
> 

Yes, thanks for the clarification. I missed the fact that a 3rd task
was blocked on a down_write. I think that fix will help prevent the
full-blown deadlock, but it'll still be susceptible to long stalls in
some situations.

In Steven's example the work on CPU0 is blocked on a SMB_READ. That
read may not be completing because the server has issued an oplock
break to the client and is waiting on the response. That oplock break
response is blocked because it's blocked on the down_write.

In that situation, what breaks the deadlock is that the server
eventually gives up waiting on the oplock break response, but that can
take on the order of a minute.

So yeah, I think we should add a dedicated workqueue for oplock breaks
as an interim fix, but I also think we need to consider revamping the
lock pushing code such that oplock breaks are not subject to being
blocked like that.

-- 
Jeff Layton <jlayton@redhat.com>
