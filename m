Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaF0O1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:27:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53942 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753130AbaF0O1R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:27:17 -0400
Date: Fri, 27 Jun 2014 10:27:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 3/5 v2] seq_buf: Move the seq_buf code to lib/
Message-ID: <20140627102715.1b670022@gandalf.local.home>
In-Reply-To: <20140627134810.GC23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220130.068245931@goodmis.org>
	<20140627134810.GC23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 15:48:10 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> On Thu 2014-06-26 17:49:04, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > The seq_buf functions are rather useful outside of tracing. Instead
> > of having it be dependent on CONFIG_TRACING, move the code into lib/
> > and allow other users to have access to it even when tracing is not
> > configured.
> > 
> > The seq_buf utility is similar to the seq_file utility, but instead of
> > writing sending data back up to userland, it writes it into a buffer
> > defined at seq_buf_init(). This allows us to send a descriptor around
> > that writes printf() formatted strings into it that can be retrieved
> > later.
> > 
> > It is currently used by the tracing facility for such things like trace
> > events to convert its binary saved data in the ring buffer into an
> > ASCII human readable context to be displayed in /sys/kernel/debug/trace.
> > 
> > It can also be used for doing NMI prints safely from NMI context into
> > the seq_buf and retrieved later and dumped to printk() safely. Doing
> > printk() from an NMI context is dangerous because an NMI can preempt
> > a current printk() and deadlock on it.
> > 
> > Link: http://lkml.kernel.org/p/20140619213952.058255809@goodmis.org
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/seq_buf.c | 348 -------------------------------------------------
> >  lib/Makefile           |   2 +-
> >  lib/seq_buf.c          | 348 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/trace_seq.c        | 303 ++++++++++++++++++++++++++++++++++++++++++
> 
> I guess that lib/trace_seq.c was copied by mistake.

Heh, that's what I get for using both quilt and git :-)

To start with what I had before (and use my scripts for the Link tag),
I pulled the old patch from my email and pulled it into a quilt queue.
Did a "quilt push -f" and then started from there. I removed all the
trace_seq.c updates but forgot that quilt push -f would create the file
in lib/.

When done with all my updates, I just did a git am of the patch in my
quilt queue, which pulled in the old copy of trace_seq.c in lib/ :-p

I'll remove it.

> 
> >  4 files changed, 652 insertions(+), 349 deletions(-)
> >  delete mode 100644 kernel/trace/seq_buf.c
> >  create mode 100644 lib/seq_buf.c
> >  create mode 100644 lib/trace_seq.c
> > 
> > diff --git a/lib/Makefile b/lib/Makefile
> > index ba967a19edba..6007194082c6 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
> >  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
> >  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
> >  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
> > -	 earlycpio.o
> > +	 earlycpio.o seq_buf.o
> >  
> >  obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >  lib-$(CONFIG_MMU) += ioremap.o
> 
> There is missing:

Nope, it just was copied by mistake. It only added dead code, it didn't
move it.

-- Steve

> 
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index edc98c72a634..67d6369ddf83 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -29,7 +29,6 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
>  obj-$(CONFIG_TRACING) += trace.o
>  obj-$(CONFIG_TRACING) += trace_output.o
>  obj-$(CONFIG_TRACING) += trace_seq.o
> -obj-$(CONFIG_TRACING) += seq_buf.o
>  obj-$(CONFIG_TRACING) += trace_stat.o
>  obj-$(CONFIG_TRACING) += trace_printk.o
>  obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
> 
> 
> Best Regards,
> Petr

