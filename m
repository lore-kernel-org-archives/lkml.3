Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3ELN7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 09:59:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3ELN7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 09:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <s5hsj1xxsv2.wl%tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-2-git-send-email-tiwai@suse.de>
	<CACVXFVM2ZFYeJND7nxGhyGU7cG08Hta5qBZMAz+rDhxM1kRWZA@mail.gmail.com>
	<s5hd2t1wih4.wl%tiwai@suse.de>
	<s5h38txwhqq.wl%tiwai@suse.de>
	<s5hsj1xxsv2.wl%tiwai@suse.de>
Date: Sun, 12 May 2013 21:59:51 +0800
Message-ID: <CACVXFVNMZ41xm=B+71E=AaM9B7GtvprrorTJfNbXvigBWMibyw@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 1:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH v2] firmware: Avoid deadlock of usermodehelper lock at shutdown
>
> When a system goes to reboot/shutdown, it tries to disable the
> usermode helper via usermodehelper_disable().  This might be blocked
> when a driver tries to load a firmware beforehand and it's stuck by
> some reason.
>
> In this patch, the firmware class driver registers a reboot notifier
> so that it can abort all pending f/w bufs.  Also enable a flag for
> avoiding the call of usermodehelper after the reboot/shutdown starts.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/firmware_class.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 4b1f926..972e535 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -27,6 +27,7 @@
>  #include <linux/pm.h>
>  #include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/reboot.h>
>
>  #include <generated/utsrelease.h>
>
> @@ -171,6 +172,7 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
>         strcpy(buf->fw_id, fw_name);
>         buf->fwc = fwc;
>         init_completion(&buf->completion);
> +       INIT_LIST_HEAD(&buf->list);

You should introduce one extra field(such as, 'list_abort') in
'struct firmware_buf' and the field of 'list' is for firmware caching now.
Also, INIT_LIST_HEAD isn't needed here.

>
>         pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
>
> @@ -446,10 +448,9 @@ static struct firmware_priv *to_firmware_priv(struct device *dev)
>         return container_of(dev, struct firmware_priv, dev);
>  }
>
> -static void fw_load_abort(struct firmware_priv *fw_priv)
> +static void fw_load_abort(struct firmware_buf *buf)
>  {
> -       struct firmware_buf *buf = fw_priv->buf;
> -
> +       list_del_init(&buf->list);
>         set_bit(FW_STATUS_ABORT, &buf->status);
>         complete_all(&buf->completion);
>  }
> @@ -457,6 +458,24 @@ static void fw_load_abort(struct firmware_priv *fw_priv)
>  #define is_fw_load_aborted(buf)        \
>         test_bit(FW_STATUS_ABORT, &(buf)->status)
>
> +static LIST_HEAD(pending_fw_head);
> +
> +/* reboot notifier for avoid deadlock with usermode_lock */
> +static int fw_shutdown_notify(struct notifier_block *unused1,
> +                             unsigned long unused2, void *unused3)
> +{
> +       mutex_lock(&fw_lock);
> +       while (!list_empty(&pending_fw_head))
> +               fw_load_abort(list_first_entry(&pending_fw_head,
> +                                              struct firmware_buf, list));
> +       mutex_unlock(&fw_lock);
> +       return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block fw_shutdown_nb = {
> +       .notifier_call = fw_shutdown_notify,
> +};
> +
>  static ssize_t firmware_timeout_show(struct class *class,
>                                      struct class_attribute *attr,
>                                      char *buf)
> @@ -604,6 +623,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>                          * is completed.
>                          * */
>                         fw_map_pages_buf(fw_buf);
> +                       list_del_init(&fw_buf->list);
>                         complete_all(&fw_buf->completion);
>                         break;
>                 }
> @@ -612,7 +632,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>                 dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
>                 /* fallthrough */
>         case -1:
> -               fw_load_abort(fw_priv);
> +               fw_load_abort(fw_buf);
>                 break;
>         }
>  out:
> @@ -680,7 +700,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
>                 new_pages = kmalloc(new_array_size * sizeof(void *),
>                                     GFP_KERNEL);
>                 if (!new_pages) {
> -                       fw_load_abort(fw_priv);
> +                       fw_load_abort(buf);
>                         return -ENOMEM;
>                 }
>                 memcpy(new_pages, buf->pages,
> @@ -697,7 +717,7 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
>                         alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
>
>                 if (!buf->pages[buf->nr_pages]) {
> -                       fw_load_abort(fw_priv);
> +                       fw_load_abort(buf);
>                         return -ENOMEM;
>                 }
>                 buf->nr_pages++;
> @@ -781,7 +801,7 @@ static void firmware_class_timeout_work(struct work_struct *work)
>                 mutex_unlock(&fw_lock);
>                 return;
>         }
> -       fw_load_abort(fw_priv);
> +       fw_load_abort(fw_priv->buf);
>         mutex_unlock(&fw_lock);
>  }
>
> @@ -857,6 +877,10 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
>         }
>
> +       mutex_lock(&fw_lock);
> +       list_add(&buf->list, &pending_fw_head);
> +       mutex_unlock(&fw_lock);
> +
>         wait_for_completion(&buf->completion);
>
>         cancel_delayed_work_sync(&fw_priv->timeout_work);
> @@ -1517,6 +1541,7 @@ static int __init firmware_class_init(void)
>  {
>         fw_cache_init();
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
> +       register_reboot_notifier(&fw_shutdown_nb);
>         return class_register(&firmware_class);
>  #else
>         return 0;
> @@ -1530,6 +1555,7 @@ static void __exit firmware_class_exit(void)
>         unregister_pm_notifier(&fw_cache.pm_notify);
>  #endif
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
> +       unregister_reboot_notifier(&fw_shutdown_nb);
>         class_unregister(&firmware_class);
>  #endif
>  }
> --
> 1.8.2.1

Thanks,
--
Ming Lei
