Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaGBIxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:53:19 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33979 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGBIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <7b58fb0b0915ea0b0838404c74ec22a3b6e5f5a8.1402037565.git.micky_ching@realsil.com.cn>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
	<7b58fb0b0915ea0b0838404c74ec22a3b6e5f5a8.1402037565.git.micky_ching@realsil.com.cn>
Date: Wed, 2 Jul 2014 10:53:15 +0200
Message-ID: <CAPDyKFobkjJ=O2TkinSAgeWv+dA87+dXahQ_c0MQ3bQfgy8cqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for async request
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>, Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Roger <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2014 09:05,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> Add support for non-blocking request, pre_req() runs dma_map_sg() and
> post_req() runs dma_unmap_sg(). This patch can increase card read/write
> speed, especially for high speed card and slow speed CPU.
>
> Test on intel i3(800MHz - 2.3GHz) performance mode(2.3GHz), SD card
> clock 208MHz
>
> run dd if=/dev/mmcblk0 of=/dev/null bs=64k count=1024
> before:
> 67108864 bytes (67 MB) copied, 0.85427 s, 78.6 MB/s
> after:
> 67108864 bytes (67 MB) copied, 0.74799 s, 89.7 MB/s
>
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

I assume Lee will pick this patchset through his mfd tree then. If
not, ping me and I will help.

Kind regards
Uffe

> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |  133 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 127 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index 1c68e0d..a2c0858 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -24,6 +24,7 @@
>  #include <linux/highmem.h>
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
> +#include <linux/workqueue.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/sd.h>
> @@ -36,7 +37,10 @@ struct realtek_pci_sdmmc {
>         struct rtsx_pcr         *pcr;
>         struct mmc_host         *mmc;
>         struct mmc_request      *mrq;
> +       struct workqueue_struct *workq;
> +#define SDMMC_WORKQ_NAME       "rtsx_pci_sdmmc_workq"
>
> +       struct work_struct      work;
>         struct mutex            host_mutex;
>
>         u8                      ssc_depth;
> @@ -48,6 +52,11 @@ struct realtek_pci_sdmmc {
>         int                     power_state;
>  #define SDMMC_POWER_ON         1
>  #define SDMMC_POWER_OFF                0
> +
> +       unsigned int            sg_count;
> +       s32                     cookie;
> +       unsigned int            cookie_sg_count;
> +       bool                    using_cookie;
>  };
>
>  static inline struct device *sdmmc_dev(struct realtek_pci_sdmmc *host)
> @@ -86,6 +95,77 @@ static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
>  #define sd_print_debug_regs(host)
>  #endif /* DEBUG */
>
> +/*
> + * sd_pre_dma_transfer - do dma_map_sg() or using cookie
> + *
> + * @pre: if called in pre_req()
> + * return:
> + *     0 - do dma_map_sg()
> + *     1 - using cookie
> + */
> +static int sd_pre_dma_transfer(struct realtek_pci_sdmmc *host,
> +               struct mmc_data *data, bool pre)
> +{
> +       struct rtsx_pcr *pcr = host->pcr;
> +       int read = data->flags & MMC_DATA_READ;
> +       int count = 0;
> +       int using_cookie = 0;
> +
> +       if (!pre && data->host_cookie && data->host_cookie != host->cookie) {
> +               dev_err(sdmmc_dev(host),
> +                       "error: data->host_cookie = %d, host->cookie = %d\n",
> +                       data->host_cookie, host->cookie);
> +               data->host_cookie = 0;
> +       }
> +
> +       if (pre || data->host_cookie != host->cookie) {
> +               count = rtsx_pci_dma_map_sg(pcr, data->sg, data->sg_len, read);
> +       } else {
> +               count = host->cookie_sg_count;
> +               using_cookie = 1;
> +       }
> +
> +       if (pre) {
> +               host->cookie_sg_count = count;
> +               if (++host->cookie < 0)
> +                       host->cookie = 1;
> +               data->host_cookie = host->cookie;
> +       } else {
> +               host->sg_count = count;
> +       }
> +
> +       return using_cookie;
> +}
> +
> +static void sdmmc_pre_req(struct mmc_host *mmc, struct mmc_request *mrq,
> +               bool is_first_req)
> +{
> +       struct realtek_pci_sdmmc *host = mmc_priv(mmc);
> +       struct mmc_data *data = mrq->data;
> +
> +       if (data->host_cookie) {
> +               dev_err(sdmmc_dev(host),
> +                       "error: reset data->host_cookie = %d\n",
> +                       data->host_cookie);
> +               data->host_cookie = 0;
> +       }
> +
> +       sd_pre_dma_transfer(host, data, true);
> +       dev_dbg(sdmmc_dev(host), "pre dma sg: %d\n", host->cookie_sg_count);
> +}
> +
> +static void sdmmc_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
> +               int err)
> +{
> +       struct realtek_pci_sdmmc *host = mmc_priv(mmc);
> +       struct rtsx_pcr *pcr = host->pcr;
> +       struct mmc_data *data = mrq->data;
> +       int read = data->flags & MMC_DATA_READ;
> +
> +       rtsx_pci_dma_unmap_sg(pcr, data->sg, data->sg_len, read);
> +       data->host_cookie = 0;
> +}
> +
>  static int sd_read_data(struct realtek_pci_sdmmc *host, u8 *cmd, u16 byte_cnt,
>                 u8 *buf, int buf_len, int timeout)
>  {
> @@ -415,7 +495,7 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
>
>         rtsx_pci_send_cmd_no_wait(pcr);
>
> -       err = rtsx_pci_transfer_data(pcr, data->sg, data->sg_len, read, 10000);
> +       err = rtsx_pci_dma_transfer(pcr, data->sg, host->sg_count, read, 10000);
>         if (err < 0) {
>                 sd_clear_error(host);
>                 return err;
> @@ -640,12 +720,24 @@ static int sd_tuning_rx(struct realtek_pci_sdmmc *host, u8 opcode)
>         return 0;
>  }
>
> -static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
> +static inline int sd_rw_cmd(struct mmc_command *cmd)
>  {
> -       struct realtek_pci_sdmmc *host = mmc_priv(mmc);
> +       return mmc_op_multi(cmd->opcode) ||
> +               (cmd->opcode == MMC_READ_SINGLE_BLOCK) ||
> +               (cmd->opcode == MMC_WRITE_BLOCK);
> +}
> +
> +static void sd_request(struct work_struct *work)
> +{
> +       struct realtek_pci_sdmmc *host = container_of(work,
> +                       struct realtek_pci_sdmmc, work);
>         struct rtsx_pcr *pcr = host->pcr;
> +
> +       struct mmc_host *mmc = host->mmc;
> +       struct mmc_request *mrq = host->mrq;
>         struct mmc_command *cmd = mrq->cmd;
>         struct mmc_data *data = mrq->data;
> +
>         unsigned int data_size = 0;
>         int err;
>
> @@ -677,13 +769,13 @@ static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
>         if (mrq->data)
>                 data_size = data->blocks * data->blksz;
>
> -       if (!data_size || mmc_op_multi(cmd->opcode) ||
> -                       (cmd->opcode == MMC_READ_SINGLE_BLOCK) ||
> -                       (cmd->opcode == MMC_WRITE_BLOCK)) {
> +       if (!data_size || sd_rw_cmd(cmd)) {
>                 sd_send_cmd_get_rsp(host, cmd);
>
>                 if (!cmd->error && data_size) {
>                         sd_rw_multi(host, mrq);
> +                       if (!host->using_cookie)
> +                               sdmmc_post_req(host->mmc, host->mrq, 0);
>
>                         if (mmc_op_multi(cmd->opcode) && mrq->stop)
>                                 sd_send_cmd_get_rsp(host, mrq->stop);
> @@ -712,6 +804,21 @@ finish:
>         mmc_request_done(mmc, mrq);
>  }
>
> +static void sdmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
> +{
> +       struct realtek_pci_sdmmc *host = mmc_priv(mmc);
> +       struct mmc_data *data = mrq->data;
> +
> +       mutex_lock(&host->host_mutex);
> +       host->mrq = mrq;
> +       mutex_unlock(&host->host_mutex);
> +
> +       if (sd_rw_cmd(mrq->cmd))
> +               host->using_cookie = sd_pre_dma_transfer(host, data, false);
> +
> +       queue_work(host->workq, &host->work);
> +}
> +
>  static int sd_set_bus_width(struct realtek_pci_sdmmc *host,
>                 unsigned char bus_width)
>  {
> @@ -1144,6 +1251,8 @@ out:
>  }
>
>  static const struct mmc_host_ops realtek_pci_sdmmc_ops = {
> +       .pre_req = sdmmc_pre_req,
> +       .post_req = sdmmc_post_req,
>         .request = sdmmc_request,
>         .set_ios = sdmmc_set_ios,
>         .get_ro = sdmmc_get_ro,
> @@ -1222,10 +1331,16 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
>                 return -ENOMEM;
>
>         host = mmc_priv(mmc);
> +       host->workq = create_singlethread_workqueue(SDMMC_WORKQ_NAME);
> +       if (!host->workq) {
> +               mmc_free_host(mmc);
> +               return -ENOMEM;
> +       }
>         host->pcr = pcr;
>         host->mmc = mmc;
>         host->pdev = pdev;
>         host->power_state = SDMMC_POWER_OFF;
> +       INIT_WORK(&host->work, sd_request);
>         platform_set_drvdata(pdev, host);
>         pcr->slots[RTSX_SD_CARD].p_dev = pdev;
>         pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
> @@ -1253,6 +1368,8 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
>         pcr->slots[RTSX_SD_CARD].card_event = NULL;
>         mmc = host->mmc;
>
> +       cancel_work_sync(&host->work);
> +
>         mutex_lock(&host->host_mutex);
>         if (host->mrq) {
>                 dev_dbg(&(pdev->dev),
> @@ -1271,6 +1388,10 @@ static int rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
>         mmc_remove_host(mmc);
>         host->eject = true;
>
> +       flush_workqueue(host->workq);
> +       destroy_workqueue(host->workq);
> +       host->workq = NULL;
> +
>         mmc_free_host(mmc);
>
>         dev_dbg(&(pdev->dev),
> --
> 1.7.9.5
>
