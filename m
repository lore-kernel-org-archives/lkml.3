Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3DMAwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 20:52:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3DMAwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 20:52:50 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rb2-4CBkrPkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=obdEBU1kN5oA:10 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=7d_E57ReAAAA:8 a=VWcbVgGv56rHAKXkiCIA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=2e6ZYRoF4I4A:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365814368.9609.99.camel@gandalf.local.home>
Subject: Re: [PATCH v2] tracepoints: prevents null probe from being added
From: Steven Rostedt <rostedt@goodmis.org>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com
Date: Fri, 12 Apr 2013 20:52:48 -0400
In-Reply-To: <1363844081-17182-1-git-send-email-kpark3469@gmail.com>
References: <1363844081-17182-1-git-send-email-kpark3469@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 14:34 +0900, kpark3469@gmail.com wrote:
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
> ---
>  kernel/tracepoint.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0c05a45..7d69348 100644
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
> @@ -152,13 +153,15 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
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
> +	/* If probe is NULL, all funcs in the entry will be removed. */

OK, I first thought this was a bug as nr_del would be zero and not match
nr_probes, but then I realized that nr_probes would also be zero. Can
you update the above comment to say something like:

	/*
	 * If probe is NULL, then nr_probes = nr_del = 0, and then the
	 * entire entry will be removed.
	 */

Thanks,

-- Steve

>  	if (nr_probes - nr_del == 0) {
>  		/* N -> 0, (N > 1) */
>  		entry->funcs = NULL;
> @@ -173,8 +176,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>  		if (new == NULL)
>  			return ERR_PTR(-ENOMEM);
>  		for (i = 0; old[i].func; i++)
> -			if (probe &&
> -			    (old[i].func != probe || old[i].data != data))
> +			if (old[i].func != probe || old[i].data != data)
>  				new[j++] = old[i];
>  		new[nr_probes - nr_del].func = NULL;
>  		entry->refcount = nr_probes - nr_del;


