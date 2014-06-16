Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaFPMUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:20:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48433 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaFPMUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:20:40 -0400
Date: Mon, 16 Jun 2014 13:20:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, chris@printf.net, ulf.hansson@linaro.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, rogerable@realtek.com,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH 1/2] mfd: rtsx: add dma transfer function
Message-ID: <20140616122032.GS14323@lee--X1>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
 <9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> rtsx driver using a single function for transfer data, dma map/unmap are
> placed in one fix function. We need map/unmap dma in different place(for
> mmc async driver), so add three function for dma map, dma transfer and
> dma unmap.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c       |   76 ++++++++++++++++++++++++++----------------
>  include/linux/mfd/rtsx_pci.h |    6 ++++
>  2 files changed, 54 insertions(+), 28 deletions(-)

I don't see any glaring issues with this patch.  Does it rely on the
first patch, or vise versa, or can it just be applied?

> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 1d15735..d01b8c2 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -337,40 +337,64 @@ static void rtsx_pci_add_sg_tbl(struct rtsx_pcr *pcr,
>  int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
>  		int num_sg, bool read, int timeout)
>  {
> -	struct completion trans_done;
> -	u8 dir;
> -	int err = 0, i, count;
> -	long timeleft;
> -	unsigned long flags;
> -	struct scatterlist *sg;
> -	enum dma_data_direction dma_dir;
> -	u32 val;
> -	dma_addr_t addr;
> -	unsigned int len;
> +	int err = 0, count;
>  
>  	dev_dbg(&(pcr->pci->dev), "--> %s: num_sg = %d\n", __func__, num_sg);
> +	count = rtsx_pci_dma_map_sg(pcr, sglist, num_sg, read);
> +	if (count < 1)
> +		return -EINVAL;
> +	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
> +
> +	err = rtsx_pci_dma_transfer(pcr, sglist, count, read, timeout);
> +
> +	rtsx_pci_dma_unmap_sg(pcr, sglist, num_sg, read);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(rtsx_pci_transfer_data);
> +
> +int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int num_sg, bool read)
> +{
> +	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>  
> -	/* don't transfer data during abort processing */
>  	if (pcr->remove_pci)
>  		return -EINVAL;
>  
>  	if ((sglist == NULL) || (num_sg <= 0))
>  		return -EINVAL;
>  
> -	if (read) {
> -		dir = DEVICE_TO_HOST;
> -		dma_dir = DMA_FROM_DEVICE;
> -	} else {
> -		dir = HOST_TO_DEVICE;
> -		dma_dir = DMA_TO_DEVICE;
> -	}
> +	return dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dir);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_pci_dma_map_sg);
>  
> -	count = dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
> -	if (count < 1) {
> -		dev_err(&(pcr->pci->dev), "scatterlist map failed\n");
> +void rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int num_sg, bool read)
> +{
> +	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +
> +	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dir);
> +}
> +EXPORT_SYMBOL_GPL(rtsx_pci_dma_unmap_sg);
> +
> +int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int count, bool read, int timeout)
> +{
> +	struct completion trans_done;
> +	struct scatterlist *sg;
> +	dma_addr_t addr;
> +	long timeleft;
> +	unsigned long flags;
> +	unsigned int len;
> +	int i, err = 0;
> +	u32 val;
> +	u8 dir = read ? DEVICE_TO_HOST : HOST_TO_DEVICE;
> +
> +	if (pcr->remove_pci)
> +		return -ENODEV;
> +
> +	if ((sglist == NULL) || (count < 1))
>  		return -EINVAL;
> -	}
> -	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
>  
>  	val = ((u32)(dir & 0x01) << 29) | TRIG_DMA | ADMA_MODE;
>  	pcr->sgi = 0;
> @@ -400,12 +424,10 @@ int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
>  	}
>  
>  	spin_lock_irqsave(&pcr->lock, flags);
> -
>  	if (pcr->trans_result == TRANS_RESULT_FAIL)
>  		err = -EINVAL;
>  	else if (pcr->trans_result == TRANS_NO_DEVICE)
>  		err = -ENODEV;
> -
>  	spin_unlock_irqrestore(&pcr->lock, flags);
>  
>  out:
> @@ -413,8 +435,6 @@ out:
>  	pcr->done = NULL;
>  	spin_unlock_irqrestore(&pcr->lock, flags);
>  
> -	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
> -
>  	if ((err < 0) && (err != -ENODEV))
>  		rtsx_pci_stop_cmd(pcr);
>  
> @@ -423,7 +443,7 @@ out:
>  
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(rtsx_pci_transfer_data);
> +EXPORT_SYMBOL_GPL(rtsx_pci_dma_transfer);
>  
>  int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len)
>  {
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index a383597..74346d5 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -943,6 +943,12 @@ void rtsx_pci_send_cmd_no_wait(struct rtsx_pcr *pcr);
>  int rtsx_pci_send_cmd(struct rtsx_pcr *pcr, int timeout);
>  int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
>  		int num_sg, bool read, int timeout);
> +int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int num_sg, bool read);
> +void rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int num_sg, bool read);
> +int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
> +		int count, bool read, int timeout);
>  int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
>  int rtsx_pci_write_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
>  int rtsx_pci_card_pull_ctl_enable(struct rtsx_pcr *pcr, int card);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
