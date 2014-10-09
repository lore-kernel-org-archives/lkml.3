Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaJIU1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:27:16 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49335 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <1412883877.2975.26.camel@joe-AO725>
References: <1412882541-10934-1-git-send-email-octavian.purdila@intel.com>
	<1412882541-10934-2-git-send-email-octavian.purdila@intel.com>
	<1412883877.2975.26.camel@joe-AO725>
Date: Thu, 9 Oct 2014 23:27:12 +0300
Message-ID: <CAE1zotJTQATJkTQinnWOg=NJbG+SWzNNdgB2uVEJgubnhtyXbA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Johan Hovold <johan@kernel.org>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 10:44 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-10-09 at 22:22 +0300, Octavian Purdila wrote:
>> This patch implements the USB part of the Diolan USB-I2C/SPI/GPIO
>> Master Adapter DLN-2. Details about the device can be found here:
>
> trivia:
>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> []
>> +config MFD_DLN2
>> +     tristate "Diolan DLN2 support"
>> +     select MFD_CORE
>> +     depends on USB
>> +     help
>> +       This adds support for Diolan USB-I2C/SPI/GPIO Master Adapter DLN-2.
>> +       Additional drivers must be enabled in order to use the functionality
>> +       of the device.
>
> additional drivers like...
>

I will rephrase.

>> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> []
> +struct dln2_mod_rx_slots {
> +       /* RX slots bitmap */
> +       unsigned long bmap;
>
> Probably better as:
>         DECLARE_BITMAP(bmap, DLN2_MAX_RX_SLOTS);
>
> Then a lot of &ptr->bmap uses can be ptr->bmap
>

Originally I was using DECLARE_BITMAP, but during the review process
Johan suggested to use unsigned long. Now that I think about it, it
sounds better to use DECLARE_BITMAP and of couse keep using
find_first_bit, set_bit, etc. Johan do you see any issue with that?

>> +struct dln2_dev {
>> +     struct usb_device *usb_dev;
>> +     struct usb_interface *interface;
>> +     u8 ep_in;
>> +     u8 ep_out;
>> +
>> +     struct urb *rx_urb[DLN2_MAX_URBS];
>> +     void *rx_buf[DLN2_MAX_URBS];
>> +
>> +     struct dln2_mod_rx_slots mod_rx_slots[DLN2_HANDLES];
>> +
>> +     struct list_head event_cb_list;
>> +     spinlock_t event_cb_lock;
>> +
>> +     bool disconnect;
>> +     int active_transfers;
>> +     wait_queue_head_t disconnect_wq;
>> +     spinlock_t disconnect_lock;
>> +};
>
> Maybe reorder the bools and u8s to pack this a bit better?
>

I prefer to keep it this way, it's not wasting a lot since you will
only have a handful of these devices, and it keeps the related data
together.

>> +int dln2_register_event_cb(struct platform_device *pdev, u16 id,
>> +                        dln2_event_cb_t rx_cb)
>> +{
>> +     struct dln2_dev *dln2 = dev_get_drvdata(pdev->dev.parent);
>> +     struct dln2_event_cb_entry *i, *new;
>
> new isn't a very good name
>

Yes, new_cb should be better.

>> +static void dln2_run_event_callbacks(struct dln2_dev *dln2, u16 id, u16 echo,
>> +                                  void *data, int len)
>> +{
>> +     struct dln2_event_cb_entry *i;
>> +
>> +     rcu_read_lock();
>> +
>> +     list_for_each_entry_rcu(i, &dln2->event_cb_list, list)
>> +             if (i->id == id)
>> +                     i->callback(i->pdev, echo, data, len);
>
> probably nicer with braces
>
>> +static int dln2_setup_rx_urbs(struct dln2_dev *dln2,
>> +                           struct usb_host_interface *hostif)
>> +{
>> +     int i;
>> +     const int rx_max_size = DLN2_RX_BUF_SIZE;
>> +
>> +     for (i = 0; i < DLN2_MAX_URBS; i++) {
>> +             int ret;
>> +             struct device *dev = &dln2->interface->dev;
>> +
>> +             dln2->rx_buf[i] = kmalloc(rx_max_size, GFP_KERNEL);
>> +             if (!dln2->rx_buf[i])
>> +                     return -ENOMEM;
>
> memory leaks on failure?
>

No, dln2_free_rx_urbs will do the cleanup (even in case of failures above).

Thanks for the review Joe.
