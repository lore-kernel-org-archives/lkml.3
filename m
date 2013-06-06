Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3FFThz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:37:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3FFThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:37:53 -0400
Date: Thu, 6 Jun 2013 12:37:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: Fix null pointer dereference caused by
 sysfs_notify on binary attribute
Message-ID: <20130606193752.GA22115@kroah.com>
References: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:45:20AM +0100, Nick Dyer wrote:
> If sysfs_notify is called on a binary attribute, bad things can
> happen, so prevent it.
> 
> Note, no in-kernel usage of this is currently present, but in the
> future, it's good to be safe.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  fs/sysfs/file.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 602f56d..976819b 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -449,10 +449,12 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
>  
>  	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
>  
> -	od = sd->s_attr.open;
> -	if (od) {
> -		atomic_inc(&od->event);
> -		wake_up_interruptible(&od->poll);
> +	if (sd->s_attr) {
> +		od = sd->s_attr.open;
> +		if (od) {
> +			atomic_inc(&od->event);
> +			wake_up_interruptible(&od->poll);
> +		}

Please test build your patches, it makes kernel maintainers very grumpy
when you send them patches that are obviously broken :(

greg k-h
