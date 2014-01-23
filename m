Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaAWOhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:37:42 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37273 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaAWOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <1390411440-1158-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1390411440-1158-1-git-send-email-benjamin.tissoires@redhat.com>
	<1390411440-1158-2-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 23 Jan 2014 15:37:40 +0100
Message-ID: <CANq1E4R9xaSvCuLwGVxQ8-j5Bed8mJLYzQc-88rWuzepmNfHXA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] input/uinput: add UI_GET_SYSNAME ioctl to retrieve
 the sysfs path
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin

On Wed, Jan 22, 2014 at 6:24 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> uinput is used in the xorg-integration-tests suite and in the wayland
> test suite. These automated tests suites create many virtual input
> devices and then hook something to read these newly created devices.
>
> Currently, uinput does not provide the created input device, which means
> that we rely on an heuristic to guess which input node was created.
> The problem is that is heuristic is subjected to races between different
> uinput devices or even with physical devices. Having a way to retrieve
> the sysfs path allows us to find without any doubts the event node.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> Hi guys,
>
> a new version of this patch with a brand new commit message.
> Happy reviewing :)
>
> changes since v3:
> - new commit message (I hope it will be better now)
> - removed the -EAGAIN stuff thanks to the previous patch (not in v3)
> - used "put_user(0, (char *)dest + len - 1);" instead of "copy_to_user(dest + len - 1, "\0", 1);"
> - check if maxlen == 0
>
> changes since v2:
> - the ioctl returns only the device name, thus I renamed the ioctl to UI_GET_SYSNAME
> - reordered uinput_str_to_user() arguments
> - be sure to terminate the user string we send by \0
> - abort if udev->state is not UIST_CREATED
> - dropped the patch 1/2 (adding resolution to uinput) because I think David has
>   already it in one of his queues (ABS2 IIRC)
>
> The corresponding libevdev patch is still here:
> http://lists.freedesktop.org/archives/input-tools/2014-January/000757.html
>
> Cheers,
> Benjamin
>
>  drivers/input/misc/uinput.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/uinput.h      |  2 ++
>  include/uapi/linux/uinput.h | 13 ++++++++++++-
>  3 files changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
> index d8ae08d..b51269f 100644
> --- a/drivers/input/misc/uinput.c
> +++ b/drivers/input/misc/uinput.c
> @@ -20,6 +20,8 @@
>   * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
>   *
>   * Changes/Revisions:
> + *     0.4     01/09/2014 (Benjamin Tissoires <benjamin.tissoires@redhat.com>)
> + *             - add UI_GET_SYSNAME ioctl
>   *     0.3     09/04/2006 (Anssi Hannula <anssi.hannula@gmail.com>)
>   *             - updated ff support for the changes in kernel interface
>   *             - added MODULE_VERSION
> @@ -670,6 +672,30 @@ static int uinput_ff_upload_from_user(const char __user *buffer,
>         __ret;                                          \
>  })
>
> +static int uinput_str_to_user(void __user *dest, const char *str,
> +                             unsigned int maxlen)
> +{
> +       int len, ret;
> +
> +       if (!str)
> +               return -ENOENT;
> +
> +       if (maxlen == 0)
> +               return -EINVAL;
> +
> +       len = strlen(str) + 1;
> +       if (len > maxlen)
> +               len = maxlen;
> +
> +       ret = copy_to_user(dest, str, len);

Technically you could use "len - 1" here, but it's fine.

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> +       if (ret)
> +               return -EFAULT;
> +
> +       /* force terminating '\0' */
> +       ret = put_user(0, (char *)dest + len - 1);
> +       return ret ? -EFAULT : len;
> +}
> +
>  static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>                                  unsigned long arg, void __user *p)
>  {
> @@ -679,6 +705,8 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>         struct uinput_ff_erase  ff_erase;
>         struct uinput_request   *req;
>         char                    *phys;
> +       const char              *name;
> +       unsigned int            size;
>
>         retval = mutex_lock_interruptible(&udev->mutex);
>         if (retval)
> @@ -831,6 +859,20 @@ static long uinput_ioctl_handler(struct file *file, unsigned int cmd,
>                         goto out;
>         }
>
> +       size = _IOC_SIZE(cmd);
> +
> +       /* Now check variable-length commands */
> +       switch (cmd & ~IOCSIZE_MASK) {
> +       case UI_GET_SYSNAME(0):
> +               if (udev->state != UIST_CREATED) {
> +                       retval = -ENOENT;
> +                       goto out;
> +               }
> +               name = dev_name(&udev->dev->dev);
> +               retval = uinput_str_to_user(p, name, size);
> +               goto out;
> +       }
> +
>         retval = -EINVAL;
>   out:
>         mutex_unlock(&udev->mutex);
> diff --git a/include/linux/uinput.h b/include/linux/uinput.h
> index 0a4487d..0994c0d 100644
> --- a/include/linux/uinput.h
> +++ b/include/linux/uinput.h
> @@ -20,6 +20,8 @@
>   * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
>   *
>   * Changes/Revisions:
> + *     0.4     01/09/2014 (Benjamin Tissoires <benjamin.tissoires@redhat.com>)
> + *             - add UI_GET_SYSNAME ioctl
>   *     0.3     24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>   *             - update ff support for the changes in kernel interface
>   *             - add UINPUT_VERSION
> diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
> index fe46431..0389b48 100644
> --- a/include/uapi/linux/uinput.h
> +++ b/include/uapi/linux/uinput.h
> @@ -20,6 +20,8 @@
>   * Author: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
>   *
>   * Changes/Revisions:
> + *     0.4     01/09/2014 (Benjamin Tissoires <benjamin.tissoires@redhat.com>)
> + *             - add UI_GET_SYSNAME ioctl
>   *     0.3     24/05/2006 (Anssi Hannula <anssi.hannulagmail.com>)
>   *             - update ff support for the changes in kernel interface
>   *             - add UINPUT_VERSION
> @@ -35,7 +37,7 @@
>  #include <linux/types.h>
>  #include <linux/input.h>
>
> -#define UINPUT_VERSION         3
> +#define UINPUT_VERSION         4
>
>
>  struct uinput_ff_upload {
> @@ -73,6 +75,15 @@ struct uinput_ff_erase {
>  #define UI_BEGIN_FF_ERASE      _IOWR(UINPUT_IOCTL_BASE, 202, struct uinput_ff_erase)
>  #define UI_END_FF_ERASE                _IOW(UINPUT_IOCTL_BASE, 203, struct uinput_ff_erase)
>
> +/**
> + * UI_GET_SYSNAME - get the sysfs name of the created uinput device
> + *
> + * @return the sysfs name of the created virtual input device.
> + * The complete sysfs path is then /sys/devices/virtual/input/--NAME--
> + * Usually, it is in the form "inputN"
> + */
> +#define UI_GET_SYSNAME(len)    _IOC(_IOC_READ, UINPUT_IOCTL_BASE, 300, len)
> +
>  /*
>   * To write a force-feedback-capable driver, the upload_effect
>   * and erase_effect callbacks in input_dev must be implemented.
> --
> 1.8.4.2
>
