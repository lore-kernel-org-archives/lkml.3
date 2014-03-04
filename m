Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaCDQBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:01:19 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55070 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaCDQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:01:17 -0500
Message-ID: <531606DB.4010601@cogentembedded.com>
Date: Tue, 04 Mar 2014 20:01:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, mina86@mina86.com,
        david.a.cohen@linux.intel.com
Subject: Re: [PATCH v2] usb: gadget: return the right length in ffs_epfile_io()
References: <n> <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
In-Reply-To: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/04/2014 10:34 AM, Chuansheng Liu wrote:

> When the request length is aligned to maxpacketsize, sometimes
> the return length ret > the user space requested len.

> At that time, we will use min_t(size_t, ret, len) to limit the
> size in case of user data buffer overflow.

> But we need return the min_t(size_t, ret, len) to tell the user
> space rightly also.

> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>   drivers/usb/gadget/f_fs.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)

> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 42f7a0e..780f877 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
>   			 * we may end up with more data then user space has
>   			 * space for.
>   			 */
> -			ret = ep->status;
> -			if (io_data->read && ret > 0 &&
> -			    unlikely(copy_to_user(io_data->buf, data,
> -						  min_t(size_t, ret,
> -						  io_data->len))))
> -				ret = -EFAULT;
> +				ret = ep->status;

    Why the indentation jumped suddenly to the right?

> +				if (io_data->read && ret > 0) {
> +					ret = min_t(size_t, ret, io_data->len);
> +
> +					if (unlikely(copy_to_user(io_data->buf,
> +						data, ret)))
> +						ret = -EFAULT;
> +				}
>   			}
>   			kfree(data);

WBR, Sergei

