Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaLILOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:14:38 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35082 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755617AbaLILOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:14:36 -0500
Message-ID: <5486D950.6050108@xs4all.nl>
Date: Tue, 09 Dec 2014 12:13:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-api <linux-api@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v5] media: platform: add VPFE capture driver support for
 AM437X
References: <1418077306-2493-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1418077306-2493-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 23:21, Lad, Prabhakar wrote:
> From: Benoit Parrot <bparrot@ti.com>
> 
> This patch adds Video Processing Front End (VPFE) driver for
> AM437X family of devices
> Driver supports the following:
> - V4L2 API using MMAP buffer access based on videobuf2 api
> - Asynchronous sensor/decoder sub device registration
> - DT support
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Changes for v5:
>  1: Fixed review comments pointed out by Hans, fixing race condition.
> 
>  v4l2-compliance output:

Thanks!

<snip>

>  ----------------------
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> new file mode 100644
> index 0000000..c2b29a2
> --- /dev/null
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> +/*
> + * vpfe_release : This function is based on the vb2_fop_release
> + * helper function.
> + * It has been augmented to handle module power management,
> + * by disabling/enabling h/w module fcntl clock when necessary.
> + */
> +static int vpfe_release(struct file *file)
> +{
> +	struct vpfe_device *vpfe = video_drvdata(file);
> +	bool close = v4l2_fh_is_singular_file(file);
> +	int ret;
> +
> +	vpfe_dbg(2, vpfe, "vpfe_release\n");
> +
> +	mutex_lock(&vpfe->lock);

The v4l2_fh_is_singular_file() call should be inside the lock as well.
So:

	close = v4l2_fh_is_singular_file(file);

> +
> +	ret = _vb2_fop_release(file, NULL);
> +	if (close)
> +		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
> +
> +	mutex_unlock(&vpfe->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * vpfe_open : This function is based on the v4l2_fh_open helper function.
> + * It has been augmented to handle module power management,
> + * by disabling/enabling h/w module fcntl clock when necessary.
> + */
> +static int vpfe_open(struct file *file)
> +{
> +	struct vpfe_device *vpfe = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_fh_open(file);

Same here, v4l2_fh_open should be inside the lock.

> +	if (ret) {
> +		vpfe_err(vpfe, "v4l2_fh_open failed\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&vpfe->lock);

So:

	ret = v4l2_fh_open(file);
	if (ret) {
		vpfe_err(vpfe, "v4l2_fh_open failed\n");
		goto unlock;
	}

	
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	if (vpfe_initialize_device(vpfe)) {
> +		v4l2_fh_release(file);
> +		ret = -ENODEV;
> +	}
> +
> +unlock:
> +	mutex_unlock(&vpfe->lock);
> +	return ret;
> +}

Regards,

	Hans
