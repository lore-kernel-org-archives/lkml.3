Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaJITop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:44:45 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:58934 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751008AbaJITom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:44:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2729:2731:2828:2899:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:4225:4250:4321:4605:5007:6742:7558:7652:9010:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13161:13229:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lunch48_7fe11ff47c91a
X-Filterd-Recvd-Size: 3598
Message-ID: <1412883877.2975.26.camel@joe-AO725>
Subject: Re: [PATCH v7 1/4] mfd: add support for Diolan DLN-2 devices
From: Joe Perches <joe@perches.com>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Date: Thu, 09 Oct 2014 12:44:37 -0700
In-Reply-To: <1412882541-10934-2-git-send-email-octavian.purdila@intel.com>
References: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
	 <1412882541-10934-2-git-send-email-octavian.purdila@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 22:22 +0300, Octavian Purdila wrote:
> This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
> Master Adapter DLN-2. Details about the device can be found here:

trivia:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
[]
> +config MFD_DLN2
> +	tristate "Diolan DLN2 support"
> +	select MFD_CORE
> +	depends on USB
> +	help
> +	  This adds support for Diolan USB-I2C/SPI/GPIO Master Adapter DLN-2.
> +	  Additional drivers must be enabled in order to use the functionality
> +	  of the device.

additional drivers like...

> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
[]
+struct dln2_mod_rx_slots {
+       /* RX slots bitmap */
+       unsigned long bmap;

Probably better as:
	DECLARE_BITMAP(bmap, DLN2_MAX_RX_SLOTS);

Then a lot of &ptr->bmap uses can be ptr->bmap

> +struct dln2_dev {
> +	struct usb_device *usb_dev;
> +	struct usb_interface *interface;
> +	u8 ep_in;
> +	u8 ep_out;
> +
> +	struct urb *rx_urb[DLN2_MAX_URBS];
> +	void *rx_buf[DLN2_MAX_URBS];
> +
> +	struct dln2_mod_rx_slots mod_rx_slots[DLN2_HANDLES];
> +
> +	struct list_head event_cb_list;
> +	spinlock_t event_cb_lock;
> +
> +	bool disconnect;
> +	int active_transfers;
> +	wait_queue_head_t disconnect_wq;
> +	spinlock_t disconnect_lock;
> +};

Maybe reorder the bools and u8s to pack this a bit better?

> +int dln2_register_event_cb(struct platform_device *pdev, u16 id,
> +			   dln2_event_cb_t rx_cb)
> +{
> +	struct dln2_dev *dln2 = dev_get_drvdata(pdev->dev.parent);
> +	struct dln2_event_cb_entry *i, *new;

new isn't a very good name

> +static void dln2_run_event_callbacks(struct dln2_dev *dln2, u16 id, u16 echo,
> +				     void *data, int len)
> +{
> +	struct dln2_event_cb_entry *i;
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(i, &dln2->event_cb_list, list)
> +		if (i->id == id)
> +			i->callback(i->pdev, echo, data, len);

probably nicer with braces

> +static int dln2_setup_rx_urbs(struct dln2_dev *dln2,
> +			      struct usb_host_interface *hostif)
> +{
> +	int i;
> +	const int rx_max_size = DLN2_RX_BUF_SIZE;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++) {
> +		int ret;
> +		struct device *dev = &dln2->interface->dev;
> +
> +		dln2->rx_buf[i] = kmalloc(rx_max_size, GFP_KERNEL);
> +		if (!dln2->rx_buf[i])
> +			return -ENOMEM;

memory leaks on failure?


