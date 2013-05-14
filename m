Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3ENJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:09:27 -0400
Received: from smtp-out-187.synserver.de ([212.40.185.187]:1067 "EHLO
	smtp-out-187.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3ENJJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:09:24 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9307
Message-ID: <5191FF2A.3050801@metafoo.de>
Date: Tue, 14 May 2013 11:08:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: padma.v@samsung.com
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend 2/2] dma: pl330: Use the common of_dma_xlate_by_chan_id
References: <23087644.68271368521594139.JavaMail.weblogic@epv6ml09>
In-Reply-To: <23087644.68271368521594139.JavaMail.weblogic@epv6ml09>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 10:53 AM, PADMAVATHI VENNA wrote:
> Hi Lars,
> 
> As I remember Vinod had asked you to keep DMA_CYCLIC capability on both controller and client side.  But I didn't see in this patch set. 

That doesn't make too much sense, since it means you'd only be able to
request channels for controllers which support cyclic transfers.

> Otherwise your patches looks good to me.
> 
> Thanks
> Padma
> ------- Original Message -------
> Sender : Lars-Peter Clausen<lars@metafoo.de>
> Date : May 13, 2013 01:02 (GMT+09:00)
> Title : [PATCH resend 2/2] dma: pl330: Use the common of_dma_xlate_by_chan_id
> 
> Use the generic of_dma_xlate_by_chan_id xlate callback instead of a custom
> implementation.
> 
> There is one minor difference between the generic of_dma_xlate_by_chan_id
> function and the pl330 specific one. of_dma_xlate_by_chan_id only sets the
> DMA_SLAVE capability for the channel capability mask, while the pl330 driver
> additionally sets the DMA_CYCLIC capability. But since all pl330 channels which
> have the DMA_SLAVE capability set also have DMA_CYCLIC capability set both
> functions will have the same result.
> 
> Signed-off-by: Lars-Peter Clausen 
> ---
> drivers/dma/pl330.c | 41 +----------------------------------------
> 1 file changed, 1 insertion(+), 40 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index a17553f..c831fae 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -608,11 +608,6 @@ struct dma_pl330_desc {
> struct dma_pl330_chan *pchan;
> };
> 
> -struct dma_pl330_filter_args {
> - struct dma_pl330_dmac *pdmac;
> - unsigned int chan_id;
> -};
> -
> static inline void _callback(struct pl330_req *r, enum pl330_op_err err)
> {
> if (r && r->xfer_cb)
> @@ -2358,16 +2353,6 @@ static void dma_pl330_rqcb(void *token, enum pl330_op_err err)
> tasklet_schedule(&pch->task);
> }
> 
> -static bool pl330_dt_filter(struct dma_chan *chan, void *param)
> -{
> - struct dma_pl330_filter_args *fargs = param;
> -
> - if (chan->device != &fargs->pdmac->ddma)
> - return false;
> -
> - return (chan->chan_id == fargs->chan_id);
> -}
> -
> bool pl330_filter(struct dma_chan *chan, void *param)
> {
> u8 *peri_id;
> @@ -2380,30 +2365,6 @@ bool pl330_filter(struct dma_chan *chan, void *param)
> }
> EXPORT_SYMBOL(pl330_filter);
> 
> -static struct dma_chan *of_dma_pl330_xlate(struct of_phandle_args *dma_spec,
> - struct of_dma *ofdma)
> -{
> - int count = dma_spec->args_count;
> - struct dma_pl330_dmac *pdmac = ofdma->of_dma_data;
> - struct dma_pl330_filter_args fargs;
> - dma_cap_mask_t cap;
> -
> - if (!pdmac)
> - return NULL;
> -
> - if (count != 1)
> - return NULL;
> -
> - fargs.pdmac = pdmac;
> - fargs.chan_id = dma_spec->args[0];
> -
> - dma_cap_zero(cap);
> - dma_cap_set(DMA_SLAVE, cap);
> - dma_cap_set(DMA_CYCLIC, cap);
> -
> - return dma_request_channel(cap, pl330_dt_filter, &fargs);
> -}
> -
> static int pl330_alloc_chan_resources(struct dma_chan *chan)
> {
> struct dma_pl330_chan *pch = to_pchan(chan);
> @@ -2989,7 +2950,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> 
> if (adev->dev.of_node) {
> ret = of_dma_controller_register(adev->dev.of_node,
> - of_dma_pl330_xlate, pdmac);
> + of_dma_pl330_xlate, pd);
> if (ret) {
> dev_err(&adev->dev,
> "unable to register DMA to the generic DT DMA helpers\n");

