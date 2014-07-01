Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaGAHYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:24:00 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:35901 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaGAHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:23:59 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <1404171017-28064-1-git-send-email-mcgrof@do-not-panic.com>
References: <1404171017-28064-1-git-send-email-mcgrof@do-not-panic.com>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 1 Jul 2014 09:23:38 +0200
Message-ID: <CAG-2HqWViA_+dkDQ63DkdfY_sd6Be+yW7WP6UquM24LjGJXSNQ@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: inform direct failure when udev loader
 is disabled
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Ming Lei <ming.lei@canonical.com>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 1:30 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Now that the udev firmware loader is optional request_firmware()
> will not provide any information on the kernel ring buffer if
> direct firmware loading failed and udev firmware loading is disabled.
> If no information is needed request_firmware_direct() should be used
> for optional firmware, at which point drivers can take on the onus
> over informing of any failures, if udev firmware loading is disabled
> though we should at the very least provide some sort of information
> as when the udev loader was enabled by default back in the days.
>
> With this change with a simple firmware load test module [0]:
>
> Example output without FW_LOADER_USER_HELPER_FALLBACK
>
> platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
>
> Example without FW_LOADER_USER_HELPER_FALLBACK

This ^^ should be "Example output with [...]" ?

Otherwise looks good, so:

Reviewed-by: Tom Gundersen <teg@jklm.no>

> platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
> platform fake-dev.0: Falling back to user helper
>
> Without this change without FW_LOADER_USER_HELPER_FALLBACK we get no output
> logged upon failure.
>
> [0] https://github.com/mcgrof/fake-firmware-test.git
>
> Cc: Tom Gundersen <teg@jklm.no>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Abhay Salunke <Abhay_Salunke@dell.com>
> Cc: Stefan Roese <sr@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>
>  drivers/base/firmware_class.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 46ea5f4..23274d8 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -101,8 +101,10 @@ static inline long firmware_loading_timeout(void)
>  #define FW_OPT_NOWAIT  (1U << 1)
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
>  #define FW_OPT_USERHELPER      (1U << 2)
> +#define FW_OPT_FAIL_WARN       0
>  #else
>  #define FW_OPT_USERHELPER      0
> +#define FW_OPT_FAIL_WARN       (1U << 3)
>  #endif
>  #ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>  #define FW_OPT_FALLBACK                FW_OPT_USERHELPER
> @@ -1116,10 +1118,11 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>
>         ret = fw_get_filesystem_firmware(device, fw->priv);
>         if (ret) {
> -               if (opt_flags & FW_OPT_USERHELPER) {
> +               if (opt_flags & (FW_OPT_FAIL_WARN | FW_OPT_USERHELPER))
>                         dev_warn(device,
> -                                "Direct firmware load failed with error %d\n",
> -                                ret);
> +                                "Direct firmware load for %s failed with error %d\n",
> +                                name, ret);
> +               if (opt_flags & FW_OPT_USERHELPER) {
>                         dev_warn(device, "Falling back to user helper\n");
>                         ret = fw_load_from_user_helper(fw, name, device,
>                                                        opt_flags, timeout);
> @@ -1170,7 +1173,8 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>         /* Need to pin this module until return */
>         __module_get(THIS_MODULE);
>         ret = _request_firmware(firmware_p, name, device,
> -                               FW_OPT_UEVENT | FW_OPT_FALLBACK);
> +                               FW_OPT_UEVENT | FW_OPT_FALLBACK |
> +                               FW_OPT_FAIL_WARN);
>         module_put(THIS_MODULE);
>         return ret;
>  }
> --
> 2.0.0
>
