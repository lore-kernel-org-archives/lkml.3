Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaFDOfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:35:14 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:61239 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaFDOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:35:12 -0400
MIME-Version: 1.0
X-Originating-IP: [188.149.52.16]
In-Reply-To: <s5hr43421un.wl%tiwai@suse.de>
References: <1401733474-1767-1-git-send-email-teg@jklm.no> <s5hr43421un.wl%tiwai@suse.de>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 4 Jun 2014 16:34:51 +0200
Message-ID: <CAG-2HqW1_=wCz0wjP92L7Of18HO_30Aboa4wKUuYWr+k+NryuA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 4:20 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon,  2 Jun 2014 20:24:34 +0200,
> Tom Gundersen wrote:
>>
>> Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER,
>> which means that distros can't really stop loading firmware through udev
>> without breaking other users (though some have).
>>
>> Ideally we would remove/disable the udev firmware helper in both the kernel
>> and in udev, but if we were to disable it in udev and not the kernel, the result
>> would be (seemingly) hung kernels as no one would be around to cancel firmware
>> requests.
>>
>> This patch allows udev firmware loading to be disabled while still allowing
>> non-udev firmware loading, as done by the dell-rbu driver, to continue
>> working. This is achieved by only using the fallback mechanism when the
>> uevent is suppressed.
>>
>> Tested with
>>     FW_LOADER_USER_HELPER=n
>>     LATTICE_ECP3_CONFIG=y
>>     DELL_RBU=y
>> and udev without the firmware loading support, but I don't have the hardware
>> to test the lattice/dell drivers, so additional testing would be appreciated.
>
> The logic of this patch looks good to me, but the Kconfig items become
> confusing by this.  Basically what we'd need is a Kconfig item
> deciding whether to build the user helper or not, in addition to a
> Kconfig item for deciding the fallback mode of request_firmware().
>
> What about the patch like below instead?  It's smaller and the meaning
> of Kconfig items are clearer.  (In the final form, the help text
> change you added should be included there, too.)

Yeah, this way is clearer, so looks good to me.

Reviewed-by: Tom Gundersen <teg@jklm.no>

> The only (and biggest) drawback is, however, that the user-selectable
> Kconfig would be actually renamed from CONFIG_FW_LOADER_USER_HELPER to
> CONFIG_FW_LOADER_USER_HELPER_FALLBACK.

I also first intended to rename the Kconfig stuff in this way, but I
thought prompting the user was a no-no. That said, drawing attention
to the fact that people are probably better off changing this from y
to n may be a good thing in the end.

> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 8fa8deab6449..195b08f49209 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -144,8 +144,12 @@ config EXTRA_FIRMWARE_DIR
>           some other directory containing the firmware files.
>
>  config FW_LOADER_USER_HELPER
> +       bool
> +
> +config FW_LOADER_USER_HELPER_FALLBACK
>         bool "Fallback user-helper invocation for firmware loading"
>         depends on FW_LOADER
> +       select FW_LOADER_USER_HELPER
>         default y
>         help
>           This option enables / disables the invocation of user-helper
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d276e33880be..e98fd78c5c40 100644
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
> @@ -1277,7 +1282,7 @@ request_firmware_nowait(
>         fw_work->context = context;
>         fw_work->cont = cont;
>         fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
> -               (uevent ? FW_OPT_UEVENT : 0);
> +               (uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
>
>         if (!try_module_get(module)) {
>                 kfree(fw_work);
