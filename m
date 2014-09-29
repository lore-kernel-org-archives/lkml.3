Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaI2Sb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:31:29 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:60706 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754343AbaI2Sb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:31:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3873:4321:4605:5007:7652:7903:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12296:12517:12519:12555:12740:13019:13095:13160:13161:13229:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: time93_46b149a78c91d
X-Filterd-Recvd-Size: 3321
Message-ID: <1412015484.4302.51.camel@joe-AO725>
Subject: Re: [PATCH] Staging: gdm72xx: fix coding style
From: Joe Perches <joe@perches.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michalis Pappas <mpappas@fastmail.fm>,
        Davide Gianforte <davide@gengisdave.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 11:31:24 -0700
In-Reply-To: <1412014535-24239-1-git-send-email-thibaut.robert@gmail.com>
References: <1412014535-24239-1-git-send-email-thibaut.robert@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 20:15 +0200, Thibaut Robert wrote:
> This patch remove a checkstyle warning in netlink_k.c.
> Note: This is my homework of the day.

The "Note: " line isn't useful for a commit message.
Neither is the checkpatch warning bit.

Maybe the commit message could be something like:
"Remove unnecessary else after return".

> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
[]
> @@ -147,12 +147,11 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
>  
>  	if (!ret) {
>  		return len;
> -	} else {
> -		if (ret != -ESRCH) {
> -			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> -			       group, type, len, ret);
> -		}
> -		ret = 0;
>  	}
> -	return ret;
> +
> +	if (ret != -ESRCH) {
> +		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
> +		       group, type, len, ret);
> +	}

OK, but you don't need the braces around the pr_err.

My preference is to also fix the typo in the function
and would be something like:
---
 drivers/staging/gdm72xx/netlink_k.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 9bf00e6..43d2a49 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -120,9 +120,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 	struct nlmsghdr *nlh;
 	int ret = 0;
 
-	if (group > ND_MAX_GROUP) {
-		pr_err("Group %d is invalied.\n", group);
-		pr_err("Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
+	if (group < 0 || group > ND_MAX_GROUP) {
+		pr_err("Invalid group %d (valid groups are 0 to %d)\n",
+		       group, ND_MAX_GROUP);
 		return -EINVAL;
 	}
 
@@ -144,15 +144,12 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 	NETLINK_CB(skb).dst_group = 0;
 
 	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
-
-	if (!ret) {
+	if (!ret)
 		return len;
-	} else {
-		if (ret != -ESRCH) {
-			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
-			       group, type, len, ret);
-		}
-		ret = 0;
-	}
-	return ret;
+
+	if (ret != -ESRCH)
+		pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
+		       group, type, len, ret);
+
+	return 0;
 }



