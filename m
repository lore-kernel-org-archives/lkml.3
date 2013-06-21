Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab3FUGwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:52:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55390 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FUGwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:52:19 -0400
Message-ID: <51C3F81F.5090005@hitachi.com>
Date: Fri, 21 Jun 2013 15:52:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] tracing: simplify event_enable_read()
References: <cover.1371751701.git.tom.zanussi@linux.intel.com> <5e57e22fc06131f05c010c044680d56b6d7dc3c9.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <5e57e22fc06131f05c010c044680d56b6d7dc3c9.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:31), Tom Zanussi wrote:
> Rather than enumerating each permutation, build the enable state
> string up from the combination of states.  This also allows for the
> simpler addition of more states.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Looks nicer for me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks,

> ---
>  kernel/trace/trace_events.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 27963e2..ecb2609 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -624,17 +624,17 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
>  	struct ftrace_event_file *file = filp->private_data;
> -	char *buf;
> +	char buf[4] = "0";
>  
> -	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
> -		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
> -			buf = "0*\n";
> -		else if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
> -			buf = "1*\n";
> -		else
> -			buf = "1\n";
> -	} else
> -		buf = "0\n";
> +	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
> +	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
> +		strcpy(buf, "1");
> +
> +	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
> +	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
> +		strcat(buf, "*");
> +
> +	strcat(buf, "\n");
>  
>  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


