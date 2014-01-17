Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaAQOdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:33:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQOdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:33:02 -0500
Date: Fri, 17 Jan 2014 06:33:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Message-ID: <20140117143329.GA6877@kroah.com>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:46:56AM +0100, Marek Szyprowski wrote:
> GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
> flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
> atomic allocation, the code must test __GFP_WAIT flag presence.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  .../lustre/include/linux/libcfs/libcfs_private.h   |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> index d0d942c..dddccca1 100644
> --- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> +++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> @@ -120,7 +120,7 @@ do {						\
>  do {									    \
>  	LASSERT(!in_interrupt() ||					    \
>  		((size) <= LIBCFS_VMALLOC_SIZE &&			    \
> -		 ((mask) & GFP_ATOMIC)) != 0);			    \
> +		 ((mask) & __GFP_WAIT) == 0));				    \
>  } while (0)

What a horrible assert, can't we just remove this entirely?
in_interrupt() usually should never be checked, if so, the code is doing
something wrong.  And __GFP flags shouldn't be used on their own.

thanks,

greg k-h
