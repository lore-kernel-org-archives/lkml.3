Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3BDK6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:58:22 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3387 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3BDK6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:58:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH v6 1/2] sta2x11_vip: convert to videobuf2, control framework, file handler
Date: Mon, 4 Feb 2013 11:57:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-durdane; KDE/4.8.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358950027-27419-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1358950027-27419-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302041157.45340.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed January 23 2013 15:07:06 Federico Vaga wrote:
> This patch re-write the driver and use the videobuf2
> interface instead of the old videobuf. Moreover, it uses also
> the control framework which allows the driver to inherit
> controls from its subdevice (ADV7180). Finally the driver does not
> implement custom file operation but it uses the generic ones from
> videobuf2 and v4l2_fh
> 
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>  drivers/media/pci/sta2x11/Kconfig       |    2 +-
>  drivers/media/pci/sta2x11/sta2x11_vip.c | 1071 +++++++++++++------------------
>  2 file modificati, 432 inserzioni(+), 641 rimozioni(-)
> 
> @@ -797,12 +601,11 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>  static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  				  struct v4l2_format *f)
>  {
> -	struct video_device *dev = priv;
> -	struct sta2x11_vip *vip = video_get_drvdata(dev);
> +	struct sta2x11_vip *vip = video_drvdata(file);
>  	int interlace_lim;
>  
>  	if (V4L2_PIX_FMT_UYVY != f->fmt.pix.pixelformat)
> -		return -EINVAL;
> +		v4l2_warn(&vip->v4l2_dev, "Invalid format, only UYVY supported\n");

As mentioned in my v4 review, keep the return -EINVAL here. As long as it is
uncertain what try_fmt should do with unsupported pixelformats we shouldn't
change this behavior.

Regards,

	Hans

>  
>  	if (V4L2_STD_525_60 & vip->std)
>  		interlace_lim = 240;
> @@ -810,6 +613,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  		interlace_lim = 288;
>  
>  	switch (f->fmt.pix.field) {
> +	default:
>  	case V4L2_FIELD_ANY:
>  		if (interlace_lim < f->fmt.pix.height)
>  			f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> @@ -823,10 +627,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  		break;
>  	case V4L2_FIELD_INTERLACED:
>  		break;
> -	default:
> -		return -EINVAL;
>  	}
>  
> +	/* It is the only supported format */
> +	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
>  	f->fmt.pix.height &= ~1;
>  	if (2 * interlace_lim < f->fmt.pix.height)
>  		f->fmt.pix.height = 2 * interlace_lim;
