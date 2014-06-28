Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaF1RJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:09:40 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:51209 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751165AbaF1RJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:09:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:4321:5007:7652:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slip65_36d7b87b3de5e
X-Filterd-Recvd-Size: 2514
Message-ID: <1403975375.9064.29.camel@joe-AO725>
Subject: Re: [PATCH linux-next] staging: emxx_udc: replace strict_strtol call
From: Joe Perches <joe@perches.com>
To: Vincent =?ISO-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-next@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Magnus Damm <damm+renesas@opensource.se>
Date: Sat, 28 Jun 2014 10:09:35 -0700
In-Reply-To: <1403974823-23578-1-git-send-email-vincent.stehle@laposte.net>
References: <1403974823-23578-1-git-send-email-vincent.stehle@laposte.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-28 at 19:00 +0200, Vincent Stehlé wrote:
> Commit 582e9d37a9a3 'include/linux: remove strict_strto* definitions' has
> obsoleted the strict_strtol function. Use kstrtol instead.
[]
> diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
[]
> @@ -3285,7 +3285,7 @@ static void __init nbu2ss_drv_set_ep_info(
>  
>  		tempbuf[0] = name[2];
>  		tempbuf[1] = '\0';
> -		res = strict_strtol(tempbuf, 16, &num);
> +		res = kstrtol(tempbuf, 16, &num);


The whole block if code is obtuse and should be simplified to:
---
 drivers/staging/emxx_udc/emxx_udc.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index c92ded8..f41831e 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -3276,24 +3276,10 @@ static void __init nbu2ss_drv_set_ep_info(
 	ep->ep.name = name;
 	ep->ep.ops = &nbu2ss_ep_ops;
 
-	if (isdigit(name[2])) {
-
-		long	num;
-		int	res;
-		char	tempbuf[2];
-
-		tempbuf[0] = name[2];
-		tempbuf[1] = '\0';
-		res = strict_strtol(tempbuf, 16, &num);
-
-		if (num == 0)
-			ep->ep.maxpacket = EP0_PACKETSIZE;
-		else
-			ep->ep.maxpacket = EP_PACKETSIZE;
-
-	} else {
+	if (name[2] == '0')
+		ep->ep.maxpacket = EP0_PACKETSIZE;
+	else
 		ep->ep.maxpacket = EP_PACKETSIZE;
-	}
 
 	list_add_tail(&ep->ep.ep_list, &udc->gadget.ep_list);
 	INIT_LIST_HEAD(&ep->queue);


