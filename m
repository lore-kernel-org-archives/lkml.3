Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaIIMWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:22:47 -0400
Received: from smtp2.bmts.com ([216.183.128.136]:33308 "EHLO smtp2.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbaIIMWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:22:46 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 08:22:46 EDT
Message-ID: <540EEF62.7000307@hempeldesigngroup.com>
Date: Tue, 09 Sep 2014 08:15:30 -0400
From: Ralph Hempel <rhempel@hempeldesigngroup.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: s.hauer@pengutronix.de
CC: linux-kernel@vger.kernel.org
Subject: pwm_get() in core.c does not save best match before setting period
 and polarity
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM core does not appear to respect the settings in the pwm_lookup 
table in the ev3dev projects implementation of a board file. Root cause 
is that pwm_get() does not save the pwm_lookup entry for the  best 
matching device, and therefore ends up using period and polarity from a 
pointer that's past the end of the table.

These values are often 0, which translates to PWM_POLARITY_NORMAL, but 
it can be anything really...

First patch ever submitted - fun times finding this one - the bug was in 
the last place I looked
-----------------------------------------------------------------------

Make the match loop save the best match so that period and polarity can 
be set correctly

-----------------------------------------------------------------------


diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 4b66bf0..f244e2c 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -605,6 +605,7 @@ struct pwm_device *pwm_get(struct device *dev, const 
char *con_id)
         unsigned int index = 0;
         unsigned int best = 0;
         struct pwm_lookup *p;
+       struct pwm_lookup *pl = NULL;
         unsigned int match;

         /* look up via DT first */
@@ -651,6 +652,7 @@ struct pwm_device *pwm_get(struct device *dev, const 
char *con_id)
                 }

                 if (match > best) {
+                       pl = p;
                         chip = pwmchip_find_by_name(p->provider);
                         index = p->index;

@@ -668,8 +670,8 @@ struct pwm_device *pwm_get(struct device *dev, const 
char *con_id)
         if (IS_ERR(pwm))
                 return pwm;

-       pwm_set_period(pwm, p->period);
-       pwm_set_polarity(pwm, p->polarity);
+       pwm_set_period(pwm, pl->period);
+       pwm_set_polarity(pwm, pl->polarity);


         return pwm;

Ralph Hempel (rhempel@hempeldesigngroup.com)
