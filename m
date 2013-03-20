Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3CTRcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:32:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3CTRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:31:54 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=IDtP91cgT7AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=-oqz9XiUJNoA:10 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=IRjRwGnNuNxDLOziyK0A:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363800712.6345.17.camel@gandalf.local.home>
Subject: Re: [PATCH] tracepoints: prevents null probe from being added
From: Steven Rostedt <rostedt@goodmis.org>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 20 Mar 2013 13:31:52 -0400
In-Reply-To: <1363749497-12176-1-git-send-email-kpark3469@gmail.com>
References: <1363749497-12176-1-git-send-email-kpark3469@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 12:18 +0900, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@windriver.com>
> 
> Somehow tracepoint_entry_add/remove_probe functions allow a null probe
> function.

You actually hit this in practice, or is this just something that you
observe from code review?

>  Especially on getting a null probe in remove function, it seems
> to be used to remove all probe functions in the entry.

Hmm, that actually sounds like a feature.

> But, the code is not handled as expected. Since the tracepoint_entry
> maintains funcs array's last func as NULL in order to mark it as the end
> of the array. Also NULL func is used in for-loop to check out the end of
> the loop. So if there's NULL func in the entry's funcs, the for-loop
> will be abruptly ended in the middle of operation.
> Also checking out if probe is null in for-loop is not efficient.
> 
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> ---
>  kernel/tracepoint.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0c05a45..30f427e 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -112,7 +112,10 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
>  	int nr_probes = 0;
>  	struct tracepoint_func *old, *new;
>  
> -	WARN_ON(!probe);
> +	if (unlikely(!probe)) {
> +		WARN_ON(!probe);
> +		return ERR_PTR(-EINVAL);
> +	}

Um, you want:

	if (WARN_ON(!probe))
		return ERR_PTR(-EINVAL);

>  
>  	debug_print_probes(entry);
>  	old = entry->funcs;
> @@ -147,15 +150,19 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  
>  	old = entry->funcs;
>  
> +	if (unlikely(!probe)) {
> +		WARN_ON(!probe);
> +		return ERR_PTR(-EINVAL);
> +	}

Here too if it wasn't intended to allow removal of all probes from a
tracepoint.

> +
>  	if (!old)
>  		return ERR_PTR(-ENOENT);
>  
>  	debug_print_probes(entry);
>  	/* (N -> M), (N > 1, M >= 0) probes */
>  	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -		if (!probe ||
> -		    (old[nr_probes].func == probe &&
> -		     old[nr_probes].data == data))
> +		if (old[nr_probes].func == probe &&
> +		     old[nr_probes].data == data)
>  			nr_del++;
>  	}
>  
> @@ -173,8 +180,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  		if (new == NULL)
>  			return ERR_PTR(-ENOMEM);
>  		for (i = 0; old[i].func; i++)
> -			if (probe &&
> -			    (old[i].func != probe || old[i].data != data))
> +			if (old[i].func != probe || old[i].data != data)

This makes it look like the null probe was intentional.

-- Steve

>  				new[j++] = old[i];
>  		new[nr_probes - nr_del].func = NULL;
>  		entry->refcount = nr_probes - nr_del;


