Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbaELM4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:56:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbaELM4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:56:39 -0400
Date: Mon, 12 May 2014 14:56:32 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Seunghun Lee <waydi1@gmail.com>
cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: super: remove unnecessary goto statement
In-Reply-To: <1399478883-2897-1-git-send-email-waydi1@gmail.com>
Message-ID: <alpine.LFD.2.00.1405121449001.8008@localhost.localdomain>
References: <1399478883-2897-1-git-send-email-waydi1@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Seunghun Lee wrote:

> Date: Thu,  8 May 2014 01:08:03 +0900
> From: Seunghun Lee <waydi1@gmail.com>
> To: jack@suse.cz
> Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Seunghun Lee <waydi1@gmail.com>
> Subject: [PATCH] ext2: super: remove unnecessary goto statement
> 
> This patch removes unnecessary goto failed,
> and moves kfree to failed.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  fs/ext2/super.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3750031..7d20a50 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -777,17 +777,15 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	__le32 features;
>  	int err;
>  
> -	err = -ENOMEM;

The problem here is actually that we return -EINVAL while we should
actually return -ENOMEM, which is fixed only partially by your
patch.

Also there are number other problems in error handling here mainly
because we're using err variable but not setting ret variable which
is the one that we return eventually.

Also ret is defined as long (not sure if that's needed) but the
function is supposed to return int.

So if you're changing the code around it would be good to actually
fix some problems as well :)

Thanks!
-Lukas

>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
> -		goto failed;
> +		return -ENOMEM;
>  
>  	sbi->s_blockgroup_lock =
>  		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
> -	if (!sbi->s_blockgroup_lock) {
> -		kfree(sbi);
> +	if (!sbi->s_blockgroup_lock)
>  		goto failed;
> -	}
> +
>  	sb->s_fs_info = sbi;
>  	sbi->s_sb_block = sb_block;
>  
> @@ -1138,8 +1136,8 @@ failed_mount:
>  failed_sbi:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
> -	kfree(sbi);
>  failed:
> +	kfree(sbi);
>  	return ret;
>  }
>  
> 
