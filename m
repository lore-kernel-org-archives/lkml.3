Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3BUNl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:41:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3BUNl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:41:56 -0500
Date: Thu, 21 Feb 2013 14:41:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: use kmalloc for lzo de/compress buffer
Message-ID: <20130221134153.GD27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, hyojun.im@lge.com, chan.jeong@lge.com,
	raphael.andy.lee@gmail.com
References: <1361174164-7182-1-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361174164-7182-1-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 04:56:04PM +0900, Kyungsik Lee wrote:
> @@ -55,8 +55,9 @@ static struct list_head *lzo_alloc_workspace(void)
>  		return ERR_PTR(-ENOMEM);
>  
>  	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
> -	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
> -	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
> +	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
> +	workspace->cbuf = kmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE),

This is still larger than usual page size and allocator may issue a
warning, so if we want to use kmalloc (it's ~4.4k in size and likely to
be available, but not always due to possible page fragmentation), the
__GFP_NOWARN should be supplied and if the allocation fails fall back to
vmalloc.

david
