Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaJBH3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:29:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43172 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJBH3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:29:49 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/mgag200: Fix type of dividend in do_div()
Date: Thu,  2 Oct 2014 09:29:46 +0200
Message-Id: <1412234986-2001-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The semantics of do_div() are (see include/asm-generic/do_div.h):

	uint32_t do_div(uint64_t *n, uint32_t base)

Using a different type will therefore cause the following warning (as
seen on xtensa/allmodconfig):

	  CC [M]  drivers/gpu/drm/mgag200/mgag200_mode.o
	In file included from arch/xtensa/include/generated/asm/div64.h:1:0,
	                 from include/linux/kernel.h:124,
	                 from include/linux/delay.h:10,
	                 from drivers/gpu/drm/mgag200/mgag200_mode.c:14:
	drivers/gpu/drm/mgag200/mgag200_mode.c: In function 'mga_vga_calculate_mode_bandwidth':
	include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast
	  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
	                            ^
	drivers/gpu/drm/mgag200/mgag200_mode.c:1471:2: note: in expansion of macro 'do_div'
	  do_div(pixels_per_second, total_area);
	  ^
	include/asm-generic/div64.h:43:28: warning: comparison of distinct pointer types lacks a cast
	  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
	                            ^
	drivers/gpu/drm/mgag200/mgag200_mode.c:1474:2: note: in expansion of macro 'do_div'
	  do_div(bandwidth, divisor);
	  ^

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 83485ab81ce8..4d519dc99db8 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -1455,9 +1455,9 @@ static int mga_vga_get_modes(struct drm_connector *connector)
 static uint32_t mga_vga_calculate_mode_bandwidth(struct drm_display_mode *mode,
 							int bits_per_pixel)
 {
-	uint32_t total_area, divisor;
-	int64_t active_area, pixels_per_second, bandwidth;
 	uint64_t bytes_per_pixel = (bits_per_pixel + 7) / 8;
+	uint32_t total_area, divisor, active_area;
+	uint64_t pixels_per_second, bandwidth;
 
 	divisor = 1024;
 
-- 
2.1.0

