Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbaKXXbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:31:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51295 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaKXXbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:31:42 -0500
Message-ID: <5473BFC2.5090203@ti.com>
Date: Mon, 24 Nov 2014 17:31:14 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
CC: Jassi Brar <jassisinghbrar@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v4] mailbox/omap: adapt to the new mailbox framework
References: <1415055950-64090-1-git-send-email-s-anna@ti.com> <CAJe_ZhcfYuoJcVE=Kc4mYOasrnGor1OEjfaN7CQVH=2s1Xmr-A@mail.gmail.com>
In-Reply-To: <CAJe_ZhcfYuoJcVE=Kc4mYOasrnGor1OEjfaN7CQVH=2s1Xmr-A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 11/24/2014 03:54 AM, Jassi Brar wrote:
> On 4 November 2014 at 04:35, Suman Anna <s-anna@ti.com> wrote:
>> The OMAP mailbox driver and its existing clients (remoteproc
>> for OMAP4+) are adapted to use the generic mailbox framework.
>>
>> The main changes for the adaptation are:
>>   - The tasklet used for Tx is replaced with the state machine from
>>     the generic mailbox framework. The workqueue used for processing
>>     the received messages stays intact for minimizing the effects on
>>     the OMAP mailbox clients.
>>   - The existing exported client API, omap_mbox_get, omap_mbox_put and
>>     omap_mbox_send_msg are deleted, as the framework provides equivalent
>>     functionality. A OMAP-specific omap_mbox_request_channel is added
>>     though to support non-DT way of requesting mailboxes.
>>   - The OMAP mailbox driver is integrated with the mailbox framework
>>     through the proper implementations of mbox_chan_ops, except for
>>     .last_tx_done and .peek_data. The OMAP mailbox driver does not need
>>     these ops, as it is completely interrupt driven.
>>   - The OMAP mailbox driver uses a custom of_xlate controller ops that
>>     allows phandles for the pargs specifier instead of indexing to avoid
>>     any channel registration order dependencies.
>>   - The new framework does not support multiple clients operating on a
>>     single channel, so the reference counting logic is simplified.
>>   - The remoteproc driver (current client) is adapted to use the new API.
>>     The notifier callbacks used within this client is replaced with the
>>     regular callbacks from the newer framework.
>>   - The exported OMAP mailbox API are limited to omap_mbox_save_ctx,
>>     omap_mbox_restore_ctx, omap_mbox_enable_irq & omap_mbox_disable_irq,
>>     with the signature modified to take in the new mbox_chan handle instead
>>     of the OMAP specific omap_mbox handle. The first 2 will be removed when
>>     the OMAP mailbox driver is adapted to runtime_pm. The other exported
>>     API omap_mbox_request_channel will be removed once existing legacy
>>     users are converted to DT.
>>
>> Cc: Jassi Brar <jassisinghbrar@gmail.com>
>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>> v3->v4: No code changes, switched the example to use the DSP node instead of
>> WkupM3 in the bindings document & minor commit description changes. Other than
>> that, this is a repost of the driver adaptation patch [1] from the OMAP Mailbox
>> framework adaptation series [2]. This patch is intended for the 3.19 merge window,
>> all the dependent patches in [2] are merged as of 3.18-rc2. The DTS patch in [2]
>> will be posted separately.
>>
>> [1] http://marc.info/?l=linux-omap&m=141038453917790&w=2
>> [2] http://marc.info/?l=linux-omap&m=141038447817775&w=2
>>
>>  .../devicetree/bindings/mailbox/omap-mailbox.txt   |  23 ++
>>  drivers/mailbox/omap-mailbox.c                     | 346 ++++++++++++---------
>>  drivers/remoteproc/omap_remoteproc.c               |  51 +--
>>  include/linux/omap-mailbox.h                       |  16 +-
>>  4 files changed, 256 insertions(+), 180 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
>> index 48edc4b..d1a0433 100644
>> --- a/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
>> +++ b/Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
>> @@ -43,6 +43,9 @@ Required properties:
>>                         device. The format is dependent on which interrupt
>>                         controller the OMAP device uses
>>  - ti,hwmods:           Name of the hwmod associated with the mailbox
>> +- #mbox-cells:         Common mailbox binding property to identify the number
>> +                       of cells required for the mailbox specifier. Should be
>> +                       1
>>  - ti,mbox-num-users:   Number of targets (processor devices) that the mailbox
>>                         device can interrupt
>>  - ti,mbox-num-fifos:   Number of h/w fifo queues within the mailbox IP block
>> @@ -72,6 +75,18 @@ data that represent the following:
>>      Cell #3 (usr_id)  - mailbox user id for identifying the interrupt line
>>                          associated with generating a tx/rx fifo interrupt.
>>
>> +Mailbox Users:
>> +==============
>> +A device needing to communicate with a target processor device should specify
>> +them using the common mailbox binding properties, "mboxes" and the optional
>> +"mbox-names" (please see Documentation/devicetree/bindings/mailbox/mailbox.txt
>> +for details). Each value of the mboxes property should contain a phandle to the
>> +mailbox controller device node and an args specifier that will be the phandle to
>> +the intended sub-mailbox child node to be used for communication. The equivalent
>> +"mbox-names" property value can be used to give a name to the communication channel
>> +to be used by the client user.
>> +
>> +
>>  Example:
>>  --------
>>
>> @@ -81,6 +96,7 @@ mailbox: mailbox@4a0f4000 {
>>         reg = <0x4a0f4000 0x200>;
>>         interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
>>         ti,hwmods = "mailbox";
>> +       #mbox-cells = <1>;
>>         ti,mbox-num-users = <3>;
>>         ti,mbox-num-fifos = <8>;
>>         mbox_ipu: mbox_ipu {
>> @@ -93,12 +109,19 @@ mailbox: mailbox@4a0f4000 {
>>         };
>>  };
>>
>> +dsp {
>> +       ...
>> +       mboxes = <&mailbox &mbox_dsp>;
>> +       ...
>> +};
>> +
>>  /* AM33xx */
>>  mailbox: mailbox@480C8000 {
>>         compatible = "ti,omap4-mailbox";
>>         reg = <0x480C8000 0x200>;
>>         interrupts = <77>;
>>         ti,hwmods = "mailbox";
>> +       #mbox-cells = <1>;
>>         ti,mbox-num-users = <4>;
>>         ti,mbox-num-fifos = <8>;
>>         mbox_wkupm3: wkup_m3 {
>> diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c
>> index bcc7ee1..66b83ca 100644
>> --- a/drivers/mailbox/omap-mailbox.c
>> +++ b/drivers/mailbox/omap-mailbox.c
>> @@ -29,13 +29,14 @@
>>  #include <linux/slab.h>
>>  #include <linux/kfifo.h>
>>  #include <linux/err.h>
>> -#include <linux/notifier.h>
>>  #include <linux/module.h>
>>  #include <linux/of_device.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/platform_data/mailbox-omap.h>
>>  #include <linux/omap-mailbox.h>
>> +#include <linux/mailbox_controller.h>
>> +#include <linux/mailbox_client.h>
>>
>>  #define MAILBOX_REVISION               0x000
>>  #define MAILBOX_MESSAGE(m)             (0x040 + 4 * (m))
>> @@ -80,7 +81,6 @@ struct omap_mbox_queue {
>>         spinlock_t              lock;
>>         struct kfifo            fifo;
>>         struct work_struct      work;
>> -       struct tasklet_struct   tasklet;
>>         struct omap_mbox        *mbox;
>>         bool full;
>>  };
>> @@ -92,6 +92,7 @@ struct omap_mbox_device {
>>         u32 num_users;
>>         u32 num_fifos;
>>         struct omap_mbox **mboxes;
>> +       struct mbox_controller controller;
>>         struct list_head elem;
>>  };
>>
>> @@ -110,15 +111,14 @@ struct omap_mbox_fifo_info {
>>  struct omap_mbox {
>>         const char              *name;
>>         int                     irq;
>> -       struct omap_mbox_queue  *txq, *rxq;
>> +       struct omap_mbox_queue  *rxq;
>>         struct device           *dev;
>>         struct omap_mbox_device *parent;
>>         struct omap_mbox_fifo   tx_fifo;
>>         struct omap_mbox_fifo   rx_fifo;
>>         u32                     ctx[OMAP4_MBOX_NR_REGS];
>>         u32                     intr_type;
>> -       int                     use_count;
>> -       struct blocking_notifier_head   notifier;
>> +       struct mbox_chan        *chan;
>>  };
>>
>>  /* global variables for the mailbox devices */
>> @@ -129,6 +129,14 @@ static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
>>  module_param(mbox_kfifo_size, uint, S_IRUGO);
>>  MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
>>
>> +static struct omap_mbox *mbox_chan_to_omap_mbox(struct mbox_chan *chan)
>> +{
>> +       if (!chan || !chan->con_priv)
>> +               return NULL;
>> +
>> +       return (struct omap_mbox *)chan->con_priv;
>> +}
>> +
>>  static inline
>>  unsigned int mbox_read_reg(struct omap_mbox_device *mdev, size_t ofs)
>>  {
>> @@ -194,41 +202,14 @@ static int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>>         return (int)(enable & status & bit);
>>  }
>>
>> -/*
>> - * message sender
>> - */
>> -int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
>> -{
>> -       struct omap_mbox_queue *mq = mbox->txq;
>> -       int ret = 0, len;
>> -
>> -       spin_lock_bh(&mq->lock);
>> -
>> -       if (kfifo_avail(&mq->fifo) < sizeof(msg)) {
>> -               ret = -ENOMEM;
>> -               goto out;
>> -       }
>> -
>> -       if (kfifo_is_empty(&mq->fifo) && !mbox_fifo_full(mbox)) {
>> -               mbox_fifo_write(mbox, msg);
>> -               goto out;
>> -       }
>> -
>> -       len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
>> -       WARN_ON(len != sizeof(msg));
>> -
>> -       tasklet_schedule(&mbox->txq->tasklet);
>> -
>> -out:
>> -       spin_unlock_bh(&mq->lock);
>> -       return ret;
>> -}
>> -EXPORT_SYMBOL(omap_mbox_msg_send);
>> -
>> -void omap_mbox_save_ctx(struct omap_mbox *mbox)
>> +void omap_mbox_save_ctx(struct mbox_chan *chan)
>>  {
>>         int i;
>>         int nr_regs;
>> +       struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
>> +
>> +       if (WARN_ON(!mbox))
>> +               return;
>>
>>         if (mbox->intr_type)
>>                 nr_regs = OMAP4_MBOX_NR_REGS;
>> @@ -243,10 +224,14 @@ void omap_mbox_save_ctx(struct omap_mbox *mbox)
>>  }
>>  EXPORT_SYMBOL(omap_mbox_save_ctx);
>>
>> -void omap_mbox_restore_ctx(struct omap_mbox *mbox)
>> +void omap_mbox_restore_ctx(struct mbox_chan *chan)
>>  {
>>         int i;
>>         int nr_regs;
>> +       struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
>> +
>> +       if (WARN_ON(!mbox))
>> +               return;
>>
>>         if (mbox->intr_type)
>>                 nr_regs = OMAP4_MBOX_NR_REGS;
>> @@ -254,14 +239,13 @@ void omap_mbox_restore_ctx(struct omap_mbox *mbox)
>>                 nr_regs = MBOX_NR_REGS;
>>         for (i = 0; i < nr_regs; i++) {
>>                 mbox_write_reg(mbox->parent, mbox->ctx[i], i * sizeof(u32));
>> -
>>                 dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
>>                         i, mbox->ctx[i]);
>>         }
>>  }
>>  EXPORT_SYMBOL(omap_mbox_restore_ctx);
>>
>> -void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>> +static void _omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>>  {
>>         u32 l;
>>         struct omap_mbox_fifo *fifo = (irq == IRQ_TX) ?
>> @@ -273,9 +257,8 @@ void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>>         l |= bit;
>>         mbox_write_reg(mbox->parent, l, irqenable);
>>  }
>> -EXPORT_SYMBOL(omap_mbox_enable_irq);
>>
>> -void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>> +static void _omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>>  {
>>         struct omap_mbox_fifo *fifo = (irq == IRQ_TX) ?
>>                                 &mbox->tx_fifo : &mbox->rx_fifo;
>> @@ -291,28 +274,28 @@ void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
>>
>>         mbox_write_reg(mbox->parent, bit, irqdisable);
>>  }
>> -EXPORT_SYMBOL(omap_mbox_disable_irq);
>>
>> -static void mbox_tx_tasklet(unsigned long tx_data)
>> +void omap_mbox_enable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq)
>>  {
>> -       struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
>> -       struct omap_mbox_queue *mq = mbox->txq;
>> -       mbox_msg_t msg;
>> -       int ret;
>> +       struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
>>
>> -       while (kfifo_len(&mq->fifo)) {
>> -               if (mbox_fifo_full(mbox)) {
>> -                       omap_mbox_enable_irq(mbox, IRQ_TX);
>> -                       break;
>> -               }
>> +       if (WARN_ON(!mbox))
>> +               return;
>>
>> -               ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
>> -                                                               sizeof(msg));
>> -               WARN_ON(ret != sizeof(msg));
>> +       _omap_mbox_enable_irq(mbox, irq);
>> +}
>> +EXPORT_SYMBOL(omap_mbox_enable_irq);
>>
>> -               mbox_fifo_write(mbox, msg);
>> -       }
>> +void omap_mbox_disable_irq(struct mbox_chan *chan, omap_mbox_irq_t irq)
>> +{
>> +       struct omap_mbox *mbox = mbox_chan_to_omap_mbox(chan);
>> +
>> +       if (WARN_ON(!mbox))
>> +               return;
>> +
>> +       _omap_mbox_disable_irq(mbox, irq);
>>  }
>> +EXPORT_SYMBOL(omap_mbox_disable_irq);
>>
>>  /*
>>   * Message receiver(workqueue)
>> @@ -328,12 +311,11 @@ static void mbox_rx_work(struct work_struct *work)
>>                 len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
>>                 WARN_ON(len != sizeof(msg));
>>
>> -               blocking_notifier_call_chain(&mq->mbox->notifier, len,
>> -                                                               (void *)msg);
>> +               mbox_chan_received_data(mq->mbox->chan, (void *)msg);
>>                 spin_lock_irq(&mq->lock);
>>                 if (mq->full) {
>>                         mq->full = false;
>> -                       omap_mbox_enable_irq(mq->mbox, IRQ_RX);
>> +                       _omap_mbox_enable_irq(mq->mbox, IRQ_RX);
>>                 }
>>                 spin_unlock_irq(&mq->lock);
>>         }
>> @@ -344,9 +326,9 @@ static void mbox_rx_work(struct work_struct *work)
>>   */
>>  static void __mbox_tx_interrupt(struct omap_mbox *mbox)
>>  {
>> -       omap_mbox_disable_irq(mbox, IRQ_TX);
>> +       _omap_mbox_disable_irq(mbox, IRQ_TX);
>>         ack_mbox_irq(mbox, IRQ_TX);
>> -       tasklet_schedule(&mbox->txq->tasklet);
>> +       mbox_chan_txdone(mbox->chan, 0);
>>  }
>>
>>  static void __mbox_rx_interrupt(struct omap_mbox *mbox)
>> @@ -357,7 +339,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
>>
>>         while (!mbox_fifo_empty(mbox)) {
>>                 if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
>> -                       omap_mbox_disable_irq(mbox, IRQ_RX);
>> +                       _omap_mbox_disable_irq(mbox, IRQ_RX);
>>                         mq->full = true;
>>                         goto nomem;
>>                 }
>> @@ -388,11 +370,13 @@ static irqreturn_t mbox_interrupt(int irq, void *p)
>>  }
>>
>>  static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
>> -                                       void (*work) (struct work_struct *),
>> -                                       void (*tasklet)(unsigned long))
>> +                                       void (*work)(struct work_struct *))
>>  {
>>         struct omap_mbox_queue *mq;
>>
>> +       if (!work)
>> +               return NULL;
>> +
>>         mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
>>         if (!mq)
>>                 return NULL;
>> @@ -402,12 +386,9 @@ static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
>>         if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
>>                 goto error;
>>
>> -       if (work)
>> -               INIT_WORK(&mq->work, work);
>> -
>> -       if (tasklet)
>> -               tasklet_init(&mq->tasklet, tasklet, (unsigned long)mbox);
>> +       INIT_WORK(&mq->work, work);
>>         return mq;
>> +
>>  error:
>>         kfree(mq);
>>         return NULL;
>> @@ -423,71 +404,35 @@ static int omap_mbox_startup(struct omap_mbox *mbox)
>>  {
>>         int ret = 0;
>>         struct omap_mbox_queue *mq;
>> -       struct omap_mbox_device *mdev = mbox->parent;
>>
>> -       mutex_lock(&mdev->cfg_lock);
>> -       ret = pm_runtime_get_sync(mdev->dev);
>> -       if (unlikely(ret < 0))
>> -               goto fail_startup;
>> -
>> -       if (!mbox->use_count++) {
>> -               mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
>> -               if (!mq) {
>> -                       ret = -ENOMEM;
>> -                       goto fail_alloc_txq;
>> -               }
>> -               mbox->txq = mq;
>> +       mq = mbox_queue_alloc(mbox, mbox_rx_work);
>> +       if (!mq)
>> +               return -ENOMEM;
>> +       mbox->rxq = mq;
>> +       mq->mbox = mbox;
>> +
>> +       ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
>> +                         mbox->name, mbox);
>> +       if (unlikely(ret)) {
>> +               pr_err("failed to register mailbox interrupt:%d\n", ret);
>> +               goto fail_request_irq;
>> +       }
>>
>> -               mq = mbox_queue_alloc(mbox, mbox_rx_work, NULL);
>> -               if (!mq) {
>> -                       ret = -ENOMEM;
>> -                       goto fail_alloc_rxq;
>> -               }
>> -               mbox->rxq = mq;
>> -               mq->mbox = mbox;
>> -               ret = request_irq(mbox->irq, mbox_interrupt, IRQF_SHARED,
>> -                                                       mbox->name, mbox);
>> -               if (unlikely(ret)) {
>> -                       pr_err("failed to register mailbox interrupt:%d\n",
>> -                                                                       ret);
>> -                       goto fail_request_irq;
>> -               }
>> +       _omap_mbox_enable_irq(mbox, IRQ_RX);
>>
>> -               omap_mbox_enable_irq(mbox, IRQ_RX);
>> -       }
>> -       mutex_unlock(&mdev->cfg_lock);
>>         return 0;
>>
>>  fail_request_irq:
>>         mbox_queue_free(mbox->rxq);
>> -fail_alloc_rxq:
>> -       mbox_queue_free(mbox->txq);
>> -fail_alloc_txq:
>> -       pm_runtime_put_sync(mdev->dev);
>> -       mbox->use_count--;
>> -fail_startup:
>> -       mutex_unlock(&mdev->cfg_lock);
>>         return ret;
>>  }
>>
>>  static void omap_mbox_fini(struct omap_mbox *mbox)
>>  {
>> -       struct omap_mbox_device *mdev = mbox->parent;
>> -
>> -       mutex_lock(&mdev->cfg_lock);
>> -
>> -       if (!--mbox->use_count) {
>> -               omap_mbox_disable_irq(mbox, IRQ_RX);
>> -               free_irq(mbox->irq, mbox);
>> -               tasklet_kill(&mbox->txq->tasklet);
>> -               flush_work(&mbox->rxq->work);
>> -               mbox_queue_free(mbox->txq);
>> -               mbox_queue_free(mbox->rxq);
>> -       }
>> -
>> -       pm_runtime_put_sync(mdev->dev);
>> -
>> -       mutex_unlock(&mdev->cfg_lock);
>> +       _omap_mbox_disable_irq(mbox, IRQ_RX);
>> +       free_irq(mbox->irq, mbox);
>> +       flush_work(&mbox->rxq->work);
>> +       mbox_queue_free(mbox->rxq);
>>  }
>>
>>  static struct omap_mbox *omap_mbox_device_find(struct omap_mbox_device *mdev,
>> @@ -509,42 +454,55 @@ static struct omap_mbox *omap_mbox_device_find(struct omap_mbox_device *mdev,
>>         return mbox;
>>  }
>>
>> -struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
>> +struct mbox_chan *omap_mbox_request_channel(struct mbox_client *cl,
>> +                                           const char *chan_name)
>>  {
>> +       struct device *dev = cl->dev;
>>         struct omap_mbox *mbox = NULL;
>>         struct omap_mbox_device *mdev;
>> +       struct mbox_chan *chan;
>> +       unsigned long flags;
>>         int ret;
>>
>> +       if (!dev)
>> +               return ERR_PTR(-ENODEV);
>> +
>> +       if (dev->of_node) {
>> +               pr_err("%s: please use mbox_request_channel(), this API is supported only for OMAP non-DT usage\n",
>> +                      __func__);
>> +               return ERR_PTR(-ENODEV);
>> +       }
>> +
>>         mutex_lock(&omap_mbox_devices_lock);
>>         list_for_each_entry(mdev, &omap_mbox_devices, elem) {
>> -               mbox = omap_mbox_device_find(mdev, name);
>> +               mbox = omap_mbox_device_find(mdev, chan_name);
>>                 if (mbox)
>>                         break;
>>         }
>>         mutex_unlock(&omap_mbox_devices_lock);
>>
>> -       if (!mbox)
>> +       if (!mbox || !mbox->chan)
>>                 return ERR_PTR(-ENOENT);
>>
>> -       if (nb)
>> -               blocking_notifier_chain_register(&mbox->notifier, nb);
>> +       chan = mbox->chan;
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +       chan->msg_free = 0;
>> +       chan->msg_count = 0;
>> +       chan->active_req = NULL;
>> +       chan->cl = cl;
>> +       init_completion(&chan->tx_complete);
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>>
>> -       ret = omap_mbox_startup(mbox);
>> +       ret = chan->mbox->ops->startup(chan);
>>         if (ret) {
>> -               blocking_notifier_chain_unregister(&mbox->notifier, nb);
>> -               return ERR_PTR(-ENODEV);
>> +               pr_err("Unable to startup the chan (%d)\n", ret);
>> +               mbox_free_channel(chan);
>> +               chan = ERR_PTR(ret);
>>         }
>>
>> -       return mbox;
>> -}
>> -EXPORT_SYMBOL(omap_mbox_get);
>> -
>> -void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
>> -{
>> -       blocking_notifier_chain_unregister(&mbox->notifier, nb);
>> -       omap_mbox_fini(mbox);
>> +       return chan;
>>  }
>> -EXPORT_SYMBOL(omap_mbox_put);
>> +EXPORT_SYMBOL(omap_mbox_request_channel);
>>
> Why not mbox_request_channel()?
> And what about other 4 exports - omap_mbox_{save_ctx, restore_ctx,
> enable_irq & disable_irq} ?

Please see the last bullet item in the patch description. It is gonna
take couple of kernel versions before the OMAP remoteproc is converted
to DT, so until then we need some of the API as a stop-gap, but the plan
is to remove most of them eventually.

The enable_irq and disable_irq variants will be needed by our WkupM3 IPC
driver (needed to achieve PM suspend/resume on TI AM335x/AM437x SoCs)
for flow control. You can look at the usage in an earlier version [1],
and that series is being reworked now but would still require these. It
had also been used by TI DSP/Bridge driver, but that is no longer
relevant as that driver has been deleted in 3.17.

regards
Suman

[1] http://marc.info/?l=linux-omap&m=140504747716092&w=2
