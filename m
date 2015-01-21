Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbbAULwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:52:36 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:48180 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbAULw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:52:28 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Simon Kelley <simon@thekelleys.org.uk>, Kalle Valo <kvalo@codeaurora.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wireless: atmel: Remove open-coded and wrong strcasecmp
Date: Wed, 21 Jan 2015 12:52:07 +0100
Message-Id: <1421841127-8209-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1421414907-26764-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's string library does in fact have strcasecmp, at least
since ded220bd8f08 ("[STRING]: Move strcasecmp/strncasecmp to
lib/string.c"). Moreover, this open-coded version is in fact wrong: If
the strings only differ in their last character, a and b have already
been incremented to point to the terminating NUL bytes, so they would
wrongly be treated as equal.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: Address Sergei's comments to the commit message.

 drivers/net/wireless/atmel.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 9183f1cf89a7..55db9f03eb2a 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -45,7 +45,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/ctype.h>
 #include <linux/timer.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
@@ -2699,16 +2698,7 @@ static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		domain[REGDOMAINSZ] = 0;
 		rc = -EINVAL;
 		for (i = 0; i < ARRAY_SIZE(channel_table); i++) {
-			/* strcasecmp doesn't exist in the library */
-			char *a = channel_table[i].name;
-			char *b = domain;
-			while (*a) {
-				char c1 = *a++;
-				char c2 = *b++;
-				if (tolower(c1) != tolower(c2))
-					break;
-			}
-			if (!*a && !*b) {
+			if (!strcasecmp(channel_table[i].name, domain)) {
 				priv->config_reg_domain = channel_table[i].reg_domain;
 				rc = 0;
 			}
-- 
2.1.3

