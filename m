Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaLXUGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 15:06:33 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:64701 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaLXUGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 15:06:30 -0500
From: James Hartley <James.Hartley@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        James Hogan <James.Hogan@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/2] dmaengine: Add driver for IMG MDC
Thread-Topic: [PATCH V3 2/2] dmaengine: Add driver for IMG MDC
Thread-Index: AQHQFZYddEirczngJkWyGFSUbQupMZyeR/8AgADI2oCAAC4s5g==
Date: Wed, 24 Dec 2014 20:06:25 +0000
Message-ID: <DCB85CE8-D4D7-41B2-8C56-ADD675DB131E@imgtec.com>
References: <1418338757-10022-1-git-send-email-abrestic@chromium.org>
	<1418338757-10022-3-git-send-email-abrestic@chromium.org>
	<20141224052218.GR16827@intel.com>,<CAL1qeaGRUEZ0tF+fgH4aJK2S70aacJkwKZNJHvDU_NaiwYbChQ@mail.gmail.com>
In-Reply-To: <CAL1qeaGRUEZ0tF+fgH4aJK2S70aacJkwKZNJHvDU_NaiwYbChQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> On 24 Dec 2014, at 17:21, Andrew Bresticker <abrestic@chromium.org> wrote:
> 
>> On Tue, Dec 23, 2014 at 9:22 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>>> On Thu, Dec 11, 2014 at 02:59:17PM -0800, Andrew Bresticker wrote:
>>> Add support for the IMG Multi-threaded DMA Controller (MDC) found on
>>> certain IMG SoCs.  Currently this driver supports the variant present
>>> on the MIPS-based Pistachio SoC.a
> 
>> Overall looks okay. I also need some review by DT folks on the bindings
> 
> Arnd has ack'ed the DT bindings, do you need someone else to review
> them as well?
> 
>>> +static void mdc_list_desc_config(struct mdc_chan *mchan,
>>> +                              struct mdc_hw_list_desc *ldesc,
>>> +                              enum dma_transfer_direction dir,
>>> +                              dma_addr_t src, dma_addr_t dst, size_t len)
>>> +{
>>> +     struct mdc_dma *mdma = mchan->mdma;
>>> +     unsigned int max_burst, burst_size;
>>> +
>>> +     ldesc->gen_conf = MDC_GENERAL_CONFIG_IEN | MDC_GENERAL_CONFIG_LIST_IEN |
>>> +             MDC_GENERAL_CONFIG_LEVEL_INT | MDC_GENERAL_CONFIG_PHYSICAL_W |
>>> +             MDC_GENERAL_CONFIG_PHYSICAL_R;
>>> +     ldesc->readport_conf =
>>> +             (mchan->thread << MDC_READ_PORT_CONFIG_STHREAD_SHIFT) |
>>> +             (mchan->thread << MDC_READ_PORT_CONFIG_RTHREAD_SHIFT) |
>>> +             (mchan->thread << MDC_READ_PORT_CONFIG_WTHREAD_SHIFT);
>>> +     ldesc->read_addr = src;
>>> +     ldesc->write_addr = dst;
>>> +     ldesc->xfer_size = len - 1;
>>> +     ldesc->node_addr = 0;
>>> +     ldesc->cmds_done = 0;
>>> +     ldesc->ctrl_status = MDC_CONTROL_AND_STATUS_LIST_EN |
>>> +             MDC_CONTROL_AND_STATUS_EN;
>>> +     ldesc->next_desc = NULL;
>>> +
>>> +     if (IS_ALIGNED(dst, mdma->bus_width) &&
>>> +         IS_ALIGNED(src, mdma->bus_width))
>>> +             max_burst = mdma->bus_width * mdma->max_burst_mult;
>>> +     else
>>> +             max_burst = mdma->bus_width * (mdma->max_burst_mult - 1);
>>> +
>>> +     if (dir == DMA_MEM_TO_DEV) {
>>> +             ldesc->gen_conf |= MDC_GENERAL_CONFIG_INC_R;
>>> +             ldesc->readport_conf |= MDC_READ_PORT_CONFIG_DREQ_ENABLE;
>>> +             mdc_set_read_width(ldesc, mdma->bus_width);
>>> +             mdc_set_write_width(ldesc, mchan->config.dst_addr_width);
>>> +             burst_size = min(max_burst, mchan->config.dst_maxburst *
>>> +                              mchan->config.dst_addr_width);
> 
>> why is this calculation done for burst size? Shouldn't we take the
>> config.dst_maxburst value configured by client?
> 
> It's possible that the client could select a burst size that is too
> large (i.e. it exceeds the max_burst calculated above), so we cap it
> here to max_burst.
> 
>>> +static struct dma_async_tx_descriptor *mdc_prep_slave_sg(
>>> +     struct dma_chan *chan, struct scatterlist *sgl,
>>> +     unsigned int sg_len, enum dma_transfer_direction dir,
>>> +     unsigned long flags, void *context)
>>> +{
>>> +     struct mdc_chan *mchan = to_mdc_chan(chan);
>>> +     struct mdc_dma *mdma = mchan->mdma;
>>> +     struct mdc_tx_desc *mdesc;
>>> +     struct scatterlist *sg;
>>> +     struct mdc_hw_list_desc *curr, *prev = NULL;
>>> +     dma_addr_t curr_phys, prev_phys;
>>> +     unsigned int i;
>>> +
>>> +     if (!sgl)
>>> +             return NULL;
>>> +
>>> +     if (!is_slave_direction(dir))
>>> +             return NULL;
>>> +
>>> +     if (mdc_check_slave_width(mchan, dir) < 0)
>>> +             return NULL;
>>> +
>>> +     mdesc = kzalloc(sizeof(*mdesc), GFP_NOWAIT);
>>> +     if (!mdesc)
>>> +             return NULL;
>>> +     mdesc->chan = mchan;
>>> +
>>> +     for_each_sg(sgl, sg, sg_len, i) {
>>> +             dma_addr_t buf = sg_dma_address(sg);
>>> +             size_t buf_len = sg_dma_len(sg);
>>> +
>>> +             while (buf_len > 0) {
>>> +                     size_t xfer_size;
>>> +
>>> +                     curr = dma_pool_alloc(mdma->desc_pool, GFP_NOWAIT,
>>> +                                           &curr_phys);
>>> +                     if (!curr)
>>> +                             goto free_desc;
>>> +
>>> +                     if (!prev) {
>>> +                             mdesc->list_phys = curr_phys;
>>> +                             mdesc->list = curr;
>>> +                     } else {
>>> +                             prev->node_addr = curr_phys;
>>> +                             prev->next_desc = curr;
>>> +                     }
>>> +
>>> +                     xfer_size = min_t(size_t, mdma->max_xfer_size,
>>> +                                       buf_len);
>>> +
>>> +                     if (dir == DMA_MEM_TO_DEV) {
>>> +                             mdc_list_desc_config(mchan, curr, dir, buf,
>>> +                                                  mchan->config.dst_addr,
>>> +                                                  xfer_size);
>>> +                     } else {
>>> +                             mdc_list_desc_config(mchan, curr, dir,
>>> +                                                  mchan->config.src_addr,
>>> +                                                  buf, xfer_size);
>>> +                     }
>>> +
>>> +                     prev = curr;
>>> +                     prev_phys = curr_phys;
>>> +
>>> +                     mdesc->list_len++;
>>> +                     mdesc->list_xfer_size += xfer_size;
>>> +                     buf += xfer_size;
>>> +                     buf_len -= xfer_size;
> 
>> i see this pattern is repeat in all the .prepare calls, can we make it bit
>> generic and use that in the these three calls..
> 
> I've pulled out almost all of the common stuff into
> mdc_list_desc_config().  I suppose the list manipulation could be
> moved there as well, but the rest is all slightly different in each
> case.
> 
>>> +     dma_cap_zero(mdma->dma_dev.cap_mask);
>>> +     dma_cap_set(DMA_SLAVE, mdma->dma_dev.cap_mask);
>>> +     dma_cap_set(DMA_PRIVATE, mdma->dma_dev.cap_mask);
>>> +     dma_cap_set(DMA_CYCLIC, mdma->dma_dev.cap_mask);
> 
>> and you dont seen to support pause/resume, though not a blocker but is it
>> not supported in HW or driver doesn't?
> 
> Someone from IMG can correct me if I'm wrong, but I don't think the HW
> supports it.

Pause / resume is not supported by the MDC hardware. 

James. 