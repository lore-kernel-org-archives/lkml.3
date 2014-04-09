Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbaDIQkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:40:46 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51597 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:40:45 -0400
Date: Wed, 9 Apr 2014 18:40:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] tracepoint: Convert process iteration to use
 for_each_process_thread()
Message-ID: <20140409164037.GC17782@localhost.localdomain>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-3-git-send-email-fweisbec@gmail.com>
 <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:28:35PM +0000, Mathieu Desnoyers wrote:
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

It's the same requirements than do_each_thread while_each_thread: tasklist_lock
or RCU. Except that it's really RCU-safe. while_each_thread isn't really
safe due to issues with concurrent exec/de_thread()

Then it depends on your requirement, if you can tolerate concurrent
adds and removals or not. Here tasklist_lock seems required or we may miss
some tasks' syscall traces.

> 
> A quick glance at those for_each iterator defines in sched.h was not
> helpful in finding this information.

Agreed, I'm going to add comments to precise that.
