Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3GWBfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:35:24 -0400
Received: from leo.clearchain.com ([199.73.29.74]:48323 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3GWBfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:35:23 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 21:35:22 EDT
Date: Tue, 23 Jul 2013 11:15:46 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] input/uinput: add UI_GET_SYSPATH ioctl to
 retrieve the sysfs path
Message-ID: <20130723011546.GB9302@yabbi.HOME>
References: <1373895429-8846-1-git-send-email-benjamin.tissoires@redhat.com>
 <1373895429-8846-2-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373895429-8846-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Tue, 23 Jul 2013 10:45:40 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:37:09PM +0200, Benjamin Tissoires wrote:
> Evemu [1] uses uinput to replay devices traces it has recorded. However,
> the way evemu uses uinput is slightly different from how uinput is
> supposed to be used.
> Evemu creates the device node through uinput, bu inject events through
> the input device node directly (and skipping the uinput node).
> 
> Currently, evemu relies on an heuristic to guess which input node was
> created. The problem is that is heuristic is subjected to races between
> different uinput devices or even with physical devices. Having a way
> to retrieve the sysfs path allows us to find the event node without
> having to rely on this heuristic.
> 
> [1] http://www.freedesktop.org/wiki/Evemu/
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Tested-by: Peter Hutterer <peter.hutterer@who-t.net>

I'd really appreciate a comment above the ioctl define stating what the
ioctl actually returns. only comment regarding the code:

> +static int uinput_str_to_user(const char *str, unsigned int maxlen,
> +			      void __user *p)

I'd do this with a signature of the type (dest, src, len).

Cheers,
   Peter

> ---
>  drivers/input/misc/uinput.c | 37 ++++++++++++++++++++++++++++++++++++-
>  include/linux/uinput.h      |  1 +
>  include/uapi/linux/uinput.h |  3 +++
>  3 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index 7d518b4..49a9f7d 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -22,6 +22,7 @@
>   * Changes/Revisions:
>   *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>   *		- update uinput_user_dev struct to allow abs resolution
> + *		- add UI_GET_SYSPATH ioctl
>   *	0.3	09/04/2006 (Anssi Hannula <anssi.hannula@gmail.com>)
>   *		- updated ff support for the changes in kernel interface
>   *		- added MODULE_VERSION
> @@ -667,6 +668,21 @@ static int uinput_ff_upload_from_user(const char __user *buffer,
>  	__ret;						\
>  })
>  
> +static int uinput_str_to_user(const char *str, unsigned int maxlen,
> +			      void __user *p)
> +{
> +	int len;
> +
> +	if (!str)
> +		return -ENOENT;
> +
> +	len = strlen(str) + 1;
> +	if (len > maxlen)
> +		len = maxlen;
> +
> +	return copy_to_user(p, str, len) ? -EFAULT : len;
> +}
> +
>  static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>  				 unsigned long arg, void __user *p)
>  {
> @@ -676,6 +692,8 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>  	struct uinput_ff_erase  ff_erase;
>  	struct uinput_request   *req;
>  	char			*phys;
> +	const char		*path;
> +	unsigned int		size;
>  
>  	retval = mutex_lock_interruptible(&udev->mutex);
>  	if (retval)
> @@ -828,7 +846,24 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>  			break;
>  
>  		default:
> -			retval = -EINVAL;
> +			retval = -EAGAIN;
> +	}
> +
> +	if (retval == -EAGAIN) {
> +		size = _IOC_SIZE(cmd);
> +
> +		/* Now check variable-length commands */
> +		switch (cmd & ~IOCSIZE_MASK) {
> +			case UI_GET_SYSPATH(0):
> +				path = kobject_get_path(&udev->dev->dev.kobj,
> +							GFP_KERNEL);
> +				retval = uinput_str_to_user(path, size, p);
> +				kfree(path);
> +				break;
> +
> +			default:
> +				retval = -EINVAL;
> +		}
>  	}
>  
>   out:
> diff --git a/include/linux/uinput.h b/include/linux/uinput.h
> index 6291a22..64fab81 100644
> --- a/include/linux/uinput.h
> +++ b/include/linux/uinput.h
> @@ -22,6 +22,7 @@
>   * Changes/Revisions:
>   *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>   *		- update uinput_user_dev struct to allow abs resolution
> + *		- add UI_GET_SYSPATH ioctl
>   *	0.3	24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>   *		- update ff support for the changes in kernel interface
>   *		- add UINPUT_VERSION
> diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
> index f6a393b..d826409 100644
> --- a/include/uapi/linux/uinput.h
> +++ b/include/uapi/linux/uinput.h
> @@ -22,6 +22,7 @@
>   * Changes/Revisions:
>   *	0.4	12/07/2013 (Peter Hutterer <peter.hutterer@redhat.com>)
>   *		- update uinput_user_dev struct to allow abs resolution
> + *		- add UI_GET_SYSPATH ioctl
>   *	0.3	24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>   *		- update ff support for the changes in kernel interface
>   *		- add UINPUT_VERSION
> @@ -75,6 +76,8 @@ struct uinput_ff_erase {
>  #define UI_BEGIN_FF_ERASE	_IOWR(UINPUT_IOCTL_BASE, 202, struct uinput_ff_erase)
>  #define UI_END_FF_ERASE		_IOW(UINPUT_IOCTL_BASE, 203, struct uinput_ff_erase)
>  
> +#define UI_GET_SYSPATH(len)	_IOC(_IOC_READ, UINPUT_IOCTL_BASE, 300, len)
> +
>  /*
>   * To write a force-feedback-capable driver, the upload_effect
>   * and erase_effect callbacks in input_dev must be implemented.
> -- 
> 1.8.3.1
> 
