Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3E0XGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 19:06:12 -0400
Received: from ozlabs.org ([203.10.76.45]:33284 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3E0XGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 19:06:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modules: insert mods sorted
In-Reply-To: <1369469386-3215-1-git-send-email-drjones@redhat.com>
References: <1369469386-3215-1-git-send-email-drjones@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 27 May 2013 20:33:41 +0930
Message-ID: <87k3mkptv6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Jones <drjones@redhat.com> writes:
> While there isn't a big difference between typing 'lsmod' and
> 'lsmod | sort', the module listing in Oopses isn't so easily sorted.
> Attempting to search these quickly by eye for particular modules while
> rapidly triaging bugs can be a pain. Sort the list and reduce the pain.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Hi Andrew,

        ISTR the story of young Fleming being fired as bottlewasher for
a major lab because the head researcher felt he was wasting his
talents.[1]

        Please take my rejection of this patch as similar endorsement of
your future prospects.

Cheers,
Rusty.
[1] Google can't find any trace of this story, so may be my imagination...

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
