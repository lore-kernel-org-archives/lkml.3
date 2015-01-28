Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbbA2DzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:55:09 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:59706 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbbA2BKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v2 6/7] [media] marvell-ccic: MMP_CAMERA no longer builds
Date: Wed, 28 Jan 2015 23:11:20 +0100
Message-ID: <1683657.95n8fCPCvc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422479867-3370921-7-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de> <1422479867-3370921-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:/wXLpFudlUuAnks4aNKSta7rexE0Dc8LSp6J9oDvbmY4Zuzmywv
 ael9TCR8QknPHLrKT/Stxi0/Apwa3ElpBtikkjsLFT3nkkyb5osJri1QdyQyiZA9B2Gy9u1
 MbHzUvfNxFkp1ZdhFEx59cj+WddyxdTAEQnQgEzW089jhNURjn20HSATFaCD09aag8zBCsg
 p8p8+lfXlDhBAwD2TtdbQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmp ccic driver expects a platform_data structure that does not exist
in the mainline kernel and presumably was changed in a kernel fork, which
leads to build errors now:

media/platform/marvell-ccic/mmp-driver.c: In function 'mmpcam_calc_dphy':
media/platform/marvell-ccic/mmp-driver.c:252:15: error: 'struct mmp_camera_platform_data' has no member named 'dphy3_algo'
  switch (pdata->dphy3_algo) {
               ^
media/platform/marvell-ccic/mmp-driver.c:253:7: error: 'DPHY3_ALGO_PXA910' undeclared (first use in this function)
  case DPHY3_ALGO_PXA910:
       ^
media/platform/marvell-ccic/mmp-driver.c:253:7: note: each undeclared identifier is reported only once for each function it appears in
media/platform/marvell-ccic/mmp-driver.c:257:8: error: 'struct mmp_camera_platform_data' has no member named 'dphy'

This marks the driver as 'BROKEN' but keeps the code around.
Alternatively it could be removed entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Cc: Libin Yang <lbyang@marvell.com>
Fixes: 05fed81625bf75 ("[media] marvell-ccic: add MIPI support for marvell-ccic driver")
----
> This driver most assuredly did work on XO 1.75 machines, and the
> platform_data structure does exist; it's the stuff added by Libin
> afterward that apparently broke things.  Strange that it only came out now,
> though, nearly two years later. Libin, any thoughts on this?

I've carried this workaround in a private git tree that has hundreds of
randconfig fixes, just started flushing out some of the patches again.
The configuration in which the driver gets selected is relatively rare,
and it is not enabled in any of the defconfigs obviously.

When I originally wrote the patch description, I must have missed the
fact that the driver was moved from a different directory and I only
saw that it was broken at the point when it showed up in
drivers/media/platform/marvell-ccic/.

> Meanwhile, it is clearly broken, and I don't have an immediate fix, so,
>
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks

> (Though I would like a different patch subject, since the current one is
> wrong).

Done.

diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
index 6265d36adceb..7ac0f13c98be 100644
--- a/drivers/media/platform/marvell-ccic/Kconfig
+++ b/drivers/media/platform/marvell-ccic/Kconfig
@@ -13,7 +13,7 @@ config VIDEO_CAFE_CCIC
 config VIDEO_MMP_CAMERA
 	tristate "Marvell Armada 610 integrated camera controller support"
 	depends on ARCH_MMP && I2C && VIDEO_V4L2
-	depends on HAS_DMA
+	depends on HAS_DMA && BROKEN
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG

