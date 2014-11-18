Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaKRQdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:33:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaKRQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:33:47 -0500
Date: Tue, 18 Nov 2014 17:33:54 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141118163354.GK23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.904875201@goodmis.org>
 <20141117123250.10f6f57c@gandalf.local.home>
 <20141117141215.2dbd5f12@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117141215.2dbd5f12@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-17 14:12:15, Steven Rostedt wrote:
> 
> > I don't like the fact that I did a code structure change with this
> > patch. This patch should be just a simple conversion of len to
> > seq_buf_used(). I'm going to strip this change out and put it before
> > this patch.
> 
> 
> As the seq_buf->len will soon be +1 size when there's an overflow, we
> must use trace_seq_used() or seq_buf_used() methods to get the real
> length. This will prevent buffer overflow issues if just the len
> of the seq_buf descriptor is used to copy memory.
> 
> Link: http://lkml.kernel.org/r/20141114121911.09ba3d38@gandalf.local.home
> 
> Reported-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/trace_seq.h            | 20 +++++++++++++++++++-
>  kernel/trace/seq_buf.c               |  2 +-
>  kernel/trace/trace.c                 | 22 +++++++++++-----------
>  kernel/trace/trace_events.c          |  9 ++++++---
>  kernel/trace/trace_functions_graph.c |  5 ++++-
>  kernel/trace/trace_seq.c             |  2 +-
>  6 files changed, 42 insertions(+), 18 deletions(-)

[...]


> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -944,10 +944,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
>  {
>  	int len;
>  
> -	if (s->seq.len <= s->seq.readpos)
> +	if (trace_seq_used(s) <= s->seq.readpos)
>  		return -EBUSY;
>  
> -	len = s->seq.len - s->seq.readpos;
> +	len = trace_seq_used(s) - s->seq.readpos;
>  	if (cnt > len)
>  		cnt = len;
>  	memcpy(buf, s->buffer + s->seq.readpos, cnt);


There is one more dangerous usage in trace_printk_seq(). It is on
three lines there.

The rest looks good.

Best Regards,
Petr
