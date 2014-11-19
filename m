Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaKSQor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:44:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaKSQoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:44:46 -0500
Date: Wed, 19 Nov 2014 17:44:40 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141119164440.GE2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.904875201@goodmis.org>
 <20141117123250.10f6f57c@gandalf.local.home>
 <20141117141215.2dbd5f12@gandalf.local.home>
 <20141118163354.GK23958@pathway.suse.cz>
 <20141118123732.462b1ad8@gandalf.local.home>
 <20141119114017.GA2332@dhcp128.suse.cz>
 <20141119084800.524beb62@gandalf.local.home>
 <20141119144004.GB2332@dhcp128.suse.cz>
 <20141119110037.6fafa106@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119110037.6fafa106@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-19 11:00:37, Steven Rostedt wrote:
> On Wed, 19 Nov 2014 15:40:05 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > > Regardless of overflow or not (or even if trace_seq is full), that if
> > > statement will prevent this from doing any buffer overflows.
> > > 
> > > s->seq.len will never be more than s->seq.size after the test against
> > > TRACE_MAX_PRINT. So I see no harm here.
> > 
> > Ah, I see. Well, I would feel more comfortable if it uses
> > trace_seq_used() or if there is some explanation in a comment.
> > But you are right, it is safe as it is. Feel free to leave it.
> > 
> 
> OK, I added this just for you:
>
> BTW, using trace_seq_used() would not be good enough because it could
> return s->seq.size. Which would overflow the buffer on the
> 
> 	s->buffer[s->seq.len] = 0;

Great catch!

> -- Steve
> 
> From 1922acc9987d23d0b9c1ad28dc3eaafc1cf2d6b7 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 19 Nov 2014 10:56:41 -0500
> Subject: [PATCH] tracing: Add paranoid size check in trace_printk_seq()
> 
> To be really paranoid about writing out of bound data in
> trace_printk_seq(), add another check of len compared to size.
> 
> Link: http://lkml.kernel.org/r/20141119144004.GB2332@dhcp128.suse.cz
> 
> Suggested-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks a lot for the addition.

Best Regards,
Petr

> ---
>  kernel/trace/trace.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9023446b2c2b..26facec4625e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6656,6 +6656,14 @@ trace_printk_seq(struct trace_seq *s)
>  	if (s->seq.len >= TRACE_MAX_PRINT)
>  		s->seq.len = TRACE_MAX_PRINT;
>  
> +	/*
> +	 * More paranoid code. Although the buffer size is set to
> +	 * PAGE_SIZE, and TRACE_MAX_PRINT is 1000, this is just
> +	 * an extra layer of protection.
> +	 */
> +	if (WARN_ON_ONCE(s->seq.len >= s->seq.size))
> +		s->seq.len = s->seq.size - 1;
> +
>  	/* should be zero ended, but we are paranoid. */
>  	s->buffer[s->seq.len] = 0;
>  
> -- 
> 1.8.1.4
> 
