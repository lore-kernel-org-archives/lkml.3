Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab3IBIY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:24:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35862 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3IBIY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:24:58 -0400
Message-ID: <52244B44.4030703@gmail.com>
Date: Mon, 02 Sep 2013 16:24:36 +0800
From: Baoquan He <baoquan.he@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>
CC: Hillf Danton <dhillf@gmail.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: 3.11-rc7:BUG: soft lockup
References: <522055D7.70002@gmail.com> <CAM_iQpW3F=inR0y6GFE64OgkhKSdzF-trrZamgThXTiyOYYmBw@mail.gmail.com> <CAJd=RBCT6dbLwX6z+1LxCvJ9-NOYQRe0zzBkEQosFgLvNgg4bg@mail.gmail.com> <52242AEA.9020502@gmail.com> <522441E9.8040809@huawei.com>
In-Reply-To: <522441E9.8040809@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tianhong,

I applied your patch and execute below cmd. 
Then keyboard inputting problems happened, 
I can't enter user/password correctly, then reboot again, it's OK now.

The original bug still can't be reproduced.

make SUBDIRS=net/bridge/netfilter/
cp /net/bridge/netfilter/ebtables.ko
/lib/modules/3.11.0-rc7+/kernel/net/bridge/netfilter/ebtables.ko
depmod
modprobe ebtables.ko
reboot

Baoquan
Thanks

> please try this patch and give me the result, thanks.
>
> Return the correct value if mutex_lock_interruptible() failed, avoid
> confusion with that the modules is not exist, and deal with the return
> value in right way.
>
> if mutex_lock_interrupt() failed, sh
>
> Signed-off-by: root <root@linux-yocto.site>
> ---
>  net/bridge/netfilter/ebtables.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index ac78024..e7fe9f8 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -322,17 +322,14 @@ static inline void *
>  find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
>     struct mutex *mutex)
>  {
> -	struct {
> -		struct list_head list;
> -		char name[EBT_FUNCTION_MAXNAMELEN];
> -	} *e;
> +	struct ebt_table *e;
>  
>  	*error = mutex_lock_interruptible(mutex);
>  	if (*error != 0)
> -		return NULL;
> +		return ERR_PTR(-EINTR);
>  
>  	list_for_each_entry(e, head, list) {
> -		if (strcmp(e->name, name) == 0)
> +		 if (strcmp(e->name, name) == 0 && try_module_get(e->me))
>  			return e;
>  	}
>  	*error = -ENOENT;
> @@ -1005,7 +1002,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>  		goto free_counterstmp;
>  
>  	t = find_table_lock(net, repl->name, &ret, &ebt_mutex);
> -	if (!t) {
> +	if (IS_ERR_OR_NULL(t)) {
>  		ret = -ENOENT;
>  		goto free_iterate;
>  	}
> @@ -1284,7 +1281,7 @@ static int do_update_counters(struct net *net, const char *name,
>  		return -ENOMEM;
>  
>  	t = find_table_lock(net, name, &ret, &ebt_mutex);
> -	if (!t)
> +	if (IS_ERR_OR_NULL(t))
>  		goto free_tmp;
>  
>  	if (num_counters != t->private->nentries) {
> @@ -1504,7 +1501,7 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
>  		return -EFAULT;
>  
>  	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
> -	if (!t)
> +	if (IS_ERR_OR_NULL(t))
>  		return ret;
>  
>  	switch(cmd) {
> @@ -2319,7 +2316,7 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
>  		return -EFAULT;
>  
>  	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
> -	if (!t)
> +	if (IS_ERR_OR_NULL(t))
>  		return ret;
>  
>  	xt_compat_lock(NFPROTO_BRIDGE);

