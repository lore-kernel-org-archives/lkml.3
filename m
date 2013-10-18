Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3JRCqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 22:46:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:24584 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755783Ab3JRCqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 22:46:07 -0400
Date: Thu, 17 Oct 2013 22:46:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
Message-ID: <20131017224605.2e1d4bab@gandalf.local.home>
In-Reply-To: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 22:44:56 -0300
"Geyslan G. Bem" <geyslan@gmail.com> wrote:

> Restructures function logic conditions testing 'tracing_open_generic'
> return before the others. It avoids: unnecessary trace_array_get and
> kzalloc when tracing is disabled; and fix the possible 'dir'
> assignment after freeing it.
> 
> Centralizes the exiting, ensuring the 'trace_array_put' on error,
> in accordance to Coding Style, Chapter 7.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  kernel/trace/trace_events.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..8232362 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1108,26 +1108,28 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	struct trace_array *tr = inode->i_private;
>  	int ret;
>  
> -	if (trace_array_get(tr) < 0)
> -		return -ENODEV;
> +	ret = tracing_open_generic(inode, filp);
> +	if (ret)
> +		return ret;
> +
> +	ret = trace_array_get(tr);
> +	if (ret)
> +		return ret;

Hmm,

I'm thinking of just nuking the tracing_open_generic() here. The only
thing it does here is the tracing_disabled check. The assignment of
inode->i_private to filp->private_data is pointless as it just
reassigns it anyway.

We could add a tracing_is_disabled() function to test instead.

-- Steve

>  
>  	/* Make a temporary dir that has no system but points to tr */
>  	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
>  	if (!dir) {
> -		trace_array_put(tr);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_dir;
>  	}
>  
>  	dir->tr = tr;
>  
> -	ret = tracing_open_generic(inode, filp);
> -	if (ret < 0) {
> -		trace_array_put(tr);
> -		kfree(dir);
> -	}
> -
>  	filp->private_data = dir;
> +	return 0;
>  
> +err_dir:
> +	trace_array_put(tr);
>  	return ret;
>  }
>  

