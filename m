Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3FRIZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:25:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3FRIZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:25:44 -0400
Date: Tue, 18 Jun 2013 10:25:43 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130618082543.GD13677@dhcp22.suse.cz>
References: <20130617141822.GF5018@dhcp22.suse.cz>
 <20130617151403.GA25172@localhost.localdomain>
 <20130617143508.7417f1ac9ecd15d8b2877f76@linux-foundation.org>
 <20130617223004.GB2538@localhost.localdomain>
 <20130618062623.GA20528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618062623.GA20528@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-06-13 10:26:24, Glauber Costa wrote:
[...]
> Which is obviously borked since I did not fix the other callers so to move I_FREEING
> after lru del.
> 
> Michal, would you mind testing the following patch?

I was about to start testing with inode_lru_isolate fix. I will give it
few runs and then test this one if it is still relevant.

> diff --git a/fs/inode.c b/fs/inode.c
> index 00b804e..48eafa6 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -419,6 +419,8 @@ void inode_add_lru(struct inode *inode)
>  
>  static void inode_lru_list_del(struct inode *inode)
>  {
> +	if (inode->i_state & I_FREEING)
> +		return;
>  
>  	if (list_lru_del(&inode->i_sb->s_inode_lru, &inode->i_lru))
>  		this_cpu_dec(nr_unused);
> @@ -609,8 +611,8 @@ void evict_inodes(struct super_block *sb)
>  			continue;
>  		}
>  
> -		inode->i_state |= I_FREEING;
>  		inode_lru_list_del(inode);
> +		inode->i_state |= I_FREEING;
>  		spin_unlock(&inode->i_lock);
>  		list_add(&inode->i_lru, &dispose);
>  	}
> @@ -653,8 +655,8 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
>  			continue;
>  		}
>  
> -		inode->i_state |= I_FREEING;
>  		inode_lru_list_del(inode);
> +		inode->i_state |= I_FREEING;
>  		spin_unlock(&inode->i_lock);
>  		list_add(&inode->i_lru, &dispose);
>  	}
> @@ -1381,9 +1383,8 @@ static void iput_final(struct inode *inode)
>  		inode->i_state &= ~I_WILL_FREE;
>  	}
>  
> +	inode_lru_list_del(inode);
>  	inode->i_state |= I_FREEING;
> -	if (!list_empty(&inode->i_lru))
> -		inode_lru_list_del(inode);
>  	spin_unlock(&inode->i_lock);
>  
>  	evict(inode);


-- 
Michal Hocko
SUSE Labs
