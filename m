Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3JUJMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:12:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967Ab3JUIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Henrik Rydberg" <rydberg@euromail.se>,
        "Guenter Roeck" <linux@roeck-us.net>, "" <jwboyer@fedoraproject.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.14992029@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 089/149] hwmon: (applesmc) Check key count before
 proceeding
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/applesmc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -485,16 +485,25 @@ static int applesmc_init_smcreg_try(void
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

