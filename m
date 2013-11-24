Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3KXJdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:33:31 -0500
Received: from palahniuk.acksyn.org ([5.9.7.26]:50235 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab3KXJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:33:27 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Nov 2013 04:33:27 EST
Date: Sun, 24 Nov 2013 09:23:59 +0000
From: Michele Baldessari <michele@acksyn.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: <jwboyer@fedoraproject.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        bugzilla@colorremedies.com
Subject: small regression: hwmon: (applesmc) Check key count before
 proceeding - 5f4513864304672e6ea9eac60583eeac32e679f2
Message-ID: <20131124092359.4241e633@fante.int.rhx>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik & Guenther,

via commit 5f4513864304672e6ea9eac60583eeac32e679f2 the following
code was added:
diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 62c2e32..98814d1 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -525,16 +525,25 @@ static int applesmc_init_smcreg_try(void)
 {
        struct applesmc_registers *s = &smcreg;
        bool left_light_sensor, right_light_sensor;
+       unsigned int count;
        u8 tmp[1];
        int ret;
 
        if (s->init_complete)
                return 0;
 
-       ret = read_register_count(&s->key_count);
+       ret = read_register_count(&count);
        if (ret)
                return ret;
 
+       if (s->cache && s->key_count != count) {
+               pr_warn("key count changed from %d to %d\n",
+                       s->key_count, count);
+               kfree(s->cache);
+               s->cache = NULL;
+       }
+       s->key_count = count;
+
        if (!s->cache)
                s->cache = kcalloc(s->key_count, sizeof(*s->cache),
GFP_KERNEL); if (!s->cache)

The issue Chris has seen in Fedora on one MacBookPro4,1
(https://bugzilla.redhat.com/show_bug.cgi?id=1033414) is that this
machine returns a huge number from read_register_count() so now we will
try to allocate an insane amount of memory and we will barf:
[    8.603053] applesmc: key count changed from 261 to 1392508929

Dmidecode for this box is here:
https://bugzilla.redhat.com/attachment.cgi?id=828118

Do we need to special case this specific machine/smc version or should
we limit the kcalloc() call to a somewhat sane limit? Other thoughts?

Thanks,
Michele
