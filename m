Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaK0PoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:44:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaK0PoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:44:00 -0500
Date: Thu, 27 Nov 2014 18:43:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, lee.jones@linaro.org, chris@printf.net,
        ulf.hansson@linaro.org, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for sdio card
Message-ID: <20141127154332.GB4860@mwanda>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <671243677462065a8eb515d654c8a269ce73409c.1417056337.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <671243677462065a8eb515d654c8a269ce73409c.1417056337.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #ifdef DEBUG
> -static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
> +static void dump_reg_range(struct realtek_pci_sdmmc *host, u16 start, u16 end)
>  {
> -	struct rtsx_pcr *pcr = host->pcr;
> -	u16 i;
> -	u8 *ptr;
> +	u16 len = end - start + 1;
> +	int i;
> +	u8 *data = kzalloc(8, GFP_KERNEL);

The zeroing should be done inside the loop so that the last partial
read doesn't have old data.  Just use an array on the stack here.

	u8 data[8];

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
> +
> +	for (i = 0; i < len; i += 8, start += 8) {

I don't like this loop.  Just leave start as is and write:

			rtsx_pci_read_register(host->pcr, start + i + j,
					       data + j);


> +		int j, n = min(8, len - i);

Put these declarations on separate lines.

The memset I mentioned earlier goes here.

		memset(&data, 0, sizeof(data));


> +
> +		for (j = 0; j < n; j++)
> +			rtsx_pci_read_register(host->pcr, start + j, data + j);
> +		dev_dbg(sdmmc_dev(host), "0x%04X(%d): %8ph\n", start, n, data);
> +	}
> +
> +	kfree(data);
> +}
> +
> +static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
> +{
> +	dump_reg_range(host, 0xFDA0, 0xFDB3);
> +	dump_reg_range(host, 0xFD52, 0xFD69);
>  }
>  #else
>  #define sd_print_debug_regs(host)
>  #endif /* DEBUG */
>  
> +static int sdmmc_get_cd(struct mmc_host *mmc);

This forward declaration is not needed.

> +static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
> +	struct mmc_command *cmd);

It's better to move the function forward, instead of having forward
declarations.

> +
> +static void sd_cmd_set_sd_cmd(struct rtsx_pcr *pcr, struct mmc_command *cmd)
> +{
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CMD0, 0xFF, 0x40 | cmd->opcode);

0x40 is a magic number.

> +	rtsx_pci_write_be32(pcr, SD_CMD1, cmd->arg);
> +}
> +

[ snip ]

> @@ -293,47 +329,15 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
>  	int timeout = 100;
>  	int i;
>  	u8 *ptr;
> -	int stat_idx = 0;
> -	u8 rsp_type;
> -	int rsp_len = 5;
> +	int rsp_type = sd_response_type(cmd);

Don't do this assignment in the initializer.  Put it next to the error
handling code.  First we assign it.  Then we use it.  Then blank line.
Then we check it for errors.  Spagghetttii.

> +	int stat_idx = sd_status_index(rsp_type);

I have always hated this terrible pointer math.  5 is relative to
pcr->host_cmds_ptr + 1.  It's a mess...  :(

>  	bool clock_toggled = false;


[ snip ]

> -static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
> +static int sd_read_long_data(struct realtek_pci_sdmmc *host,
> +	struct mmc_request *mrq)
>  {
>  	struct rtsx_pcr *pcr = host->pcr;
>  	struct mmc_host *mmc = host->mmc;
>  	struct mmc_card *card = mmc->card;
> +	struct mmc_command *cmd = mrq->cmd;
>  	struct mmc_data *data = mrq->data;
>  	int uhs = mmc_card_uhs(card);
> -	int read = (data->flags & MMC_DATA_READ) ? 1 : 0;
> -	u8 cfg2, trans_mode;
> +	u8 cfg2 = 0;
>  	int err;
> +	int resp_type = sd_response_type(cmd);

Same thing.  Move this next to the error handling code.


[ snip ]

> @@ -653,14 +697,14 @@ static int sd_tuning_rx_cmd(struct realtek_pci_sdmmc *host,
>  		u8 opcode, u8 sample_point)
>  {
>  	int err;
> -	u8 cmd[5] = {0};
> +	struct mmc_command cmd = {0};

I like the struct mmc_command changes but these seem like cleanups and
not needed for the new hardware.  Send them as a separate patch instead
of mixed in with everything else.

regards,
dan carpenter

