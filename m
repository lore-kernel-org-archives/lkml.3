Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3EXB1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 21:27:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14179 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab3EXB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 21:27:38 -0400
X-Spam-Score: -100.8
Message-ID: <519EC1D7.1000402@asianux.com>
Date: Fri, 24 May 2013 09:26:47 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [Suggestion] fs/namespace.c: the direct cause of the warning
 for: "ida_remove called for id=0 which is not allocated" with mnt_release_group_id()
References: <5191FE96.6050607@asianux.com> <20130523161805.1faa0f8c59bfc8ee728d8c7f@linux-foundation.org>
In-Reply-To: <20130523161805.1faa0f8c59bfc8ee728d8c7f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 07:18 AM, Andrew Morton wrote:
> On Tue, 14 May 2013 17:06:30 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> 
>> > After call collect_mounts(), then call drop_collected_mounts(), it will
>> > report an warning: "ida_remove called for id=0 which is not allocated"
>> > (one sample is audit_add_tree_rule() in kernel/audit_tree.c).
>> > 
>> > The direct cause (maybe also be the root cause):
>> >   collect_mounts() passs 'CL_PRIVATE' to copy_tree() -> clone_mnt().
>> >   it will set "mnt->mnt_group_id = 0" in clone_mnt().
>> >   when drop_collected_mounts() -> mnt_release_group_id(), 'mnt->mnt_group_id == 0'.
> I expect this patch also addresses the bug.  Can you please review and test it?
> 

I am sure, after apply the patch below, it will be no warning again (fix
the direct cause).

Originally, I want to fix this bug just like the patch below, but I am
not quite sure whether it will hide the real root cause.


Thanks.

> 
> From: Takashi Iwai <tiwai@suse.de>
> Subject: vfs: fix invalid ida_remove() call
> 
> When the group id of a shared mount is not allocated, the umount still
> tries to call mnt_release_group_id(), which eventually hits a kernel
> warning at ida_remove() spewing a message like:
> 
>   ida_remove called for id=0 which is not allocated.
> 
> This patch fixes the bug simply checking the group id in the caller.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Reported-by: Cristian Rodr�guez <crrodriguez@opensuse.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/pnode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff -puN fs/pnode.c~vfs-fix-invalid-ida_remove-call fs/pnode.c
> --- a/fs/pnode.c~vfs-fix-invalid-ida_remove-call
> +++ a/fs/pnode.c
> @@ -83,7 +83,8 @@ static int do_make_slave(struct mount *m
>  		if (peer_mnt == mnt)
>  			peer_mnt = NULL;
>  	}
> -	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
> +	if (mnt->mnt_group_id && IS_MNT_SHARED(mnt) &&
> +	    list_empty(&mnt->mnt_share))
>  		mnt_release_group_id(mnt);
>  
>  	list_del_init(&mnt->mnt_share);
> _
> 
> 
> 


-- 
Chen Gang

Asianux Corporation
