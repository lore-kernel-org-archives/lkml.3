Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3HTMUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3HTMUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:20:37 -0400
Message-ID: <52135F04.80700@redhat.com>
Date: Tue, 20 Aug 2013 14:20:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] gspca: fix dev_open() error path
References: <1375733797-7002-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1375733797-7002-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch I've added this to my "gspca" tree, and this
will be included in my next pull-request to Mauro for 3.12

Regards,

Hans

On 08/05/2013 10:16 PM, Alexey Khoroshilov wrote:
> If v4l2_fh_open() fails in dev_open(), gspca_dev->module left locked.
> The patch adds module_put(gspca_dev->module) on this path.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>
> ---
>   drivers/media/usb/gspca/gspca.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index b7ae872..048507b 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -1266,6 +1266,7 @@ static void gspca_release(struct v4l2_device *v4l2_device)
>   static int dev_open(struct file *file)
>   {
>   	struct gspca_dev *gspca_dev = video_drvdata(file);
> +	int ret;
>
>   	PDEBUG(D_STREAM, "[%s] open", current->comm);
>
> @@ -1273,7 +1274,10 @@ static int dev_open(struct file *file)
>   	if (!try_module_get(gspca_dev->module))
>   		return -ENODEV;
>
> -	return v4l2_fh_open(file);
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		module_put(gspca_dev->module);
> +	return ret;
>   }
>
>   static int dev_close(struct file *file)
> -- 1.8.1.2
>
