Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaLAMhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:37:40 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbaLAMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:37:37 -0500
Date: Mon, 1 Dec 2014 15:37:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, lee.jones@linaro.org, chris@printf.net,
        ulf.hansson@linaro.org, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2 2/2] mmc: rtsx: add support for sdio card
Message-ID: <20141201123704.GE4994@mwanda>
References: <cover.1417141102.git.micky_ching@realsil.com.cn>
 <544df18ef543c169c93e4c9bd64e94c4ed3c1f9b.1417141102.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544df18ef543c169c93e4c9bd64e94c4ed3c1f9b.1417141102.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 02:31:56PM +0800, micky_ching@realsil.com.cn wrote:
>  #ifdef DEBUG
> -static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
> +static void dump_reg_range(struct realtek_pci_sdmmc *host, u16 start, u16 end)
>  {
> -	struct rtsx_pcr *pcr = host->pcr;
> -	u16 i;
> -	u8 *ptr;
> +	u16 len = end - start + 1;
> +	int i;
> +	u8 data[8];
>  
> -	/* Print SD host internal registers */
> -	rtsx_pci_init_cmd(pcr);
> -	for (i = 0xFDA0; i <= 0xFDAE; i++)
> -		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
> -	for (i = 0xFD52; i <= 0xFD69; i++)
> -		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
> -	rtsx_pci_send_cmd(pcr, 100);
> -
> -	ptr = rtsx_pci_get_cmd_data(pcr);
> -	for (i = 0xFDA0; i <= 0xFDAE; i++)
> -		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
> -	for (i = 0xFD52; i <= 0xFD69; i++)
> -		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
> +	if (!data)
> +		return;

Delete this check.  It will cause a static checker warning because
arrays never NULL.

> +
> +	for (i = 0; i < len; i += 8) {
> +		int j;
> +		int n = min(8, len - i);
> +
> +		memset(&data, 0, sizeof(data));
> +		for (j = 0; j < n; j++)
> +			rtsx_pci_read_register(host->pcr, start + i + j,
> +				data + j);
> +		dev_dbg(sdmmc_dev(host), "0x%04X(%d): %8ph\n", start, n, data);

This should be start + i, sorry for not spotting that earlier.

regards,
dan carpenter

