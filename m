Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaATXXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:23:23 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48098 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaATXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:23:20 -0500
Message-ID: <1390260196.2501.4.camel@leira.trondhjem.org>
Subject: Re: [PATCH] NFSv4.1: new layout stateid can not be overwrite by one
 out of date
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: shaobingqing <shaobingqing@bwstor.com.cn>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Jan 2014 16:23:16 -0700
In-Reply-To: <1390205731-21005-1-git-send-email-shaobingqing@bwstor.com.cn>
References: <n>
	 <1390205731-21005-1-git-send-email-shaobingqing@bwstor.com.cn>
Organization: Primary Data
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-20 at 16:15 +0800, shaobingqing wrote:
> If initiate_file_draining returned NFS4ERR_DELAY, all the lsegs of
> a file might be released before the retrying cb_layout request arriving
> at the client. In this situation, layoutget request of the file will
> use open stateid to obtain a new layout stateid. And if the retrying
> cb_layout request arrived at the client after the layoutget reply,
> new layout stateid would be overwrite by one out of date.
> 
> Signed-off-by: shaobingqing <shaobingqing@bwstor.com.cn>
> ---
>  fs/nfs/callback_proc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
> index ae2e87b..98fed13 100644
> --- a/fs/nfs/callback_proc.c
> +++ b/fs/nfs/callback_proc.c
> @@ -174,7 +174,9 @@ static u32 initiate_file_draining(struct nfs_client *clp,
>  		rv = NFS4ERR_DELAY;
>  	else
>  		rv = NFS4ERR_NOMATCHING_LAYOUT;
> -	pnfs_set_layout_stateid(lo, &args->cbl_stateid, true);
> +	if (memcmp(args->cbl_stateid.other, lo->plh_stateid.other,
> +	     NFS4_STATEID_OTHER_SIZE) == 0)
> +		pnfs_set_layout_stateid(lo, &args->cbl_stateid, true);

Well...  We shouldn't really be calling
pnfs_mark_matching_lsegs_invalid() either in this case...

>  	spin_unlock(&ino->i_lock);
>  	pnfs_free_lseg_list(&free_me_list);
>  	pnfs_put_layout_hdr(lo);


-- 
Trond Myklebust
Linux NFS client maintainer

