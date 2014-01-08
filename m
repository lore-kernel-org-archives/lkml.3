Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaAHKVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:21:18 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755152AbaAHKVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:21:16 -0500
From: Richard Weinberger <richard@nod.at>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@lst.de, eric.dumazet@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/inode: No need to take ->i_lock right after alloc_inode()
Date: Wed, 08 Jan 2014 11:21:13 +0100
Message-ID: <1524545.iNFYXWHlaf@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1387054495-31498-1-git-send-email-richard@nod.at>
References: <1387054495-31498-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 14. Dezember 2013, 21:54:55 schrieb Richard Weinberger:
> In all three cases, new_inode_pseudo(), iget_locked() and iget5_locked(),
> we own the new inode exclusively at this point and therefore taking
> ->i_lock to protect ->i_state/->i_hash against concurrent access is
> superfluous.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  fs/inode.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 4bcdad3..5f2a735 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -869,9 +869,7 @@ struct inode *new_inode_pseudo(struct super_block *sb)
>  	struct inode *inode = alloc_inode(sb);
> 
>  	if (inode) {
> -		spin_lock(&inode->i_lock);
>  		inode->i_state = 0;
> -		spin_unlock(&inode->i_lock);
>  		INIT_LIST_HEAD(&inode->i_sb_list);
>  	}
>  	return inode;
> @@ -1025,10 +1023,8 @@ struct inode *iget5_locked(struct super_block *sb,
> unsigned long hashval, if (set(inode, data))
>  				goto set_failed;
> 
> -			spin_lock(&inode->i_lock);
>  			inode->i_state = I_NEW;
>  			hlist_add_head(&inode->i_hash, head);
> -			spin_unlock(&inode->i_lock);
>  			inode_sb_list_add(inode);
>  			spin_unlock(&inode_hash_lock);
> 
> @@ -1092,10 +1088,8 @@ struct inode *iget_locked(struct super_block *sb,
> unsigned long ino) old = find_inode_fast(sb, head, ino);
>  		if (!old) {
>  			inode->i_ino = ino;
> -			spin_lock(&inode->i_lock);
>  			inode->i_state = I_NEW;
>  			hlist_add_head(&inode->i_hash, head);
> -			spin_unlock(&inode->i_lock);
>  			inode_sb_list_add(inode);
>  			spin_unlock(&inode_hash_lock);

Any comments on this?

Thanks,
//richard
