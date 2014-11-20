Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbaKTRTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:19:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbaKTRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:19:23 -0500
Message-ID: <546E2296.1070709@redhat.com>
Date: Thu, 20 Nov 2014 17:19:18 +0000
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
CC: cluster-devel@redhat.com
Subject: Re: [Cluster-devel] gfs2: gfs2_dir_get_hash_table(): avoiding deferred
 vfree() is easy here...
References: <20141120051947.GG7996@ZenIV.linux.org.uk>
In-Reply-To: <20141120051947.GG7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All five patches now in the GFS2 -nmw tree. Thanks,

Steve.

On 20/11/14 05:19, Al Viro wrote:
> vfree() is allowed under spinlock these days, but it's cheaper when
> it doesn't step into deferred case and here it's very easy to avoid.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>   fs/gfs2/dir.c |    7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
> index c247fed..c5a34f0 100644
> --- a/fs/gfs2/dir.c
> +++ b/fs/gfs2/dir.c
> @@ -370,11 +370,12 @@ static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
>   	}
>   
>   	spin_lock(&inode->i_lock);
> -	if (ip->i_hash_cache)
> -		kvfree(hc);
> -	else
> +	if (likely(!ip->i_hash_cache)) {
>   		ip->i_hash_cache = hc;
> +		hc = NULL;
> +	}
>   	spin_unlock(&inode->i_lock);
> +	kvfree(hc);
>   
>   	return ip->i_hash_cache;
>   }

