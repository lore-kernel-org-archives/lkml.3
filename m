Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaLOOMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:12:23 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62806 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaLOOMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:12:21 -0500
Date: Mon, 15 Dec 2014 06:12:17 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 08/12] input: cyapa: add gen3 trackpad device force
 re-calibrate function support
Message-ID: <20141215141217.GG918@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
 <1418624603-19054-9-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418624603-19054-9-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Mon, Dec 15, 2014 at 02:23:19PM +0800, Dudley Du wrote:
> Add force re-calibrate function supported for gen3 trackpad device,
> it can be used through sysfs calibrate interface.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
>  drivers/input/mouse/cyapa_gen3.c | 58 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
> index f42e008..836a00b 100644
> --- a/drivers/input/mouse/cyapa_gen3.c
> +++ b/drivers/input/mouse/cyapa_gen3.c
> @@ -754,6 +754,63 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
>  	return 0;
>  }
>  
> +static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct cyapa *cyapa = dev_get_drvdata(dev);
> +	int tries = 20;  /* max recalibration timeout 2s. */
Where this timeout is used is not obvious here.
Maybe move it to the loop where it is used?

+	int tries;

> +	int ret;
> +
> +	ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
> +	if (ret < 0) {
> +		dev_err(dev, "Error reading dev status: %d\n", ret);
> +		goto out;
> +	}
> +	if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
> +		dev_warn(dev, "Trackpad device is busy, device state: 0x%02x\n",
> +			 ret);
> +		ret = -EAGAIN;
> +		goto out;
> +	}
> +
> +	ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
> +			       OP_RECALIBRATION_MASK);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to send calibrate command: %d\n",
> +			ret);
> +		goto out;
> +	}
> +

Set tries here since it is used in this loop.

+	tries = 20;  /* max recalibration timeout 2s. */
> +	do {
> +		/*
> +		 * For this recalibration, the max time will not exceed 2s.
> +		 * The average time is approximately 500 - 700 ms, and we
> +		 * will check the status every 100 - 200ms.
> +		 */
> +		usleep_range(100000, 200000);
> +
> +		ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
> +		if (ret < 0) {
> +			dev_err(dev, "Error reading dev status: %d\n",
> +				ret);
> +			goto out;
> +		}
> +		if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
> +			break;
> +	} while (--tries);
> +
> +	if (tries == 0) {
> +		dev_err(dev, "Failed to calibrate. Timeout.\n");
> +		ret = -ETIMEDOUT;
> +		goto out;
> +	}
> +	dev_dbg(dev, "Calibration successful.\n");
> +
> +out:
> +	return ret < 0 ? ret : count;
> +}
> +
>  static ssize_t cyapa_gen3_show_baseline(struct device *dev,
>  				   struct device_attribute *attr, char *buf)
>  {
> @@ -1137,6 +1194,7 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
>  	.bl_deactivate = cyapa_gen3_bl_deactivate,
>  
>  	.show_baseline = cyapa_gen3_show_baseline,
> +	.calibrate_store = cyapa_gen3_do_calibrate,
>  
>  	.state_parse = cyapa_gen3_state_parse,
>  	.operational_check = cyapa_gen3_do_operational_check,
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
- Jeremiah Mahler
