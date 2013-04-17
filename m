Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3DQKKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:10:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55819 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab3DQKKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:10:12 -0400
Date: Wed, 17 Apr 2013 12:10:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] drm/nouveau: always select ACPI_VIDEO if ACPI is
 enabled.
Message-ID: <20130417101007.GC11807@pd.tnic>
References: <20130204152344.GG13909@pd.tnic>
 <510FD6A2.80101@canonical.com>
 <20130205145232.GI4827@pd.tnic>
 <5111277B.5020607@canonical.com>
 <20130205162206.GJ4827@pd.tnic>
 <20130220185633.GF16775@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130220185633.GF16775@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 07:56:33PM +0100, Borislav Petkov wrote:
> On Tue, Feb 05, 2013 at 05:22:06PM +0100, Borislav Petkov wrote:
> > On Tue, Feb 05, 2013 at 04:38:35PM +0100, Maarten Lankhorst wrote:
> > > Argh, next attempt, based on i915's Kconfig.
> > > 
> > > It seems that not only I have to select ACPI_VIDEO, I also have to select all the dependencies.
> > > Is this a Kconfig bug or working as intended? i915 seems to have a workaround, so I copied it from
> > > there. Except it's currently missing select THERMAL, so I guess it didn't get updated when that got
> > > added.
> > > 
> > > ---->8
> > > Having nouveau builtin would still allow ACPI_VIDEO to be used as external module
> > > if some of the deps for acpi_video have not been met, which would result in a linking
> > > failure. Solve this by selecting all dependencies as well.
> > > 
> > > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > 
> > Yep, this takes care of all deps,
> > 
> > Tested-by: Borislav Petkov <bp@suse.de>
> 
> Just to check whether anyone has picked this already - it is triggering
> on 3.8 too so it most probably needs a stable tag too.

Ok,

this is not good.

So we have -rc7+, this patch has been out there for 2 months and still
not in Linus' tree.

Linus,

the patch below fixes a build failure here with my custom config. I
think this late in the game, we need some kind of a fix before 3.9 is
released. I'm adding the patch here in case you want to pick it up
yourself.

Thanks.

--
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Wed, 17 Apr 2013 12:04:09 +0200
Subject: [PATCH] drm/nouveau: always select ACPI_VIDEO if ACPI is enabled.

Having nouveau builtin would still allow ACPI_VIDEO to be used as
external module if some of the deps for acpi_video have not been met,
which would result in a linking failure. Solve this by selecting all
dependencies as well.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Tested-by: Borislav Petkov <bp@suse.de>
---
 drivers/gpu/drm/nouveau/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index a7ff6d5a34b9..845b7caa9ee1 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,11 +10,17 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
-	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	select X86_PLATFORM_DEVICES if ACPI && X86
 	select ACPI_WMI if ACPI && X86
 	select MXM_WMI if ACPI && X86
 	select POWER_SUPPLY
+	# Similar to i915, we need to select ACPI_VIDEO and it's dependencies
+	select BACKLIGHT_LCD_SUPPORT if ACPI && X86
+	select BACKLIGHT_CLASS_DEVICE if ACPI && X86
+	select VIDEO_OUTPUT_CONTROL if ACPI && X86
+	select INPUT if ACPI && X86
+	select THERMAL if ACPI && X86
+	select ACPI_VIDEO if ACPI && X86
 	help
 	  Choose this option for open-source nVidia support.
 
-- 
1.8.2.135.g7b592fa

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
- -
