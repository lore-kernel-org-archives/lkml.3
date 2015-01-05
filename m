Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbbAEN6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:58:47 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60386 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbAEN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:58:45 -0500
Date: Mon, 5 Jan 2015 13:58:27 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: xiaomin1 <xiaoming.wang@intel.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, Zhang Dongxing <dongxing.zhang@intel.com>
Subject: Re: [PATCH] move file->f_op->open out of mutex (misc_mtx) in
 misc_open
Message-ID: <20150105135827.31dd0201@lxorguk.ukuu.org.uk>
In-Reply-To: <1420504447-9670-1-git-send-email-xiaoming.wang@intel.com>
References: <1420504447-9670-1-git-send-email-xiaoming.wang@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Jan 2015 08:34:07 +0800
xiaomin1 <xiaoming.wang@intel.com> wrote:

> misc_mtx was used to mutex misc_list.
> But file->f_op->open may be blocked by downloading
> firmware in some devices' open.
> So move file->f_op->open out of mutex (misc_mtx)
> in misc_open to avoid this block.
> It also make code more efficiency.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> ---
>  drivers/char/misc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index ffa97d2..289c59e 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -144,7 +144,8 @@ static int misc_open(struct inode * inode, struct file * file)
>  	replace_fops(file, new_fops);
>  	if (file->f_op->open) {
>  		file->private_data = c;
> -		err = file->f_op->open(inode,file);
> +		mutex_unlock(&misc_mtx);
> +		return file->f_op->open(inode,file);
>  	}

This changes all the users of misc device open from singlethreaded to
multi-threaded. Having read through the users I can find this seems safe
and they all seem to have the right checks in place and to assume they
are multi-threaded.

Reviewed-by: Alan Cox <alan@linux.intel.com>
