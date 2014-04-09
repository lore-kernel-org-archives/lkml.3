Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbaDIQnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:43:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:5996 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933100AbaDIQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:43:23 -0400
Date: Wed, 9 Apr 2014 12:42:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/5] tracepoint: Convert process iteration to use
 for_each_process_thread()
Message-ID: <20140409124249.4081e665@gandalf.local.home>
In-Reply-To: <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 16:28:35 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Frederic Weisbecker" <fweisbec@gmail.com>
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar"
> > <mingo@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Oleg Nesterov" <oleg@redhat.com>, "Steven
> > Rostedt" <rostedt@goodmis.org>
> > Sent: Wednesday, April 9, 2014 12:11:19 PM
> > Subject: [PATCH 2/5] tracepoint: Convert process iteration to use for_each_process_thread()
> > 
> > do_each_thread/while_each_thread iterators are deprecated by
> > for_each_thread/for_each_process_thread() APIs.
> > 
> > Lets convert the callers in the tracepoint code. The ultimate
> > goal is to remove the struct task_struct::thread_group field and
> > the corresponding do_each_thread/while_each_thread iterators that are
> > RCU unsafe.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/tracepoint.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index fb0a38a..00a7e8b 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -561,15 +561,15 @@ static int sys_tracepoint_refcount;
> >  void syscall_regfunc(void)
> >  {
> >  	unsigned long flags;
> > -	struct task_struct *g, *t;
> > +	struct task_struct *p, *t;
> >  
> >  	if (!sys_tracepoint_refcount) {
> >  		read_lock_irqsave(&tasklist_lock, flags);
> > -		do_each_thread(g, t) {
> > +		for_each_process_thread(p, t) {
> 
> What are the locking rules for for_each_process_thread() ?
> 
> Is it required to hold RCU read-side lock ? (it's not the case here)
> 
> Is tasklist_lock read-side lock sufficient ?

The tasklist_lock is all that is needed. Nothing about the list will
change when that's held. Ideally we would like to start converting
things to rcu, where it's OK if the list actually changes while you are
iterating.

But if you require the list to stay the same while you read all the
tasks, then you need the bigger hammer (tasklist_lock).

Also, this is just about iterating the tasklist list. If something
within the loop requires rcu, then that's a different story.

-- Steve

> 
> A quick glance at those for_each iterator defines in sched.h was not
> helpful in finding this information.
> 
