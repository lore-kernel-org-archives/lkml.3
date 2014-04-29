Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487AbaD2Wgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:36:43 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51393 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965473AbaD2Wgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:36:39 -0400
Date: Tue, 29 Apr 2014 18:36:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bharath Ravi <rbharath@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Laurent Chavey <chavey@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tracing: Allow changing default ring buffer size for
 ftrace instances.
Message-ID: <20140429183637.75eb365e@gandalf.local.home>
In-Reply-To: <CAHN2JJ_hOS=jfvGUZFt=mx5ymCOmJrUdP1ATnOXe-D9MvtgAMg@mail.gmail.com>
References: <CAHN2JJ_hOS=jfvGUZFt=mx5ymCOmJrUdP1ATnOXe-D9MvtgAMg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 15:29:57 -0800
Bharath Ravi <rbharath@google.com> wrote:

> > @@ -5930,7 +5932,7 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
> >  static int new_instance_create(const char *name)
> >  {
> >         struct trace_array *tr;
> > -       int ret;
> > +       int ret, ring_buffer_size;
> >
> >         mutex_lock(&trace_types_lock);
> >
> > @@ -5961,7 +5963,12 @@ static int new_instance_create(const char *name)
> >         INIT_LIST_HEAD(&tr->systems);
> >         INIT_LIST_HEAD(&tr->events);
> >
> > -       if (allocate_trace_buffers(tr, trace_buf_size) < 0)
> > +       /* allocate memory only if buffers are to be expanded */
> > +       if (trace_flags & TRACE_EXPAND_NEW_BUFFERS)
> > +               ring_buffer_size = trace_buf_size;
> > +       else
> > +               ring_buffer_size = 1

Sure you tested this patch?

Well, playing with it, I've come back full circle, and think having the
option is better.

Now, I wonder if we should have the buffers act like the main buffer
when this option is cleared. That is, if you set "expand-new-buffers"
to zero, when you create the buffer, it should be the minimum but will
expand as soon as they will be used to whatever the main buffer was.

Of course you can still set the size before you do so, just like the
main buffer does.

That way the name sounds better. Because when "expand-new-buffers" is
zero, it sounds like they should not be expanded, but can be when used.

How's that sound?

-- Steve



> > +       if (allocate_trace_buffers(tr, ring_buffer_size) < 0)
> >                 goto out_free_tr;
> >
> >         tr->dir = debugfs_create_dir(name, trace_instance_dir);
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index ea189e0..15ddbf4 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -888,6 +888,7 @@ enum trace_iterator_flags {
> >         TRACE_ITER_IRQ_INFO             = 0x800000,
> >         TRACE_ITER_MARKERS              = 0x1000000,
> >         TRACE_ITER_FUNCTION             = 0x2000000,
> > +       TRACE_EXPAND_NEW_BUFFERS        = 0x4000000,
> >  };
> >
> >  /*
> > --
> > 1.8.5.3
> >

