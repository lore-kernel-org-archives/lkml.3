Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaLHONv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:13:51 -0500
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46419 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700AbaLHONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:13:48 -0500
Message-ID: <5485B214.3090805@xs4all.nl>
Date: Mon, 08 Dec 2014 15:13:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-api <linux-api@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v4] media: platform: add VPFE capture driver support for
 AM437X
References: <1417871242-23797-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1417871242-23797-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2014 02:07 PM, Lad, Prabhakar wrote:
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
>  Changes for v4:
>  1: Fixed review comments pointed by Hans to check
>     ycbcr_enc and quantization while comparing formats,
>     fixed the release function and dropped compose cases
>     for vpfe_g_selection as compose isn't supported.
> 
>  .../devicetree/bindings/media/ti-am437x-vpfe.txt   |   61 +
>  MAINTAINERS                                        |    9 +
>  drivers/media/platform/Kconfig                     |    1 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/am437x/Kconfig              |   11 +
>  drivers/media/platform/am437x/Makefile             |    3 +
>  drivers/media/platform/am437x/am437x-vpfe.c        | 2778 ++++++++++++++++++++
>  drivers/media/platform/am437x/am437x-vpfe.h        |  283 ++
>  drivers/media/platform/am437x/am437x-vpfe_regs.h   |  140 +
>  include/uapi/linux/Kbuild                          |    1 +
>  include/uapi/linux/am437x-vpfe.h                   |  122 +
>  11 files changed, 3411 insertions(+)
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
> +	vpfe_dbg(2, vpfe, "vpfe_release\n");
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		return vb2_fop_release(file);
> +
> +	mutex_lock(&vpfe->lock);

This should be moved up to before the if. Otherwise there will be a
race between open and release w.r.t. to v4l2_fh_is_singular_file().

> +	ret = _vb2_fop_release(file, NULL);
> +	vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
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
> +	if (ret) {
> +		vpfe_err(vpfe, "v4l2_fh_open failed\n");
> +		return ret;
> +	}
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		return 0;
> +
> +	mutex_lock(&vpfe->lock);

Same here: the lock should move to before the v4l2_fh_open call.

> +	if (vpfe_initialize_device(vpfe)) {
> +		mutex_unlock(&vpfe->lock);
> +		v4l2_fh_release(file);
> +		return -ENODEV;
> +	}
> +	mutex_unlock(&vpfe->lock);
> +
> +	return 0;
> +}

Regards,

	Hans
