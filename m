Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaKQQbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:31:25 -0500
Received: from mail-wi0-f196.google.com ([209.85.212.196]:45651 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaKQQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:31:24 -0500
Message-ID: <546A22C9.6070000@gmail.com>
Date: Mon, 17 Nov 2014 17:31:05 +0100
From: Bruno Ramey <bruno.ramey@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: airlied@linux.ie, matthew.d.roper@intel.com, robdclark@gmail.com
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/tilcdc : fixing LCD clock divisor configuration
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear gentlemen,

My first contribution to the Linux kernel is for you !
(yes, really)

I apologize for all the mistake I can make in a one liner fix !

My hardware :
CPU : Beaglebone black, with ARM TI AM3358 processor
Display : Densitron ripdraw 7" 1024x600 HDMI

Software :
Kernel Linux 3.17
Buildroot 2014.08
Qt applications on framebuffer (no X)

Problem :
My display doesn't show anything.
In the EDID retrieved from my display, I have a pixel-clock at 43.980 MHz.

I enable debug in drm_drv.c :
unsigned int drm_debug = 1;

So in dmesg, I read :
[drm:tilcdc_crtc_update_clk] lcd_clk=87900000, mode clock=43980, div=1
[drm:tilcdc_crtc_update_clk] fck=87900000, dpll_disp_ck=87900000

As you can see, div=1. Which is an error for tilcdc.
div = 87900000 / 43980000;
Which is, in real world about = 1,998..., but unfortunately round to 1 
in software world !

with my fix, I have :
[drm:tilcdc_crtc_update_clk] lcd_clk=87900000, mode clock=43980, div=2
[drm:tilcdc_crtc_update_clk] fck=87900000, dpll_disp_ck=87900000
And my display works.

I try this with other display and see no regression.

Thanks for your attention,

Best regards,
Bruno

 From f6205b6506f96f99d67909931b59d3742c8e1272 Mon Sep 17 00:00:00 2001
From: Bruno RAMEY <bruno.ramey@gmail.com>
Date: Thu, 13 Nov 2014 12:58:36 +0100
Subject: [PATCH] drm/tilcdc : fixing LCD clock divisor configuration

Depending of the pixel clock of the connected display and the
rounding of the system clock, the LCDC_CLK_DIVISOR part of
the LCDC_CTRL_REG register could be misconfigured.
---
  drivers/gpu/drm/tilcdc/tilcdc_crtc.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c 
b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
index d3e6858..0f715eb 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_crtc.c
@@ -555,7 +555,7 @@ void tilcdc_crtc_update_clk(struct drm_crtc *crtc)
         }

         lcd_clk = clk_get_rate(priv->clk);
-       div = lcd_clk / (crtc->mode.clock * 1000);
+       div = DIV_ROUND_CLOSEST(lcd_clk, crtc->mode.clock * 1000);

         DBG("lcd_clk=%u, mode clock=%d, div=%u", lcd_clk, 
crtc->mode.clock, div);
         DBG("fck=%lu, dpll_disp_ck=%lu", clk_get_rate(priv->clk), 
clk_get_rate(priv->disp_clk));
-- 
1.9.3



