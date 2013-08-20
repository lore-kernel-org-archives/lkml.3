Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3HTDEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:04:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:46710 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3HTDED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:04:03 -0400
X-Spam-Score: -101.1
Message-ID: <5212DC65.9080702@asianux.com>
Date: Tue, 20 Aug 2013 11:03:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com>
In-Reply-To: <5212DBFA.8030805@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If this patch is correct, also need modify the man page for the return
value of getgroups().

Thanks.

On 08/20/2013 11:01 AM, Chen Gang wrote:
> groups_alloc() can return NULL for 'group_info', also group_search()
> already considers about NULL for 'group_info', so can assume the caller
> has right to use all related extern functions when 'group_info' is NULL.
> 
> For groups_free(), need check NULL to match groups_alloc(), just like
> kmalloc/free().
> 
> For set_groups(), can allow the caller to set NULL parameter to new
> 'cred'.
> 
> For system call getgroups(), if 'cred->group_info' is NULL, need return
> the related error code (no related data), also need change the related
> man page ("man 2 getgroups") to complete the return value.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/groups.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 6b2588d..a21a4ce 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -52,6 +52,9 @@ EXPORT_SYMBOL(groups_alloc);
> 
>  void groups_free(struct group_info *group_info)
>  {
> +	if (!group_info)
> +		return;
> +
>  	if (group_info->blocks[0] != group_info->small_block) {
>  		int i;
>  		for (i = 0; i < group_info->nblocks; i++)
> @@ -163,9 +166,12 @@ int groups_search(const struct group_info
> *group_info, kgid_t grp)
>   */
>  int set_groups(struct cred *new, struct group_info *group_info)
>  {
> -	put_group_info(new->group_info);
> -	groups_sort(group_info);
> -	get_group_info(group_info);
> +	if (new->group_info)
> +		put_group_info(new->group_info);
> +	if (group_info) {
> +		groups_sort(group_info);
> +		get_group_info(group_info);
> +	}
>  	new->group_info = group_info;
>  	return 0;
>  }
> @@ -206,6 +212,8 @@ SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t
> __user *, grouplist)
> 
>  	if (gidsetsize < 0)
>  		return -EINVAL;
> +	if (!cred->group_info)
> +		return -ENODATA;
> 
>  	/* no need to grab task_lock here; it cannot change */
>  	i = cred->group_info->ngroups;
> 


-- 
Chen Gang
