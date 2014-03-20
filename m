Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbaCTXSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:18:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932AbaCTXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:18:29 -0400
Date: Thu, 20 Mar 2014 16:18:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v4 3/3] memstick: Add realtek USB memstick host driver
Message-Id: <20140320161827.5904bc407f9d3490514fd84e@linux-foundation.org>
In-Reply-To: <1392199238-14500-4-git-send-email-rogerable@realtek.com>
References: <1392199238-14500-1-git-send-email-rogerable@realtek.com>
	<1392199238-14500-4-git-send-email-rogerable@realtek.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 18:00:38 +0800 <rogerable@realtek.com> wrote:

> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB memstick host driver provides memstick host support based on the
> Realtek USB card reader MFD driver.
> 
> ...
>
> +#include <linux/module.h>
> +#include <linux/highmem.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/workqueue.h>
> +#include <linux/memstick.h>
> +#include <linux/kthread.h>
> +#include <linux/mfd/rtsx_usb.h>
> +#include <linux/pm_runtime.h>
> +#include <asm/unaligned.h>
> +
> +struct rtsx_usb_ms {
> +	struct platform_device	*pdev;
> +	struct rtsx_ucr	*ucr;
> +	struct memstick_host	*msh;
> +	struct memstick_request	*req;
> +
> +	struct mutex		host_mutex;

Should have included mutex.h.

> +	struct work_struct	handle_req;
> +
> +	struct task_struct	*detect_ms;

sched.h.

> +	struct completion	detect_ms_exit;

completion.h.

> +	u8			ssc_depth;
> +	unsigned int		clock;
> +	int			power_mode;
> +	unsigned char           ifmode;
> +	bool			eject;
> +};
> +
> 
> ...
>
> +
> +#else
> +
> +#define ms_print_debug_regs(host)

static void ms_print_debug_regs(struct rtsx_usb_ms *host)
{
}

It is good to have the same signature for either case.  And doing it in
C provides typechecking and can avoid variable-unused warnings.  

> +#endif
> 
> ...
>
> +static int ms_power_on(struct rtsx_usb_ms *host)
> +{
> +	struct rtsx_ucr *ucr = host->ucr;
> +	int err;
> +
> +	dev_dbg(ms_dev(host), "%s\n", __func__);
> +
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_SELECT, 0x07, MS_MOD_SEL);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_SHARE_MODE,
> +			CARD_SHARE_MASK, CARD_SHARE_MS);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_CLK_EN,
> +			MS_CLK_EN, MS_CLK_EN);
> +	err = rtsx_usb_send_cmd(ucr, MODE_C, 100);
> +	if (err < 0)
> +		return err;
> +
> +	if (CHECK_PKG(ucr, LQFP48))
> +		err = ms_pull_ctl_enable_lqfp48(ucr);
> +	else
> +		err = ms_pull_ctl_enable_qfn24(ucr);
> +	if (err < 0)
> +		return err;
> +
> +	err = rtsx_usb_write_register(ucr, CARD_PWR_CTL,
> +			POWER_MASK, PARTIAL_POWER_ON);
> +	if (err)
> +		return err;
> +
> +	/* Wait ms power stable */

Comment is strange.

> +	usleep_range(800, 1000);
> +
> +	rtsx_usb_init_cmd(ucr);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PWR_CTL,
> +			POWER_MASK, POWER_ON);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_OE,
> +			MS_OUTPUT_EN, MS_OUTPUT_EN);
> +
> +	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
> +}
> +
> 
> ...
>
> +static int ms_transfer_data(struct rtsx_usb_ms *host, unsigned char data_dir,
> +		u8 tpc, u8 cfg, struct scatterlist *sg)
> +{
> +	struct rtsx_ucr *ucr = host->ucr;
> +	int err;
> +	unsigned int length = sg->length;
> +	u16 sec_cnt = (u16)(length / 512);
> +	u8 trans_mode, dma_dir, flag;
> +	unsigned int pipe;
> +	struct memstick_dev *card = host->msh->card;
> +
> +	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x, data_dir = %s, length = %d\n",

length = %u

> +			__func__, tpc, (data_dir == READ) ? "READ" : "WRITE",
> +			length);
> +
> +	if (data_dir == READ) {
> +		flag = MODE_CDIR;
> +		dma_dir = DMA_DIR_FROM_CARD;
> +		if (card->id.type != MEMSTICK_TYPE_PRO)
> +			trans_mode = MS_TM_NORMAL_READ;
> +		else
> +			trans_mode = MS_TM_AUTO_READ;
> +		pipe = usb_rcvbulkpipe(ucr->pusb_dev, EP_BULK_IN);
> +	} else {
> +		flag = MODE_CDOR;
> +		dma_dir = DMA_DIR_TO_CARD;
> +		if (card->id.type != MEMSTICK_TYPE_PRO)
> +			trans_mode = MS_TM_NORMAL_WRITE;
> +		else
> +			trans_mode = MS_TM_AUTO_WRITE;
> +		pipe = usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT);
> +	}
> +
> +	rtsx_usb_init_cmd(ucr);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
> +	if (card->id.type == MEMSTICK_TYPE_PRO) {
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_SECTOR_CNT_H,
> +				0xFF, (u8)(sec_cnt >> 8));
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_SECTOR_CNT_L,
> +				0xFF, (u8)sec_cnt);
> +	}
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MC_DMA_TC3,
> +			0xFF, (u8)(length >> 24));
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MC_DMA_TC2,
> +			0xFF, (u8)(length >> 16));
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MC_DMA_TC1,
> +			0xFF, (u8)(length >> 8));
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MC_DMA_TC0, 0xFF,
> +			(u8)length);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MC_DMA_CTL,
> +			0x03 | DMA_PACK_SIZE_MASK, dma_dir | DMA_EN | DMA_512);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_DATA_SOURCE,
> +			0x01, RING_BUFFER);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TRANSFER,
> +			0xFF, MS_TRANSFER_START | trans_mode);
> +	rtsx_usb_add_cmd(ucr, CHECK_REG_CMD, MS_TRANSFER,
> +			MS_TRANSFER_END, MS_TRANSFER_END);
> +
> +	err = rtsx_usb_send_cmd(ucr, flag | STAGE_MS_STATUS, 100);
> +	if (err)
> +		return err;
> +
> +	err = rtsx_usb_transfer_data(ucr, pipe, sg, length,
> +			1, NULL, 10000);
> +	if (err)
> +		goto err_out;
> +
> +	err = rtsx_usb_get_rsp(ucr, 3, 15000);
> +	if (err)
> +		goto err_out;
> +
> +	if (ucr->rsp_buf[0] & MS_TRANSFER_ERR ||
> +	    ucr->rsp_buf[1] & (MS_CRC16_ERR | MS_RDY_TIMEOUT)) {
> +		err = -EIO;
> +		goto err_out;
> +	}
> +	return 0;
> +err_out:
> +	ms_clear_error(host);
> +	return err;
> +}
> +
> +static int ms_write_bytes(struct rtsx_usb_ms *host, u8 tpc,
> +		u8 cfg, u8 cnt, u8 *data, u8 *int_reg)
> +{
> +	struct rtsx_ucr *ucr = host->ucr;
> +	int err, i;
> +
> +	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x\n", __func__, tpc);
> +
> +	if (!data)
> +		return -EINVAL;

Is this needed?

> +	rtsx_usb_init_cmd(ucr);
> +
> +	for (i = 0; i < cnt; i++)
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				PPBUF_BASE2 + i, 0xFF, data[i]);
> +
> +	if (cnt % 2)
> +		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
> +				PPBUF_BASE2 + i, 0xFF, 0xFF);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_BYTE_CNT, 0xFF, cnt);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_DATA_SOURCE,
> +			0x01, PINGPONG_BUFFER);
> +
> +	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, MS_TRANSFER,
> +			0xFF, MS_TRANSFER_START | MS_TM_WRITE_BYTES);
> +	rtsx_usb_add_cmd(ucr, CHECK_REG_CMD, MS_TRANSFER,
> +			MS_TRANSFER_END, MS_TRANSFER_END);
> +	rtsx_usb_add_cmd(ucr, READ_REG_CMD, MS_TRANS_CFG, 0, 0);
> +
> +	err = rtsx_usb_send_cmd(ucr, MODE_CR, 100);
> +	if (err)
> +		return err;
> +
> +	err = rtsx_usb_get_rsp(ucr, 2, 5000);
> +	if (err || (ucr->rsp_buf[0] & MS_TRANSFER_ERR)) {
> +		u8 val;
> +
> +		rtsx_usb_ep0_read_register(ucr, MS_TRANS_CFG, &val);
> +		dev_dbg(ms_dev(host), "MS_TRANS_CFG: 0x%02x\n", val);
> +
> +		if (int_reg)
> +			*int_reg = val & 0x0F;
> +
> +		ms_print_debug_regs(host);
> +
> +		ms_clear_error(host);
> +
> +		if (!(tpc & 0x08)) {
> +			if (val & MS_CRC16_ERR)
> +				return -EIO;
> +		} else {
> +			if (!(val & 0x80)) {
> +				if (val & (MS_INT_ERR | MS_INT_CMDNK))
> +					return -EIO;
> +			}
> +		}
> +
> +		return -ETIMEDOUT;
> +	}
> +
> +	if (int_reg)
> +		*int_reg = ucr->rsp_buf[1] & 0x0F;
> +
> +	return 0;
> +}
> +
> 
> ...
>
> +static void rtsx_usb_ms_request(struct memstick_host *msh)
> +{
> +	struct rtsx_usb_ms *host = memstick_priv(msh);
> +
> +	dev_dbg(ms_dev(host), "--> %s\n", __func__);
> +
> +	schedule_work(&host->handle_req);
> +}

I see a schedule_work() but I see no flush_scheduled_work() on the
shutdown/rmmod path.  Do we have races here?  Should the shutdown paths
be waiting for work completion before tearing things down?

> 
> ...
>
> +static int rtsx_usb_detect_ms_card(void *__host)
> +{
> +	struct rtsx_usb_ms *host = (struct rtsx_usb_ms *)__host;
> +	struct rtsx_ucr *ucr = host->ucr;
> +	u8 val = 0;
> +	int err;
> +
> +	for (;;) {
> +		mutex_lock(&ucr->dev_mutex);
> +
> +		/* Check pending MS card changes */
> +		err = rtsx_usb_read_register(ucr, CARD_INT_PEND, &val);
> +		if (err) {
> +			mutex_unlock(&ucr->dev_mutex);
> +			goto poll_again;
> +		}
> +
> +		/* Clear the pending */
> +		rtsx_usb_write_register(ucr, CARD_INT_PEND,
> +				XD_INT | MS_INT | SD_INT,
> +				XD_INT | MS_INT | SD_INT);
> +
> +		mutex_unlock(&ucr->dev_mutex);
> +
> +		if (val & MS_INT) {
> +			dev_dbg(ms_dev(host), "MS slot change detected\n");
> +			memstick_detect_change(host->msh);
> +		}
> +
> +poll_again:
> +		if (host->eject)
> +			break;
> +
> +		msleep(1000);
> +	}
> +
> +	complete(&host->detect_ms_exit);
> +	return 0;
> +}

Would be helpful to add a comment explaining that this is a kernel
thread and describing its lifetime, exit conditions, etc.

> +static int rtsx_usb_ms_drv_probe(struct platform_device *pdev)
> +{
> +	struct memstick_host *msh;
> +	struct rtsx_usb_ms *host;
> +	struct rtsx_ucr *ucr;
> +	int err;
> +
> +	ucr = usb_get_intfdata(to_usb_interface(pdev->dev.parent));
> +	if (!ucr)
> +		return -ENXIO;
> +
> +	dev_dbg(&(pdev->dev),
> +			"Realtek USB Memstick controller found\n");
> +
> +	msh = memstick_alloc_host(sizeof(*host), &pdev->dev);
> +	if (!msh)
> +		return -ENOMEM;
> +
> +	host = memstick_priv(msh);
> +	host->ucr = ucr;
> +	host->msh = msh;
> +	host->pdev = pdev;
> +	host->power_mode = MEMSTICK_POWER_OFF;
> +	platform_set_drvdata(pdev, host);
> +
> +	mutex_init(&host->host_mutex);
> +	INIT_WORK(&host->handle_req, rtsx_usb_ms_handle_req);
> +
> +	init_completion(&host->detect_ms_exit);
> +	host->detect_ms = kthread_create(rtsx_usb_detect_ms_card, host,
> +			"rtsx_usb_ms_%d", pdev->id);
> +	if (IS_ERR(host->detect_ms)) {
> +		dev_dbg(&(pdev->dev),
> +				"Unable to create polling thread.\n");
> +		err = PTR_ERR(host->detect_ms);
> +		goto err_out;
> +	}
> +
> +	msh->request = rtsx_usb_ms_request;
> +	msh->set_param = rtsx_usb_ms_set_param;
> +	msh->caps = MEMSTICK_CAP_PAR4;
> +
> +	pm_runtime_enable(&pdev->dev);
> +	err = memstick_add_host(msh);
> +	if (err)
> +		goto err_out;

Isn't that kernel thread still running?

> +	wake_up_process(host->detect_ms);
> +	return 0;
> +err_out:
> +	memstick_free_host(msh);
> +	return err;
> +}
> +
> +static int rtsx_usb_ms_drv_remove(struct platform_device *pdev)
> +{
> +	struct rtsx_usb_ms *host = platform_get_drvdata(pdev);
> +	struct memstick_host *msh;
> +	int err;
> +
> +	if (!host)
> +		return 0;

Can this happen?

> +	msh = host->msh;
> +	host->eject = true;
> +
> +	mutex_lock(&host->host_mutex);
> +	if (host->req) {
> +		dev_dbg(&(pdev->dev),
> +			"%s: Controller removed during transfer\n",
> +			dev_name(&msh->dev));
> +		host->req->error = -ENOMEDIUM;
> +		do {
> +			err = memstick_next_req(msh, &host->req);
> +			if (!err)
> +				host->req->error = -ENOMEDIUM;
> +		} while (!err);
> +	}
> +	mutex_unlock(&host->host_mutex);
> +
> +	wait_for_completion(&host->detect_ms_exit);

OK, so here we're waiting for the kernel thread to terminate.

> +	memstick_remove_host(msh);
> +	memstick_free_host(msh);
> +
> +	/* Balance possible unbalanced usage count
> +	 * e.g. unconditional module removal
> +	 */
> +	if (pm_runtime_active(ms_dev(host)))
> +		pm_runtime_put(ms_dev(host));
> +
> +	pm_runtime_disable(&pdev->dev);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	dev_dbg(&(pdev->dev),
> +		": Realtek USB Memstick controller has been removed\n");
> +
> +	return 0;
> +}
> 
> ...
>

