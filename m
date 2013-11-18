Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3KRKkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:40:53 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:37344 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab3KRKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:40:48 -0500
Message-ID: <5289EEA9.1000202@mev.co.uk>
Date: Mon, 18 Nov 2013 10:40:41 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Conrad Gomes <conrad.s.j.gomes@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "joe@perches.com" <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: fix coding style issues in unioxx5.c
References: <1383309116-8042-1-git-send-email-conrad.s.j.gomes@gmail.com>	<20131112001540.GA26611@kroah.com> <CALxff2GmatgMQF_2yQ9g=tZzh=J-5fKt89sFAU4oYq_FBJHNag@mail.gmail.com>
In-Reply-To: <CALxff2GmatgMQF_2yQ9g=tZzh=J-5fKt89sFAU4oYq_FBJHNag@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-11-17 03:42, Conrad Gomes wrote:
> Hi,
>
> No problem, I'll break this up and resend it.
>
> In order to use dev_info type functions I was planning on assigning the
> comedi device's struct device to the struct subdevice's class_dev as
> follows in comedi_alloc_subdevices as it appears that is is not used(I
> could be wrong):
>
> diff --git a/drivers/staging/comedi/drivers.c
> b/drivers/staging/comedi/drivers.c
> index 8f02bf6..e4c44ae 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -90,6 +90,7 @@ int comedi_alloc_subdevices(struct comedi_device *dev,
> int num_subdevices)
>                  s->async_dma_dir = DMA_NONE;
>                  spin_lock_init(&s->spin_lock);
>                  s->minor = -1;
> +               s->class_dev = dev->class_dev;
>          }
>          return 0;
>   }

The class_dev member is assigned by comedi_alloc_subdevice_minor(s) 
(which will be called if the subdevice supports asynchronous comedi 
commands) and is kept around for the call to comedi_free_subdevice_minor(s).

The struct comedi_subdevice has a pointer back to the struct 
comedi_device.  The class_dev member in the struct comedi_device can be 
used as the device pointer parameter of dev_info() etc.

> And adding a reference to the subdevice in the private  data structure
> unioxx5_subd_priv in order to substitute pr_info with dev_info. If this
> is fine I'll remove all references of pr_info in the file:
>
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c
> b/drivers/staging/comedi/drivers/unioxx5.c
> index 2b1ece8..bb8f5a4 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -72,6 +72,7 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>
>   /* 'private' structure for each subdevice */
>   struct unioxx5_subd_priv {
> +       struct comedi_subdevice *subdevice;
>          int usp_iobase;
>          /* 12 modules. each can be 70L or 73L */
>          unsigned char usp_module_type[12];
> @@ -94,9 +95,10 @@ static int __unioxx5_define_chan_offset(int chan_num)
>   static void __unioxx5_digital_config(struct unioxx5_subd_priv *usp,
> int mode)
>   {
>          int i, mask;
> +       struct device *dev = usp->subdevice->class_dev;
>
>          mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
> -       printk("COMEDI: mode = %d\n", mask);
> +       dev_info(dev, "COMEDI: mode = %d\n", mask);
>
>          outb(1, usp->usp_iobase + 0);

It would be better to change those functions to pass the pointer to the 
struct comedi_subdevice instead of the pointer to the struct 
unioxx5_subd_priv.

A variable or parameter named 'dev' in the comedi drivers is usually of 
type struct comedi_device for consistency.

The message passed to dev_info() wouldn't need the "COMEDI:" prefix - 
it's redundant.

Also, this particular message should be a dev_dbg() at best, and 
probably better not to have it at all!

For the sake of example, the above function could start as follows:

static void __unioxx5_digital_config(struct comedi_subdevice *s, int mode)
{
	struct unioxx5_subd_priv *usp = s->private;
	struct device *csdev = s->device->class_dev;
	int i, mask;

	mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
	dev_dbg(csdev, "mode = %d\n", mask);

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
