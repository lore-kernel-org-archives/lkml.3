Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3GZJ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:56:23 -0400
Received: from smtpbg63.qq.com ([103.7.29.150]:56915 "HELO smtpbg63.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758360Ab3GZJ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:56:20 -0400
X-QQ-mid: bizesmtp1t1374832575t659t198
X-QQ-SSF: 01400000000000F0FPF2000A0000000
Message-ID: <51F24864.7070306@tnsoft.com.cn>
Date: Fri, 26 Jul 2013 17:59:00 +0800
From: Dennis Chen <xschen@tnsoft.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
CC: Tejun Heo <tj@kernel.org>, xiyou.wangcong@gmail.com,
        Dennis Chen <xschen@tnsoft.com.cn>
Subject: Re: [PATCH] race condition fixing in sysfs_create_dir
References: <51F24612.6030509@tnsoft.com.cn>
In-Reply-To: <51F24612.6030509@tnsoft.com.cn>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 05:49 PM, Dennis Chen wrote:

> The patch is trying its best to avoid creating a dir under a parent dir which is removing from
> the system:
>      PATH0 (create a dir under 'PARENT/...')         PATH1 (remove the 'PARENT/...')
>           sysfs_create_dir() {                         sysfs_remove_dir() {
>           ...                                          ...
>           if (kobj->parent)                            spin_lock(&sysfs_assoc_lock);
>          parent_sd = kobj->parent->sd;  <----- kobj->sd = NULL;
>       else                                         spin_unlock(&sysfs_assoc_lock);
>          parent_sd = &sysfs_root;
> Suppose PATH1 enter the critical section first, then PATH0 begin to execute before kobj->sd
> has been reset to NULL, possibly PATH0 will get a non-NULL parent_sd since lack of the
> sysfs_assoc_lock protection in PATH0. In this case, PATH0 think it has a valid parent_sd which
> can be freed by PATH1 in the followed, refer to the comments in the patch. Maybe we need
> to figure out a perfect solution to solve the race condition, although the codes in question are
> in slow path...
> Signed-off-by: Dennis Chen <xschen@tnsoft.com.cn>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Tejun Heo <teheo@suse.de>

should be Tejun Heo <tj@kernel.org>

> Cc: Wang Cong <xiyou.wangcong@gmail.com>
> ---
> fs/sysfs/dir.c |   11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index e068e74..114073d 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -746,13 +746,22 @@ int sysfs_create_dir(struct kobject * kobj)
>          BUG_ON(!kobj);
> +       spin_lock(&sysfs_assoc_lock);
>      if (kobj->parent)
>          parent_sd = kobj->parent->sd;
>      else
>          parent_sd = &sysfs_root;
> -       if (!parent_sd)
> +       if (!parent_sd) {
> +               spin_unlock(&sysfs_assoc_lock);
>                  return -ENOENT;
> +       }
> +       spin_unlock(&sysfs_assoc_lock);
> +       /* TODO: although the sysfs is in a slow path, but in the operation
> +       * followed, we still have a window to let the sysfs_remove_dir to
> +       * free the memory space pointered by parent_sd till we inc its ref
> +       * count in __sysfs_add_one()
> +       */
>          if (sysfs_ns_type(parent_sd))
>                  ns = kobj->ktype->namespace(kobj);

Re CC Tejun whose email addess <@suse.de> is obsolete :)

