Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab3EZI0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 04:26:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3EZIZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 04:25:57 -0400
Date: Sun, 26 May 2013 10:25:49 +0200
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au
Subject: Re: [PATCH] modules: insert mods sorted
Message-ID: <20130526082548.GA1815@hawk.usersys.redhat.com>
References: <1369469386-3215-1-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369469386-3215-1-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 10:09:46AM +0200, Andrew Jones wrote:
> While there isn't a big difference between typing 'lsmod' and
> 'lsmod | sort', the module listing in Oopses isn't so easily sorted.
> Attempting to search these quickly by eye for particular modules while
> rapidly triaging bugs can be a pain. Sort the list and reduce the pain.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  kernel/module.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index cab4bce49c23d..7914d8ef2e09c 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3146,7 +3146,7 @@ static int may_init_module(void)
>  static int add_unformed_module(struct module *mod)
>  {
>  	int err;
> -	struct module *old;
> +	struct module *old, *m;
>  
>  	mod->state = MODULE_STATE_UNFORMED;
>  
> @@ -3166,7 +3166,13 @@ again:
>  		err = -EEXIST;
>  		goto out;
>  	}
> -	list_add_rcu(&mod->list, &modules);
> +	if (!list_empty(&modules)) {
> +		list_for_each_entry(m, &modules, list)
> +			if (strcmp(mod->name, m->name) < 0)
> +				break;
> +		list_add_tail_rcu(&mod->list, &m->list);
> +	} else
> +		list_add_rcu(&mod->list, &modules);
>  	err = 0;
>  
>  out:
> -- 
> 1.8.1.4
>

self-nacking. Tons of docs and tools exist expecting this
list in reverse load order. I'll blame the momentary insanity
the drove me to post this patch on having to triage too many
bugs...

drew
