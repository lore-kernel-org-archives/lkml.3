Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbbAIXC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:02:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbbAIXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:02:55 -0500
Date: Fri, 9 Jan 2015 15:02:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, samu.p.onkalo@nokia.com
Subject: Re: [PATCH] misc: pass miscdevice through file's private_data
Message-ID: <20150109230254.GA3528@kroah.com>
References: <20141204232951.GA13690@kroah.com>
 <1417754274-29769-1-git-send-email-tomvanbraeckel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417754274-29769-1-git-send-email-tomvanbraeckel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 05:37:54AM +0100, Tom Van Braeckel wrote:
> Make the miscdevice accessible through the file's private_data.
> 
> Previously, this was done only when an open() operation had been registered.
> But it's also useful in other file operations so we pass it on unconditionally.
> 
> All drivers that use private_data and misc_register() were checked to ensure
> they register an open() operation in order to verify that this improvement
> does not break any existing driver that uses the misc subsystem.
> 
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
> ---
>  drivers/char/misc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index ffa97d2..d6445de 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -140,12 +140,17 @@ static int misc_open(struct inode * inode, struct file * file)
>  			goto fail;
>  	}
>  
> +	/*
> +	 * Place the miscdevice in the file's
> +	 * private_data so it can be used by the
> +	 * file operations, including f_op->open below
> +	 */
> +	file->private_data = c;
> +
>  	err = 0;
>  	replace_fops(file, new_fops);
> -	if (file->f_op->open) {
> -		file->private_data = c;
> +	if (file->f_op->open)
>  		err = file->f_op->open(inode,file);
> -	}
>  fail:
>  	mutex_unlock(&misc_mtx);
>  	return err;
> -- 
> 1.9.1

Wait, didn't this break FUSE?  Or was that some other variant of this
patch?

confused,

greg k-h
