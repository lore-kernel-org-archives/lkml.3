Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaFII6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58534 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Martin Peres <martin.peres@labri.fr>,
        Martin Peres <martin.peres@free.fr>, Ben Skeggs <bskeggs@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/146] drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling
Date: Mon,  9 Jun 2014 10:50:16 +0200
Message-Id: <fb5996a588e3d0aec3fc54f72b7fffcd5bc84326.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Peres <martin.peres@labri.fr>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 61679fe153b2b9ea5b5e2ab93305419e85e99a9d upstream.

This should fix a deadlock that has been reported to us where fan_update()
would hold the fan lock and try to grab the alarm_program_lock to reschedule
an update. On an other CPU, the alarm_program_lock would have been taken
before calling fan_update(), leading to a deadlock.

We should Cc: <stable@vger.kernel.org> # 3.9+

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Tested-by: Timothée Ravier <tim@siosm.fr>
Tested-by: Boris Fersing (IRC nick fersingb, no public email address)
Signed-off-by: Martin Peres <martin.peres@free.fr>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c b/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c
index 39f47b950ad1..c14cb093a64e 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c
@@ -54,8 +54,10 @@ nouveau_fan_update(struct nouveau_fan *fan, bool immediate, int target)
 
 	/* check that we're not already at the target duty cycle */
 	duty = fan->get(therm);
-	if (duty == target)
-		goto done;
+	if (duty == target) {
+		spin_unlock_irqrestore(&fan->lock, flags);
+		return 0;
+	}
 
 	/* smooth out the fanspeed increase/decrease */
 	if (!immediate && duty >= 0) {
@@ -73,8 +75,15 @@ nouveau_fan_update(struct nouveau_fan *fan, bool immediate, int target)
 
 	nv_debug(therm, "FAN update: %d\n", duty);
 	ret = fan->set(therm, duty);
-	if (ret)
-		goto done;
+	if (ret) {
+		spin_unlock_irqrestore(&fan->lock, flags);
+		return ret;
+	}
+
+	/* fan speed updated, drop the fan lock before grabbing the
+	 * alarm-scheduling lock and risking a deadlock
+	 */
+	spin_unlock_irqrestore(&fan->lock, flags);
 
 	/* schedule next fan update, if not at target speed already */
 	if (list_empty(&fan->alarm.head) && target != duty) {
@@ -92,8 +101,6 @@ nouveau_fan_update(struct nouveau_fan *fan, bool immediate, int target)
 		ptimer->alarm(ptimer, delay * 1000 * 1000, &fan->alarm);
 	}
 
-done:
-	spin_unlock_irqrestore(&fan->lock, flags);
 	return ret;
 }
 
-- 
1.9.3

