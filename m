Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaCZOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:36:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaCZOgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:36:47 -0400
Message-ID: <1395844604.483.12.camel@linux-fkkt.site>
Subject: Re: [PATCH v5 1/3] mfd: Add realtek USB card reader driver
From: Oliver Neukum <oneukum@suse.de>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Wed, 26 Mar 2014 15:36:44 +0100
In-Reply-To: <1395744293-24398-2-git-send-email-rogerable@realtek.com>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
	 <1395744293-24398-2-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 18:44 +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>

> +static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
> +		unsigned int pipe, struct scatterlist *sg, int num_sg,
> +		unsigned int length, unsigned int *act_len, int timeout)
> +{
> +	int ret;
> +
> +	dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
> +			__func__, length, num_sg);
> +	ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
> +			sg, num_sg, length, GFP_NOIO);
> +	if (ret)
> +		return ret;
> +
> +	ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
> +	add_timer(&ucr->sg_timer);
> +	usb_sg_wait(&ucr->current_sg);
> +	del_timer(&ucr->sg_timer);
> +

A slight race. You cannot rule out that the timer handler is still
running when you call this the next time. You'd better use
del_timer_sync()

> +static int rtsx_usb_probe(struct usb_interface *intf,
> +			 const struct usb_device_id *id)
> +{
> +	struct usb_device *usb_dev = interface_to_usbdev(intf);
> +	struct rtsx_ucr *ucr;
> +	int ret;
> +
> +	dev_dbg(&intf->dev,
> +		": Realtek USB Card Reader found at bus %03d address %03d\n",
> +		 usb_dev->bus->busnum, usb_dev->devnum);
> +
> +	ucr = devm_kzalloc(&intf->dev, sizeof(*ucr), GFP_KERNEL);
> +	if (!ucr)
> +		return -ENOMEM;
> +
> +	ucr->pusb_dev = usb_dev;
> +
> +	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
> +			GFP_KERNEL, &ucr->iobuf_dma);
> +	if (!ucr->iobuf)
> +		return -ENOMEM;
> +
> +	usb_set_intfdata(intf, ucr);
> +
> +	ucr->vendor_id = id->idVendor;
> +	ucr->product_id = id->idProduct;
> +	ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
> +
> +	mutex_init(&ucr->dev_mutex);
> +
> +	ucr->pusb_intf = intf;
> +
> +	/* initialize */
> +	ret = rtsx_usb_init_chip(ucr);
> +	if (ret)
> +		goto out_init_fail;
> +
> +	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
> +			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);

Race condition. What prevents the mfd layer from using this device
before you've finished the next steps of the initialisation?

> +	if (ret)
> +		goto out_init_fail;
> +
> +	/* initialize USB SG transfer timer */
> +	init_timer(&ucr->sg_timer);
> +	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
> +#ifdef CONFIG_PM
> +	intf->needs_remote_wakeup = 1;

Why?
> +	usb_enable_autosuspend(usb_dev);
> +#endif
> +
> +	return 0;
> +
> +out_init_fail:
> +	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
> +			ucr->iobuf_dma);
> +	return ret;
> +}
> +
> +static void rtsx_usb_disconnect(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	dev_dbg(&intf->dev, "%s called\n", __func__);
> +
> +	mfd_remove_devices(&intf->dev);
> +
> +	usb_set_intfdata(ucr->pusb_intf, NULL);
> +	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
> +			ucr->iobuf_dma);
> +}
> +
> +#ifdef CONFIG_PM
> +static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct rtsx_ucr *ucr =
> +		(struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
> +			__func__, message.event);
> +
> +	mutex_lock(&ucr->dev_mutex);
> +	rtsx_usb_turn_off_led(ucr);

When is this turned on again?

> +	mutex_unlock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static int rtsx_usb_resume(struct usb_interface *intf)
> +{
> +	return 0;
> +}
> +
> +static int rtsx_usb_reset_resume(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr =
> +		(struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	rtsx_usb_reset_chip(ucr);
> +	return 0;
> +}
> +
> +#else /* CONFIG_PM */
> +
> +#define rtsx_usb_suspend NULL
> +#define rtsx_usb_resume NULL
> +#define rtsx_usb_reset_resume NULL
> +
> +#endif /* CONFIG_PM */
> +
> +
> +static int rtsx_usb_pre_reset(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	mutex_lock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static int rtsx_usb_post_reset(struct usb_interface *intf)
> +{
> +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
> +
> +	mutex_unlock(&ucr->dev_mutex);
> +	return 0;
> +}
> +
> +static struct usb_device_id rtsx_usb_usb_ids[] = {
> +	{ USB_DEVICE(0x0BDA, 0x0129) },
> +	{ USB_DEVICE(0x0BDA, 0x0139) },
> +	{ USB_DEVICE(0x0BDA, 0x0140) },
> +	{ }
> +};
> +
> +static struct usb_driver rtsx_usb_driver = {
> +	.name			= "rtsx_usb",
> +	.probe			= rtsx_usb_probe,
> +	.disconnect		= rtsx_usb_disconnect,
> +	.suspend		= rtsx_usb_suspend,
> +	.resume			= rtsx_usb_resume,
> +	.reset_resume		= rtsx_usb_reset_resume,
> +	.pre_reset		= rtsx_usb_pre_reset,
> +	.post_reset		= rtsx_usb_post_reset,
> +	.id_table		= rtsx_usb_usb_ids,
> +	.supports_autosuspend	= 1,
> +	.soft_unbind		= 1,
> +};
> +

	Regards
		Oliver


