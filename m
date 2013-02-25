Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3BYIvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:51:50 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47013 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BYIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130225081723.GD25749@arwen.pp.htv.fi>
References: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
	<20130225081723.GD25749@arwen.pp.htv.fi>
Date: Mon, 25 Feb 2013 14:21:46 +0530
Message-ID: <CAFp+6iHaP96F0OF9_C1DTsfmkPNZMVC78tj7m0YGdV=d_znWrA@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,


On Mon, Feb 25, 2013 at 1:47 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Feb 05, 2013 at 07:15:58PM +0530, Vivek Gautam wrote:
>> Now that machines may select the mode of working of DWC3,
>> we can set the Port capability direction based on selected mode.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/dwc3/core.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 177f4c6..f4c47f7 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -479,7 +479,6 @@ static int dwc3_probe(struct platform_device *pdev)
>>
>>       switch (mode) {
>>       case DWC3_MODE_DEVICE:
>> -             dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
>>               ret = dwc3_gadget_init(dwc);
>>               if (ret) {
>>                       dev_err(dev, "failed to initialize gadget\n");
>> @@ -487,7 +486,6 @@ static int dwc3_probe(struct platform_device *pdev)
>>               }
>>               break;
>>       case DWC3_MODE_HOST:
>> -             dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
>>               ret = dwc3_host_init(dwc);
>>               if (ret) {
>>                       dev_err(dev, "failed to initialize host\n");
>> @@ -495,7 +493,6 @@ static int dwc3_probe(struct platform_device *pdev)
>>               }
>>               break;
>>       case DWC3_MODE_DRD:
>> -             dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
>>               ret = dwc3_host_init(dwc);
>>               if (ret) {
>>                       dev_err(dev, "failed to initialize host\n");
>> @@ -514,6 +511,14 @@ static int dwc3_probe(struct platform_device *pdev)
>>       }
>>       dwc->mode = mode;
>>
>> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
>> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
>> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
>> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
>> +#else
>> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
>> +#endif
>
> you can actually use:
>
> if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
>         dwc3_set_mode(dwc...
> else if (IS_ENABLED( ...
>         ...
> else
>         ...
>

I am actually hoping to change this to something like below (after
of course changing the preprocessor conditionals) :

commit 9a62ed948dcb6ac5d78aff41f5355c0a5ea86475
Author: Vivek Gautam <gautam.vivek@samsung.com>
Date:   Thu Jan 24 11:58:05 2013 +0530

    usb: dwc3: Set GCTL.PrtCapDir based on selected mode.

    Now that machines may select the mode of working of DWC3,
    we can set the Port capability direction based on selected mode.

    Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 79f335f..9444fbe 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -478,7 +478,13 @@ static int dwc3_probe(struct platform_device *pdev)
                goto err1;
        }

-       mode = DWC3_MODE(dwc->hwparams.hwparams0);
+#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
+       mode = DWC3_MODE_HOST;
+#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
+       mode = DWC3_MODE_DEVICE;
+#else
+       mode = DWC3_MODE_DRD;
+#endif

        switch (mode) {
        case DWC3_MODE_DEVICE:


Since the mode is now software dependent, we can skip
initializing gadget/host in case of Host-only/Gadget-only modes respectively.
Can't guess how much this is valid though :-(

> instead of pre-processor conditionals. In fact, I have recently written
> a patch converting #if IS_ENABLED() to if (IS_ENABLED()) but I haven't
> posted yet:
>

Right, very valid change. Missed this in earlier change :-(

> commit 42dbbbc272bc941ec2b0cac51342609e61e13a01
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Fri Feb 22 16:24:49 2013 +0200
>
>     usb: dwc3: debugfs: improve debugfs file creation
>
>     when commit 388e5c5 (usb: dwc3: remove dwc3
>     dependency on host AND gadget.) changed the
>     way debugfs files are created, it failed to
>     note that 'mode' is necessary in Dual Role
>     mode only while 'testmode' and 'link_state'
>     are valid in Dual Role and Peripheral-only
>     builds. Fix this while also converting pre-
>     processor conditional to C conditionals.
>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>
> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
> index a1bac9a..8b23d045 100644
> --- a/drivers/usb/dwc3/debugfs.c
> +++ b/drivers/usb/dwc3/debugfs.c
> @@ -667,28 +667,31 @@ int dwc3_debugfs_init(struct dwc3 *dwc)
>                 goto err1;
>         }
>
> -#if IS_ENABLED(CONFIG_USB_DWC3_GADGET)
> -       file = debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
> -                       dwc, &dwc3_mode_fops);
> -       if (!file) {
> -               ret = -ENOMEM;
> -               goto err1;
> +       if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)) {
> +               file = debugfs_create_file("mode", S_IRUGO | S_IWUSR, root,
> +                               dwc, &dwc3_mode_fops);
> +               if (!file) {
> +                       ret = -ENOMEM;
> +                       goto err1;
> +               }
>         }
>
> -       file = debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
> -                       dwc, &dwc3_testmode_fops);
> -       if (!file) {
> -               ret = -ENOMEM;
> -               goto err1;
> -       }
> -
> -       file = debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
> -                       dwc, &dwc3_link_state_fops);
> -       if (!file) {
> -               ret = -ENOMEM;
> -               goto err1;
> +       if (IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE) ||
> +                       IS_ENABLED(CONFIG_USB_DWC3_GADGET)) {
> +               file = debugfs_create_file("testmode", S_IRUGO | S_IWUSR, root,
> +                               dwc, &dwc3_testmode_fops);
> +               if (!file) {
> +                       ret = -ENOMEM;
> +                       goto err1;
> +               }
> +
> +               file = debugfs_create_file("link_state", S_IRUGO | S_IWUSR, root,
> +                               dwc, &dwc3_link_state_fops);
> +               if (!file) {
> +                       ret = -ENOMEM;
> +                       goto err1;
> +               }
>         }
> -#endif
>
>         return 0;
>
>
> --
> balbi



-- 
Thanks & Regards
Vivek
