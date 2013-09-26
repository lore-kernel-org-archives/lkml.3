Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3IZGd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:33:58 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:43587 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3IZGd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:33:56 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtE/ADzUQ1JV5qhFPGdsb2JhbABbgwfBX4EfFwMBAQEBODWCJQEBBAEnExwTAQ8FCwgDDgMDAQIKJQ8FJQoMDhOIAAq8ehaNcIFLB4MdgQEDl3uGRo5YOoEs
X-IronPort-AV: E=Sophos;i="4.90,982,1371074400"; 
   d="scan'208";a="400957054"
Date: Thu, 26 Sep 2013 08:34:53 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130926063453.GA526@polaris.bitmath.org>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
 <20130925214807.GA3234@polaris.bitmath.org>
 <20130925220838.GB4184@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925220838.GB4184@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This suggests that initialization may be attempted more than once. The key cache
> > > is allocated only once, but the number of keys is read for each attempt.
> > > 
> > > No idea if that can happen, but if the number of keys can increase after
> > > the first initialization attempt you would have an explanation for the crash.
> > 
> > Good idea, and easy enough to test with the patch below.
> > 
> Should we apply this patch even though it may not solve the specific problem ?

Yes, why not - it certainly won't hurt. I am running it right now, so
it is at least run-tested.

> Again, not sure if the key count can change, but the current code is at the very
> least inconsistent, as it keeps reading the key count without updating or
> verifying the cache size.

Yes - I agree that the error state is far-fetched, but it is hard to
see any other logical explanation. There is of course always the
possibility that the problem is somewhere else completely.

Proper patch attached.

Thanks,
Henrik

---

>From dedefba9167913c46e1896ce0624e68ffe95d532 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Thu, 26 Sep 2013 08:33:16 +0200
Subject: [PATCH] hwmon: (applesmc) Check key count before proceeding

After reports from Chris and Josh Boyer of a rare crash in applesmc,
Guenter pointed at the initialization problem fixed below. The patch
has not been verified to fix the crash, but should be applied
regardless.

Reported-by: <jwboyer@fedoraproject.org>
Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 62c2e32..98814d1 100644
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
1.8.3.4

