Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaHLQWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:22:07 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48039 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaHLQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <1405917465-18185-3-git-send-email-apelete@seketeli.net>
References: <1405917465-18185-1-git-send-email-apelete@seketeli.net>
	<1405917465-18185-3-git-send-email-apelete@seketeli.net>
Date: Tue, 12 Aug 2014 18:22:04 +0200
Message-ID: <CAPDyKFo4q+YWDgezZPqAHet0sBPE5WvnZzm00MHdf-+jZAY93Q@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] mmc: jz4740: prepare next dma transfer in parallel
 with current transfer
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Apelete Seketeli <apelete@seketeli.net>
Cc: Chris Ball <chris@printf.net>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 July 2014 06:37, Apelete Seketeli <apelete@seketeli.net> wrote:
> Make use of the MMC asynchronous request capability to prepare the
> next DMA transfer request in parallel with the current transfer.
> This is done by adding pre-request and post-request callbacks that are
> used by the MMC framework during an active data transfer.
>
> It should help reduce the impact of DMA preparation overhead on the SD
> card performance.
>
> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>

Thanks! Queued for 3.18.

Kind regards
Uffe


> ---
>  drivers/mmc/host/jz4740_mmc.c |  138 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 116 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
> index 049b133..14738cd 100644
> --- a/drivers/mmc/host/jz4740_mmc.c
> +++ b/drivers/mmc/host/jz4740_mmc.c
> @@ -114,6 +114,11 @@ enum jz4740_mmc_state {
>         JZ4740_MMC_STATE_DONE,
>  };
>
> +struct jz4740_mmc_host_next {
> +       int sg_len;
> +       s32 cookie;
> +};
> +
>  struct jz4740_mmc_host {
>         struct mmc_host *mmc;
>         struct platform_device *pdev;
> @@ -143,6 +148,7 @@ struct jz4740_mmc_host {
>         /* DMA support */
>         struct dma_chan *dma_rx;
>         struct dma_chan *dma_tx;
> +       struct jz4740_mmc_host_next next_data;
>         bool use_dma;
>         int sg_len;
>
> @@ -184,6 +190,9 @@ static int jz4740_mmc_acquire_dma_channels(struct jz4740_mmc_host *host)
>                 goto free_master_write;
>         }
>
> +       /* Initialize DMA pre request cookie */
> +       host->next_data.cookie = 1;
> +
>         return 0;
>
>  free_master_write:
> @@ -196,23 +205,72 @@ static inline int jz4740_mmc_get_dma_dir(struct mmc_data *data)
>         return (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>  }
>
> +static inline struct dma_chan *jz4740_mmc_get_dma_chan(struct jz4740_mmc_host *host,
> +                                                      struct mmc_data *data)
> +{
> +       return (data->flags & MMC_DATA_READ) ? host->dma_rx : host->dma_tx;
> +}
> +
>  static void jz4740_mmc_dma_unmap(struct jz4740_mmc_host *host,
>                                  struct mmc_data *data)
>  {
> -       struct dma_chan *chan;
> +       struct dma_chan *chan = jz4740_mmc_get_dma_chan(host, data);
>         enum dma_data_direction dir = jz4740_mmc_get_dma_dir(data);
>
> -       if (dir == DMA_TO_DEVICE)
> -               chan = host->dma_tx;
> -       else
> -               chan = host->dma_rx;
> -
>         dma_unmap_sg(chan->device->dev, data->sg, data->sg_len, dir);
>  }
>
> +/* Prepares DMA data for current/next transfer, returns non-zero on failure */
> +static int jz4740_mmc_prepare_dma_data(struct jz4740_mmc_host *host,
> +                                      struct mmc_data *data,
> +                                      struct jz4740_mmc_host_next *next,
> +                                      struct dma_chan *chan)
> +{
> +       struct jz4740_mmc_host_next *next_data = &host->next_data;
> +       enum dma_data_direction dir = jz4740_mmc_get_dma_dir(data);
> +       int sg_len;
> +
> +       if (!next && data->host_cookie &&
> +           data->host_cookie != host->next_data.cookie) {
> +               dev_warn(mmc_dev(host->mmc),
> +                        "[%s] invalid cookie: data->host_cookie %d host->next_data.cookie %d\n",
> +                        __func__,
> +                        data->host_cookie,
> +                        host->next_data.cookie);
> +               data->host_cookie = 0;
> +       }
> +
> +       /* Check if next job is already prepared */
> +       if (next || data->host_cookie != host->next_data.cookie) {
> +               sg_len = dma_map_sg(chan->device->dev,
> +                                   data->sg,
> +                                   data->sg_len,
> +                                   dir);
> +
> +       } else {
> +               sg_len = next_data->sg_len;
> +               next_data->sg_len = 0;
> +       }
> +
> +       if (sg_len <= 0) {
> +               dev_err(mmc_dev(host->mmc),
> +                       "Failed to map scatterlist for DMA operation\n");
> +               return -EINVAL;
> +       }
> +
> +       if (next) {
> +               next->sg_len = sg_len;
> +               data->host_cookie = ++next->cookie < 0 ? 1 : next->cookie;
> +       } else
> +               host->sg_len = sg_len;
> +
> +       return 0;
> +}
> +
>  static int jz4740_mmc_start_dma_transfer(struct jz4740_mmc_host *host,
>                                          struct mmc_data *data)
>  {
> +       int ret;
>         struct dma_chan *chan;
>         struct dma_async_tx_descriptor *desc;
>         struct dma_slave_config conf = {
> @@ -221,9 +279,8 @@ static int jz4740_mmc_start_dma_transfer(struct jz4740_mmc_host *host,
>                 .src_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
>                 .dst_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
>         };
> -       enum dma_data_direction dir = jz4740_mmc_get_dma_dir(data);
>
> -       if (dir == DMA_TO_DEVICE) {
> +       if (data->flags & MMC_DATA_WRITE) {
>                 conf.direction = DMA_MEM_TO_DEV;
>                 conf.dst_addr = host->mem_res->start + JZ_REG_MMC_TXFIFO;
>                 conf.slave_id = JZ4740_DMA_TYPE_MMC_TRANSMIT;
> @@ -235,16 +292,9 @@ static int jz4740_mmc_start_dma_transfer(struct jz4740_mmc_host *host,
>                 chan = host->dma_rx;
>         }
>
> -       host->sg_len = dma_map_sg(chan->device->dev,
> -                                 data->sg,
> -                                 data->sg_len,
> -                                 dir);
> -
> -       if (host->sg_len == 0) {
> -               dev_err(mmc_dev(host->mmc),
> -                       "Failed to map scatterlist for DMA operation\n");
> -               return -EINVAL;
> -       }
> +       ret = jz4740_mmc_prepare_dma_data(host, data, NULL, chan);
> +       if (ret)
> +               return ret;
>
>         dmaengine_slave_config(chan, &conf);
>         desc = dmaengine_prep_slave_sg(chan,
> @@ -269,6 +319,43 @@ dma_unmap:
>         return -ENOMEM;
>  }
>
> +static void jz4740_mmc_pre_request(struct mmc_host *mmc,
> +                                  struct mmc_request *mrq,
> +                                  bool is_first_req)
> +{
> +       struct jz4740_mmc_host *host = mmc_priv(mmc);
> +       struct mmc_data *data = mrq->data;
> +       struct jz4740_mmc_host_next *next_data = &host->next_data;
> +
> +       BUG_ON(data->host_cookie);
> +
> +       if (host->use_dma) {
> +               struct dma_chan *chan = jz4740_mmc_get_dma_chan(host, data);
> +
> +               if (jz4740_mmc_prepare_dma_data(host, data, next_data, chan))
> +                       data->host_cookie = 0;
> +       }
> +}
> +
> +static void jz4740_mmc_post_request(struct mmc_host *mmc,
> +                                   struct mmc_request *mrq,
> +                                   int err)
> +{
> +       struct jz4740_mmc_host *host = mmc_priv(mmc);
> +       struct mmc_data *data = mrq->data;
> +
> +       if (host->use_dma && data->host_cookie) {
> +               jz4740_mmc_dma_unmap(host, data);
> +               data->host_cookie = 0;
> +       }
> +
> +       if (err) {
> +               struct dma_chan *chan = jz4740_mmc_get_dma_chan(host, data);
> +
> +               dmaengine_terminate_all(chan);
> +       }
> +}
> +
>  /*----------------------------------------------------------------------------*/
>
>  static void jz4740_mmc_set_irq_enabled(struct jz4740_mmc_host *host,
> @@ -627,14 +714,19 @@ static irqreturn_t jz_mmc_irq_worker(int irq, void *devid)
>
>         case JZ4740_MMC_STATE_TRANSFER_DATA:
>                 if (host->use_dma) {
> -                       /* Use DMA if enabled, data transfer direction was
> -                        * defined  before in jz_mmc_prepare_data_transfer().
> +                       /* Use DMA if enabled.
> +                        * Data transfer direction is defined later by
> +                        * relying on data flags in
> +                        * jz4740_mmc_prepare_dma_data() and
> +                        * jz4740_mmc_start_dma_transfer().
>                          */
>                         timeout = jz4740_mmc_start_dma_transfer(host, data);
>                         data->bytes_xfered = data->blocks * data->blksz;
>                 } else if (data->flags & MMC_DATA_READ)
> -                       /* If DMA is not enabled, rely on data flags
> -                        * to establish data transfer direction.
> +                       /* Use PIO if DMA is not enabled.
> +                        * Data transfer direction was defined before
> +                        * by relying on data flags in
> +                        * jz_mmc_prepare_data_transfer().
>                          */
>                         timeout = jz4740_mmc_read_data(host, data);
>                 else
> @@ -809,6 +901,8 @@ static void jz4740_mmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
>
>  static const struct mmc_host_ops jz4740_mmc_ops = {
>         .request        = jz4740_mmc_request,
> +       .pre_req        = jz4740_mmc_pre_request,
> +       .post_req       = jz4740_mmc_post_request,
>         .set_ios        = jz4740_mmc_set_ios,
>         .get_ro         = mmc_gpio_get_ro,
>         .get_cd         = mmc_gpio_get_cd,
> --
> 1.7.10.4
>
