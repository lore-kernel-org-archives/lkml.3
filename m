Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaLESa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:30:57 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:64865 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaLESay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:30:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141205173553.GS3411@intel.com>
References: <1416002384-3525-1-git-send-email-abrestic@chromium.org>
	<1416002384-3525-3-git-send-email-abrestic@chromium.org>
	<20141205173553.GS3411@intel.com>
Date: Fri, 5 Dec 2014 10:30:53 -0800
X-Google-Sender-Auth: _Ltj-n0EIxvpWwqppg64cHESnj0
Message-ID: <CAL1qeaE+7L2p=HxPBasQYLVPD0H2qBAd439Fn_z3Fza9Y3+0eA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] dmaengine: Add driver for IMG MDC
From: Andrew Bresticker <abrestic@chromium.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review Vinod!

On Fri, Dec 5, 2014 at 9:35 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, Nov 14, 2014 at 01:59:43PM -0800, Andrew Bresticker wrote:
>> +static inline unsigned int to_mdc_width(enum dma_slave_buswidth bw)
>> +{
>> +     switch (bw) {
>> +     case DMA_SLAVE_BUSWIDTH_1_BYTE:
>> +             return 0;
>> +     case DMA_SLAVE_BUSWIDTH_2_BYTES:
>> +             return 1;
>> +     case DMA_SLAVE_BUSWIDTH_4_BYTES:
>> +             return 2;
>> +     case DMA_SLAVE_BUSWIDTH_8_BYTES:
>> +             return 3;

> ffs()?

Ok.

>> +     default:
>> +             return 2;

> for slave cases default makes little sense, better to return error?

Sure.

>> +     }
>> +}
>> +
>> +static void mdc_list_desc_config(struct mdc_chan *mchan,
>> +                              struct mdc_hw_list_desc *ldesc,
>> +                              enum dma_transfer_direction dir,
>> +                              dma_addr_t src, dma_addr_t dst, size_t len)
>> +{
>> +     struct mdc_dma *mdma = mchan->mdma;
>> +     unsigned int max_burst, burst_size;
>> +
>> +     ldesc->gen_conf = MDC_GENERAL_CONFIG_IEN | MDC_GENERAL_CONFIG_LIST_IEN |
>> +             MDC_GENERAL_CONFIG_LEVEL_INT | MDC_GENERAL_CONFIG_PHYSICAL_W |
>> +             MDC_GENERAL_CONFIG_PHYSICAL_R;
>> +     ldesc->readport_conf =
>> +             (mchan->thread << MDC_READ_PORT_CONFIG_STHREAD_SHIFT) |
>> +             (mchan->thread << MDC_READ_PORT_CONFIG_RTHREAD_SHIFT) |
>> +             (mchan->thread << MDC_READ_PORT_CONFIG_WTHREAD_SHIFT);
>> +     ldesc->read_addr = src;
>> +     ldesc->write_addr = dst;
>> +     ldesc->xfer_size = len - 1;
>> +     ldesc->node_addr = 0;
>> +     ldesc->cmds_done = 0;
>> +     ldesc->ctrl_status = MDC_CONTROL_AND_STATUS_LIST_EN |
>> +             MDC_CONTROL_AND_STATUS_EN;
>> +     ldesc->next_desc = NULL;
>> +
>> +     if ((dst % mdma->bus_width == 0) && (src % mdma->bus_width == 0))
>> +             max_burst = mdma->bus_width * mdma->max_burst_mult;
>> +     else
>> +             max_burst = mdma->bus_width * (mdma->max_burst_mult - 1);

> sounds like you should use something like ALIGN ?

Yup.

>> +
>> +     if (dir == DMA_MEM_TO_DEV) {
>> +             ldesc->gen_conf |= MDC_GENERAL_CONFIG_INC_R |
>> +                     ((fls(mdma->bus_width) - 1) <<

> bus_width calculation is repeated quite few times, would help readability if
> we hanlde this in macro.

Yes, will do.

> Also this be using src/dstn_addr_widths based on direction passed.

The above is setting the memory (not slave) bus width which is fixed
and not a per-slave property.

>> +                      MDC_GENERAL_CONFIG_WIDTH_R_SHIFT) |
>> +                     (to_mdc_width(mchan->config.dst_addr_width) <<
>> +                      MDC_GENERAL_CONFIG_WIDTH_W_SHIFT);

> and a macro for this calculation, which take args for different cases would
> help a lot!

Ok.

>> +             ldesc->readport_conf |= MDC_READ_PORT_CONFIG_DREQ_ENABLE;
>> +             burst_size = min(max_burst, mchan->config.dst_maxburst *
>> +                              mchan->config.dst_addr_width);
>> +     } else if (dir == DMA_DEV_TO_MEM) {
>> +             ldesc->gen_conf |= MDC_GENERAL_CONFIG_INC_W |
>> +                     (to_mdc_width(mchan->config.src_addr_width) <<
>> +                      MDC_GENERAL_CONFIG_WIDTH_R_SHIFT) |
>> +                     ((fls(mdma->bus_width) - 1) <<
>> +                      MDC_GENERAL_CONFIG_WIDTH_W_SHIFT);
>> +             ldesc->readport_conf |= MDC_READ_PORT_CONFIG_DREQ_ENABLE;
>> +             burst_size = min(max_burst, mchan->config.src_maxburst *
>> +                              mchan->config.src_addr_width);
>> +     } else {

> DEV_TO_DEV too?

No, but it's not possible to have dir == DEV_TO_DEV here.  The callers
(mdc_prep_xxx) will check the direcioin.

>> +             ldesc->gen_conf |= MDC_GENERAL_CONFIG_INC_R |
>> +                     MDC_GENERAL_CONFIG_INC_W |
>> +                     ((fls(mdma->bus_width) - 1) <<
>> +                      MDC_GENERAL_CONFIG_WIDTH_R_SHIFT) |
>> +                     ((fls(mdma->bus_width) - 1) <<
>> +                      MDC_GENERAL_CONFIG_WIDTH_W_SHIFT);
>> +             burst_size = max_burst;

> btw this piece is very hard to read, please do improve upon

After adding a macro for setting the WIDTH_{R,W} fields it seems fine
to me.  Is there something else you had in mind?

>> +static struct dma_async_tx_descriptor *mdc_prep_dma_memcpy(
>> +     struct dma_chan *chan, dma_addr_t dest, dma_addr_t src, size_t len,
>> +     unsigned long flags)
>> +{
>> +     struct mdc_chan *mchan = to_mdc_chan(chan);
>> +     struct mdc_dma *mdma = mchan->mdma;
>> +     struct mdc_tx_desc *mdesc;
>> +     struct mdc_hw_list_desc *curr, *prev = NULL;
>> +     dma_addr_t curr_phys, prev_phys;
>> +
>> +     if (!len)
>> +             return NULL;
>> +
>> +     mdesc = kzalloc(sizeof(*mdesc), GFP_NOWAIT);
>> +     if (!mdesc)
>> +             return NULL;
>> +     mdesc->chan = mchan;
>> +     mdesc->list_xfer_size = len;
>> +
>> +     while (len > 0) {
>> +             size_t xfer_size;
>> +
>> +             curr = dma_pool_alloc(mdma->desc_pool, GFP_NOWAIT, &curr_phys);
>> +             if (!curr)
>> +                     goto free_desc;
>> +
>> +             if (prev) {
>> +                     prev->node_addr = curr_phys;
>> +                     prev->next_desc = curr;
>> +             } else {
>> +                     mdesc->list_phys = curr_phys;
>> +                     mdesc->list = curr;
>> +             }
>> +
>> +             xfer_size = min_t(size_t, mdma->max_xfer_size, len);
>> +
>> +             mdc_list_desc_config(mchan, curr, DMA_MEM_TO_MEM, src, dest,
>> +                                  xfer_size);

> and this depends on dma_slave_config being set, which shouldn't be the case
> for memcpy

It doesn't.  mdc_list_desc_config only looks at mchan->config in the
slave cases.

>> +static enum dma_status mdc_tx_status(struct dma_chan *chan,
>> +     dma_cookie_t cookie, struct dma_tx_state *txstate)
>> +{
>> +     struct mdc_chan *mchan = to_mdc_chan(chan);
>> +     struct mdc_tx_desc *mdesc;
>> +     struct virt_dma_desc *vd;
>> +     unsigned long flags;
>> +     size_t bytes = 0;
>> +     int ret;
>> +
>> +     ret = dma_cookie_status(chan, cookie, txstate);
>> +     if (ret == DMA_COMPLETE)
>> +             return ret;
>> +

> you should check txstate before proceeding. It can be null too

Ok.

>> +
>> +static int mdc_slave_config(struct dma_chan *chan,
>> +                         struct dma_slave_config *config)
>> +{
>> +     struct mdc_chan *mchan = to_mdc_chan(chan);
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&mchan->vc.lock, flags);
>> +     if (config->direction == DMA_MEM_TO_DEV) {
>> +             config->dst_addr_width = min(config->dst_addr_width,
>> +                                          mchan->mdma->bus_width);
>> +     } else {
>> +             config->src_addr_width = min(config->src_addr_width,
>> +                                          mchan->mdma->bus_width);

> direction field is deprecated pls don't use that. Use the prep_xx direction
> argument instead

Ok.

>> +static int mdc_dma_remove(struct platform_device *pdev)
>> +{
>> +     struct mdc_dma *mdma = platform_get_drvdata(pdev);
>> +
>> +     of_dma_controller_free(pdev->dev.of_node);
>> +     dma_async_device_unregister(&mdma->dma_dev);
>> +     clk_disable_unprepare(mdma->clk);

> you need to call devm_irq_free() explicitly and also ensure you kill your
> tasklet and syncronize irq()

Ok.

> Plus a rebase on Maxime's series which will be merged in required

This patch is already based on Maxime's series.
