Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaGBBvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:51:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaGBBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140702010117.GS27687@wotan.suse.de>
References: <1404171017-28064-1-git-send-email-mcgrof@do-not-panic.com>
	<CACVXFVMgNa6RM6GdtNbbNOG0zn29WVRSfD8xdM983-x8sGnp4g@mail.gmail.com>
	<s5hk37x8mdc.wl%tiwai@suse.de>
	<20140702010117.GS27687@wotan.suse.de>
Date: Wed, 2 Jul 2014 09:51:36 +0800
Message-ID: <CACVXFVNKc7i1CiyY=6cG+xv9joTFgthwBwMZMyTfTN9Z-+XqfA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: inform direct failure when udev loader
 is disabled
From: Ming Lei <ming.lei@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Stefan Roese <sr@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 9:01 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Tue, Jul 01, 2014 at 11:22:07AM +0200, Takashi Iwai wrote:
>> At Tue, 1 Jul 2014 11:54:24 +0800,
>> Ming Lei wrote:
>> >
>> > On Tue, Jul 1, 2014 at 7:30 AM, Luis R. Rodriguez
>> > <mcgrof@do-not-panic.com> wrote:
>> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
>> > >
>> > > Now that the udev firmware loader is optional request_firmware()
>> > > will not provide any information on the kernel ring buffer if
>> > > direct firmware loading failed and udev firmware loading is disabled.
>> > > If no information is needed request_firmware_direct() should be used
>> > > for optional firmware, at which point drivers can take on the onus
>> > > over informing of any failures, if udev firmware loading is disabled
>> > > though we should at the very least provide some sort of information
>> > > as when the udev loader was enabled by default back in the days.
>> > >
>> > > With this change with a simple firmware load test module [0]:
>> > >
>> > > Example output without FW_LOADER_USER_HELPER_FALLBACK
>> > >
>> > > platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
>> > >
>> > > Example without FW_LOADER_USER_HELPER_FALLBACK
>> > >
>> > > platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
>> > > platform fake-dev.0: Falling back to user helper
>> > >
>> > > Without this change without FW_LOADER_USER_HELPER_FALLBACK we get no output
>> > > logged upon failure.
>> > >
>> > > [0] https://github.com/mcgrof/fake-firmware-test.git
>> > >
>> > > Cc: Tom Gundersen <teg@jklm.no>
>> > > Cc: Ming Lei <ming.lei@canonical.com>
>> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > > Cc: Abhay Salunke <Abhay_Salunke@dell.com>
>> > > Cc: Stefan Roese <sr@denx.de>
>> > > Cc: Arnd Bergmann <arnd@arndb.de>
>> > > Cc: Kay Sievers <kay@vrfy.org>
>> > > Cc: Takashi Iwai <tiwai@suse.de>
>> > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
>> > > ---
>> > >
>> > >  drivers/base/firmware_class.c | 12 ++++++++----
>> > >  1 file changed, 8 insertions(+), 4 deletions(-)
>> > >
>> > > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> > > index 46ea5f4..23274d8 100644
>> > > --- a/drivers/base/firmware_class.c
>> > > +++ b/drivers/base/firmware_class.c
>> > > @@ -101,8 +101,10 @@ static inline long firmware_loading_timeout(void)
>> > >  #define FW_OPT_NOWAIT  (1U << 1)
>> > >  #ifdef CONFIG_FW_LOADER_USER_HELPER
>> > >  #define FW_OPT_USERHELPER      (1U << 2)
>> > > +#define FW_OPT_FAIL_WARN       0
>> > >  #else
>> > >  #define FW_OPT_USERHELPER      0
>> > > +#define FW_OPT_FAIL_WARN       (1U << 3)
>> > >  #endif
>> > >  #ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>> > >  #define FW_OPT_FALLBACK                FW_OPT_USERHELPER
>> > > @@ -1116,10 +1118,11 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>> > >
>> > >         ret = fw_get_filesystem_firmware(device, fw->priv);
>> > >         if (ret) {
>> > > -               if (opt_flags & FW_OPT_USERHELPER) {
>> > > +               if (opt_flags & (FW_OPT_FAIL_WARN | FW_OPT_USERHELPER))
>> > >                         dev_warn(device,
>> > > -                                "Direct firmware load failed with error %d\n",
>> > > -                                ret);
>> > > +                                "Direct firmware load for %s failed with error %d\n",
>> > > +                                name, ret);
>> >
>> > Maybe the warning can be always printed out since
>> > (FW_OPT_FAIL_WARN | FW_OPT_USERHELPER) should be
>> > always true.
>>
>> Yes, it'd be simpler.  Let's reduce lines! :)
>
> Actually we don't want to warn when request_firmware_direct() is used right? That's really what

Yes, that is for the CPU microcode update in which it is common to
fail in direct loading, and x86 guys hate the warning.

> I meant to upkeep while adding a warning when _direct() is not used. So how about
> this as an ammendment:

Yes, the idea is right, and it is good to make request_firmware_direct()
not depend on CONFIG_FW_LOADER_USER_HELPER, and with
one FW_OPT_DIRECT_ONLY flag together it should work.

>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 23274d8..4f6adf3 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -1180,7 +1180,6 @@ request_firmware(const struct firmware **firmware_p, const char *name,
>  }
>  EXPORT_SYMBOL(request_firmware);
>
> -#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
>  /**
>   * request_firmware: - load firmware directly without usermode helper
>   * @firmware_p: pointer to firmware image
> @@ -1202,7 +1201,6 @@ int request_firmware_direct(const struct firmware **firmware_p,
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(request_firmware_direct);
> -#endif
>
>  /**
>   * release_firmware: - release the resource associated with a firmware image
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 67e5b80..5c41c5e 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -45,6 +45,8 @@ int request_firmware_nowait(
>         struct module *module, bool uevent,
>         const char *name, struct device *device, gfp_t gfp, void *context,
>         void (*cont)(const struct firmware *fw, void *context));
> +int request_firmware_direct(const struct firmware **fw, const char *name,
> +                           struct device *device);
>
>  void release_firmware(const struct firmware *fw);
>  #else
> @@ -66,13 +68,12 @@ static inline void release_firmware(const struct firmware *fw)
>  {
>  }
>
> -#endif
> +static inline int request_firmware_direct(const struct firmware **fw,
> +                                         const char *name,
> +                                         struct device *device)
> +{
> +       return -EINVAL;
> +}

You define two request_firmware_direct?

>
> -#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> -int request_firmware_direct(const struct firmware **fw, const char *name,
> -                           struct device *device);
> -#else
> -#define request_firmware_direct        request_firmware
>  #endif
> -
>  #endif
