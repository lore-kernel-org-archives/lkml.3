Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaCYAv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:51:29 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:59550 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751958AbaCYAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:51:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:3874:4321:4385:5007:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cast30_63f1d6bf01d0b
X-Filterd-Recvd-Size: 2513
Message-ID: <1395708685.31285.2.camel@joe-AO722>
Subject: Re: [PATCH 1/2] staging: binder: add __user annotation in binder.c
From: Joe Perches <joe@perches.com>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: linux-kernel@vger.kernel.org, arve@android.com, gregkh@linuxfoundation.org
Date: Mon, 24 Mar 2014 17:51:25 -0700
In-Reply-To: <1395707065-23808-1-git-send-email-mathieu.maret@gmail.com>
References: <1395707065-23808-1-git-send-email-mathieu.maret@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-25 at 01:24 +0100, Mathieu Maret wrote:
> Fix the following spare warning

sparse

> drivers/staging/android/binder.c:2691:21: warning: incorrect type in argument 1 (different address spaces)
[]
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -2688,7 +2688,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
[]
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
> +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version __user *)ubuf)->protocol_version)) {

That's certainly one way to do it, but I'd suggest
using a temporary instead

 drivers/staging/android/binder.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..1f5e249 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2683,16 +2683,20 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		binder_free_thread(proc, thread);
 		thread = NULL;
 		break;
-	case BINDER_VERSION:
+	case BINDER_VERSION: {
+		struct binder_version __user *ver = ubuf;
+
 		if (size != sizeof(struct binder_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			     &ver->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
 		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto err;


