Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3KLCLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:11:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3KLCLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <s5heh6mx2vz.wl%tiwai@suse.de>
References: <1384183278-19787-1-git-send-email-tiwai@suse.de>
	<1384183278-19787-2-git-send-email-tiwai@suse.de>
	<20131111153426.GA6630@pd.tnic>
	<s5heh6mx2vz.wl%tiwai@suse.de>
Date: Tue, 12 Nov 2013 10:11:09 +0800
Message-ID: <CACVXFVO2ixTCqfMxhwi_rfkOsknneX42aUxzP=jKjmpW99HtxA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] firmware: Introduce request_firmware_direct()
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 1:30 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 11 Nov 2013 16:34:26 +0100,
>
> Sounds like a good idea.  How about the patch below?
> (I used unsigned int since there shouldn't be so many different
>  behaviors.)
>
>
> thanks,
>
> Takashi
>
> ===
>
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] firmware: Use bit flags instead of boolean combos
>
> More than two boolean arguments to a function are rather confusing and
> error-prone for callers.  Let's make the behavior bit flags instead of
> triple combos.
>
> A nice suggestion by Borislav Petkov.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Nice work,

              Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei

> ---
>  drivers/base/firmware_class.c | 49 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index bb03c71bd94d..a4eaa7b82882 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -96,6 +96,11 @@ static inline long firmware_loading_timeout(void)
>         return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
>  }
>
> +/* firmware behavior options */
> +#define FW_OPT_UEVENT  (1U << 0)
> +#define FW_OPT_NOWAIT  (1U << 1)
> +#define FW_OPT_FALLBACK        (1U << 2)
> +
>  struct firmware_cache {
>         /* firmware_buf instance will be added into the below list */
>         spinlock_t lock;
> @@ -820,7 +825,7 @@ static void firmware_class_timeout_work(struct work_struct *work)
>
>  static struct firmware_priv *
>  fw_create_instance(struct firmware *firmware, const char *fw_name,
> -                  struct device *device, bool uevent, bool nowait)
> +                  struct device *device, unsigned int opt_flags)
>  {
>         struct firmware_priv *fw_priv;
>         struct device *f_dev;
> @@ -832,7 +837,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>                 goto exit;
>         }
>
> -       fw_priv->nowait = nowait;
> +       fw_priv->nowait = !!(opt_flags & FW_OPT_NOWAIT);
>         fw_priv->fw = firmware;
>         INIT_DELAYED_WORK(&fw_priv->timeout_work,
>                 firmware_class_timeout_work);
> @@ -848,8 +853,8 @@ exit:
>  }
>
>  /* load a firmware via user helper */
> -static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
> -                                 long timeout)
> +static int _request_firmware_load(struct firmware_priv *fw_priv,
> +                                 unsigned int opt_flags, long timeout)
>  {
>         int retval = 0;
>         struct device *f_dev = &fw_priv->dev;
> @@ -885,7 +890,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>                 goto err_del_bin_attr;
>         }
>
> -       if (uevent) {
> +       if (opt_flags & FW_OPT_UEVENT) {
>                 buf->need_uevent = true;
>                 dev_set_uevent_suppress(f_dev, false);
>                 dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
> @@ -911,16 +916,16 @@ err_put_dev:
>
>  static int fw_load_from_user_helper(struct firmware *firmware,
>                                     const char *name, struct device *device,
> -                                   bool uevent, bool nowait, long timeout)
> +                                   unsigned int opt_flags, long timeout)
>  {
>         struct firmware_priv *fw_priv;
>
> -       fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
> +       fw_priv = fw_create_instance(firmware, name, device, opt_flags);
>         if (IS_ERR(fw_priv))
>                 return PTR_ERR(fw_priv);
>
>         fw_priv->buf = firmware->priv;
> -       return _request_firmware_load(fw_priv, uevent, timeout);
> +       return _request_firmware_load(fw_priv, opt_flags, timeout);
>  }
>
>  #ifdef CONFIG_PM_SLEEP
> @@ -1015,7 +1020,7 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
>  }
>
>  static int assign_firmware_buf(struct firmware *fw, struct device *device,
> -                               bool skip_cache)
> +                              unsigned int opt_flags)
>  {
>         struct firmware_buf *buf = fw->priv;
>
> @@ -1032,7 +1037,8 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
>          * device may has been deleted already, but the problem
>          * should be fixed in devres or driver core.
>          */
> -       if (device && !skip_cache)
> +       /* don't cache firmware handled without uevent */
> +       if (device && (opt_flags & FW_OPT_UEVENT))
>                 fw_add_devm_name(device, buf->fw_id);
>
>         /*
> @@ -1053,7 +1059,7 @@ static int assign_firmware_buf(struct firmware *fw, struct device *device,
>  /* called from request_firmware() and request_firmware_work_func() */
>  static int
>  _request_firmware(const struct firmware **firmware_p, const char *name,
> -                 struct device *device, bool uevent, bool nowait, bool fallback)
> +                 struct device *device, unsigned int opt_flags)
>  {
>         struct firmware *fw;
>         long timeout;
> @@ -1068,7 +1074,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>
>         ret = 0;
>         timeout = firmware_loading_timeout();
> -       if (nowait) {
> +       if (opt_flags & FW_OPT_NOWAIT) {
>                 timeout = usermodehelper_read_lock_wait(timeout);
>                 if (!timeout) {
>                         dev_dbg(device, "firmware: %s loading timed out\n",
> @@ -1090,17 +1096,16 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>                 dev_warn(device, "Direct firmware load failed with error %d\n",
>                          ret);
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
> -               if (fallback) {
> +               if (opt_flags & FW_OPT_FALLBACK) {
>                         dev_warn(device, "Falling back to user helper\n");
>                         ret = fw_load_from_user_helper(fw, name, device,
> -                                              uevent, nowait, timeout);
> +                                                      opt_flags, timeout);
>                 }
>  #endif
>         }
>
> -       /* don't cache firmware handled without uevent */
>         if (!ret)
> -               ret = assign_firmware_buf(fw, device, !uevent);
> +               ret = assign_firmware_buf(fw, device, opt_flags);
>
>         usermodehelper_read_unlock();
>
> @@ -1142,7 +1147,8 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>
>         /* Need to pin this module until return */
>         __module_get(THIS_MODULE);
> -       ret = _request_firmware(firmware_p, name, device, true, false, true);
> +       ret = _request_firmware(firmware_p, name, device,
> +                               FW_OPT_UEVENT | FW_OPT_FALLBACK);
>         module_put(THIS_MODULE);
>         return ret;
>  }
> @@ -1165,7 +1171,7 @@ int request_firmware_direct(const struct firmware **firmware_p,
>  {
>         int ret;
>         __module_get(THIS_MODULE);
> -       ret = _request_firmware(firmware_p, name, device, true, false, false);
> +       ret = _request_firmware(firmware_p, name, device, FW_OPT_UEVENT);
>         module_put(THIS_MODULE);
>         return ret;
>  }
> @@ -1194,7 +1200,7 @@ struct firmware_work {
>         struct device *device;
>         void *context;
>         void (*cont)(const struct firmware *fw, void *context);
> -       bool uevent;
> +       unsigned int opt_flags;
>  };
>
>  static void request_firmware_work_func(struct work_struct *work)
> @@ -1205,7 +1211,7 @@ static void request_firmware_work_func(struct work_struct *work)
>         fw_work = container_of(work, struct firmware_work, work);
>
>         _request_firmware(&fw, fw_work->name, fw_work->device,
> -                         fw_work->uevent, true, true);
> +                         fw_work->opt_flags);
>         fw_work->cont(fw, fw_work->context);
>         put_device(fw_work->device); /* taken in request_firmware_nowait() */
>
> @@ -1253,7 +1259,8 @@ request_firmware_nowait(
>         fw_work->device = device;
>         fw_work->context = context;
>         fw_work->cont = cont;
> -       fw_work->uevent = uevent;
> +       fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
> +               (uevent ? FW_OPT_UEVENT : 0);
>
>         if (!try_module_get(module)) {
>                 kfree(fw_work);
> --
> 1.8.4.2
>
