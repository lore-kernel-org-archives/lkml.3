Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaBUCyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:54:43 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:51715 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaBUCyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:54:41 -0500
Message-ID: <5306BFC4.5000005@elopez.com.ar>
Date: Thu, 20 Feb 2014 23:53:56 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 2/2] i2c: New bus driver for the Qualcomm QUP I2C controller
References: <1392943090-30556-1-git-send-email-bjorn.andersson@sonymobile.com> <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1392943090-30556-3-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

El 20/02/14 21:38, Bjorn Andersson escribió:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm SOCs.
> The Qualcomm Universal Peripheral Engine (QUP) is a general purpose data path
> engine with input/output FIFOs and an embedded i2c mini-core. The driver
> supports FIFO mode (for low bandwidth applications) and block mode (interrupt
> generated for each block-size data transfer).
>
> Cc: Andy Gross <agross@codeaurora.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---

I'm not familiar with the subsystem nor the hardware, so I had a look 
around for general stuff. I have some minor comments to make on the 
probe code.

(snip)
> +static int qup_i2c_probe(struct platform_device *pdev)
> +{
> +	static const int blk_sizes[] = {4, 16, 32};
> +	struct device_node *node = pdev->dev.of_node;
> +	struct qup_i2c_dev *qup;
> +	unsigned long one_bit_t;
> +	struct resource *res;
> +	u32 val, io_mode, hw_ver, size;
> +	int ret, fs_div, hs_div;
> +	int src_clk_freq;
> +	int clk_freq;
> +
> +	qup = devm_kzalloc(&pdev->dev, sizeof(*qup), GFP_KERNEL);
> +	if (!qup)
> +		return -ENOMEM;
> +
> +	qup->dev = &pdev->dev;
> +	init_completion(&qup->xfer);
> +	platform_set_drvdata(pdev, qup);
> +
> +	clk_freq = 100000;
> +	if (!of_property_read_u32(node, "clock-frequency", &val))
> +		clk_freq = val;

val will be modified only if no error occurs, so you may rewrite this 
bit as

+	u32 clk_freq = 100000;
...
+	of_property_read_u32(node, "clock-frequency", &clk_freq)

> +
> +	/* We support frequencies up to FAST Mode (400KHz) */
> +	if (clk_freq <= 0 || clk_freq > 400000) {

And you can drop the < check when it's unsigned.

> +		dev_err(qup->dev, "clock frequency not supported %d\n",
> +			clk_freq);
> +		return -EIO;

EIO?

Cheers,

Emilio
