Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaGNMV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:21:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37819 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942AbaGNMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:21:20 -0400
Date: Mon, 14 Jul 2014 08:21:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Do not copy old hash when resetting.
Message-ID: <20140714082117.1b274a3d@gandalf.local.home>
In-Reply-To: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
References: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 12:10:00 +0800
Wang Nan <wangnan0@huawei.com> wrote:

> If we are going to reset hash, we don't need to duplicate old hash
> and remove every entries right after allocation.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ftrace.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b372e3..52d6931 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3471,14 +3471,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
>  	else
>  		orig_hash = &ops->notrace_hash;
>  
> -	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	if (!reset)
> +		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	else
> +		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);

I'm fine with this patch, but please swap the if statement above. I
prefer the if condition being positive if there's also an else
statement above. That is:

	if (reset)
		hash = alloc_ftrace_hash();
	else
		hash = alloc_and_copy_ftrace_hash();

-- Steve

> +
>  	if (!hash) {
>  		ret = -ENOMEM;
>  		goto out_regex_unlock;
>  	}
>  
> -	if (reset)
> -		ftrace_filter_reset(hash);
>  	if (buf && !ftrace_match_records(hash, buf, len)) {
>  		ret = -EINVAL;
>  		goto out_regex_unlock;

