Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaFWNWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:22:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36939 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaFWNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Peres <martin.peres@free.fr>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 44/93] drm/nouveau/pm/fan: drop the fan lock in fan_update() before rescheduling
Date: Mon, 23 Jun 2014 14:02:23 +0100
Message-Id: <1403528592-2163-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Peres <martin.peres@labri.fr>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c b/drivers/gpu/drm/nouveau/core/subdev/therm/fan.c
index c728380d3d62..ea19acd20784 100644
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
1.9.1

