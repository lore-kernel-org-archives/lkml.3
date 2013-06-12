Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab3FLVbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:31:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3FLVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:31:15 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [RFC: PATCH] err.h: silence warning when using IS_ERR on void __iomem *
Date: Wed, 12 Jun 2013 23:31:08 +0200
Message-Id: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and encourage to check its return value with
IS_ERR(). This however leads to the following sparse warnings, as
devm_ioremap_resource() returns a void __iomem pointer:

drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type in argument 1 (different address spaces)
drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *ptr
drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [noderef] [usertype] <asn:2>*raminit_ctrlreg

This patch silences the warning by introducing a macro to force cast the
pointer to a plain const void *.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello,

I think this macro is a bit ugly, is there a better way to make sparse happy?
If we agree on a solution other functions in this file have to be wrapped.

regards,
Marc

 include/linux/err.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..1a5a57b 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -29,11 +29,13 @@ static inline long __must_check PTR_ERR(const void *ptr)
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check __IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
+#define IS_ERR(__ptr)	__IS_ERR((const void __force *)__ptr)
+
 static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
-- 
1.8.2.rc2

