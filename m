Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbbAWXJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:09:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbAWXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:09:40 -0500
Date: Fri, 23 Jan 2015 15:09:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Crowe <mac@mcrowe.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: kmsg: lseek errors confuse glibc's dprintf
Message-Id: <20150123150939.f96d28a380fc5ec1f3894d3a@linux-foundation.org>
In-Reply-To: <20150115173132.GA7486@mcrowe.com>
References: <20150115173132.GA7486@mcrowe.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 17:31:32 +0000 Mike Crowe <mac@mcrowe.com> wrote:

> glibc's dprintf implementation does not work correctly with /dev/kmsg file
> descriptors because glibc treats receiving EBADF and EINVAL from lseek when
> trying to determine the current file position as errors. See
> https://sourceware.org/bugzilla/show_bug.cgi?id=17830
> 
> >From what I can tell prior to Kay Sievers printk record commit
> e11fea92e13fb91c50bacca799a6131c81929986, calling lseek(fd, 0, SEEK_CUR)
> with such a file descriptor would not return an error.
> 
> Prior to Kay's change, Arnd Bergmann's commit
> 6038f373a3dc1f1c26496e60b6c40b164716f07e seemed to go to some lengths to
> preserve the successful return code rather than returning (the perhaps more
> logical) -ESPIPE.
> 
> glibc is happy with either a successful return or -ESPIPE.
> 
> For maximum compatibility it seems that success should be returned but
> given Kay's new seek interface perhaps this isn't helpful.
> 
> This patch ensures that such a seek succeeds:
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 02d6b6d..b3ff6f0 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -693,7 +693,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
>  	loff_t ret = 0;
>  
>  	if (!user)
> -		return -EBADF;
> +		return (whence == SEEK_CUR) ? 0 : -EBADF;

What's actually going on here?  What is the significance of
file->private_data==NULL and why does this code treat it as an error?

>  	if (offset)
>  		return -ESPIPE;
>  
> @@ -718,6 +718,11 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
>  		user->idx = log_next_idx;
>  		user->seq = log_next_seq;
>  		break;
> +	case SEEK_CUR:
> +		/* For compatibility with userspace requesting the
> +		 * current file position. */
> +		ret = 0;
> +		break;

Can we actually do something useful here?  Return some value which can
be fed back into SEEK_SET to restore the file position?

>  	default:
>  		ret = -EINVAL;
>  	}

