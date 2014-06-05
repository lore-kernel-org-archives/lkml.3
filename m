Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaFEMSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:18:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFEMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:18:13 -0400
MIME-Version: 1.0
In-Reply-To: <1401896895-14262-1-git-send-email-tiwai@suse.de>
References: <1401896895-14262-1-git-send-email-tiwai@suse.de>
Date: Thu, 5 Jun 2014 20:18:08 +0800
Message-ID: <CACVXFVPpmdXJV2CC-U=bsA820VD42i2-OqBfNfTPPaMergu8TQ@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: allow disabling of udev as firmware loader
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Gundersen <teg@jklm.no>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Stefan Roese <sr@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 11:48 PM, Takashi Iwai <tiwai@suse.de> wrote:
> [The patch was originally proposed by Tom Gundersen, and rewritten
>  afterwards by me; most of changelogs below borrowed from Tom's
>  original patch -- tiwai]
>
> Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER,
> which means that distros can't really stop loading firmware through
> udev without breaking other users (though some have).
>
> Ideally we would remove/disable the udev firmware helper in both the
> kernel and in udev, but if we were to disable it in udev and not the
> kernel, the result would be (seemingly) hung kernels as no one would
> be around to cancel firmware requests.
>
> This patch allows udev firmware loading to be disabled while still
> allowing non-udev firmware loading, as done by the dell-rbu driver, to
> continue working. This is achieved by only using the fallback
> mechanism when the uevent is suppressed.
>
> The patch renames the user-selectable Kconfig from FW_LOADER_USER_HELPER
> to FW_LOADER_USER_HELPER_FALLBACK, and the former is reverse-selected
> by the latter or the drivers that need userhelper like dell-rbu.
>
> Also, the "default y" is removed together with this change, since it's
> been deprecated in udev upstream, thus rather better to disable it
> nowadays.
>
> Tested with
>     FW_LOADER_USER_HELPER=n
>     LATTICE_ECP3_CONFIG=y
>     DELL_RBU=y
> and udev without the firmware loading support, but I don't have the
> hardware to test the lattice/dell drivers, so additional testing would
> be appreciated.
>
> Reviewed-by: Tom Gundersen <teg@jklm.no>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Abhay Salunke <Abhay_Salunke@dell.com>
> Cc: Stefan Roese <sr@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kay Sievers <kay@vrfy.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/Kconfig          | 10 ++++++++--
>  drivers/base/firmware_class.c | 15 ++++++++++-----
>  include/linux/firmware.h      |  2 +-
>  3 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 8fa8deab6449..d0bb32e4c416 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -144,15 +144,21 @@ config EXTRA_FIRMWARE_DIR
>           some other directory containing the firmware files.
>
>  config FW_LOADER_USER_HELPER
> +       bool
> +
> +config FW_LOADER_USER_HELPER_FALLBACK
>         bool "Fallback user-helper invocation for firmware loading"
>         depends on FW_LOADER
> -       default y
> +       select FW_LOADER_USER_HELPER
>         help
>           This option enables / disables the invocation of user-helper
>           (e.g. udev) for loading firmware files as a fallback after the
>           direct file loading in kernel fails.  The user-mode helper is
>           no longer required unless you have a special firmware file that
> -         resides in a non-standard path.
> +         resides in a non-standard path. Moreover, the udev support has
> +         been deprecated upstream.
> +
> +         If you are unsure about this, say N here.

It may be safer to say Y here for fallback if not sure.

>
>  config DEBUG_DRIVER
>         bool "Driver Core verbose debug messages"
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d276e33880be..46ea5f4c3bb5 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -100,9 +100,14 @@ static inline long firmware_loading_timeout(void)
>  #define FW_OPT_UEVENT  (1U << 0)
>  #define FW_OPT_NOWAIT  (1U << 1)
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
> -#define FW_OPT_FALLBACK        (1U << 2)
> +#define FW_OPT_USERHELPER      (1U << 2)
>  #else
> -#define FW_OPT_FALLBACK        0
> +#define FW_OPT_USERHELPER      0
> +#endif
> +#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> +#define FW_OPT_FALLBACK                FW_OPT_USERHELPER
> +#else
> +#define FW_OPT_FALLBACK                0
>  #endif
>
>  struct firmware_cache {
> @@ -1111,7 +1116,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>
>         ret = fw_get_filesystem_firmware(device, fw->priv);
>         if (ret) {
> -               if (opt_flags & FW_OPT_FALLBACK) {
> +               if (opt_flags & FW_OPT_USERHELPER) {
>                         dev_warn(device,
>                                  "Direct firmware load failed with error %d\n",
>                                  ret);
> @@ -1171,7 +1176,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>  }
>  EXPORT_SYMBOL(request_firmware);
>
> -#ifdef CONFIG_FW_LOADER_USER_HELPER
> +#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>  /**
>   * request_firmware: - load firmware directly without usermode helper
>   * @firmware_p: pointer to firmware image
> @@ -1277,7 +1282,7 @@ request_firmware_nowait(
>         fw_work->context = context;
>         fw_work->cont = cont;
>         fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
> -               (uevent ? FW_OPT_UEVENT : 0);
> +               (uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
>
>         if (!try_module_get(module)) {
>                 kfree(fw_work);
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 59529330efd6..67e5b801af0c 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -68,7 +68,7 @@ static inline void release_firmware(const struct firmware *fw)
>
>  #endif
>
> -#ifdef CONFIG_FW_LOADER_USER_HELPER
> +#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>  int request_firmware_direct(const struct firmware **fw, const char *name,
>                             struct device *device);
>  #else
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
