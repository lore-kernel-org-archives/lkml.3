Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaI1CbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:31:09 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55589 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaI1CbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:31:07 -0400
Message-ID: <542772E7.80902@kernel.dk>
Date: Sat, 27 Sep 2014 20:31:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kieran Kunhya <kieran@kunhya.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Fabian Frederick <fabf@skynet.be>,
        Akhil Bhansali <abhansali@stec-inc.com>, Jiri Kosina <jkosina@suse.cz>,
        Alan <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] block: Add support for Sony SxS cards
References: <1405814499-4163-1-git-send-email-kieran@kunhya.com> <1411861415-16210-1-git-send-email-kieran@kunhya.com>
In-Reply-To: <1411861415-16210-1-git-send-email-kieran@kunhya.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-27 17:43, Kieran Kunhya wrote:
> +static void sxs_memcpy_read(struct sxs_device *dev, unsigned long sector,
> +			    unsigned long nsect, char *buffer)
> +{
> +	struct pci_dev *pdev = dev->pci_dev;
> +	u32 status;
> +	u32 data[4];
> +	u16 *tmp;
> +	u32 *tmp2;
> +
> +	void *dma2;
> +	dma_addr_t dma2_handle;
> +	void *dma3;
> +	dma_addr_t dma3_handle;
> +
> +	sector >>= dev->sector_shift;
> +	nsect >>= dev->sector_shift;
> +
> +	/* Read */
> +	dma2 = pci_alloc_consistent(pdev, 8192, &dma2_handle);
> +	dma3 = pci_alloc_consistent(pdev, 8192, &dma3_handle);
> +
> +	tmp = dma2;
> +	tmp2 = dma3;
> +	tmp2[0] = dma2_handle;
> +	tmp2[2] = dma3_handle;
> +
> +	dev_dbg_ratelimited(&pdev->dev, "CALL %lu %lu\n",
> +			    sector & 0xffffffff, nsect & 0xffffffff);
> +
> +	reinit_completion(&dev->irq_response);
> +	status = readl(dev->mmio+SXS_STATUS_REG);
> +	data[0] = cpu_to_le32(0x00010028);
> +	data[1] = cpu_to_le32(sector & 0xffffffff);
> +	data[2] = 0x0;
> +	data[3] = cpu_to_le32(nsect & 0xffffffff);
> +	memcpy_toio(dev->mmio, data, sizeof(data));
> +	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
> +	writel(0x80, dev->mmio+SXS_CONTROL_REG);
> +
> +	if (!wait_for_completion_timeout(&dev->irq_response,
> +					 msecs_to_jiffies(5000))) {
> +		dev_dbg(&pdev->dev, "No IRQ\n");
> +	}
> +
> +	reinit_completion(&dev->irq_response);
> +	writel(dma3_handle, dev->mmio+SXS_MASTER_LINK_REG_L);
> +	writel(0x0, dev->mmio+SXS_MASTER_LINK_REG_H);
> +	writel(0x20, dev->mmio+SXS_CONTROL_REG);
> +
> +	if (!wait_for_completion_timeout(&dev->irq_response,
> +					 msecs_to_jiffies(5000))) {
> +		dev_dbg(&pdev->dev, "No IRQ\n");
> +	}
> +
> +	/* FIXME: Use DMA properly */
> +	memcpy(buffer, dma2, dev->sector_size * nsect);
> +
> +	dev_dbg_ratelimited(&pdev->dev, "boot-signature %x\n",
> +			    tmp[255]);
> +
> +	writel(0, dev->mmio+SXS_ENABLE_REG);
> +
> +	pci_free_consistent(pdev, 8192, dma3, dma3_handle);
> +	pci_free_consistent(pdev, 8192, dma2, dma2_handle);
> +}
> +
> +static void sxs_request(struct request_queue *q, struct bio *bio)
> +{
> +	struct bvec_iter iter;
> +	struct bio_vec bvec;
> +	char *buffer;
> +	unsigned long flags;
> +	struct sxs_device *dev = q->queuedata;
> +	struct pci_dev *pdev = dev->pci_dev;
> +	sector_t sector = bio->bi_iter.bi_sector;
> +
> +	bio_for_each_segment(bvec, bio, iter) {
> +		dev_dbg_ratelimited(&pdev->dev, "REQUEST %i %i %i\n",
> +				    bio_cur_bytes(bio), bio->bi_vcnt,
> +				    bvec.bv_len);
> +		buffer = bvec_kmap_irq(&bvec, &flags);
> +		sxs_memcpy_read(dev, sector, bio_cur_bytes(bio) >> 9,
> +				buffer);
> +		sector += bio_cur_bytes(bio) >> 9;
> +		bvec_kunmap_irq(buffer, &flags);
> +	}
> +
> +	bio_endio(bio, 0);

So a few questions here... This device only does reads? And it seems to 
be assuming that only reads end up in the request handler? How so?

Second question. IO never fails? There's no status checking and IO is 
always ended successfully. This too seems odd.

Third, this wong work as-is, at least not of HIGHMEM is used. After the 
bvec_kmap_irq(), irqs will be disabled. But your sxs_memcpy_read() 
invokes schedule through the completion waits, that will instantly go bad.

-- 
Jens Axboe

