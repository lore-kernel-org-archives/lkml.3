Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaLIUtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:49:52 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36888 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbaLIUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:49:50 -0500
Message-ID: <54876067.2070608@xs4all.nl>
Date: Tue, 09 Dec 2014 21:49:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-api <linux-api@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v6] media: platform: add VPFE capture driver support for
 AM437X
References: <1418154224-6045-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1418154224-6045-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:43 PM, Lad, Prabhakar wrote:
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
>  Changes for v6:
>  1: Fixed review comments pointed Hans, fixing race condition.
>  
>  v5: https://patchwork.kernel.org/patch/5459311/
>  v4: https://patchwork.kernel.org/patch/5449211/
>  v3: https://patchwork.kernel.org/patch/5434291/
>  v2: https://patchwork.kernel.org/patch/5425631/
>  v1: https://patchwork.kernel.org/patch/5362661/
>  
>  .../devicetree/bindings/media/ti-am437x-vpfe.txt   |   61 +
>  MAINTAINERS                                        |    9 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/am437x/Kconfig              |   11 +
>  drivers/media/platform/am437x/Makefile             |    3 +
>  drivers/media/platform/am437x/am437x-vpfe.c        | 2777 ++++++++++++++++++++
>  drivers/media/platform/am437x/am437x-vpfe.h        |  283 ++
>  drivers/media/platform/am437x/am437x-vpfe_regs.h   |  140 +
>  include/uapi/linux/Kbuild                          |    1 +
>  include/uapi/linux/am437x-vpfe.h                   |  122 +
>  11 files changed, 3410 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/ti-am437x-vpfe.txt
>  create mode 100644 drivers/media/platform/am437x/Kconfig
>  create mode 100644 drivers/media/platform/am437x/Makefile
>  create mode 100644 drivers/media/platform/am437x/am437x-vpfe.c
>  create mode 100644 drivers/media/platform/am437x/am437x-vpfe.h
>  create mode 100644 drivers/media/platform/am437x/am437x-vpfe_regs.h
>  create mode 100644 include/uapi/linux/am437x-vpfe.h
> 

<snip>

> +/*
> + * vpfe_release : This function is based on the vb2_fop_release
> + * helper function.
> + * It has been augmented to handle module power management,
> + * by disabling/enabling h/w module fcntl clock when necessary.
> + */
> +static int vpfe_release(struct file *file)
> +{
> +	struct vpfe_device *vpfe = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&vpfe->lock);
> +
> +	ret = _vb2_fop_release(file, NULL);
> +	if (v4l2_fh_is_singular_file(file))
> +		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);

This function seems cursed since your _vb2_fop_release call should
go *after* the v4l2_fh_is_singular_file() check.

I've fixed that in the patch in my pull request, so there is no need
for a v7. I know you've tested that since that was the order in your v5
version of this patch.

Regards,

	Hans

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
> +	mutex_lock(&vpfe->lock);
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret) {
> +		vpfe_err(vpfe, "v4l2_fh_open failed\n");
> +		goto unlock;
> +	}
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

