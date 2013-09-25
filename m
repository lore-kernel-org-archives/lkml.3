Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3IYVrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:47:15 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:37705 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3IYVrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:47:13 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiVOADlZQ1JV5qhFPGdsb2JhbABbgweDS4UitXeCeoEhFwMBAQEBODWCJQEBBScTHCMQCAMOCgklDwUlChqIHbxDFo87B4MdgQADl3uGRo5YOg
X-IronPort-AV: E=Sophos;i="4.90,980,1371074400"; 
   d="scan'208";a="326278586"
Date: Wed, 25 Sep 2013 23:48:07 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130925214807.GA3234@polaris.bitmath.org>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925195628.GA1532@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:56:28PM -0700, Guenter Roeck wrote:
> On Wed, Sep 25, 2013 at 03:06:25PM -0400, Josh Boyer wrote:
> > Hi All,
> > 
> > Chris has reported[1] an issue with the applesmc driver in the 3.10
> > and 3.11 kernels.  This seems to be a bit transient, but the oops is
> > consistent across those releases.  This is with a MacBook Pro 4,1.
> > The backtrace is below.
> > 
> > Any ideas on this one?
> > 
> Some of the bug reports suggest that there are related messages in at least some
> of the kernel logs.
> 
> Jul 02 22:23:22 f19s.local kernel: applesmc: send_byte(0x04, 0x0300) fail: 0x01
> Jul 02 22:23:22 f19s.local kernel: applesmc: : read len fail
> 
> This suggests that initialization may be attempted more than once. The key cache
> is allocated only once, but the number of keys is read for each attempt.
> 
> No idea if that can happen, but if the number of keys can increase after
> the first initialization attempt you would have an explanation for the crash.

Good idea, and easy enough to test with the patch below.

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 62c2e32..d962c4d 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -525,16 +525,24 @@ static int applesmc_init_smcreg_try(void)
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
+               pr_warn("key count changed from %d to %d\n", s->key_count, count);
+               kfree(s->cache);
+               s->cache = NULL;
+       }
+       s->key_count = count;
+
        if (!s->cache)
                s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
        if (!s->cache)
 
Thanks,
Henrik
