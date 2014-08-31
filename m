Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaHaUCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:02:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHaUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:02:42 -0400
Date: Sun, 31 Aug 2014 13:02:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish_audio.c: sparse warning of incorrect
 type
Message-ID: <20140831200241.GA26833@kroah.com>
References: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Alan Cox, as he pushed this driver upstream...

On Sun, Aug 31, 2014 at 09:46:22PM +0530, Sudip Mukherjee wrote:
> fixed sparse warning of incorrect type in argument 1 and incorrect type in argument 2
> it was directly dereferencing a __iomem pointer , which will work in x86 but will fail in other architectures.

Please wrap your changelog comments at 72 columns...

> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> hi,
> can you please reveiew the patch and check if the approach is correct. If it is correct then I can send another patch to correct the other similar warnings present in this file. 

I don't think this is correct, because:

> 
>  drivers/staging/goldfish/goldfish_audio.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
> index c89d0b8..f9a13e7 100644
> --- a/drivers/staging/goldfish/goldfish_audio.c
> +++ b/drivers/staging/goldfish/goldfish_audio.c
> @@ -118,6 +118,7 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
>  	struct goldfish_audio *data = fp->private_data;
>  	int length;
>  	int result = 0;
> +	void *buffer;
>  
>  	if (!data->read_supported)
>  		return -ENODEV;
> @@ -133,9 +134,15 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
>  						AUDIO_READ_BUFFER_AVAILABLE);
>  
>  		/* copy data to user space */
> -		if (copy_to_user(buf, data->read_buffer, length))
> +		buffer = kzalloc(length, GFP_KERNEL);
> +		if (buffer == NULL)
> +			return -ENOMEM;
> +		memcpy_fromio(buffer, data->read_buffer, length);
> +		if (copy_to_user((void __user *)buf, buffer, length)) {
> +			kfree(buffer);
>  			return -EFAULT;
> -
> +		}
> +		kfree(buffer);

The goldfish platform is an "emulator" so iomem is (or should be?) the
same as "normal" memory here.  So I think this is a false-positive.

But I could be totally wrong here, Alan?

thanks,

greg k-h
