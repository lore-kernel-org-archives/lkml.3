Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab3EJBzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:55:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:53876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3EJBzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:55:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,645,1363158000"; 
   d="scan'208";a="334614387"
From: "Zhang, Ning A" <ning.a.zhang@intel.com>
To: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ASOC bug? maybe no need to set bias_level to PREPARE.
Thread-Topic: ASOC bug? maybe no need to set bias_level to PREPARE.
Thread-Index: Ac5NHByMEDSZGfd2RfWQbkjWhMl7bA==
Date: Fri, 10 May 2013 01:55:45 +0000
Message-ID: <027FCDD209E4CC4181A7B9D5DBB88057249BFD2C@SHSMSX102.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Girdwood

When I try to fix wm1811 standby issue for our customer, I find a strange behavior in ASOC core.

here is my test code:

snd_soc_dapm_disable_pin(&dapm,"MICBIAS2"); 
snd_soc_dapm_disable_pin(&dapm,"CLK_SYS"); 
snd_soc_dapm_sync(&dapm);

and add debug info in dapm_pre_sequence_async() 
and we will find these debug info printed: 

d->bias_level = 1 
d->target_bias_level = 0 
in snd_soc_dapm_set_bias_level

from the debug log, when STANDBY -> OFF transition, it set bias_level to PREPARE.

that's wrong logic.

And more there is comment in source code:
	/* Prepare for a STADDBY->ON or ON->STANDBY transition */
But, the code isn't the same as the comment.

----
>From 58d8994bdc543909e9904b8df0787afc36684283 Mon Sep 17 00:00:00 2001
From: ning.a.zhang <ning.a.zhang@intel.com>
Date: Fri, 10 May 2013 09:44:06 +0700
Subject: [PATCH] Asoc dapm behavior fix

in soc_dapm.c, there is a illogic behavior, when bias_level
from STANDBY -> OFF transition.
source does not follow its comment.

this patch is based on the comment

Signed-off-by: ning.a.zhang <ning.a.zhang@intel.com>
---
 sound/soc/soc-dapm.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index d6d9ba2..834ab4c 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1486,8 +1486,9 @@ static void dapm_pre_sequence_async(void *data, async_cookie_t cookie)
 				"ASoC: Failed to turn on bias: %d\n", ret);
 	}
 
-	/* Prepare for a STADDBY->ON or ON->STANDBY transition */
-	if (d->bias_level != d->target_bias_level) {
+	/* If we're on and we're not supposed to be go into PREPARE */
+	if (d->bias_level == SND_SOC_BIAS_ON &&
+	    d->target_bias_level != SND_SOC_BIAS_ON) {
 		ret = snd_soc_dapm_set_bias_level(d, SND_SOC_BIAS_PREPARE);
 		if (ret != 0)
 			dev_err(d->dev,
@@ -1525,6 +1526,15 @@ static void dapm_post_sequence_async(void *data, async_cookie_t cookie)
 			pm_runtime_put(d->dev);
 	}
 
+	if (d->bias_level == SND_SOC_BIAS_STANDBY &&
+	    (d->target_bias_level == SND_SOC_BIAS_PREPARE ||
+	     d->target_bias_level == SND_SOC_BIAS_ON)) {
+		ret = snd_soc_dapm_set_bias_level(d, SND_SOC_BIAS_PREPARE);
+		if (ret != 0)
+			dev_err(d->dev, "ASoC: Failed to apply prepare bias: %d\n",
+				ret);
+	}
+
 	/* If we just powered up then move to active bias */
 	if (d->bias_level == SND_SOC_BIAS_PREPARE &&
 	    d->target_bias_level == SND_SOC_BIAS_ON) {
-- 
1.7.1

