Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaF1ULm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:11:42 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:39863 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515AbaF1ULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:11:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 48,2.914,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:418:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2196:2198:2199:2200:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:7652:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13071:13138:13141:13230:13231:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF
X-HE-Tag: slope03_2b5aedbfe6b63
X-Filterd-Recvd-Size: 3845
Message-ID: <1403986296.9064.45.camel@joe-AO725>
Subject: Re: [PATCH] batman-adv: Use kasprintf
From: Joe Perches <joe@perches.com>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Sat, 28 Jun 2014 13:11:36 -0700
In-Reply-To: <53AF1C42.6000108@meshcoding.com>
References: <20140628183628.GA9946@himangi-Dell>
	 <1403982781.9064.33.camel@joe-AO725> <53AF1C42.6000108@meshcoding.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-28 at 21:49 +0200, Antonio Quartulli wrote:
> Hi all,
> 
> On 28/06/14 21:13, Joe Perches wrote:
> > diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
[]
> > @@ -896,7 +896,7 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
> >  {
> >  	int ret = -ENOMEM;
> >  	struct kobject *bat_kobj;
> > -	char *uevent_env[4] = { NULL, NULL, NULL, NULL };
> > +	char *uevent_env[3];
> 
> 
> Joe, why are you shortening this? kobject_uevent_env() expect a
> NULL-terminating array (that is the forth cell).

Hi Antonio, sorry, I didn't know about the last NULL
being required.  It looked to me more like an
oversight in the code instead of a required NULL.

> And how is this change reducing the code space?

Removing unnecessary initializations reduces
object code size.

> For what concerns the labels, we use this pattern mostly all over the
> code: one single label/exit-point with the related NULL checks. Do you
> think that we can improve something by changing this? (I am not talking
> about the fastpath here).

Not calling known unnecessary kfree calls helps a
little.  Certainly, it'd be more valuable in any
fast path area.

Other than that, it was an unsigned suggestion
not a formal patch submission.

Ignore it or improve it as you see fit.

cheers, Joe

Maybe:
---
 net/batman-adv/sysfs.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index f40cb04..90c245e 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -896,7 +896,7 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
 {
 	int ret = -ENOMEM;
 	struct kobject *bat_kobj;
-	char *uevent_env[4] = { NULL, NULL, NULL, NULL };
+	char *uevent_env[4];
 
 	bat_kobj = &bat_priv->soft_iface->dev.kobj;
 
@@ -910,22 +910,26 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
 				  "%s%s", BATADV_UEV_ACTION_VAR,
 				  batadv_uev_action_str[action]);
 	if (!uevent_env[1])
-		goto out;
+		goto out0;
 
 	/* If the event is DEL, ignore the data field */
 	if (action != BATADV_UEV_DEL) {
 		uevent_env[2] = kasprintf(GFP_ATOMIC,
 					  "%s%s", BATADV_UEV_DATA_VAR, data);
 		if (!uevent_env[2])
-			goto out;
+			goto out1;
 	}
 
+	uevent_env[3] = NULL;
+
 	ret = kobject_uevent_env(bat_kobj, KOBJ_CHANGE, uevent_env);
-out:
-	kfree(uevent_env[0]);
-	kfree(uevent_env[1]);
-	kfree(uevent_env[2]);
 
+	kfree(uevent_env[2]);
+out1:
+	kfree(uevent_env[1]);
+out0:
+	kfree(uevent_env[0]);
+out:
 	if (ret)
 		batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
 			   "Impossible to send uevent for (%s,%s,%s) event (err: %d)\n",


