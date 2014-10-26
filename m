Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaJZP77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 11:59:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaJZP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 11:59:57 -0400
MIME-Version: 1.0
In-Reply-To: <1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
Date: Sun, 26 Oct 2014 23:59:55 +0800
Message-ID: <CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] firmware loader: Introduce new API - request_firmware_abort()
From: Ming Lei <ming.lei@canonical.com>
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 2:18 PM, Kweh Hock Leong
<hock.leong.kweh@intel.com> wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
>
> Besides aborting through user helper interface, a new API
> request_firmware_abort() allows kernel driver module to abort the
> request_firmware() / request_firmware_nowait() when they are no
> longer needed. It is useful for cancelling an outstanding firmware
> load if initiated from inside a module where that module is in the
> process of being unloaded, since the unload function may not have
> a handle to the struct firmware_buf.
>
> Note for people who use request_firmware_nowait():
> You are required to do your own synchronization after you call
> request_firmware_abort() in order to continue unloading the
> module. The example synchronization code shows below:
>
> while (THIS_MODULE && module_refcount(THIS_MODULE))
>         msleep(20);
>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++++++++
>  include/linux/firmware.h      |    4 ++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d276e33..b2fe40b 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1291,6 +1291,36 @@ request_firmware_nowait(
>  }
>  EXPORT_SYMBOL(request_firmware_nowait);
>
> +/**
> + * request_firmware_abort - abort the waiting of firmware request
> + * @fw_name: name of firmware file
> + *
> + *     @fw_name is the same name string while calling to request_firmware()
> + *             or request_firmware_nowait().
> + **/
> +int request_firmware_abort(const char *fw_name)
> +{
> +       struct firmware_buf *buf;
> +       struct firmware_buf *entry;
> +
> +       spin_lock(&fw_cache.lock);
> +       buf = __fw_lookup_buf(fw_name);
> +       spin_unlock(&fw_cache.lock);

You can call fw_lookup_buf() directly, otherwise feel free to add:

Acked-by: Ming Lei <ming.lei@canonical.com>

> +       if (!buf)
> +               return -ENOENT;
> +
> +       mutex_lock(&fw_lock);
> +       list_for_each_entry(entry, &pending_fw_head, pending_list) {
> +               if (entry == buf) {
> +                       __fw_load_abort(buf);
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&fw_lock);
> +       return 0;
> +}
> +EXPORT_SYMBOL(request_firmware_abort);
> +
>  #ifdef CONFIG_PM_SLEEP
>  static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
>
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 5952933..ed90c8b 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -47,6 +47,7 @@ int request_firmware_nowait(
>         void (*cont)(const struct firmware *fw, void *context));
>
>  void release_firmware(const struct firmware *fw);
> +int request_firmware_abort(const char *fw_name);
>  #else
>  static inline int request_firmware(const struct firmware **fw,
>                                    const char *name,
> @@ -66,6 +67,9 @@ static inline void release_firmware(const struct firmware *fw)
>  {
>  }
>
> +static inline int request_firmware_abort(const char *fw_name)
> +{
> +}
>  #endif
>
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
> --
> 1.7.9.5
>
