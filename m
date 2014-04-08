Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaDHPUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:20:32 -0400
Received: from tex.lwn.net ([70.33.254.29]:36529 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756711AbaDHPU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:20:28 -0400
X-Greylist: delayed 2146 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 11:20:28 EDT
Date: Tue, 8 Apr 2014 10:44:39 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org\" <linux-arm-kernel@lists.infradead.org>, "@lwn.net,
        linux-kernel@vger.kernel.org,
        " <linux-kernel@vger.kernel.org>"@lwn.net
Subject: Re: [PATCH 2/2] dma: Add Xilinx AXI Central Direct Memory Access
 Engine driver support
Message-ID: <20140408104439.012e3280@lwn.net>
In-Reply-To: <CA+mB=1J3Mb4A_SVtxxH-cra5tBSctwr0O-Lnif7j=v_Ro9YgPQ@mail.gmail.com>
References: <1396274044-6524-1-git-send-email-sthokal@xilinx.com>
	<1396274044-6524-2-git-send-email-sthokal@xilinx.com>
	<CA+mB=1J3Mb4A_SVtxxH-cra5tBSctwr0O-Lnif7j=v_Ro9YgPQ@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2014 20:22:54 +0530
Srikanth Thokala <sthokal@xilinx.com> wrote:

> Kindly review this driver and please let me know if you have any comments.

Here's some comments from a quick look at the patch; they do not qualify as
a proper review by any means.

> +/**
> + * struct xilinx_cdma_chan - Driver specific cdma channel structure
> + * @xdev: Driver specific device structure
> + * @lock: Descriptor operation lock
> + * @done_list: Complete descriptors
> + * @pending_list: Descriptors waiting
> + * @active_desc: Active descriptor
> + * @allocated_desc: Allocated descriptor
> + * @common: DMA common channel
> + * @desc_pool: Descriptors pool
> + * @dev: The dma device
> + * @irq: Channel IRQ
> + * @has_sg: Support scatter transfers
> + * @err: Channel has errors
> + * @tasklet: Cleanup work after irq
> + */
> +struct xilinx_cdma_chan {
> +       struct xilinx_cdma_device *xdev;
> +       spinlock_t lock;
> +       struct list_head done_list;
> +       struct list_head pending_list;
> +       struct xilinx_cdma_tx_descriptor *active_desc;
> +       struct xilinx_cdma_tx_descriptor *allocated_desc;
> +       struct dma_chan common;
> +       struct dma_pool *desc_pool;
> +       struct device *dev;
> +       int irq;
> +       bool has_sg;
> +       int err;
> +       struct tasklet_struct tasklet;
> +};

Have you thought about using a threaded IRQ handler instead of a tasklet?
The tasklet interface has its pitfalls and some reviewers frown on the
addition of more users.

[...]

> +/**
> + * xilinx_cdma_tx_descriptor - Allocate transaction descriptor
> + * @chan: Driver specific cdma channel
> + *
> + * Return: The allocated descriptor on success and NULL on failure.
> + */
> +static struct xilinx_cdma_tx_descriptor *
> +xilinx_cdma_alloc_tx_descriptor(struct xilinx_cdma_chan *chan)
> +{
> +       struct xilinx_cdma_tx_descriptor *desc;
> +       unsigned long flags;
> +
> +       if (chan->allocated_desc)
> +               return chan->allocated_desc;

This looks racy.  What happens if two threads hit here at once, or, in
general, some other thread does something with chan->allocated_desc?

> +       desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +       if (!desc)
> +               return NULL;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +       chan->allocated_desc = desc;
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       INIT_LIST_HEAD(&desc->segments);

Using the lock to protect a single assignment doesn't really buy you much;
it's what is going on outside of the locked region that is going to bite
you.

Also, as soon as you do that assignment, desc is visible to the rest of the
world.  Somebody else could try to use it before you get around to that
INIT_LIST_HEAD() call, with unpleasant results.  You really need a lock
around the whole test/allocate/initialize operation.

> +       return desc;
> +}
> +
> +/**
> + * xilinx_cdma_free_tx_descriptor - Free transaction descriptor
> + * @chan: Driver specific cdma channel
> + * @desc: cdma transaction descriptor
> + */
> +static void
> +xilinx_cdma_free_tx_descriptor(struct xilinx_cdma_chan *chan,
> +                              struct xilinx_cdma_tx_descriptor *desc)
> +{
> +       struct xilinx_cdma_tx_segment *segment, *next;
> +
> +       if (!desc)
> +               return;
> +
> +       list_for_each_entry_safe(segment, next, &desc->segments, node) {
> +               list_del(&segment->node);
> +               xilinx_cdma_free_tx_segment(chan, segment);
> +       }
> +
> +       kfree(desc);
> +}

What are the locking requirements for this function?  It looks from a
casual reading like some callers hold the spinlock while others do not.  It
would be good to sort out (and document!) the requirement here.

> +/**
> + * xilinx_cdma_free_chan_resources - Free channel resources
> + * @dchan: DMA channel
> + */
> +static void xilinx_cdma_free_chan_resources(struct dma_chan *dchan)
> +{
> +       struct xilinx_cdma_chan *chan = to_xilinx_chan(dchan);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +       xilinx_cdma_free_desc_list(chan, &chan->done_list);
> +       xilinx_cdma_free_desc_list(chan, &chan->pending_list);
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       dma_pool_destroy(chan->desc_pool);
> +       chan->desc_pool = NULL;

Why is this part done outside the lock?

> + */
> +static void xilinx_cdma_chan_desc_cleanup(struct xilinx_cdma_chan *chan)
> +{
> +       struct xilinx_cdma_tx_descriptor *desc, *next;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       list_for_each_entry_safe(desc, next, &chan->done_list, node) {
> +               dma_async_tx_callback callback;
> +               void *callback_param;
> +
> +               /* Remove from the list of running transactions */
> +               list_del(&desc->node);
> +
> +               /* Run the link descriptor callback function */
> +               callback = desc->async_tx.callback;
> +               callback_param = desc->async_tx.callback_param;
> +               if (callback) {
> +                       spin_unlock_irqrestore(&chan->lock, flags);

What happens if somebody slips in here and makes changes to the list?

> +                       callback(callback_param);
> +                       spin_lock_irqsave(&chan->lock, flags);
> +               }
> +
> +               /* Run any dependencies, then free the descriptor */
> +               dma_run_dependencies(&desc->async_tx);
> +               xilinx_cdma_free_tx_descriptor(chan, desc);
> +       }
> +
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +}

[...]

> +/**
> + * xilinx_cdma_do_tasklet - Schedule completion tasklet
> + * @data: Pointer to the Xilinx cdma channel structure
> + */

That comment is misleading; this is the actual tasklet function, it doesn't
schedule anything.

Again, though, consider threaded IRQ handlers instead.

> +static void xilinx_cdma_do_tasklet(unsigned long data)
> +{
> +       struct xilinx_cdma_chan *chan = (struct xilinx_cdma_chan *)data;
> +
> +       xilinx_cdma_chan_desc_cleanup(chan);
> +}


> +/**
> + * xilinx_cdma_free_channel - Channel remove function
> + * @chan: Driver specific cdma channel
> + */
> +static void xilinx_cdma_free_channel(struct xilinx_cdma_chan *chan)
> +{
> +       /* Disable Interrupts */
> +       cdma_ctrl_clr(chan, XILINX_CDMA_CONTROL_OFFSET,
> +                     XILINX_CDMA_XR_IRQ_ALL_MASK);
> +
> +       if (chan->irq > 0)
> +               free_irq(chan->irq, chan);
> +
> +       tasklet_kill(&chan->tasklet);
> +
> +       list_del(&chan->common.device_node);
> +}

What assurance do you have that there are no operations outstanding when
you do this?

> +/**
> + * xilinx_cdma_chan_probe - Per Channel Probing
> + * It get channel features from the device tree entry and
> + * initialize special channel handling routines
> + *
> + * @xdev: Driver specific device structure
> + * @node: Device node
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_cdma_chan_probe(struct xilinx_cdma_device *xdev,
> +                                 struct device_node *node)
> +{
> +       struct xilinx_cdma_chan *chan;
> +       bool has_dre;
> +       u32 value, width;
> +       int err;
> +
> +       /* Alloc channel */
> +       chan = devm_kzalloc(xdev->dev, sizeof(*chan), GFP_KERNEL);
> +       if (!chan)
> +               return -ENOMEM;
> +
> +       chan->dev = xdev->dev;
> +       chan->has_sg = xdev->has_sg;
> +       chan->xdev = xdev;
> +
> +       spin_lock_init(&chan->lock);
> +       INIT_LIST_HEAD(&chan->pending_list);
> +       INIT_LIST_HEAD(&chan->done_list);
> +
> +       /* Retrieve the channel properties from the device tree */
> +       has_dre = of_property_read_bool(node, "xlnx,include-dre");
> +
> +       err = of_property_read_u32(node, "xlnx,datawidth", &value);
> +       if (err) {
> +               dev_err(xdev->dev, "unable to read datawidth property");
> +               return err;
> +       }
> +       width = value >> 3; /* convert bits to bytes */
> +
> +       /* If data width is greater than 8 bytes, DRE is not in hw */
> +       if (width > 8)
> +               has_dre = false;
> +
> +       if (!has_dre)
> +               xdev->common.copy_align = fls(width - 1);
> +
> +       /* Request the interrupt */
> +       chan->irq = irq_of_parse_and_map(node, 0);
> +       err = request_irq(chan->irq, xilinx_cdma_irq_handler, IRQF_SHARED,
> +                         "xilinx-cdma-controller", chan);

Your interrupt handler could be called here.  Are you ready for that?

> +       if (err) {
> +               dev_err(xdev->dev, "unable to request IRQ %d\n", chan->irq);
> +               return err;
> +       }
> +
> +       /* Initialize the tasklet */
> +       tasklet_init(&chan->tasklet, xilinx_cdma_do_tasklet,
> +                    (unsigned long)chan);
> +
> +       /*
> +        * Initialize the DMA channel and add it to the DMA engine channels
> +        * list.
> +        */
> +       chan->common.device = &xdev->common;
> +
> +       list_add_tail(&chan->common.device_node, &xdev->common.channels);
> +       xdev->chan = chan;
> +
> +       /* Initialize the channel */
> +       err = xilinx_cdma_chan_reset(chan);
> +       if (err) {
> +               dev_err(xdev->dev, "Reset channel failed\n");
> +               return err;
> +       }
> +
> +       return 0;
> +}

[...]

jon
