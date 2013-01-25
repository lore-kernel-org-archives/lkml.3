Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3AYDMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:12:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50325 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3AYDMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <s5hliblh1v8.wl%tiwai@suse.de>
References: <s5hliblh1v8.wl%tiwai@suse.de>
Date: Fri, 25 Jan 2013 11:12:03 +0800
Message-ID: <CACVXFVNxWUWGN-HAuaQ1rLsxdGBYAUqZKAPCocPgiD3K8HBuFA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Make user-mode helper optional
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 7:51 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Since 3.7 kernel, the firmware loader can read the firmware files
> directly, and the traditional user-mode helper is invoked only as a
> fallback.  This seems working pretty well, and the next step would be
> to reduce the redundant user-mode helper stuff in future.

The idea is good.

>
> This patch is a preparation for that, to make the user-mode helper
> invocation optional via kconfig.  Other than that, there is no
> functional change here.

In fact, your patch does much code refactoring work, which isn't
strictly related with what you claimed in the commit log, at least
it should be separated from introducing FW_LOADER_USER_HELPER.

So could you split the patch into several parts and let one part do one thing
so that we can review them a bit easily?

Also it is not good to introduce too many '#ifdef #endif', IMO.

>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/Kconfig          |  11 ++
>  drivers/base/firmware_class.c | 350 +++++++++++++++++++++++++-----------------
>  2 files changed, 218 insertions(+), 143 deletions(-)
>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index c8b4539..07abd9d 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -145,6 +145,17 @@ config EXTRA_FIRMWARE_DIR
>           this option you can point it elsewhere, such as /lib/firmware/ or
>           some other directory containing the firmware files.
>
> +config FW_LOADER_USER_HELPER
> +       bool "Fallback user-helper invocation for firmware loading"
> +       depends on FW_LOADER
> +       default y
> +       help
> +         This option enables / disables the invocation of user-helper
> +         (e.g. udev) for loading firmware files as a fallback after the
> +         direct file loading in kernel fails.  The user-mode helper is
> +         no longer required unless you have a special firmware file that
> +         resides in a non-standard path.
> +
>  config DEBUG_DRIVER
>         bool "Driver Core verbose debug messages"
>         depends on DEBUG_KERNEL
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index b392b35..6c6f714 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -88,6 +88,7 @@ enum {
>         FW_STATUS_ABORT,
>  };
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>  enum fw_buf_fmt {
>         VMALLOC_BUF,    /* used in direct loading */
>         PAGE_BUF,       /* used in loading via userspace */
> @@ -99,6 +100,7 @@ static inline long firmware_loading_timeout(void)
>  {
>         return loading_timeout > 0 ? loading_timeout * HZ : MAX_SCHEDULE_TIMEOUT;
>  }
> +#endif /* CONFIG_FW_LOADER_USER_HELPER */
>
>  struct firmware_cache {
>         /* firmware_buf instance will be added into the below list */
> @@ -128,12 +130,14 @@ struct firmware_buf {
>         struct completion completion;
>         struct firmware_cache *fwc;
>         unsigned long status;
> -       enum fw_buf_fmt fmt;
>         void *data;
>         size_t size;
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +       enum fw_buf_fmt fmt;
>         struct page **pages;
>         int nr_pages;
>         int page_array_size;
> +#endif
>         char fw_id[];
>  };
>
> @@ -142,6 +146,7 @@ struct fw_cache_entry {
>         char name[];
>  };
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>  struct firmware_priv {
>         struct delayed_work timeout_work;
>         bool nowait;
> @@ -149,6 +154,7 @@ struct firmware_priv {
>         struct firmware_buf *buf;
>         struct firmware *fw;
>  };
> +#endif
>
>  struct fw_name_devm {
>         unsigned long magic;
> @@ -182,7 +188,9 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
>         strcpy(buf->fw_id, fw_name);
>         buf->fwc = fwc;
>         init_completion(&buf->completion);
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         buf->fmt = VMALLOC_BUF;
> +#endif
>
>         pr_debug("%s: fw-%s buf=%p\n", __func__, fw_name, buf);
>
> @@ -240,7 +248,6 @@ static void __fw_free_buf(struct kref *ref)
>  {
>         struct firmware_buf *buf = to_fwbuf(ref);
>         struct firmware_cache *fwc = buf->fwc;
> -       int i;
>
>         pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
>                  __func__, buf->fw_id, buf, buf->data,
> @@ -250,12 +257,15 @@ static void __fw_free_buf(struct kref *ref)
>         spin_unlock(&fwc->lock);
>
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         if (buf->fmt == PAGE_BUF) {
> +               int i;
>                 vunmap(buf->data);
>                 for (i = 0; i < buf->nr_pages; i++)
>                         __free_page(buf->pages[i]);
>                 kfree(buf->pages);
>         } else
> +#endif
>                 vfree(buf->data);
>         kfree(buf);
>  }
> @@ -319,7 +329,8 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
>         return true;
>  }
>
> -static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
> +static bool fw_get_filesystem_firmware(struct device *device,
> +                                      struct firmware_buf *buf)
>  {
>         int i;
>         bool success = false;
> @@ -343,9 +354,32 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
>                         break;
>         }
>         __putname(path);
> +
> +       if (success) {
> +               dev_dbg(device, "firmware: direct-loading firmware %s\n",
> +                       buf->fw_id);
> +               mutex_lock(&fw_lock);
> +               set_bit(FW_STATUS_DONE, &buf->status);
> +               mutex_unlock(&fw_lock);
> +               complete_all(&buf->completion);
> +       }
> +
>         return success;
>  }
>
> +/* firmware holds the ownership of pages */
> +static void firmware_free_data(const struct firmware *fw)
> +{
> +       /* Loaded directly? */
> +       if (!fw->priv) {
> +               vfree(fw->data);
> +               return;
> +       }
> +       fw_free_buf(fw->priv);
> +}
> +
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +
>  static struct firmware_priv *to_firmware_priv(struct device *dev)
>  {
>         return container_of(dev, struct firmware_priv, dev);
> @@ -435,17 +469,6 @@ static ssize_t firmware_loading_show(struct device *dev,
>         return sprintf(buf, "%d\n", loading);
>  }
>
> -/* firmware holds the ownership of pages */
> -static void firmware_free_data(const struct firmware *fw)
> -{
> -       /* Loaded directly? */
> -       if (!fw->priv) {
> -               vfree(fw->data);
> -               return;
> -       }
> -       fw_free_buf(fw->priv);
> -}
> -
>  /* Some architectures don't have PAGE_KERNEL_RO */
>  #ifndef PAGE_KERNEL_RO
>  #define PAGE_KERNEL_RO PAGE_KERNEL
> @@ -726,14 +749,17 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>  exit:
>         return fw_priv;
>  }
> +#endif /* CONFIG_FW_LOADER_USER_HELPER */
>
>  /* store the pages buffer info firmware from buf */
>  static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
>  {
>         fw->priv = buf;
> -       fw->pages = buf->pages;
>         fw->size = buf->size;
>         fw->data = buf->data;
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +       fw->pages = buf->pages;
> +#endif
>
>         pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
>                  __func__, buf->fw_id, buf, buf->data,
> @@ -796,78 +822,113 @@ static int fw_add_devm_name(struct device *dev, const char *name)
>  }
>  #endif
>
> -static void _request_firmware_cleanup(const struct firmware **firmware_p)
> +static void _request_firmware_cleanup(struct firmware **firmware_p)
>  {
>         release_firmware(*firmware_p);
>         *firmware_p = NULL;
>  }
>
> -static struct firmware_priv *
> -_request_firmware_prepare(const struct firmware **firmware_p, const char *name,
> -                         struct device *device, bool uevent, bool nowait)
> +/* wait until the shared firmware_buf becomes ready (or error) */
> +static int sync_cached_firmware_buf(struct firmware_buf *buf)
> +{
> +       int ret = 0;
> +
> +       mutex_lock(&fw_lock);
> +       while (!test_bit(FW_STATUS_DONE, &buf->status)) {
> +               if (test_bit(FW_STATUS_ABORT, &buf->status)) {
> +                       ret = -ENOENT;
> +                       break;
> +               }
> +               mutex_unlock(&fw_lock);
> +               wait_for_completion(&buf->completion);
> +               mutex_lock(&fw_lock);
> +       }
> +       mutex_unlock(&fw_lock);
> +       return ret;
> +}
> +
> +/* prepare firmware and firmware_buf structs;
> + * return 1 if a firmware is already assigned, 0 if need to load one,
> + * or a negative error code
> + */
> +static int
> +_request_firmware_prepare(struct firmware **firmware_p, const char *name,
> +                         struct device *device)
>  {
>         struct firmware *firmware;
> -       struct firmware_priv *fw_priv = NULL;
>         struct firmware_buf *buf;
>         int ret;
>
> -       if (!firmware_p)
> -               return ERR_PTR(-EINVAL);
> -
>         *firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
>         if (!firmware) {
>                 dev_err(device, "%s: kmalloc(struct firmware) failed\n",
>                         __func__);
> -               return ERR_PTR(-ENOMEM);
> +               return -ENOMEM;
>         }
>
>         if (fw_get_builtin_firmware(firmware, name)) {
>                 dev_dbg(device, "firmware: using built-in firmware %s\n", name);
> -               return NULL;
> +               return 1; /* assigned */
>         }
>
>         ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf);
> -       if (!ret)
> -               fw_priv = fw_create_instance(firmware, name, device,
> -                               uevent, nowait);
>
> -       if (IS_ERR(fw_priv) || ret < 0) {
> -               kfree(firmware);
> -               *firmware_p = NULL;
> -               return ERR_PTR(-ENOMEM);
> -       } else if (fw_priv) {
> -               fw_priv->buf = buf;
> +       /* bind buf with firmware so that it'll be released upon
> +        * request_firmware() call
> +        */
> +       firmware->priv = buf;
>
> -               /*
> -                * bind with 'buf' now to avoid warning in failure path
> -                * of requesting firmware.
> -                */
> -               firmware->priv = buf;
> -               return fw_priv;
> +       if (ret > 0) {
> +               ret = sync_cached_firmware_buf(buf);
> +               if (!ret) {
> +                       fw_set_page_data(buf, firmware);
> +                       return 1; /* assigned */
> +               }
>         }
>
> -       /* share the cached buf, which is inprogessing or completed */
> - check_status:
> -       mutex_lock(&fw_lock);
> -       if (test_bit(FW_STATUS_ABORT, &buf->status)) {
> -               fw_priv = ERR_PTR(-ENOENT);
> -               firmware->priv = buf;
> +       if (ret < 0)
>                 _request_firmware_cleanup(firmware_p);
> -               goto exit;
> -       } else if (test_bit(FW_STATUS_DONE, &buf->status)) {
> -               fw_priv = NULL;
> -               fw_set_page_data(buf, firmware);
> -               goto exit;
> +
> +       return 0;
> +}
> +
> +static int assign_firmware_buf(struct firmware *fw, struct device *device)
> +{
> +       struct firmware_buf *buf = fw->priv;
> +
> +       mutex_lock(&fw_lock);
> +       if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status)) {
> +               mutex_unlock(&fw_lock);
> +               return -ENOENT;
>         }
> -       mutex_unlock(&fw_lock);
> -       wait_for_completion(&buf->completion);
> -       goto check_status;
>
> -exit:
> +       /*
> +        * add firmware name into devres list so that we can auto cache
> +        * and uncache firmware for device.
> +        *
> +        * device may has been deleted already, but the problem
> +        * should be fixed in devres or driver core.
> +        */
> +       if (device)
> +               fw_add_devm_name(device, buf->fw_id);
> +
> +       /*
> +        * After caching firmware image is started, let it piggyback
> +        * on request firmware.
> +        */
> +       if (buf->fwc->state == FW_LOADER_START_CACHE) {
> +               if (fw_cache_piggyback_on_request(buf->fw_id))
> +                       kref_get(&buf->ref);
> +       }
> +
> +       /* pass the pages buffer to driver at the last minute */
> +       fw_set_page_data(buf, fw);
>         mutex_unlock(&fw_lock);
> -       return fw_priv;
> +       return 0;
>  }
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
> +/* load a firmware via user helper */
>  static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>                                   long timeout)
>  {
> @@ -875,20 +936,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>         struct device *f_dev = &fw_priv->dev;
>         struct firmware_buf *buf = fw_priv->buf;
>         struct firmware_cache *fwc = &fw_cache;
> -       int direct_load = 0;
> -
> -       /* try direct loading from fs first */
> -       if (fw_get_filesystem_firmware(buf)) {
> -               dev_dbg(f_dev->parent, "firmware: direct-loading"
> -                       " firmware %s\n", buf->fw_id);
> -
> -               mutex_lock(&fw_lock);
> -               set_bit(FW_STATUS_DONE, &buf->status);
> -               mutex_unlock(&fw_lock);
> -               complete_all(&buf->completion);
> -               direct_load = 1;
> -               goto handle_fw;
> -       }
>
>         /* fall back on userspace loading */
>         buf->fmt = PAGE_BUF;
> @@ -929,38 +976,10 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>
>         cancel_delayed_work_sync(&fw_priv->timeout_work);
>
> -handle_fw:
> -       mutex_lock(&fw_lock);
> -       if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
> -               retval = -ENOENT;
> -
> -       /*
> -        * add firmware name into devres list so that we can auto cache
> -        * and uncache firmware for device.
> -        *
> -        * f_dev->parent may has been deleted already, but the problem
> -        * should be fixed in devres or driver core.
> -        */
> -       if (!retval && f_dev->parent)
> -               fw_add_devm_name(f_dev->parent, buf->fw_id);
> -
> -       /*
> -        * After caching firmware image is started, let it piggyback
> -        * on request firmware.
> -        */
> -       if (!retval && fwc->state == FW_LOADER_START_CACHE) {
> -               if (fw_cache_piggyback_on_request(buf->fw_id))
> -                       kref_get(&buf->ref);
> -       }
> -
> -       /* pass the pages buffer to driver at the last minute */
> -       fw_set_page_data(buf, fw_priv->fw);
> +       if (!retval)
> +               retval = assign_firmware_buf(fw_priv->fw, f_dev->parent);
>
>         fw_priv->buf = NULL;
> -       mutex_unlock(&fw_lock);
> -
> -       if (direct_load)
> -               goto err_put_dev;
>
>         device_remove_file(f_dev, &dev_attr_loading);
>  err_del_bin_attr:
> @@ -972,6 +991,78 @@ err_put_dev:
>         return retval;
>  }
>
> +static int fw_load_from_user_helper(struct firmware *firmware,
> +                                   const char *name, struct device *device,
> +                                   bool uevent, long timeout)
> +{
> +       struct firmware_priv *fw_priv;
> +       long timeout;
> +       int ret;
> +
> +       fw_priv = fw_create_instance(*firmware_p, name, device, uevent, timeout);
> +       if (IS_ERR(fw_priv))
> +               return PTR_ERR(fw_priv);
> +
> +       fw_priv->buf = firmware->priv;
> +
> +       timeout = firmware_loading_timeout();
> +       if (nowait) {
> +               timeout = usermodehelper_read_lock_wait(timeout);
> +               if (!timeout) {
> +                       dev_dbg(device, "firmware: %s loading timed out\n",
> +                               name);
> +                       kfree(fw_priv);
> +                       return -EAGAIN;
> +               }
> +       } else {
> +               ret = usermodehelper_read_trylock();
> +               if (WARN_ON(ret)) {
> +                       dev_err(device, "firmware: %s will not be loaded\n",
> +                               name);
> +                       kfree(fw_priv);
> +                       return ret;
> +               }
> +       }
> +
> +       ret = _request_firmware_load(fw_priv, uevent, timeout);
> +       usermodehelper_read_unlock();
> +       return ret;
> +}
> +#else /* CONFIG_FW_LOADER_USER_HELPER */
> +static inline int
> +fw_load_from_user_helper(struct firmware *firmware, const char *name,
> +                        struct device *device, bool uevent, long timeout)
> +{
> +       return -ENOENT;
> +}
> +#endif /* CONFIG_FW_LOADER_USER_HELPER */
> +
> +static int
> +_request_firmware(const struct firmware **firmware_p, const char *name,
> +                 struct device *device, bool uevent, bool nowait)
> +{
> +       struct firmware *fw;
> +       int ret;
> +
> +       ret = _request_firmware_prepare(&fw, name, device);
> +       if (ret < 0)
> +               return ret;
> +       else if (ret) { /* assigned from either built-in or cache */
> +               *firmware_p = fw;
> +               return 0;
> +       }
> +
> +       if (fw_get_filesystem_firmware(device, fw->priv))
> +               ret = assign_firmware_buf(fw, device);
> +       else
> +               ret = fw_load_from_user_helper(fw, name, device,
> +                                              uevent, nowait);
> +       if (ret)
> +               _request_firmware_cleanup(&fw);
> +       *firmware_p = fw;
> +       return ret;
> +}
> +
>  /**
>   * request_firmware: - send firmware request and wait for it
>   * @firmware_p: pointer to firmware image
> @@ -994,28 +1085,9 @@ err_put_dev:
>   **/
>  int
>  request_firmware(const struct firmware **firmware_p, const char *name,
> -                 struct device *device)
> +                struct device *device)
>  {
> -       struct firmware_priv *fw_priv;
> -       int ret;
> -
> -       fw_priv = _request_firmware_prepare(firmware_p, name, device, true,
> -                                           false);
> -       if (IS_ERR_OR_NULL(fw_priv))
> -               return PTR_RET(fw_priv);
> -
> -       ret = usermodehelper_read_trylock();
> -       if (WARN_ON(ret)) {
> -               dev_err(device, "firmware: %s will not be loaded\n", name);
> -       } else {
> -               ret = _request_firmware_load(fw_priv, true,
> -                                       firmware_loading_timeout());
> -               usermodehelper_read_unlock();
> -       }
> -       if (ret)
> -               _request_firmware_cleanup(firmware_p);
> -
> -       return ret;
> +       return _request_firmware(firmware_p, name, device, true, false);
>  }
>
>  /**
> @@ -1046,31 +1118,11 @@ static void request_firmware_work_func(struct work_struct *work)
>  {
>         struct firmware_work *fw_work;
>         const struct firmware *fw;
> -       struct firmware_priv *fw_priv;
> -       long timeout;
> -       int ret;
>
>         fw_work = container_of(work, struct firmware_work, work);
> -       fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
> -                       fw_work->uevent, true);
> -       if (IS_ERR_OR_NULL(fw_priv)) {
> -               ret = PTR_RET(fw_priv);
> -               goto out;
> -       }
> -
> -       timeout = usermodehelper_read_lock_wait(firmware_loading_timeout());
> -       if (timeout) {
> -               ret = _request_firmware_load(fw_priv, fw_work->uevent, timeout);
> -               usermodehelper_read_unlock();
> -       } else {
> -               dev_dbg(fw_work->device, "firmware: %s loading timed out\n",
> -                       fw_work->name);
> -               ret = -EAGAIN;
> -       }
> -       if (ret)
> -               _request_firmware_cleanup(&fw);
>
> - out:
> +       _request_firmware(&fw, fw_work->name, fw_work->device,
> +                         fw_work->uevent, true);
>         fw_work->cont(fw, fw_work->context);
>         put_device(fw_work->device);
>
> @@ -1347,7 +1399,9 @@ static void __device_uncache_fw_images(void)
>  static void device_cache_fw_images(void)
>  {
>         struct firmware_cache *fwc = &fw_cache;
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         int old_timeout;
> +#endif
>         DEFINE_WAIT(wait);
>
>         pr_debug("%s\n", __func__);
> @@ -1355,6 +1409,7 @@ static void device_cache_fw_images(void)
>         /* cancel uncache work */
>         cancel_delayed_work_sync(&fwc->work);
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         /*
>          * use small loading timeout for caching devices' firmware
>          * because all these firmware images have been loaded
> @@ -1365,6 +1420,7 @@ static void device_cache_fw_images(void)
>          */
>         old_timeout = loading_timeout;
>         loading_timeout = 10;
> +#endif
>
>         mutex_lock(&fw_lock);
>         fwc->state = FW_LOADER_START_CACHE;
> @@ -1374,7 +1430,9 @@ static void device_cache_fw_images(void)
>         /* wait for completion of caching firmware for all devices */
>         async_synchronize_full_domain(&fw_cache_domain);
>
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         loading_timeout = old_timeout;
> +#endif
>  }
>
>  /**
> @@ -1474,7 +1532,11 @@ static void __init fw_cache_init(void)
>  static int __init firmware_class_init(void)
>  {
>         fw_cache_init();
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         return class_register(&firmware_class);
> +#else
> +       return 0;
> +#endif
>  }
>
>  static void __exit firmware_class_exit(void)
> @@ -1483,7 +1545,9 @@ static void __exit firmware_class_exit(void)
>         unregister_syscore_ops(&fw_syscore_ops);
>         unregister_pm_notifier(&fw_cache.pm_notify);
>  #endif
> +#ifdef CONFIG_FW_LOADER_USER_HELPER
>         class_unregister(&firmware_class);
> +#endif
>  }
>
>  fs_initcall(firmware_class_init);
> --
> 1.8.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
