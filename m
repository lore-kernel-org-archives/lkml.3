Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3LRKVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:21:49 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:47127 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LRKVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:21:47 -0500
X-Greylist: delayed 7219 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 05:21:47 EST
MIME-Version: 1.0
In-Reply-To: <s5hppouv4y4.wl%tiwai@suse.de>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<s5hfvpqk0p8.wl%tiwai@suse.de>
	<s5hppouv4y4.wl%tiwai@suse.de>
Date: Wed, 18 Dec 2013 11:21:46 +0100
Message-ID: <CANq1E4SEL6J50tvv-N9xSs6oA=Og96-7TQOECx=p-WGG3mU9=Q@mail.gmail.com>
Subject: Re: cirrusdrmfb broken with simplefb
From: David Herrmann <dh.herrmann@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Dec 18, 2013 at 11:17 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 18 Dec 2013 09:44:35 +0100,
> Takashi Iwai wrote:
>>
>> At Wed, 18 Dec 2013 09:21:28 +0100,
>> David Herrmann wrote:
>> >
>> > Hi
>> >
>> > On Wed, Dec 18, 2013 at 8:42 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > > Hi,
>> > >
>> > > with the recent enablement of simplefb on x86, cirrusdrmfb on QEMU/KVM
>> > > gets broken now, as reported at:
>> > >     https://bugzilla.novell.com/show_bug.cgi?id=855821
>> > >
>> > > The cirrus VGA resource is reserved at first as "BOOTFB" in
>> > > arch/x86/kernel/sysfb_simplefb.c, which is taken by simplefb platform
>> > > device.  This resource is, however, never released until the platform
>> > > device is destroyed, and the framebuffer switching doesn't trigger
>> > > it.  It calls fb's destroy callback, at most.  Then, cirrus driver
>> > > tries to assign the resource, fails and gives up, resulting in a
>> > > complete blank screen.
>> > >
>> > > The same problem should exist on other KMS drivers like mgag200 or
>> > > ast, not only cirrus.  Intel graphics doesn't hit this problem just
>> > > because the reserved iomem by BOOTFB isn't required by i915 driver.
>> > >
>> > > The patch below is a quick attempt to solve the issue.  It adds a new
>> > > API function for releasing resources of platform_device, and call it
>> > > in destroy op of simplefb.  But, forcibly releasing resources of a
>> > > parent device doesn't sound like a correct design.  We may take such
>> > > as a band aid, but definitely need a more fundamental fix.
>> > >
>> > > Any thoughts?
>> >
>> > That bug always existed, simplefb is just the first driver to hit it
>> > (vesafb/efifb didn't use resources).
>>
>> Heh, the bug didn't "exist" because no other grabbed the resource
>> before.  The way the cirrus driver allocates the resource is no bug,
>> per se.  But the proper resource takeover is missing.
>>
>> > I'm aware of the issue but as a
>> > workaround you can simply disable CONFIG_X86_SYSFB. That restores the
>> > old behavior.
>>
>> Yes, but CONFIG_X86_SYSFB breaks things as of now.  Shouldn't it be
>> mentioned or give some kconfig hints instead of silently giving a
>> broken output, if any quick fix isn't possible?
>>
>> > As a proper fix, I'd propose something like:
>> >   dev = platform_find_device("platform-framebuffer");
>> >   platform_remove_device(dev);
>> >
>> > And we wrap this as:
>> >   sysfb_remove_framebuffers()
>> > in arch/x86/kernel/sysfb.c
>> >
>> > This should cause a ->remove() event for the platform-driver and
>> > correctly release the resources. Comments?
>>
>> Who will call this?  From destroy callback?
>> Or can we simply do put_device() the bound platform device instead?
>
> Just tested, put_device() doesn't work since the refcount isn't 1, so
> if any, we need to call platform_device_unregister() to release
> forcibly.
>
> The patch below seems working at a quick test.  But I still have
> some bad feeling for unregistering the parent device from the child's
> destroy callback...

The idea is right, but call it from
"remove_conflicting_framebuffers()". The problem is, if we load a
driver on top of a dummy like vesafb/efifb/simplefb, we never removed
them properly. Instead, we only unregistered their fb driver. But with
the driver-model, that's just removing the driver, not the dummy
device.

So we'd just call platform_device_unregister() in
remove_conflicting_framebuffers() instead of unregister_framebuffer()
on such devices. I'm now at home and will have a look.

Thanks
David

>
> thanks,
>
> Takashi
>
> ---
> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
> index 210f3a02121a..196360c54157 100644
> --- a/drivers/video/simplefb.c
> +++ b/drivers/video/simplefb.c
> @@ -41,6 +41,11 @@ static struct fb_var_screeninfo simplefb_var = {
>         .vmode          = FB_VMODE_NONINTERLACED,
>  };
>
> +struct simplefb_priv {
> +       u32 pseudo_palette[16];
> +       struct platform_device *pdev;
> +};
> +
>  static int simplefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
>                               u_int transp, struct fb_info *info)
>  {
> @@ -68,8 +73,19 @@ static int simplefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
>
>  static void simplefb_destroy(struct fb_info *info)
>  {
> +       struct simplefb_priv *priv = info->par;
> +       struct platform_device *pdev = priv->pdev;
> +
>         if (info->screen_base)
>                 iounmap(info->screen_base);
> +
> +       /* release the bound platform device when called from
> +        * remove_conflicting_framebuffers()
> +        */
> +       if (pdev) {
> +               priv->pdev = NULL; /* to avoid double-free */
> +               platform_device_unregister(pdev);
> +       }
>  }
>
>  static struct fb_ops simplefb_ops = {
> @@ -169,6 +185,7 @@ static int simplefb_probe(struct platform_device *pdev)
>         struct simplefb_params params;
>         struct fb_info *info;
>         struct resource *mem;
> +       struct simplefb_priv *priv;
>
>         if (fb_get_options("simplefb", NULL))
>                 return -ENODEV;
> @@ -188,7 +205,7 @@ static int simplefb_probe(struct platform_device *pdev)
>                 return -EINVAL;
>         }
>
> -       info = framebuffer_alloc(sizeof(u32) * 16, &pdev->dev);
> +       info = framebuffer_alloc(sizeof(struct simplefb_priv), &pdev->dev);
>         if (!info)
>                 return -ENOMEM;
>         platform_set_drvdata(pdev, info);
> @@ -225,7 +242,9 @@ static int simplefb_probe(struct platform_device *pdev)
>                 framebuffer_release(info);
>                 return -ENODEV;
>         }
> -       info->pseudo_palette = (void *)(info + 1);
> +
> +       priv = info->par;
> +       info->pseudo_palette = priv->pseudo_palette;
>
>         dev_info(&pdev->dev, "framebuffer at 0x%lx, 0x%x bytes, mapped to 0x%p\n",
>                              info->fix.smem_start, info->fix.smem_len,
> @@ -243,6 +262,7 @@ static int simplefb_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> +       priv->pdev = pdev;
>         dev_info(&pdev->dev, "fb%d: simplefb registered!\n", info->node);
>
>         return 0;
> @@ -251,8 +271,13 @@ static int simplefb_probe(struct platform_device *pdev)
>  static int simplefb_remove(struct platform_device *pdev)
>  {
>         struct fb_info *info = platform_get_drvdata(pdev);
> +       struct simplefb_priv *priv = info->par;
> +
> +       if (priv->pdev) {
> +               priv->pdev = NULL; /* to avoid double-free */
> +               unregister_framebuffer(info);
> +       }
>
> -       unregister_framebuffer(info);
>         framebuffer_release(info);
>
>         return 0;
