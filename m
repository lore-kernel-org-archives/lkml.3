Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaKQRc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 12:32:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54745 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751092AbaKQRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 12:32:56 -0500
Date: Mon, 17 Nov 2014 12:32:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 19/26 v5] tracing: Use trace_seq_used() and
 seq_buf_used() instead of len
Message-ID: <20141117123250.10f6f57c@gandalf.local.home>
In-Reply-To: <20141115050603.904875201@goodmis.org>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 23:59:06 -0500
  
>  	/*
> @@ -4575,20 +4575,33 @@ static size_t
>  tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
>  {
>  	size_t count;
> +	int save_len;
>  	int ret;
>  
>  	/* Seq buffer is page-sized, exactly what we need. */
>  	for (;;) {
> -		count = iter->seq.seq.len;
> +		save_len = iter->seq.seq.len;
>  		ret = print_trace_line(iter);
> -		count = iter->seq.seq.len - count;
> -		if (rem < count) {
> -			rem = 0;
> -			iter->seq.seq.len -= count;
> +
> +		if (trace_seq_has_overflowed(&iter->seq)) {
> +			iter->seq.seq.len = save_len;
>  			break;
>  		}
> +
> +		/*
> +		 * This should not be hit, because it should only
> +		 * be set if the iter->seq overflowed. But check it
> +		 * anyway to be safe.
> +		 */
>  		if (ret == TRACE_TYPE_PARTIAL_LINE) {
> -			iter->seq.seq.len -= count;
> +			iter->seq.seq.len = save_len;
> +			break;
> +		}
> +
> +		count = trace_seq_used(&iter->seq) - save_len;
> +		if (rem < count) {
> +			rem = 0;
> +			iter->seq.seq.len = save_len;;
>  			break;
>  		}
>  

I don't like the fact that I did a code structure change with this
patch. This patch should be just a simple conversion of len to
seq_buf_used(). I'm going to strip this change out and put it before
this patch.

-- Steve

