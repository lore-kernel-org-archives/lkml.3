Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaLDH7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:59:20 -0500
Received: from mga03.intel.com ([134.134.136.65]:39822 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaLDH7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="648084640"
Message-ID: <5480144F.2040506@linux.intel.com>
Date: Thu, 04 Dec 2014 09:59:11 +0200
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, wsa@the-dreams.de
CC: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 1/2] i2c-designware: Add i2c bus locking support
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com> <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com> <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 12/02/2014 02:09 AM, David E. Box wrote:
> Adds support for acquiring and releasing a hardware bus lock in the i2c
> designware core transfer function. This is needed for i2c bus controllers
> that are shared with but not controlled by the kernel.
>
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>   drivers/i2c/busses/i2c-designware-core.c    | 11 +++++++++++
>   drivers/i2c/busses/i2c-designware-core.h    |  6 ++++++
>   drivers/i2c/busses/i2c-designware-platdrv.c | 18 +++++++++++++-----
>   3 files changed, 30 insertions(+), 5 deletions(-)
>
...
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index a743115..afdff3b 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -261,10 +261,16 @@ static int dw_i2c_probe(struct platform_device *pdev)
>   		return r;
>   	}
>   
> -	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> -	pm_runtime_use_autosuspend(&pdev->dev);
> -	pm_runtime_set_active(&pdev->dev);
> -	pm_runtime_enable(&pdev->dev);
> +	i2c_dw_eval_lock_support(dev);
i2c_dw_eval_lock_support() is added in the next patch.
> +
> +	if (dev->pm_runtime_disabled) {
> +		pm_runtime_forbid(&pdev->dev);
> +	} else {
> +		pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> +		pm_runtime_use_autosuspend(&pdev->dev);
> +		pm_runtime_set_active(&pdev->dev);
> +		pm_runtime_enable(&pdev->dev);
> +	}
>   
>   	return 0;
>   }
> @@ -314,7 +320,9 @@ static int dw_i2c_resume(struct device *dev)
>   	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
>   
>   	clk_prepare_enable(i_dev->clk);
> -	i2c_dw_init(i_dev);
> +
> +	if (!i_dev->pm_runtime_disabled)
> +		i2c_dw_init(i_dev);
>   
Should there be similar conditional call or locking around i2c_dw_init() 
and i2c_dw_disable_int() also in dw_i2c_probe()?

-- 
Jarkko
