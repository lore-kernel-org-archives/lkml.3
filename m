Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771Ab3LHOmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:42:40 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37644 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab3LHOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:42:34 -0500
MIME-Version: 1.0
In-Reply-To: <1385061348-13153-1-git-send-email-dh.herrmann@gmail.com>
References: <1385061348-13153-1-git-send-email-dh.herrmann@gmail.com>
Date: Sun, 8 Dec 2013 15:42:33 +0100
Message-ID: <CANq1E4TcjmcPbj2GvgUcXA7_+AaevbMTC6+2CsbrugJjjC755A@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix device_create() error path
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Ping?

Thanks
David

On Thu, Nov 21, 2013 at 8:15 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> We call put_device() in the error path, which is fine for dev==NULL.
> However, in case kobject_set_name_vargs() fails, we have dev!=NULL but
> device_initialized() wasn't called, yet.
>
> Fix this by splitting device_register() into explicit calls to
> device_add() and an early call to device_initialize().
>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  drivers/base/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 34abf4d..4be8911 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1676,6 +1676,7 @@ device_create_groups_vargs(struct class *class, struct device *parent,
>                 goto error;
>         }
>
> +       device_initialize(dev);
>         dev->devt = devt;
>         dev->class = class;
>         dev->parent = parent;
> @@ -1687,7 +1688,7 @@ device_create_groups_vargs(struct class *class, struct device *parent,
>         if (retval)
>                 goto error;
>
> -       retval = device_register(dev);
> +       retval = device_add(dev);
>         if (retval)
>                 goto error;
>
> --
> 1.8.4.2
>
