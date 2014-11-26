Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaKZOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:25:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:43677 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752785AbaKZOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:25:55 -0500
Date: Wed, 26 Nov 2014 09:25:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] tracing: off by one in __trace_array_vprintk()
Message-ID: <20141126092537.14b6ea9f@gandalf.local.home>
In-Reply-To: <20141126140621.GA18740@mwanda>
References: <20141126140621.GA18740@mwanda>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 17:06:21 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This check says "goto out;" if we had to truncate the string.
> 
> The "tbuffer" buffer has TRACE_BUF_SIZE bytes.  The vsnprintf() function
> returns the number of characters (not counting the NUL char) which would
> have been printed if there were space.  If we we tried to print
> TRACE_BUF_SIZE characters, the last character would have been truncated
> to make space for the NUL character so we should "goto out;".
> 
> My other concern here was that a few lines later we do:
> 
> 	entry->buf[len] = '\0';
> 
> I worried that maybe we were putting the NUL char past the end of the
> array but I wasn't smart enough to figure out the size of entry->buf[].

entry is of type struct print_entry *, which is defined by macro magic
(sorry), and would look like this:

struct print_entry {
	unsigned long		ip;
	char			buf[];
};

But then it is allocated like so:

	size = sizeof(*entry) + len + 1;
	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
					  flags, pc);

	entry = ring_buffer_event_data(event);

Now that size is the key. The "len + 1" covers the string. Which means

	entry->buf[len] = '\0';

is fine.

-- Steve


> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 42a822d..22af2ae 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2161,7 +2161,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
>  	}
>  
>  	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
> -	if (len > TRACE_BUF_SIZE)
> +	if (len >= TRACE_BUF_SIZE)
>  		goto out;
>  
>  	local_save_flags(flags);

