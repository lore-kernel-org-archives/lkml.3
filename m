Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbaDBHiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:38:52 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:63984 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbaDBHis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140217092155.GB17875@lee--X1>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
	<20140217092155.GB17875@lee--X1>
Date: Wed, 2 Apr 2014 09:38:47 +0200
Message-ID: <CACRpkdZ5YQoV3zxXiF5H-nxf-Kz_YiETvLsbJ9pkT=ueZ=VJSQ@mail.gmail.com>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:21 AM, Lee Jones <lee.jones@linaro.org> wrote:

>> +#include <linux/module.h>
>
> Does it matter that you're using:
>
>   module_platform_driver();
>
> ... yet you can't build this as a module?

I think it's a conceptual thing. Module means two things (IIUC):
(a) it is a run-time loadable module
(b) it's a piece of compartmentalized code

In this case the macro refers to (b). module_platform_driver()
resolves to module_driver() from <linux/device.h>
and it's clearly a core part of the device core and available
no matter whether the file is used as module at runtime or not.
It just simplifies the initcalls and that's no different depending
on whether the code is compiled-in or used as module.

>> +     case MSG_KEYBOARD:
>> +             if (micro->key != NULL)
>
> !micro->key

I guess you mean if (micro->key) {} rather than the !invert,
but I get it, changed everywhere we check for != NULL like this.

>> +                     micro->key(micro->key_data, len, data);
>> +             else
>> +                     dev_dbg(micro->dev, "ipaq micro : key message ignored, "
>> +                             "no handle \n");
>
> Log print spread over two lines. Doesn't Checkpatch complain about
> this?

Rather the other way around but you're right, it's better if
we keep it on one line so changed messages to a single oneliner
everywhere.

>> +static void micro_tx_chars(struct ipaq_micro *micro)
>> +{
>> +     struct ipaq_micro_txdev *tx = &micro->tx;
>> +     u32 val;
>> +
>> +     while ((tx->index < tx->len) &&
>> +            (readl(micro->base + UTSR1) & UTSR1_TNF)) {
>> +             writel(tx->buf[tx->index], micro->base + UTDR);
>
> This is pretty messy. Better broken out? Your call.

The best I can think of is converting to a for-loop but that
is just as hard to read I think :-/

Breaking out the readl() invitably result in two lines of code
like reading the flag before entering the while and once inside
the loop which is nastier IMO.

>> +static struct mfd_cell micro_cells[] = {
>> +     {
>> +             .name = "ipaq-micro-backlight",
>> +     },
>> +     {
>> +             .name = "ipaq-micro-battery",
>> +     },
>> +     {
>> +             .name = "ipaq-micro-keys",
>> +     },
>> +     {
>> +             .name = "ipaq-micro-ts",
>> +     },
>> +     {
>> +             .name = "ipaq-micro-leds",
>> +     },
>> +};
>
> Is Device Tree ever going to be supported on the iPAC?

No clue.

> If not, I think
> it's okay for you to make these single line entries.

OK doing that for now.

>> +static int micro_suspend(struct device *dev)
>> +{
>> +     return 0;
>> +}
>
> Doesn't the PM framework check for NULL .suspend?

No it's just like:

#ifdef CONFIG_SUSPEND
        case PM_EVENT_SUSPEND:
                return ops->suspend;
        case PM_EVENT_RESUME:
                return ops->resume;
#endif /* CONFIG_SUSPEND */

(drivers/power/main.c)

>> +module_platform_driver(micro_device_driver);
>
> It may seem silly for these piece of h/w, but don't we have a 'no new
> device drivers without DT support rule'?

It's more like a "no new sub-architectures without DT support".

The SA1100 systems (such as this H3600 iPAQ) are in a "legacy"
category of architectures, that will probably never get converted
over to device tree. But they are compartmentalized so they're OK.

>> +static inline int
>> +ipaq_micro_tx_msg_sync(struct ipaq_micro *micro,
>> +                    struct ipaq_micro_msg *msg)
>> +{
>> +     int ret;
>> +
>> +     init_completion(&msg->ack);
>> +     ret = ipaq_micro_tx_msg(micro, msg);
>> +     wait_for_completion(&msg->ack);
>> +
>> +     return ret;
>> +}
>> +
>> +static inline int
>> +ipaq_micro_tx_msg_async(struct ipaq_micro *micro,
>> +                     struct ipaq_micro_msg *msg)
>> +{
>> +     init_completion(&msg->ack);
>> +     return ipaq_micro_tx_msg(micro, msg);
>> +}
>
> Why are these in here? Where else are they called from?

This MFD driver provided infrastructure for all the subdrivers, LEDs,
keys etc.

These may want to send messages through the core and wait for
the message to come back, or they may want to send off a
message and await its completion at another time. Since the
most common is to send the message and then immediately
wait for it to complete, but sometimes not, these inline helpers
are provided.

Example use in the battery driver:

static void micro_battery_work(struct work_struct *work)
{
(...)
        struct ipaq_micro_msg msg_battery = {
                .id = MSG_BATTERY,
        };
(...)

        /* First send battery message */
        ipaq_micro_tx_msg_sync(mb->micro, &msg_battery);
        if (msg_battery.rx_len < 4)
                pr_info("ERROR");

        /*
         * Returned message format:
         * byte 0:   0x00 = Not plugged in
         *           0x01 = AC adapter plugged in
         * byte 1:   chemistry
         * byte 2:   voltage LSB
         * byte 3:   voltage MSB
         * byte 4:   flags
         * byte 5-9: same for battery 2
         */
        mb->ac = msg_battery.rx_data[0];
(...)

All other comments are fixed up.

I'm sending out a v2 targeted for v3.16.

Yours,
Linus Walleij
