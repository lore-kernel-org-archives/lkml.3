Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbaKTNNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:13:07 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:39885 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbaKTNNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:13:04 -0500
Date: Thu, 20 Nov 2014 08:13:03 -0500 (EST)
From: Bob Peterson <rpeterso@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Message-ID: <38038928.16891302.1416489183602.JavaMail.zimbra@redhat.com>
In-Reply-To: <20141120051947.GG7996@ZenIV.linux.org.uk>
References: <20141120051947.GG7996@ZenIV.linux.org.uk>
Subject: Re: [Cluster-devel] gfs2: gfs2_dir_get_hash_table(): avoiding
 deferred vfree() is easy here...
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF33 (Linux)/8.0.6_GA_5922)
Thread-Topic: gfs2: gfs2_dir_get_hash_table(): avoiding deferred vfree() is easy here...
Thread-Index: 19m8yNFLVWl2s9zoaYWK1wGfXD/brw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> vfree() is allowed under spinlock these days, but it's cheaper when
> it doesn't step into deferred case and here it's very easy to avoid.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/gfs2/dir.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
> index c247fed..c5a34f0 100644
> --- a/fs/gfs2/dir.c
> +++ b/fs/gfs2/dir.c
> @@ -370,11 +370,12 @@ static __be64 *gfs2_dir_get_hash_table(struct
> gfs2_inode *ip)
>  	}
>  
>  	spin_lock(&inode->i_lock);
> -	if (ip->i_hash_cache)
> -		kvfree(hc);
> -	else
> +	if (likely(!ip->i_hash_cache)) {
>  		ip->i_hash_cache = hc;
> +		hc = NULL;
> +	}
>  	spin_unlock(&inode->i_lock);
> +	kvfree(hc);
>  
>  	return ip->i_hash_cache;
>  }
> --
> 1.7.10.4
> 
> 

ACK

Bob Peterson
Red Hat File Systems
