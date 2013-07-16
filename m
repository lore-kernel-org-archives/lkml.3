Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3GPGcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:32:43 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48685 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3GPGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:32:38 -0400
Message-ID: <51E4E922.2040707@gmail.com>
Date: Tue, 16 Jul 2013 08:33:06 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/mixed;
 boundary="------------080605030202090507010401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080605030202090507010401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Aaro,

On 16.07.2013 00:56, Aaro Koskinen wrote:
> Hi,
> 
> I think USB tree introduced regressions in v3.11-rc1, at least for some
> OMAP devices using legacy boot.

Thanks for checking the tree so early.

> I have only bisected these; I have no
> idea what the real fixes are but the following reverts make Nokia OMAP2+
> boards again usable for kernel development work (they need working USB
> connection for interacting with the device):
> 
> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
>    commits:
> 
> 	09fc7d22b024692b2fe8a943b246de1af307132b
> 	usb: musb: fix incorrect usage of resource pointer
> 	(Reverting this fixes the g_ether probe failure "couldn't find
> 	 an available UDC")

Can't say much about this one, but I'd like you to only keep this one
reverted and sort out the regressions in the musb core first.

> 	fe4cb0912f8e737f8e4b8b38b9e692f8062f5423
> 	usb: musb: gadget: remove hcd initialization
> 	(Reverting this fixes error "cdc_ether: probe of 4-1:1.0 failed
> 	 with error -110" seen on the host side.)

Which role does your musb-based hardware have in this case, and which
MUSB_* config symbols do you set? You should have USB_MUSB_GADGET.

> 	8b125df5b24cfb0ec7fa1971e343cc0badc1827d
> 	usb: musb: eliminate musb_to_hcd	
> 	(Reverting this fixes compilation error cause by the previous
> 	 revert.)
>
> 2) USB peripheral mode (g_ether) is broken also on Nokia N800 and N810
>    (USB_MUSB_TUSB6010). In addition to the above, I need to also revert
>    the following:
> 
> 	b7e2e75a8c6062afe1dd88b0b299938e5d36dff8
> 	usb: gadget: drop unused USB_GADGET_MUSB_HDRC
> 
>    (This commit is clearly incorrect - code checking for this still
>    remain in the tree (see e.g. N8x0 board file), so it's not "unused".)

Good catch, I didn't expect board files to depend on config symbols that
have no effect on the driver itself.

Please check the attached patch and let me know if it helps.


Thanks,
Daniel



--------------080605030202090507010401
Content-Type: text/x-patch;
 name="0001-ARM-omap2-fix-musb-usage-for-n8x0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-ARM-omap2-fix-musb-usage-for-n8x0.patch"

>From 5f33d42f2dffb82d22b83a030f14fe2331a935b7 Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Tue, 16 Jul 2013 08:19:49 +0200
Subject: [PATCH] ARM: omap2: fix musb usage for n8x0

Commit b7e2e75a8c ("usb: gadget: drop unused USB_GADGET_MUSB_HDRC")
dropped a config symbol that was unused by the musb core, but it turns
out that board support code still had references to it.

As the core now handles both dual role and host-only modes, we can just
pass MUSB_OTG as mode from board files.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 arch/arm/mach-omap2/board-n8x0.c | 4 ----
 arch/arm/mach-omap2/usb-musb.c   | 5 +----
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index f6eeb87..827d150 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -122,11 +122,7 @@ static struct musb_hdrc_config musb_config = {
 };
 
 static struct musb_hdrc_platform_data tusb_data = {
-#ifdef CONFIG_USB_GADGET_MUSB_HDRC
 	.mode		= MUSB_OTG,
-#else
-	.mode		= MUSB_HOST,
-#endif
 	.set_power	= tusb_set_power,
 	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
 	.power		= 100,	/* Max 100 mA VBUS for host mode */
diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 8c4de27..bc89723 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -38,11 +38,8 @@ static struct musb_hdrc_config musb_config = {
 };
 
 static struct musb_hdrc_platform_data musb_plat = {
-#ifdef CONFIG_USB_GADGET_MUSB_HDRC
 	.mode		= MUSB_OTG,
-#else
-	.mode		= MUSB_HOST,
-#endif
+
 	/* .clock is set dynamically */
 	.config		= &musb_config,
 
-- 
1.8.1.4


--------------080605030202090507010401--
