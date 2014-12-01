Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaLANIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:08:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48471 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbaLANIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:08:09 -0500
Message-ID: <547C6849.7060804@gmail.com>
Date: Mon, 01 Dec 2014 21:08:25 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mtd: hisilicon: add a new NAND controller driver
 for hisilicon hip04 Soc
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com> <1415105221-7732-2-git-send-email-wangzhou.bry@gmail.com> <20141201092529.GM29070@brian-ubuntu>
In-Reply-To: <20141201092529.GM29070@brian-ubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年12月01日 17:25, Brian Norris wrote:
> I forgot to mention these comments:
>
> On Tue, Nov 04, 2014 at 08:47:00PM +0800, Zhou Wang wrote:
>> +static int hisi_nfc_remove(struct platform_device *pdev)
>> +{
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +	struct mtd_info *mtd = &host->mtd;
>> +
>> +	nand_release(mtd);
>> +	dma_free_coherent(&pdev->dev, mtd->writesize + mtd->oobsize,
>> +			  host->buffer, host->dma_buffer);
>> +
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int hisi_nfc_suspend(struct platform_device *pdev,
>> +			       pm_message_t state)
>
> This is the wrong prototype. See struct dev_pm_ops.
>

My mistake here, will modify this, thanks a lot!!

>> +{
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +
>> +	while ((hinfc_read(host, HINFC504_STATUS) & 0x1) == 0x0)
>> +		;
>> +
>> +	while ((hinfc_read(host, HINFC504_DMA_CTRL))
>> +		& HINFC504_DMA_CTRL_DMA_START)
>> +		_cond_resched();
>> +
>> +	return 0;
>> +}
>> +
>> +static int hisi_nfc_resume(struct platform_device *pdev)
>
> Same here.
>
>> +{
>> +	int cs;
>> +	struct hinfc_host *host = platform_get_drvdata(pdev);
>> +	struct nand_chip *chip = &host->chip;
>> +
>> +	for (cs = 0; cs < chip->numchips; cs++)
>> +		hisi_nfc_send_cmd_reset(host, cs);
>> +	hinfc_write(host, SET_HINFC504_PWIDTH(HINFC504_W_LATCH,
>> +		    HINFC504_R_LATCH, HINFC504_RW_LATCH), HINFC504_PWIDTH);
>> +
>> +	return 0;
>> +}
>> +#endif
>> +static SIMPLE_DEV_PM_OPS(hisi_nfc_pm_ops, hisi_nfc_suspend, hisi_nfc_resume);
>
> Brian
>

Thanks,
Zhou Wang


