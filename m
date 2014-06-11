Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaFKOF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:05:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31332 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753796AbaFKOFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:05:25 -0400
Date: Wed, 11 Jun 2014 10:05:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] tracing: Do not copy hash if O_TRUNC is set
Message-ID: <20140611100524.295efcce@gandalf.local.home>
In-Reply-To: <1402474014-28655-2-git-send-email-namhyung@kernel.org>
References: <1402474014-28655-1-git-send-email-namhyung@kernel.org>
	<1402474014-28655-2-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014 17:06:54 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> When a filter file is open for writing and O_TRUNC is set, there's no
> need to copy and free the filter entries.
> 

Nice cleanup. I'll add it for 3.17.

Thanks,

-- Steve

> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/ftrace.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index ddfda763ded7..13885590a184 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2759,7 +2759,13 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
>  		hash = ops->filter_hash;
>  
>  	if (file->f_mode & FMODE_WRITE) {
> -		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
> +		const int size_bits = FTRACE_HASH_DEFAULT_BITS;
> +
> +		if (file->f_flags & O_TRUNC)
> +			iter->hash = alloc_ftrace_hash(size_bits);
> +		else
> +			iter->hash = alloc_and_copy_ftrace_hash(size_bits, hash);
> +
>  		if (!iter->hash) {
>  			trace_parser_put(&iter->parser);
>  			kfree(iter);
> @@ -2768,10 +2774,6 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
>  		}
>  	}
>  
> -	if ((file->f_mode & FMODE_WRITE) &&
> -	    (file->f_flags & O_TRUNC))
> -		ftrace_filter_reset(iter->hash);
> -
>  	if (file->f_mode & FMODE_READ) {
>  		iter->pg = ftrace_pages_start;
>  

