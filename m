Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KRS6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:58:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3KRSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.11 20/25] misc: atmel_pwm: add deferred-probing support
Date: Mon, 18 Nov 2013 10:40:49 -0800
Message-Id: <20131118184038.358255694@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5c6d6fd1564138ad048564e48639f842714a90c6 upstream.

Two drivers (atmel-pwm-bl and leds-atmel-pwm) currently depend on the
atmel_pwm driver to have bound to any pwm-device before their devices
are probed.

Support deferred probing of such devices by making sure to return
-EPROBE_DEFER from pwm_channel_alloc when no pwm-device has yet been
bound.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/atmel_pwm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -90,8 +90,10 @@ int pwm_channel_alloc(int index, struct
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


