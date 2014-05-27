Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaE0VQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:16:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaE0VQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:16:45 -0400
Date: Tue, 27 May 2014 14:20:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 1/3] mei: move from misc to char device
Message-ID: <20140527212019.GA26089@kroah.com>
References: <1399969321-6512-1-git-send-email-tomas.winkler@intel.com>
 <1399969321-6512-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399969321-6512-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:21:59AM +0300, Tomas Winkler wrote:
> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> We need to support more then one mei interface
> hence the simple misc devices is not longer an option.
> We use char device now with to not break application
> space we preserve /dev/mei for the first interface.
> 
> Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/main.c    | 98 +++++++++++++++++++++++++++++++++-------------
>  drivers/misc/mei/mei_dev.h |  7 ++++
>  drivers/misc/mei/pci-me.c  |  1 -
>  3 files changed, 78 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
> index 66f0a1a..c58e059 100644
> --- a/drivers/misc/mei/main.c
> +++ b/drivers/misc/mei/main.c
> @@ -32,7 +32,6 @@
>  #include <linux/compat.h>
>  #include <linux/jiffies.h>
>  #include <linux/interrupt.h>
> -#include <linux/miscdevice.h>
>  
>  #include <linux/mei.h>
>  
> @@ -49,19 +48,12 @@
>   */
>  static int mei_open(struct inode *inode, struct file *file)
>  {
> -	struct miscdevice *misc = file->private_data;
> -	struct pci_dev *pdev;
>  	struct mei_cl *cl;
>  	struct mei_device *dev;
>  
>  	int err;
>  
> -	if (!misc->parent)
> -		return -ENODEV;
> -
> -	pdev = container_of(misc->parent, struct pci_dev, dev);
> -
> -	dev = pci_get_drvdata(pdev);
> +	dev = container_of(inode->i_cdev, struct mei_device, cdev);
>  	if (!dev)
>  		return -ENODEV;
>  
> @@ -667,26 +659,48 @@ static const struct file_operations mei_fops = {
>  	.llseek = no_llseek
>  };
>  
> -/*
> - * Misc Device Struct
> - */
> -static struct miscdevice  mei_misc_device = {
> -		.name = "mei",
> -		.fops = &mei_fops,
> -		.minor = MISC_DYNAMIC_MINOR,
> -};
> -
> +static struct class *mei_class;
> +static dev_t mei_devt;
> +#define MAX_MEI_DEVS 5            /* Maximum number of mei devices */

Why have a max number at all?

>  
>  int mei_register(struct mei_device *dev)
>  {
> -	int ret;
> -	mei_misc_device.parent = &dev->pdev->dev;
> -	ret = misc_register(&mei_misc_device);
> -	if (ret)
> +
> +	int ret, devno;
> +	int id = 0; /* FIXME: retrieve interface version*/

You still are only allocating 1 mei device, so why do all of this work
at all?  Nothing changes, so why should I accept this patch?

greg k-h

