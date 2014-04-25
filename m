Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaDYRwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:52:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:46552 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752591AbaDYRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:52:22 -0400
Date: Fri, 25 Apr 2014 13:52:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bharath Ravi <rbharath@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Laurent Chavey <chavey@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tracing: Allow changing default ring buffer size for
 ftrace instances.
Message-ID: <20140425135219.3ad56e1b@gandalf.local.home>
In-Reply-To: <CAHN2JJ_hOS=jfvGUZFt=mx5ymCOmJrUdP1ATnOXe-D9MvtgAMg@mail.gmail.com>
References: <CAHN2JJ_hOS=jfvGUZFt=mx5ymCOmJrUdP1ATnOXe-D9MvtgAMg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 15:29:57 -0800
Bharath Ravi <rbharath@google.com> wrote:

> Hi Steven,
> 
> Does this version of the patch look reasonable?

Sorry, your email got buried in my TODO list :-/

Anyway, what about if we make new instances act like the original
buffer does on start up? That is, have it start out as a minimum buffer
with an "expanded" attribute.

# cd /sys/kernel/debug/tracing/instances
# mkdir foo
# cd foo
# cat buffer_size_kb
7 (expanded: 1408)
# echo 1 > events/enable
# cat buffer_size_kb
1408

This way if you don't want to waste a lot of buffer size when creating
a new instance, you can simply change the size after creation.

How's that sound?

-- Steve


> --
> Bharath Ravi |  rbharath@google.com
> 
> 
> On Thu, Jan 23, 2014 at 11:37 AM, Bharath Ravi <rbharath@google.com> wrote:
> >
> > It is often memory efficient to start instances off with a smaller ring
> > buffer size than the current default. This is particularly true on
> > systems with many cores, or when multiple ftrace instances are created,
> > where the current (higher) default value results in allocation failures.
> >
> > The global trace buffer allows initialization with a minimal (1 byte)
> > size, to save memory using a "ring_buffer_expanded" flag. To allow
> > instances a similar capability, trace option named "expand-new-buffers"
> > is added. If set to true, ftrace instances created will be initialized
> > with ring buffers of the default size. If set to false, the buffers will
> > be initialized with a size of 1 byte. By default, the expand_new_buffers
> > flag is true.
> >
> > Tested: Booted into a kernel with these changes, verified reading and
> > writing the new trace_option. Ensured that new ftrace instances created
> > used the appropriate size while initializing their ring buffers.
> >
> > Signed-off-by: Bharath Ravi <rbharath@google.com>
> > ---
> >  kernel/trace/trace.c | 13 ++++++++++---
> >  kernel/trace/trace.h |  1 +
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 9d20cd9..c17c12f 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -410,7 +410,8 @@ static inline void trace_access_lock_init(void)
> >  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> >         TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
> >         TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
> > -       TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
> > +       TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION |
> > +       TRACE_EXPAND_NEW_BUFFERS;
> >
> >  static void tracer_tracing_on(struct trace_array *tr)
> >  {
> > @@ -753,6 +754,7 @@ static const char *trace_options[] = {
> >         "irq-info",
> >         "markers",
> >         "function-trace",
> > +       "expand-new-buffers",
> >         NULL
> >  };
> >
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

