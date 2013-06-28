Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3F1KnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:43:15 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52031 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3F1KnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:43:07 -0400
MIME-Version: 1.0
In-Reply-To: <51CB5D67.3090701@wwwdotorg.org>
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
	<51CB5D67.3090701@wwwdotorg.org>
Date: Fri, 28 Jun 2013 12:43:05 +0200
Message-ID: <CANq1E4R66J2JKdF1BrdczpDpvpNDUFz20v6FKJCma1XWHKWMTg@mail.gmail.com>
Subject: Re: [RFC 0/6] SimpleDRM Driver (was: dvbe driver)
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jun 26, 2013 at 11:30 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/24/2013 04:27 PM, David Herrmann wrote:
>> Hi
>>
>> This is my second revision of the dvbe driver. I renamed it to SimpleDRM to
>> show the resemblence with the recently introduced simplefb.c fbdev driver. The
>> driver is supposed to be the most basic DRM driver similar to efifb.c, vesafb.c,
>> offb.c, simplefb.c, ...
>> It provides a single virtual CRTC+encoder+connector and allows user-space to
>> create one dumb-buffer at a time and attach it.
>>
>> The setup changed slightly. It no longer uses shadow buffers but instead maps
>> the framebuffer directly into userspace. Furthermore, a new infrastructure is
>> used to unload firmware drivers during real hardware drivers probe cycles. Only
>> nouveau was changed to use it, yet.
>>
>> I still have an odd problem when unloading DRM drivers (not just SimpleDRM) with
>> an fbdev fallback. If I call printk() directly after unregister_framebufer(), I
>> get a NULL-deref somewhere in the VT layer (most times hide_cursor()). I haven't
>> figured out exactly where that happens, but I am also very reluctant to spend
>> more time debugging the VT layer.
>
> I tested this on a Tegra ARM system, and it basically worked.

Thanks a lot for the feedback!

> I have one question: With the simplefb driver, and console=tty1 on the
> kernel command-line, I see both the penguins logo and Linux's boot
> messages on the LCD panel that's hooked up through simplefb. However,
> with simpledrm, I only see the penguins logo, but no boot messages. Is
> that expected? How would I solve that if so?

No idea what is going wrong there. Somehow the simpledrm-fbdev device
is not picked up as primary device. I only got a black-cursor on
black-background (visible if painting something else on the fb0
device). And I get NULL-derefs in cursor_hide() during unregistration.
I digged through fbcon.c to find out what's going wrong but without
any success. I will see what I can do.

However, X-server or other apps work perfectly fine with it.

> Note: I needed to apply the following patch to get it to compile:
>
> diff --git a/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
> b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
> index 40a2696..39885c8 100644
> --- a/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
> +++ b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
> @@ -159,7 +159,7 @@ void sdrm_fbdev_cleanup(struct sdrm_device *sdrm)
>  {
>         struct fb_info *info;
>
> -       if (!sdrm->info)
> +       if (!sdrm->fbdev)
>                 return;

Ugh, embarrassing, sorry. I fixed it up. It was a late fix to a avoid
fbcon from panicking.

Thanks!
David

>
>         dev_info(sdrm->ddev->dev, "fbdev cleanup\n");
>
>
>
