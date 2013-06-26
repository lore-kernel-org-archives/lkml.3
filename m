Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3FZVaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:30:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33428 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3FZVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:30:18 -0400
Message-ID: <51CB5D67.3090701@wwwdotorg.org>
Date: Wed, 26 Jun 2013 15:30:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 0/6] SimpleDRM Driver (was: dvbe driver)
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 PM, David Herrmann wrote:
> Hi
> 
> This is my second revision of the dvbe driver. I renamed it to SimpleDRM to
> show the resemblence with the recently introduced simplefb.c fbdev driver. The
> driver is supposed to be the most basic DRM driver similar to efifb.c, vesafb.c,
> offb.c, simplefb.c, ...
> It provides a single virtual CRTC+encoder+connector and allows user-space to
> create one dumb-buffer at a time and attach it.
> 
> The setup changed slightly. It no longer uses shadow buffers but instead maps
> the framebuffer directly into userspace. Furthermore, a new infrastructure is
> used to unload firmware drivers during real hardware drivers probe cycles. Only
> nouveau was changed to use it, yet.
> 
> I still have an odd problem when unloading DRM drivers (not just SimpleDRM) with
> an fbdev fallback. If I call printk() directly after unregister_framebufer(), I
> get a NULL-deref somewhere in the VT layer (most times hide_cursor()). I haven't
> figured out exactly where that happens, but I am also very reluctant to spend
> more time debugging the VT layer.

I tested this on a Tegra ARM system, and it basically worked.

I have one question: With the simplefb driver, and console=tty1 on the
kernel command-line, I see both the penguins logo and Linux's boot
messages on the LCD panel that's hooked up through simplefb. However,
with simpledrm, I only see the penguins logo, but no boot messages. Is
that expected? How would I solve that if so?

Note: I needed to apply the following patch to get it to compile:

diff --git a/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
index 40a2696..39885c8 100644
--- a/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
+++ b/drivers/gpu/drm/simpledrm/simpledrm_fbdev.c
@@ -159,7 +159,7 @@ void sdrm_fbdev_cleanup(struct sdrm_device *sdrm)
 {
        struct fb_info *info;

-       if (!sdrm->info)
+       if (!sdrm->fbdev)
                return;

        dev_info(sdrm->ddev->dev, "fbdev cleanup\n");



