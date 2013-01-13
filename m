Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3AMVAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 16:00:16 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47098 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3AMVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 16:00:15 -0500
Date: Sun, 13 Jan 2013 22:00:03 +0100 (CET)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@xoschi
To: Alex Deucher <alexdeucher@gmail.com>
cc: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
In-Reply-To: <CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1301132143310.1772@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi> <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com> <alpine.LNX.2.00.1301072206530.1617@xoschi> <CADnq5_NEQ2cCEPEGwBhX1KP0bDn7b+Q2M=Logw1fVC67ct-gEA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 7 Jan 2013, Alex Deucher wrote:
> On Mon, Jan 7, 2013 at 4:33 PM, Eldad Zack <eldad@fogrefinery.com> wrote:
> >
> > On Mon, 7 Jan 2013, Alex Deucher wrote:
> >> On Sun, Jan 6, 2013 at 7:59 AM, Eldad Zack <eldad@fogrefinery.com> wrote:
> >> >
> >> > Hi Alex,
> >> >
> >> > Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f "drm/radeon: switch to a
> >> > finer grained reset for evergreen" introduced a hard system lockup to my
> >> > setup. I found it after bisecting, and confirmed it by reverting it on
> >> > the latest mainline ( 5f243b9 ).
> >> >
> >> > This:
> >> >
> >> >    echo 7 > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/brightness
> >> >
> >> > Causes a hard lock-up hard, i.e. immediate freeze, without any logs.
> >> >
> >> > See lspci output and kernel .config below.
> >> > If there's any more info I can provide, please let me know.
> >>
> >> Do you normally see GPU resets when changing the backlight?  Please
> >> attach your dmesg output when changing the backlight with the patch
> >> reverted.
> >
> > I see nothing. Just to make sure, I cleared the buffer, cycled through
> > 0-7 a couple of hunderd times (until the flicker annoyed), but I see no
> > messages at all.
> > Is there any debug config I should turn on?
> 
> Can you try adding a printk() in evergreen_asic_reset() and see if it
> is somehow getting called when you change the brightness?  When you
> use the apci backlight control, the radeon driver is not involved at
> all.  They only way the driver would get involved is if the acpi
> backlight control somehow caused the GPU to hang and then the driver
> detected the hang and attempted to reset the GPU.  I don't see any
> evidence of a GPU reset in your kernel log however.  Note that the
> driver also registers native backlight contol.  Does that work any
> better than acpi?

The native backlight controls work very well. Thanks for that, I didn't
even noticed that. It has finer control over brightness too.

I worked out a fix for the problem, but I think it's not a proper one.
What I noticed is that evergreen_gpu_soft_reset() is only ever called
once on my system, at boot.
Then I realized from the dmesg that neither 
evergreen_gpu_soft_reset_dma() nor evergreen_gpu_soft_reset_gfx() actually
do anything. Both return on the first if statements there.

So as far as I can tell, the difference your patch introduced is calling 
evergreen_mc_stop() and evergreen_mc_resume(), which somehow puts my 
system in some state that ACPI brightness control leads to a lock up.

BTW, I don't see a GPU reset happening at all - I also tried suspend/resume
and starting an OpenGL application. Do you know how I can trigger it?

To fix this, I moved the GUI_ACTIVE test before evergreen_mc_stop(), but
I think it just masks the issue.
Patch below (against latest HEAD) just in case.

Cheers,
Eldad

>From 5817128d2761f60051b069d2bb31209c909b6a04 Mon Sep 17 00:00:00 2001
From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun, 13 Jan 2013 21:14:08 +0100
Subject: [PATCH] drm/radeon: fix evergreen brightness control regression

Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f introduced a
regression, where using ACPI brightness control leads to a
hard system lock-up.
To resolve the issue, this patch moves the GUI_ACTIVE test
earlier, as it was before the commit.

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 drivers/gpu/drm/radeon/evergreen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 061fa0a..1392f99 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2310,9 +2310,6 @@ static void evergreen_gpu_soft_reset_gfx(struct radeon_device *rdev)
 {
 	u32 grbm_reset = 0;
 
-	if (!(RREG32(GRBM_STATUS) & GUI_ACTIVE))
-		return;
-
 	dev_info(rdev->dev, "  GRBM_STATUS               = 0x%08X\n",
 		RREG32(GRBM_STATUS));
 	dev_info(rdev->dev, "  GRBM_STATUS_SE0           = 0x%08X\n",
@@ -2404,6 +2401,9 @@ static int evergreen_gpu_soft_reset(struct radeon_device *rdev, u32 reset_mask)
 	if (reset_mask == 0)
 		return 0;
 
+	if (!(RREG32(GRBM_STATUS) & GUI_ACTIVE))
+		return 0;
+
 	dev_info(rdev->dev, "GPU softreset: 0x%08X\n", reset_mask);
 
 	evergreen_mc_stop(rdev, &save);
-- 
1.7.12.4

