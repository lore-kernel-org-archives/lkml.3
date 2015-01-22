Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbbAVXKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:10:16 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55780 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAVXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:10:13 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: ad2s1200: Fix sign extension
Date: Fri, 23 Jan 2015 00:09:56 +0100
Message-Id: <1421968196-17193-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line above makes vel a 12-bit quantity (st->rx[] is u8). The
intention is to sign-extend vel using bit 11 as the sign bit. But
because of C's promotion rules "vel = (vel << 4) >> 4;" is actually a
no-op, since vel is promoted to int before the inner
shift. sign_extend32 works equally well for 8 and 16 bits types, so
use that.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/iio/resolver/ad2s1200.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
index 017d2f8379b7..c17893b4918c 100644
--- a/drivers/staging/iio/resolver/ad2s1200.c
+++ b/drivers/staging/iio/resolver/ad2s1200.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
+#include <linux/bitops.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -68,7 +69,7 @@ static int ad2s1200_read_raw(struct iio_dev *indio_dev,
 		break;
 	case IIO_ANGL_VEL:
 		vel = (((s16)(st->rx[0])) << 4) | ((st->rx[1] & 0xF0) >> 4);
-		vel = (vel << 4) >> 4;
+		vel = sign_extend32(vel, 11);
 		*val = vel;
 		break;
 	default:
-- 
2.1.3

