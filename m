Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3JCEFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:05:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3JCEFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:05:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        jwboyer@fedoraproject.org, Guenter Roeck <linux@roeck-us.net>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [ 10/13] hwmon: (applesmc) Check key count before proceeding
Date: Wed,  2 Oct 2013 21:04:35 -0700
Message-Id: <20131003040401.466450552@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040400.753642257@linuxfoundation.org>
References: <20131003040400.753642257@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/applesmc.c |   11 ++++++++++-
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


