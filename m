Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbaKAUgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:36:19 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41818 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209AbaKAUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:36:17 -0400
Date: Sat, 1 Nov 2014 13:38:16 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH] fix a leak in bch_cached_dev_run()
Message-ID: <20141101203816.GA22219@kmo-pixel>
References: <20141030054208.GE7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030054208.GE7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 05:42:09AM +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -878,8 +878,11 @@ void bch_cached_dev_run(struct cached_dev *dc)
>  	buf[SB_LABEL_SIZE] = '\0';
>  	env[2] = kasprintf(GFP_KERNEL, "CACHED_LABEL=%s", buf);
>  
> -	if (atomic_xchg(&dc->running, 1))
> +	if (atomic_xchg(&dc->running, 1)) {
> +		kfree(env[1]);
> +		kfree(env[2]);
>  		return;
> +	}
>  
>  	if (!d->c &&
>  	    BDEV_STATE(&dc->sb) != BDEV_STATE_NONE) {

Thanks, applied
