Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaAaVDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:03:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaAaVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:03:36 -0500
Date: Fri, 31 Jan 2014 21:03:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Message-ID: <20140131210334.GO10323@ZenIV.linux.org.uk>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:41:58PM -0500, Oleg Drokin wrote:
> Recent changes to retry on ESTALE in linkat
> (commit 442e31ca5a49e398351b2954b51f578353fdf210)
> introduced a mountpoint reference leak and a small memory
> leak in case a filesystem link operation returns ESTALE
> which is pretty normal for distributed filesystems like
> lustre, nfs and so on.
> Free old_path in such a case.
> 
> Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
> ---
>  fs/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index bcb838e..e620937 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3931,6 +3931,7 @@ out_dput:
>  			goto retry;
>  	}
>  	if (retry_estale(error, how)) {
> +		path_put(&old_path);
>  		how |= LOOKUP_REVAL;
>  		goto retry;
>  	}

Umm...  That obviously can't be right - we have another goto retry
in the same situation (see in your diff context).  I agree that
we have a leak there, but you've fixed only a half of it.
