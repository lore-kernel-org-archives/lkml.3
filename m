Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaG3P3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:29:46 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39124 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaG3P2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:28:24 -0400
Message-ID: <53D90F18.3050709@cogentembedded.com>
Date: Wed, 30 Jul 2014 19:28:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, mina86@mina86.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com, k.opasiak@samsung.com
Subject: Re: [PATCH v3 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
References: <1406713423-32472-1-git-send-email-r.baldyga@samsung.com> <1406713423-32472-3-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1406713423-32472-3-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 01:43 PM, Robert Baldyga wrote:

> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
> returns endpoint descriptor to userspace. It works only if function
> is active.

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>   drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
>   include/uapi/linux/usb/functionfs.h |  6 ++++++
>   2 files changed, 23 insertions(+)

> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 6b806be..7f16c5a 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
>   		case FUNCTIONFS_ENDPOINT_REVMAP:
>   			ret = epfile->ep->num;
>   			break;
> +		case FUNCTIONFS_ENDPOINT_DESC:
> +		{
> +			int desc_idx;
> +			struct usb_endpoint_descriptor *desc;
> +
> +			if (epfile->ffs->gadget->speed == USB_SPEED_SUPER)
> +				desc_idx = 2;
> +			else if (epfile->ffs->gadget->speed == USB_SPEED_HIGH)
> +				desc_idx = 1;
> +			else
> +				desc_idx = 0;

    I think the above is asking to be a *switch* statement instead.

> +			desc = epfile->ep->descs[desc_idx];
> +			ret = copy_to_user((void *)value, desc, sizeof(*desc));
> +			if (ret)
> +				ret = -EFAULT;
> +			break;
> +		}
>   		default:
>   			ret = -ENOTTY;
>   		}

WBR, Sergei

