Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3GLM4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:56:39 -0400
Received: from pequod.mess.org ([46.65.169.142]:37189 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964794Ab3GLM4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:56:38 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2013 08:56:37 EDT
Date: Fri, 12 Jul 2013 13:46:27 +0100
From: Sean Young <sean@mess.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-media@vger.kernel.org, alipowski@interia.pl,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com
Subject: Re: [PATCH RFC] media: lirc: Allow lirc dev to talk to rc device
Message-ID: <20130712124627.GA18177@pequod.mess.org>
References: <1373619328-14376-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373619328-14376-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 09:55:28AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> The use case is simple, if any rc device has allowed protocols =
> RC_TYPE_LIRC and map_name = RC_MAP_LIRC set, the driver open will be never
> called. The reason for this is, all of the key maps except lirc have some
> KEYS in there map, so during rc_register_device process these keys are
> matched against the input drivers and open is performed, so for the case
> of RC_MAP_EMPTY, a tty/vt/keyboard is matched and the driver open is
> performed.
> 
> In case of lirc, there is no match and result is that there is no open
> performed, however the lirc-dev will go ahead and create a /dev/lirc0
> node. Now when lircd/mode2 opens this device, no data is available
> because the driver was never opened.

The rc device gets opened via the input interface. If the input device is
never opened (e.g. embedded with no console) then the rc open is never 
called and lirc will not work either. So that's another case.

> lirc_dev seems to have no link with actual rc device w.r.t open/close.
> This patch adds the missing link rc_dev pointer to lirc_driver structure
> for cases like this, so that it can do the open/close of the real driver
> in accordance to lircd/mode2 open/close.
> 
> Without this patch its impossible to open a rc device which has
> RC_TYPE_LIRC ad RC_MAP_LIRC set.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>  drivers/media/rc/ir-lirc-codec.c |    1 +
>  drivers/media/rc/lirc_dev.c      |   14 ++++++++++++++
>  include/media/lirc_dev.h         |    1 +
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index e456126..d5ad27f 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -375,6 +375,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	drv->code_length = sizeof(struct ir_raw_event) * 8;
>  	drv->fops = &lirc_fops;
>  	drv->dev = &dev->dev;
> +	drv->rc_dev = dev;
>  	drv->owner = THIS_MODULE;
>  
>  	drv->minor = lirc_register_driver(drv);
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 8dc057b..485bf7d 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -35,6 +35,7 @@
>  #include <linux/device.h>
>  #include <linux/cdev.h>
>  
> +#include <media/rc-core.h>
>  #include <media/lirc.h>
>  #include <media/lirc_dev.h>
>  
> @@ -437,6 +438,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
>  int lirc_dev_fop_open(struct inode *inode, struct file *file)
>  {
>  	struct irctl *ir;
> +	struct rc_dev *rc_dev;
>  	struct cdev *cdev;
>  	int retval = 0;
>  
> @@ -467,6 +469,13 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
>  		goto error;
>  	}
>  
> +	rc_dev = ir->d.rc_dev;
> +	if (rc_dev && rc_dev->open) {
> +		retval = rc_dev->open(rc_dev);
> +		if (retval)
> +			goto error;
> +	}
> +

Now the rc device can have its open called twice; once via the input 
system and then (while it is already opened) via lirc. The rc drivers do
not expect this.

>  	cdev = ir->cdev;
>  	if (try_module_get(cdev->owner)) {
>  		ir->open++;
> @@ -499,6 +508,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
>  {
>  	struct irctl *ir = irctls[iminor(inode)];
>  	struct cdev *cdev;
> +	struct rc_dev *rc_dev;
>  
>  	if (!ir) {
>  		printk(KERN_ERR "%s: called with invalid irctl\n", __func__);
> @@ -511,6 +521,10 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
>  
>  	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
>  
> +	rc_dev = ir->d.rc_dev;
> +	if (rc_dev && rc_dev->close)
> +		rc_dev->close(rc_dev);
> +

iguanair, nuvoton and ene_ir will disable the ir receiver when their close
function is called. If the device was also opened via the input interface,
the input interface will receive no new ir activity.

I think there should be some sort of (atomic) use counter so that the 
rc device open or close only gets called once, whether opened via the 
input interface or via lirc. 

>  	ir->open--;
>  	if (ir->attached) {
>  		ir->d.set_use_dec(ir->d.data);
> diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
> index 168dd0b..96dccb6 100644
> --- a/include/media/lirc_dev.h
> +++ b/include/media/lirc_dev.h
> @@ -139,6 +139,7 @@ struct lirc_driver {
>  	struct lirc_buffer *rbuf;
>  	int (*set_use_inc) (void *data);
>  	void (*set_use_dec) (void *data);
> +	struct rc_dev *rc_dev;
>  	const struct file_operations *fops;
>  	struct device *dev;
>  	struct module *owner;
> -- 
> 1.7.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
