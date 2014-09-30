Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaI3BxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:53:15 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6486 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbaI3BxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:53:13 -0400
Date: Mon, 29 Sep 2014 18:53:24 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Andy Gross <agross@codeaurora.org>
CC: Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: qup: Fix order of runtime pm initialization
Message-ID: <20140930015323.GE28481@sonymobile.com>
References: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29 Sep 15:00 PDT 2014, Andy Gross wrote:

> The runtime pm calls need to be done before populating the children via the
> i2c_add_adapter call.  If this is not done, a child can run into issues trying
> to do i2c read/writes due to the pm_runtime_sync failing.
> 

May I ask in what case this would fail?  I thought we tested this as we found
the faulty error check after calling pm_runtime_get_sync().

Nontheless,

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn

> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  drivers/i2c/busses/i2c-qup.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
> index 3a4d64e..092d89b 100644
> --- a/drivers/i2c/busses/i2c-qup.c
> +++ b/drivers/i2c/busses/i2c-qup.c
> @@ -674,16 +674,20 @@ static int qup_i2c_probe(struct platform_device *pdev)
>  	qup->adap.dev.of_node = pdev->dev.of_node;
>  	strlcpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
>  
> -	ret = i2c_add_adapter(&qup->adap);
> -	if (ret)
> -		goto fail;
> -
>  	pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
>  	pm_runtime_use_autosuspend(qup->dev);
>  	pm_runtime_set_active(qup->dev);
>  	pm_runtime_enable(qup->dev);
> +
> +	ret = i2c_add_adapter(&qup->adap);
> +	if (ret)
> +		goto fail_runtime;
> +
>  	return 0;
>  
> +fail_runtime:
> +	pm_runtime_disable(qup->dev);
> +	pm_runtime_set_suspended(qup->dev);
>  fail:
>  	qup_i2c_disable_clocks(qup);
>  	return ret;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
