Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbbAPKOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:14:24 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35554 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbAPKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:14:22 -0500
Date: Fri, 16 Jan 2015 10:14:14 +0000
From: Javi Merino <javi.merino@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RESEND PATCH v2 1/2] tracing: Add array printing helpers
Message-ID: <20150116101413.GA2898@e104805>
References: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
 <20150115212202.7939072a@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115212202.7939072a@grimm.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 02:22:02AM +0000, Steven Rostedt wrote:
> On Thu, 15 Jan 2015 16:50:58 +0000
> Javi Merino <javi.merino@arm.com> wrote:
>  
> > +const char *
> > +ftrace_print_array_seq(struct trace_seq *p, const void *buf, int
> > buf_len,
> > +		       size_t el_size)
> > +{
> > +	const char *ret = trace_seq_buffer_ptr(p);
> > +	const char *prefix = "";
> > +	void *ptr = (void *)buf;
> > +
> > +	trace_seq_putc(p, '{');
> > +
> > +	while (ptr < buf + buf_len) {
> > +		switch (el_size) {
> > +		case 8:
> > +			trace_seq_printf(p, "%s0x%x", prefix,
> > +					 *(u8 *)ptr);
> > +			break;
> > +		case 16:
> > +			trace_seq_printf(p, "%s0x%x", prefix,
> > +					 *(u16 *)ptr);
> > +			break;
> > +		case 32:
> > +			trace_seq_printf(p, "%s0x%x", prefix,
> > +					 *(u32 *)ptr);
> > +			break;
> > +		case 64:
> > +			trace_seq_printf(p, "%s0x%llx", prefix,
> > +					 *(u64 *)ptr);
> > +			break;
> > +		default:
> > +			BUG();
> 
> BUG() is a bit extreme don't you think? I'm not sure it even deserves a
> WARN_ON().

Ok, I used BUG() because that's what you suggested:

http://article.gmane.org/gmane.linux.kernel/1846749

The only way I could think of turning it into a BUILD_BUG was by
moving it to the __print_array macro, but I think it's ugly.

> I would suggest doing:
> 
> 			trace_seq_printf(p, "BAD SIZE:%d 0x%x", el_size,
> 					*(u8 *)ptr);
> 			el_size = 8;
> 
> No need to go crashing the kernel or even messing with dmesg over
> somebody's tracepoint mistake.

Ok, I'll change it to that.

> The rest looks fine.
> 
> > +		}
> > +		prefix = ",";
> > +		ptr += el_size / 8;
> > +	}
> > +
> > +	trace_seq_putc(p, '}');
> > +	trace_seq_putc(p, 0);
> 
> I need to add a trace_seq_terminate() for this.

That would make it more readable.  Cheers,
Javi
