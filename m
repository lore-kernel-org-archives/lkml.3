Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaFDNEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:04:43 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:42018 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaFDNEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <1401733885-5896-1-git-send-email-jaswinder.singh@linaro.org>
References: <1401733450-5646-1-git-send-email-jaswinder.singh@linaro.org>
	<1401733885-5896-1-git-send-email-jaswinder.singh@linaro.org>
Date: Wed, 4 Jun 2014 18:34:40 +0530
Message-ID: <CAJe_ZhfRGs4FsB5yWE=f7Vb8CEg+Sc3y8eCp64-UG4L8NNS3_A@mail.gmail.com>
Subject: Re: [PATCHv6 2/3] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Patch Tracking <patches@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 00:01, Jassi Brar <jaswinder.singh@linaro.org> wrote:

> diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
> new file mode 100644
> index 0000000..49bd64e
> --- /dev/null
> +++ b/include/linux/mailbox_controller.h
> @@ -0,0 +1,121 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CONTROLLER_H
> +#define __MAILBOX_CONTROLLER_H
> +
> +#include <linux/of.h>
> +
> +struct mbox_chan;
> +
> +/**
> + * struct mbox_chan_ops - s/w representation of a communication chan
> + * @send_data: The API asks the MBOX controller driver, in atomic
> + *             context try to transmit a message on the bus. Returns 0 if
> + *             data is accepted for transmission, -EBUSY while rejecting
> + *             if the remote hasn't yet read the last data sent. Actual
> + *             transmission of data is reported by the controller via
> + *             mbox_chan_txdone (if it has some TX ACK irq). It must not
> + *             block.
> + * @startup:   Called when a client requests the chan. The controller
> + *             could ask clients for additional parameters of communication
> + *             to be provided via client's chan_data. This call may
> + *             block. After this call the Controller must forward any
> + *             data received on the chan by calling mbox_chan_received_data.
> + * @shutdown:  Called when a client relinquishes control of a chan.
> + *             This call may block too. The controller must not forwared
> + *             any received data anymore.
> + * @last_tx_done: If the controller sets 'txdone_poll', the API calls
> + *               this to poll status of last TX. The controller must
> + *               give priority to IRQ method over polling and never
> + *               set both txdone_poll and txdone_irq. Only in polling
> + *               mode 'send_data' is expected to return -EBUSY.
> + *               Used only if txdone_poll:=true && txdone_irq:=false
> + * @peek_data: Atomic check for any received data. Return true if controller
> + *               has some data to push to the client. False otherwise.
> + */
> +struct mbox_chan_ops {
> +       int (*send_data)(struct mbox_chan *chan, void *data);
> +       int (*startup)(struct mbox_chan *chan);
> +       void (*shutdown)(struct mbox_chan *chan);
> +       bool (*last_tx_done)(struct mbox_chan *chan);
> +       bool (*peek_data)(struct mbox_chan *chan);
> +};
> +
> +/**
> + * struct mbox_controller - Controller of a class of communication chans
> + * @dev:               Device backing this controller
> + * @controller_name:   Literal name of the controller.
> + * @ops:               Operators that work on each communication chan
> + * @chans:             Null terminated array of chans.
> + * @txdone_irq:                Indicates if the controller can report to API when
> + *                     the last transmitted data was read by the remote.
> + *                     Eg, if it has some TX ACK irq.
> + * @txdone_poll:       If the controller can read but not report the TX
> + *                     done. Ex, some register shows the TX status but
> + *                     no interrupt rises. Ignored if 'txdone_irq' is set.
> + * @txpoll_period:     If 'txdone_poll' is in effect, the API polls for
> + *                     last TX's status after these many millisecs
> + */
> +struct mbox_controller {
> +       struct device *dev;
> +       struct mbox_chan_ops *ops;
> +       struct mbox_chan *chans;
> +       int num_chans;
> +       bool txdone_irq;
> +       bool txdone_poll;
> +       unsigned txpoll_period;
> +       struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
> +                                       const struct of_phandle_args *sp);
> +       /*
> +        * If the controller supports only TXDONE_BY_POLL,
> +        * this timer polls all the links for txdone.
> +        */
> +       struct timer_list poll;
> +       unsigned period;
> +       /* Hook to add to the global controller list */
> +       struct list_head node;
> +} __aligned(32);
> +
> +/*
> + * The length of circular buffer for queuing messages from a client.
> + * 'msg_count' tracks the number of buffered messages while 'msg_free'
> + * is the index where the next message would be buffered.
> + * We shouldn't need it too big because every transferr is interrupt
> + * triggered and if we have lots of data to transfer, the interrupt
> + * latencies are going to be the bottleneck, not the buffer length.
> + * Besides, mbox_send_message could be called from atomic context and
> + * the client could also queue another message from the notifier 'tx_done'
> + * of the last transfer done.
> + * REVIST: If too many platforms see the "Try increasing MBOX_TX_QUEUE_LEN"
> + * print, it needs to be taken from config option or somesuch.
> + */
> +#define MBOX_TX_QUEUE_LEN      20
> +
> +struct mbox_chan {
> +       struct mbox_controller *mbox; /* Parent Controller */
> +       unsigned txdone_method;
> +
> +       /* client */
> +       struct mbox_client *cl;
> +       struct completion tx_complete;
> +
> +       void *active_req;
> +       unsigned msg_count, msg_free;
> +       void *msg_data[MBOX_TX_QUEUE_LEN];
> +       /* Access to the channel */
> +       spinlock_t lock;
> +
> +       /* Private data for controller */
> +       void *con_priv;
> +} __aligned(32);
> +
I forgot to drop the unneeded __aligned attribute. Other than this, I
am keen on knowing what else.

Thanks
Jassi
