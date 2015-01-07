Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbbAGExB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 23:53:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbAGExA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 23:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>
References: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 7 Jan 2015 12:52:57 +0800
Message-ID: <CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>
Subject: Re: [PATCH] firmware class: remove from pending list on load failure
From: Ming Lei <ming.lei@canonical.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 11:41 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> If we failed loading the firmware we have to make sure it leaves the pending
> list if abort wasn't executed for it.
>
> Otherwise we'd free an object still on the pending list and corrupt it.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/base/firmware_class.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 58470c3..8ccf6cf4 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>         cancel_delayed_work_sync(&fw_priv->timeout_work);
>         if (is_fw_load_aborted(buf))
>                 retval = -EAGAIN;
> -       else if (!buf->data)
> +       else if (!buf->data) {
>                 retval = -ENOMEM;
>
> +               /*
> +                * We failed loading, but abort was never done so we
> +                * need to remove it from the pending list ourselves.
> +                */
> +               mutex_lock(&fw_lock);
> +               list_del_init(&buf->pending_list);
> +               mutex_unlock(&fw_lock);

The buf is always removed before the complete_all(), isn't it? Or did
you observe the issue?

Thanks,
Ming Lei

> +       }
> +
>         device_remove_file(f_dev, &dev_attr_loading);
>  err_del_bin_attr:
>         device_remove_bin_file(f_dev, &firmware_attr_data);
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
