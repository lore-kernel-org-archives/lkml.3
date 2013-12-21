Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3LUXFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 18:05:09 -0500
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:42833 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754054Ab3LUXFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 18:05:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3865:3870:4321:4605:5007:6120:7652:7875:9592:10004:10400:10848:11026:11658:11914:12043:12294:12296:12438:12517:12519:12555:12679:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glove73_f0822ae5344f
X-Filterd-Recvd-Size: 4240
Message-ID: <1387667101.22671.6.camel@joe-AO722>
Subject: Re: [RFC v2] ff-memless-next driver
From: Joe Perches <joe@perches.com>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, anssi.hannula@iki.fi,
        elias.vds@gmail.com
Date: Sat, 21 Dec 2013 15:05:01 -0800
In-Reply-To: <2287724.uNI0tVeDgp@geidi-prime>
References: <2287724.uNI0tVeDgp@geidi-prime>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactoring can help reduce the line lengths.

For example:

Move the get_envelope function.
Use get_envelope in set_envelope_times.
---
 drivers/input/ff-memless-next.c | 58 +++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/input/ff-memless-next.c b/drivers/input/ff-memless-next.c
index 722601a..73e1127 100644
--- a/drivers/input/ff-memless-next.c
+++ b/drivers/input/ff-memless-next.c
@@ -104,34 +104,46 @@ static int mlnx_upload_conditional(struct mlnx_device *mlnxdev,
 	return mlnxdev->control_effect(mlnxdev->dev, mlnxdev->private, &ecmd);
 }
 
+static const struct ff_envelope *mlnx_get_envelope(const struct ff_effect *effect)
+{
+	static const struct ff_envelope empty;
+
+	switch (effect->type) {
+	case FF_CONSTANT:
+		return &effect->u.constant.envelope;
+	case FF_PERIODIC:
+		return &effect->u.periodic.envelope;
+	case FF_RAMP:
+		return &effect->u.ramp.envelope;
+	default:
+		return &empty;
+	}
+}
+
 static void mlnx_set_envelope_times(struct mlnx_effect *mlnxeff)
 {
 	const struct ff_effect *effect = &mlnxeff->effect;
+	const struct ff_envelope *env;
 
 	switch (effect->type) {
-	case FF_CONSTANT:
-		if (effect->u.constant.envelope.attack_length)
-			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.constant.envelope.attack_length);
-		if (effect->replay.length && effect->u.constant.envelope.fade_length)
-			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.constant.envelope.fade_length);
-		break;
 	case FF_PERIODIC:
 		pr_debug("Phase: %u, Offset: %d\n",
 			 effect->u.periodic.phase, effect->u.periodic.offset);
-		if (effect->u.periodic.envelope.attack_length)
-			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.periodic.envelope.attack_length);
-		if (effect->replay.length && effect->u.periodic.envelope.fade_length)
-			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.periodic.envelope.fade_length);
 		break;
+	case FF_CONSTANT:
 	case FF_RAMP:
-		if (effect->u.ramp.envelope.attack_length)
-			mlnxeff->attack_stop = mlnxeff->begin_at + msecs_to_jiffies(effect->u.ramp.envelope.attack_length);
-		if (effect->replay.length && effect->u.ramp.envelope.fade_length)
-			mlnxeff->fade_begin = mlnxeff->stop_at - msecs_to_jiffies(effect->u.ramp.envelope.fade_length);
 		break;
 	default:
-		break;
+		return;
 	}
+
+	env = mlnx_get_envelope(effect);
+	if (env->attack_length)
+		mlnxeff->attack_stop = mlnxeff->begin_at +
+				       msecs_to_jiffies(env->attack_length);
+	if (effect->replay.length && env->fade_length)
+		mlnxeff->fade_begin = mlnxeff->stop_at -
+				      msecs_to_jiffies(env->fade_length);
 }
 
 static void mlnx_set_trip_times(struct mlnx_effect *mlnxeff,
@@ -185,22 +197,6 @@ static void mlnx_stop_effect(struct mlnx_device *mlnxdev,
 	}
 }
 
-static const struct ff_envelope *mlnx_get_envelope(const struct ff_effect *effect)
-{
-	static const struct ff_envelope empty;
-
-	switch (effect->type) {
-	case FF_CONSTANT:
-		return &effect->u.constant.envelope;
-	case FF_PERIODIC:
-		return &effect->u.periodic.envelope;
-	case FF_RAMP:
-		return &effect->u.ramp.envelope;
-	default:
-		return &empty;
-	}
-}
-
 static s32 mlnx_apply_envelope(const struct mlnx_effect *mlnxeff,
 			       const s32 level)
 {


