Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaDRObi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:31:38 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:41236 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDRObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:31:35 -0400
MIME-Version: 1.0
In-Reply-To: <535126D2.4080406@free-electrons.com>
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
	<1397814309-32160-2-git-send-email-jjhiblot@traphandler.com>
	<535126D2.4080406@free-electrons.com>
Date: Fri, 18 Apr 2014 09:31:34 -0500
Message-ID: <CAOCHtYiCq6SBadzashe+mwKmx8_23=-++zyhRM=dtjEbgrQ98w@mail.gmail.com>
Subject: Re: [RFC 1/3] atmel: drm: added drm driver for the atmel hlcd controller
From: Robert Nelson <robertcnelson@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, airlied@linux.ie, robdclark@gmail.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 8:21 AM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:
> Hi JJ,
>
> On 18/04/2014 11:45, Jean-Jacques Hiblot wrote:
>> +
>> +static void update_scanout(struct drm_crtc *crtc)
>> +{
>> +     struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
>> +     struct drm_device *dev = crtc->dev;
>> +     struct atmel_hlcdc_drm_private *priv = dev->dev_private;
>> +     struct drm_framebuffer *fb = crtc->fb;
>> +
>
> I guess you meant
>
> struct drm_framebuffer *fb = hclcd_crtc->fb;
>
>
> because otherwise you get an error when compiling (there are similar
> issues below).

This fixes this with v3.15-rc1

diff --git a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
index 649fa19..a111d69 100644
--- a/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
@@ -81,7 +81,7 @@ static void update_scanout(struct drm_crtc *crtc)
  struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
  struct drm_device *dev = crtc->dev;
  struct atmel_hlcdc_drm_private *priv = dev->dev_private;
- struct drm_framebuffer *fb = crtc->fb;
+ struct drm_framebuffer *fb = crtc->primary->fb;

  struct drm_gem_cma_object *gem;
  struct atmel_hlcd_dma_desc *desc = hlcdc_crtc->dma_descs[DMA_BASE];
@@ -188,7 +188,7 @@ static int atmel_hlcdc_crtc_page_flip(struct drm_crtc *crtc,
  return -EBUSY;
  }

- crtc->fb = fb;
+ crtc->primary->fb = fb;
  atmel_hlcdc_crtc->event = event;
  update_scanout(crtc);
  return 0;
@@ -397,7 +397,7 @@ static int atmel_hlcdc_crtc_mode_set(struct drm_crtc *crtc,
  hlcdc_write(dev, ATMEL_LCDC_BASECFG0,
     LCDC_BASECFG0_BLEN_AHB_INCR16 | LCDC_BASECFG0_DLBO);

- drm_fb_get_bpp_depth(crtc->fb->pixel_format, &depth, &bpp);
+ drm_fb_get_bpp_depth(crtc->primary->fb->pixel_format, &depth, &bpp);
  hlcdc_write(dev, ATMEL_LCDC_BASECFG1,
     atmel_hlcdfb_get_rgbmode(dev->dev, depth, bpp));
  hlcdc_write(dev, ATMEL_LCDC_BASECFG2, 0);

Tested-by: Robert Nelson <robertcnelson@gmail.com>

digs out my 31/33/34, should have a patch for them in a bit...

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
