Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3LERiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3LERiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 90/90] misc: atmel_pwm: add deferred-probing support
Date: Thu,  5 Dec 2013 17:36:12 +0000
Message-Id: <1386264972-5399-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/atmel_pwm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 28f5aaa..2741108 100644
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
1.8.3.2

