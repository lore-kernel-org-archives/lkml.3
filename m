Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbbA1DL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:11:56 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:7722 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbbA1DLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:11:54 -0500
Date: Tue, 27 Jan 2015 19:11:50 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Andy Gross <agross@codeaurora.org>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-soc@vger.kernel.org" <linux-soc@vger.kernel.org>
Subject: Re: [PATCH 1/6] soc: qcom: gsbi: Add support for ADM CRCI muxing
Message-ID: <20150128031149.GM11960@sonymobile.com>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
 <1422396644-21714-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1422396644-21714-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27 Jan 14:10 PST 2015, Andy Gross wrote:

This solution looks good, just some style things.

> diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
[..]
> +#define MAX_GSBI		12
> +
> +#define TCSR_ADM_CRCI_BASE	0x70
> +
> +struct crci_config {
> +	u32 num_rows;
> +	const u32 *array;

Making this:
 const u32 (*array)[MAX_GSBI];

> +};
> +
> +static const u32 crci_ipq8064[][MAX_GSBI] = {
> +	{
> +		0x000003, 0x00000c, 0x000030, 0x0000c0,
> +		0x000300, 0x000c00, 0x003000, 0x00c000,
> +		0x030000, 0x0c0000, 0x300000, 0xc00000
> +	},
> +	{
> +		0x000003, 0x00000c, 0x000030, 0x0000c0,
> +		0x000300, 0x000c00, 0x003000, 0x00c000,
> +		0x030000, 0x0c0000, 0x300000, 0xc00000
> +	},
> +};
> +
> +static const struct crci_config config_ipq8064 = {
> +	.num_rows = ARRAY_SIZE(crci_ipq8064),
> +	.array = crci_ipq8064[0],

...so that you can make this:
 .array = crci_ipq8064,

> +};
[..]
> @@ -45,6 +152,20 @@ static int gsbi_probe(struct platform_device *pdev)
[..]
> +	if (config)
> +		for (i = 0; i < config->num_rows; i++) {
> +			if (gsbi->mode == GSBI_PROT_SPI)
> +				val = config->array[i*MAX_GSBI + gsbi_num - 1];

...will give you:
 config->array[i][gsbi_num - 1];

> +			else
> +				val = 0;
> +
> +			regmap_update_bits(gsbi->tcsr,
> +				TCSR_ADM_CRCI_BASE + 0x4*i,
> +				config->array[i*MAX_GSBI + gsbi_num - 1], val);

To me this would be cleaner:

mask = config->array[i][gsbi_num - 1];
if (gsbi->mode == GSBI_PRO_SPI)
	regmap_update_bits(gsbi->tcsr, TCSR_ADM_CRCI_BASE + i * 4, mask, mask);
else
	regmap_update_bits(gsbi->tcsr, TCSR_ADM_CRCI_BASE + i * 4, mask, 0);

> +		}
> +
There should be an extra set of {} around the if statment body.

Regards,
Bjorn
