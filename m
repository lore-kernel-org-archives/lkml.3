Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaAZKVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:21:16 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34884 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaAZKVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:21:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] of: Fix uninitialized child warning in for_each_child_of_node() if !OF
Date: Sun, 26 Jan 2014 11:21:08 +0100
Message-Id: <1390731668-904-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF=n:

drivers/i2c/i2c-mux.c: In function ‘i2c_add_mux_adapter’:
drivers/i2c/i2c-mux.c:158: warning: ‘child’ is used uninitialized in this function
drivers/leds/leds-lp55xx-common.c: In function ‘lp55xx_of_populate_pdata’:
drivers/leds/leds-lp55xx-common.c:560: warning: ‘child’ is used uninitialized in this function
drivers/leds/leds-pwm.c: In function ‘led_pwm_probe’:
drivers/leds/leds-pwm.c:89: warning: ‘child’ is used uninitialized in this function
drivers/mfd/stmpe.c: In function ‘stmpe_of_probe’:
drivers/mfd/stmpe.c:1112: warning: ‘child’ is used uninitialized in this function
drivers/mfd/tc3589x.c: In function ‘tc3589x_probe’:
drivers/mfd/tc3589x.c:324: warning: ‘child’ is used uninitialized in this function
drivers/power/charger-manager.c: In function ‘of_cm_parse_desc’:
drivers/power/charger-manager.c:1606: warning: ‘child’ is used uninitialized in this function

Introduced by commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
("include/linux/of.h: make for_each_child_of_node() reference its args when
CONFIG_OF=n").

Instead of dropping the "__of_use_dn(child)" again, explicitly set child
to NULL, to protect against code using child after the loop (child == NULL
is the loop termination condition if CONFIG_OF=y).

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/of.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 70c64ba17fa5..0bf44f2fe092 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -383,7 +383,7 @@ static inline void __of_use_dn(const struct device_node *np)
 }
 
 #define for_each_child_of_node(parent, child) \
-	while (__of_use_dn(parent), __of_use_dn(child), 0)
+	while (__of_use_dn(parent), child = NULL, 0)
 
 #define for_each_available_child_of_node(parent, child) \
 	while (0)
-- 
1.7.9.5

