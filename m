Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3GBBtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 21:49:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16259 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3GBBtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 21:49:32 -0400
Message-ID: <51D23169.1070405@huawei.com>
Date: Tue, 2 Jul 2013 09:48:25 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Jens Axboe <axboe@kernel.dk>, Mike Miller <mike.miller@hp.com>,
        <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        <iss_storagedev@hp.com>
Subject: Re: [PATCH 5/9] cciss: rework pci pm related code for simplification
References: <1371543553-13064-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1371543553-13064-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
   Sorry to disturb you, do you have any comments for this patch?

Thanks!
Yijing.

On 2013/6/18 16:19, Yijing Wang wrote:
> Use pci core pm interface to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Mike Miller <mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/block/cciss.c |   16 +++-------------
>  1 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 62b6c2c..18da685 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4528,9 +4528,6 @@ static int cciss_message(struct pci_dev *pdev, unsigned char opcode,
>  static int cciss_controller_hard_reset(struct pci_dev *pdev,
>  	void * __iomem vaddr, u32 use_doorbell)
>  {
> -	u16 pmcsr;
> -	int pos;
> -
>  	if (use_doorbell) {
>  		/* For everything after the P600, the PCI power state method
>  		 * of resetting the controller doesn't work, so we have this
> @@ -4548,8 +4545,7 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
>  		 * this causes a secondary PCI reset which will reset the
>  		 * controller." */
>  
> -		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
> -		if (pos == 0) {
> +		if (!pdev->pm_cap) {
>  			dev_err(&pdev->dev,
>  				"cciss_controller_hard_reset: "
>  				"PCI PM not supported\n");
> @@ -4557,18 +4553,12 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
>  		}
>  		dev_info(&pdev->dev, "using PCI PM to reset controller\n");
>  		/* enter the D3hot power management state */
> -		pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
> -		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
> -		pmcsr |= PCI_D3hot;
> -		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
> +		pci_set_power_state(pdev, PCI_D3hot);
>  
>  		msleep(500);
>  
>  		/* enter the D0 power management state */
> -		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
> -		pmcsr |= PCI_D0;
> -		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
> -
> +		pci_set_power_state(pdev, PCI_D0);
>  		/*
>  		 * The P600 requires a small delay when changing states.
>  		 * Otherwise we may think the board did not reset and we bail.
> 


-- 
Thanks!
Yijing

