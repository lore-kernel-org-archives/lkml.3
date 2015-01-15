Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbAOKkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:40:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbbAOKkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:40:11 -0500
Message-ID: <54B79900.50705@redhat.com>
Date: Thu, 15 Jan 2015 11:40:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3/5, media] pwc-if: fix build warning when !CONFIG_USB_PWC_INPUT_EVDEV
References: <20141001231000.GA25634@hercules>
In-Reply-To: <20141001231000.GA25634@hercules>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02-10-14 01:10, Luis Henriques wrote:
> Label err_video_unreg in function usb_pwc_probe() is only used when
> CONFIG_USB_PWC_INPUT_EVDEV is defined.
>
> drivers/media/usb/pwc/pwc-if.c:1104:1: warning: label 'err_video_unreg' defined but not used [-Wunused-label]
>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Sorry for the slow reaction, I somehow missed this patch and just found it in my
patchwork TODO.

I understand what you're trying to achieve here, but NAK to the implementation,
this is breaking the code flow wrt error handling, making it much harder
to double check that everything is being cleaned up properly.

Regards,

Hans


>
> ---
> drivers/media/usb/pwc/pwc-if.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 15b754da4a2c..e6b7e63b0b8e 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -1078,7 +1078,8 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>   	pdev->button_dev = input_allocate_device();
>   	if (!pdev->button_dev) {
>   		rc = -ENOMEM;
> -		goto err_video_unreg;
> +		video_unregister_device(&pdev->vdev);
> +		goto err_unregister_v4l2_dev;
>   	}
>
>   	usb_make_path(udev, pdev->button_phys, sizeof(pdev->button_phys));
> @@ -1095,14 +1096,13 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>   	if (rc) {
>   		input_free_device(pdev->button_dev);
>   		pdev->button_dev = NULL;
> -		goto err_video_unreg;
> +		video_unregister_device(&pdev->vdev);
> +		goto err_unregister_v4l2_dev;
>   	}
>   #endif
>
>   	return 0;
>
> -err_video_unreg:
> -	video_unregister_device(&pdev->vdev);
>   err_unregister_v4l2_dev:
>   	v4l2_device_unregister(&pdev->v4l2_dev);
>   err_free_controls:
>
