Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JUMYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:24:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3JUMYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:24:17 -0400
MIME-Version: 1.0
In-Reply-To: <1382304926-1641-2-git-send-email-prarit@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
	<1382304926-1641-2-git-send-email-prarit@redhat.com>
Date: Mon, 21 Oct 2013 20:24:15 +0800
Message-ID: <CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
From: Ming Lei <ming.lei@canonical.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        herrmann.der.user@googlemail.com, tigran@aivazian.fsnet.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 5:35 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> If request_firmware_nowait() is called with uevent == NULL, the firmware
> completion is never marked complete resulting in a hang in the process.
>
> If uevent is undefined, that means we're not waiting on anything and the
> process should just clean up and complete.  While we're at it, add a
> debug dev_dbg() to indicate that the FW has not been found.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: x86@kernel.org
> Cc: herrmann.der.user@googlemail.com
> Cc: ming.lei@canonical.com
> Cc: tigran@aivazian.fsnet.co.uk
> ---
>  drivers/base/firmware_class.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 10a4467..95778dc 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -335,7 +335,8 @@ static bool fw_get_filesystem_firmware(struct device *device,
>                 set_bit(FW_STATUS_DONE, &buf->status);
>                 complete_all(&buf->completion);
>                 mutex_unlock(&fw_lock);
> -       }
> +       } else
> +               dev_dbg(device, "firmware: %s not found\n", buf->fw_id);
>
>         return success;
>  }
> @@ -886,6 +887,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>                         schedule_delayed_work(&fw_priv->timeout_work, timeout);
>
>                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
> +       } else {
> +               /* if there is no uevent then just cleanup */
> +               schedule_delayed_work(&fw_priv->timeout_work, 0);
>         }

This may not a good idea and might break current NOHOTPLUG
users, and how can you make sure the user space application can
complete the request during the timeout time?

Thanks,
--
Ming Lei
