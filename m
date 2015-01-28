Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbbA1UxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:09 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45530 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbbA1UxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:01 -0500
Date: Wed, 28 Jan 2015 11:26:09 +0000
From: Javi Merino <javi.merino@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4 1/3] tracing: Add array printing helpers
Message-ID: <20150128112609.GA2938@e104805>
References: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
 <1422274311-19738-2-git-send-email-javi.merino@arm.com>
 <20150127223557.407f3a13@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150127223557.407f3a13@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:35:57AM +0000, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 12:11:49 +0000
> Javi Merino <javi.merino@arm.com> wrote:
> 
> > From: Dave Martin <Dave.Martin@arm.com>
> > 
> > If a trace event contains an array, there is currently no standard
> > way to format this for text output.  Drivers are currently hacking
> > around this by a) local hacks that use the trace_seq functionailty
> > directly, or b) just not printing that information.  For fixed size
> > arrays, formatting of the elements can be open-coded, but this gets
> > cumbersome for arrays of non-trivial size.
> > 
> > These approaches result in non-standard content of the event format
> > description delivered to userspace, so userland tools needs to be
> > taught to understand and parse each array printing method
> > individually.
> > 
> > This patch implements common __print_<type>_array() helpers that
> > tracepoint implementations can use instead of reinventing them.  A
> > simple C-style syntax is used to delimit the array and its elements
> > {like,this}.
> > 
> > So that the helpers can be used with large static arrays as well as
> > dynamic arrays, they take a pointer and element count: they can be
> > used with __get_dynamic_array() for use with dynamic arrays.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > ---
> >  include/linux/ftrace_event.h |  4 ++++
> >  include/trace/ftrace.h       |  9 +++++++++
> >  kernel/trace/trace_output.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 57 insertions(+)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 0bebb5c348b8..5aa4a9269547 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -44,6 +44,10 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
> >  const char *ftrace_print_hex_seq(struct trace_seq *p,
> >  				 const unsigned char *buf, int len);
> >  
> > +const char *ftrace_print_array_seq(struct trace_seq *p,
> > +				   const void *buf, int buf_len,
> > +				   size_t el_size);
> > +
> >  struct trace_iterator;
> >  struct trace_event;
> >  
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 139b5067345b..36afd0ed3458 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -263,6 +263,14 @@
> >  #undef __print_hex
> >  #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
> >  
> > +#undef __print_array
> > +#define __print_array(array, count, el_size)				\
> > +	({								\
> > +		BUILD_BUG_ON(el_size != 8 && el_size != 16 &&		\
> > +			el_size != 32 && el_size != 64);		\
> 
> I tried testing this patch by writing a print_array myself, and I kept
> hitting this BUILD_BUG_ON, and was wondering WTF? Then it dawned on me.
> 
> el_size should not be based on bits, it should be based on bytes. I
> passed in "sizeof()" which doesn't work with bits.
> 
> Please update to "el_size < 1 || el_size > 8".
> 
> and adjust the rest accordingly.

Done, I'm testing it now.  I'll send a v5 later today.

Cheers,
Javi
