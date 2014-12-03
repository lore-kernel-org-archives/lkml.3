Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaLCSAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:00:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:12429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaLCSAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:00:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424589680"
Date: Wed, 3 Dec 2014 18:01:25 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de,
        maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        wenkai.du@intel.com, chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 1/2] i2c-designware: Add i2c bus locking support
Message-ID: <20141203160125.GB28857@lahna.fi.intel.com>
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:09:32PM -0800, David E. Box wrote:
> Adds support for acquiring and releasing a hardware bus lock in the i2c
> designware core transfer function. This is needed for i2c bus controllers
> that are shared with but not controlled by the kernel.
> 
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-core.c    | 11 +++++++++++
>  drivers/i2c/busses/i2c-designware-core.h    |  6 ++++++
>  drivers/i2c/busses/i2c-designware-platdrv.c | 18 +++++++++++++-----
>  3 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> index 3c20e4b..377deeb 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -631,6 +631,14 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>  	dev->abort_source = 0;
>  	dev->rx_outstanding = 0;
>  
> +	if (dev->acquire_lock) {
> +		ret = dev->acquire_lock(dev);
> +		if (ret) {
> +			dev_err(dev->dev, "couldn't acquire bus ownership\n");
> +			goto done;

I wonder what happens now since you failed to acquire the lock...

> +		}
> +	}
> +
>  	ret = i2c_dw_wait_bus_not_busy(dev);
>  	if (ret < 0)
>  		goto done;
> @@ -676,6 +684,9 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>  	ret = -EIO;
>  
>  done:
> +	if (dev->release_lock)
> +		dev->release_lock(dev);

... but here you unconditionally release it?

Otherwise the patch looks good to me.

> +
>  	pm_runtime_mark_last_busy(dev->dev);
>  	pm_runtime_put_autosuspend(dev->dev);
>  	mutex_unlock(&dev->lock);
> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> index d66b6cb..a472c91 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -65,6 +65,9 @@
>   * @ss_lcnt: standard speed LCNT value
>   * @fs_hcnt: fast speed HCNT value
>   * @fs_lcnt: fast speed LCNT value
> + * @acquire_lock: function to acquire a hardware lock on the bus
> + * @release_lock: function to release a hardware lock on the bus
> + * @pm_runtime_disabled: true if pm runtime is disabled
>   *
>   * HCNT and LCNT parameters can be used if the platform knows more accurate
>   * values than the one computed based only on the input clock frequency.
> @@ -105,6 +108,9 @@ struct dw_i2c_dev {
>  	u16			ss_lcnt;
>  	u16			fs_hcnt;
>  	u16			fs_lcnt;
> +	int			(*acquire_lock)(struct dw_i2c_dev *dev);
> +	void			(*release_lock)(struct dw_i2c_dev *dev);
> +	bool			pm_runtime_disabled;
>  };
>  
>  #define ACCESS_SWAP		0x00000001
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index a743115..afdff3b 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -261,10 +261,16 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		return r;
>  	}
>  
> -	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> -	pm_runtime_use_autosuspend(&pdev->dev);
> -	pm_runtime_set_active(&pdev->dev);
> -	pm_runtime_enable(&pdev->dev);
> +	i2c_dw_eval_lock_support(dev);
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
>  	return 0;
>  }
> @@ -314,7 +320,9 @@ static int dw_i2c_resume(struct device *dev)
>  	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
>  
>  	clk_prepare_enable(i_dev->clk);
> -	i2c_dw_init(i_dev);
> +
> +	if (!i_dev->pm_runtime_disabled)
> +		i2c_dw_init(i_dev);
>  
>  	return 0;
>  }
> -- 
> 1.9.1
