Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3JVQdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:33:41 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43525 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3JVQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:33:08 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] misc: atmel_pwm: add deferred-probing support
Date: Tue, 22 Oct 2013 18:32:39 +0200
Message-Id: <1382459560-26596-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two drivers (atmel-pwm-bl and leds-atmel-pwm) currently depend on the
atmel_pwm driver to have bound to any pwm-device before their devices
are probed.

Support deferred probing of such devices by making sure to return
-EPROBE_DEFER from pwm_channel_alloc when no pwm-device has yet been
bound.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/misc/atmel_pwm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 494d050..a6dc56e 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -90,8 +90,10 @@ int pwm_channel_alloc(int index, struct pwm_channel *ch)
 	unsigned long	flags;
 	int		status = 0;
 
-	/* insist on PWM init, with this signal pinned out */
-	if (!pwm || !(pwm->mask & 1 << index))
+	if (!pwm)
+		return -EPROBE_DEFER;
+
+	if (!(pwm->mask & 1 << index))
 		return -ENODEV;
 
 	if (index < 0 || index >= PWM_NCHAN || !ch)
-- 
1.8.4

