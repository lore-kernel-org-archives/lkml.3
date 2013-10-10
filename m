Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab3JJP7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:59:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3JJPtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Henrik Rydberg <rydberg@euromail.se>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 072/104] hwmon: (applesmc) Check key count before proceeding
Date: Thu, 10 Oct 2013 08:42:00 -0700
Message-Id: <1381419752-29733-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 5f4513864304672e6ea9eac60583eeac32e679f2 upstream.

After reports from Chris and Josh Boyer of a rare crash in applesmc,
Guenter pointed at the initialization problem fixed below. The patch
has not been verified to fix the crash, but should be applied
regardless.

Reported-by: <jwboyer@fedoraproject.org>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/applesmc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b41baff..f75abcc 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -525,16 +525,25 @@ static int applesmc_init_smcreg_try(void)
 {
 	struct applesmc_registers *s = &smcreg;
 	bool left_light_sensor, right_light_sensor;
+	unsigned int count;
 	u8 tmp[1];
 	int ret;
 
 	if (s->init_complete)
 		return 0;
 
-	ret = read_register_count(&s->key_count);
+	ret = read_register_count(&count);
 	if (ret)
 		return ret;
 
+	if (s->cache && s->key_count != count) {
+		pr_warn("key count changed from %d to %d\n",
+			s->key_count, count);
+		kfree(s->cache);
+		s->cache = NULL;
+	}
+	s->key_count = count;
+
 	if (!s->cache)
 		s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
 	if (!s->cache)
-- 
1.8.1.2

