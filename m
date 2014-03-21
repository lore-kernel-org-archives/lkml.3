Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966297AbaCUAL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:11:29 -0400
Received: from linuxhacker.ru ([217.76.32.60]:54469 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966236AbaCUAL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:11:27 -0400
Subject: Re: [PATCH 3.10 76/85] Fix mountpoint reference leakage in linkat
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140321000609.596835128@linuxfoundation.org>
Date: Thu, 20 Mar 2014 20:11:22 -0400
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <3E72E44E-23C8-4040-8495-0A61C9C4316A@linuxhacker.ru>
References: <20140321000558.606667505@linuxfoundation.org> <20140321000609.596835128@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Mar 20, 2014, at 8:10 PM, Greg Kroah-Hartman wrote:

> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Oleg Drokin <green@linuxhacker.ru>
> 
> commit d22e6338db7f613dd4f6095c190682fcc519e4b7 upstream.
> 
> Recent changes to retry on ESTALE in linkat
> (commit 442e31ca5a49e398351b2954b51f578353fdf210)
> introduced a mountpoint reference leak and a small memory
> leak in case a filesystem link operation returns ESTALE
> which is pretty normal for distributed filesystems like
> lustre, nfs and so on.
> Free old_path in such a case.
> 
> [AV: there was another missing path_put() nearby - on the previous
> goto retry]

This comment loses sense in this version because there's no previous goto retry,
though it might not be important due to it just being a port of an upstream commit, I guess.

> 
> Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> fs/namei.c |    1 +
> 1 file changed, 1 insertion(+)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3655,6 +3655,7 @@ retry:
> out_dput:
> 	done_path_create(&new_path, new_dentry);
> 	if (retry_estale(error, how)) {
> +		path_put(&old_path);
> 		how |= LOOKUP_REVAL;
> 		goto retry;
> 	}
> 

