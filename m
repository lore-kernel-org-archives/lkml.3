Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3DSVj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:39:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933421Ab3DSVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:39:57 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=yU-HDpJ5xocA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=obdEBU1kN5oA:10 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=7d_E57ReAAAA:8 a=oUnC9fSiCg2s68yMr84A:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=2e6ZYRoF4I4A:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1366407596.9609.129.camel@gandalf.local.home>
Subject: Re: [PATCH v3] tracepoints: prevents null probe from being added
From: Steven Rostedt <rostedt@goodmis.org>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com
Date: Fri, 19 Apr 2013 17:39:56 -0400
In-Reply-To: <1365991995-19445-1-git-send-email-kpark3469@gmail.com>
References: <1365991995-19445-1-git-send-email-kpark3469@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 11:13 +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
> 
> Somehow tracepoint_entry_add_probe function allows a null probe function.
> And, this may lead to unexpected result since the number of probe
> functions in an entry can be counted by checking whether probe is null
> or not in for-loop.
> This patch prevents the null probe from being added.
> In tracepoint_entry_remove_probe function, checking probe parameter
> within for-loop is moved out for code efficiency leaving the null probe
> feature which removes all probe functions in the entry.
> 
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

BTW, do not add tags that were not given to you. "Reviewed-by" has a
meaning, more than just someone that reviewed your patch. It means that
they not only reviewed your patch but couldn't find anything wrong with
it. As both Mathieu and I had comments, that does not deserve a
"Reviewed-by" tag.

I'm not even sure that Mathieu gave an "Acked-by". I thought he did, but
I can't seem to find it. Mathieu?

Anyway, I'll start testing this patch as it seems fine with me (although
I still wouldn't give a Reviewed-by tag).

Thanks,

-- Steve

> ---
>  kernel/tracepoint.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0c05a45..29f2654 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
>  	int nr_probes = 0;
>  	struct tracepoint_func *old, *new;
>  
> -	WARN_ON(!probe);
> +	if (WARN_ON(!probe))
> +		return ERR_PTR(-EINVAL);
>  
>  	debug_print_probes(entry);
>  	old = entry->funcs;
> @@ -152,13 +153,18 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  
>  	debug_print_probes(entry);
>  	/* (N -> M), (N > 1, M >= 0) probes */
> -	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -		if (!probe ||
> -		    (old[nr_probes].func == probe &&
> -		     old[nr_probes].data == data))
> -			nr_del++;
> +	if (probe) {
> +		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> +			if (old[nr_probes].func == probe &&
> +			     old[nr_probes].data == data)
> +				nr_del++;
> +		}
>  	}
>  
> +	/*
> +	 * If probe is NULL, then nr_probes = nr_del = 0, and then the
> +	 * entire entry will be removed.
> +	 */
>  	if (nr_probes - nr_del == 0) {
>  		/* N -> 0, (N > 1) */
>  		entry->funcs = NULL;
> @@ -173,8 +179,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  		if (new == NULL)
>  			return ERR_PTR(-ENOMEM);
>  		for (i = 0; old[i].func; i++)
> -			if (probe &&
> -			    (old[i].func != probe || old[i].data != data))
> +			if (old[i].func != probe || old[i].data != data)
>  				new[j++] = old[i];
>  		new[nr_probes - nr_del].func = NULL;
>  		entry->refcount = nr_probes - nr_del;


