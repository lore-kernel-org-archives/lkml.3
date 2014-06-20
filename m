Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaFTOPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:15:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53227 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaFTOO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:14:56 -0400
MIME-Version: 1.0
In-Reply-To: <1402537537-17945-1-git-send-email-ytk.lee@samsung.com>
References: <1402537537-17945-1-git-send-email-ytk.lee@samsung.com>
Date: Fri, 20 Jun 2014 16:14:55 +0200
Message-ID: <CANq1E4T3v9DPnj8z7B3Qj0NT98M648r+KDWT7Os4SpbCjNxQ8A@mail.gmail.com>
Subject: Re: [PATCH] Input: evdev - Fix incorrect kfree of err_free_client
 after vzalloc
From: David Herrmann <dh.herrmann@gmail.com>
To: Yongtaek Lee <ytk.lee@samsung.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, daniels@collabora.com,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Jun 12, 2014 at 3:45 AM, Yongtaek Lee <ytk.lee@samsung.com> wrote:
> This bug was introduced by commit 92eb77d ("Input: evdev - fall back
> to vmalloc for client event buffer").
>
> vzalloc is used to alloc memory as fallback in case of failure
> of kzalloc. But err_free_client was not considered on below case.
> 1. kzalloc fail
> 2. vzalloc success
> 3. evdev_open_device fail
> 4. kfree
>
> So that address checking is needed to call correct free function.
>
> Signed-off-by: Yongtaek Lee <ytk.lee@samsung.com>
> Reviewed-by: Daniel Stone <daniels@collabora.com>

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  drivers/input/evdev.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index ce953d8..f60daa0 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -422,7 +422,10 @@ static int evdev_open(struct inode *inode, struct file *file)
>
>   err_free_client:
>         evdev_detach_client(evdev, client);
> -       kfree(client);
> +       if (is_vmalloc_addr(client))
> +               vfree(client);
> +       else
> +               kfree(client);
>         return error;
>  }
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
