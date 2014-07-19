Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbaGST73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:59:29 -0400
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:54806 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaGST72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:59:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:4321:4384:4605:5007:6119:7652:7903:10004:10400:10471:10848:11026:11232:11657:11658:11914:12043:12114:12296:12517:12519:12555:12740:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paste67_8c49101fd431f
X-Filterd-Recvd-Size: 3255
Message-ID: <1405799962.14358.114.camel@joe-AO725>
Subject: Re: [PATCH 1/3] staging: lustre/lustre/lov: Remove unneeded 'if'
 statement in lov_request.c/lov_check_set()
From: Joe Perches <joe@perches.com>
To: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Cc: gregkh@linuxfoundation.org, oleg.drokin@intel.com, josh@joshtriplett.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 19 Jul 2014 12:59:22 -0700
In-Reply-To: <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
	 <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-19 at 21:34 +0200, Riccardo Lucchese wrote:
> It is silly to go through an if statement to set a single boolean
> value in function of a single boolean expression. In the function
> lov_check_set, assign the return value directly.
[]
> diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
[]
> @@ -140,14 +140,13 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
>  
>  static int lov_check_set(struct lov_obd *lov, int idx)
>  {
> -	int rc = 0;
> +	int rc;
>  	mutex_lock(&lov->lov_lock);
>  
> -	if (lov->lov_tgts[idx] == NULL ||
> -	    lov->lov_tgts[idx]->ltd_active ||
> -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> -		rc = 1;
> +	rc = lov->lov_tgts[idx] == NULL ||
> +		lov->lov_tgts[idx]->ltd_active ||
> +		(lov->lov_tgts[idx]->ltd_exp != NULL &&
> +		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);
>  
>  	mutex_unlock(&lov->lov_lock);
>  	return rc;

Maybe consider using a temporary for lov->lov_tgtx[idx] like:

---

 drivers/staging/lustre/lustre/lov/lov_request.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c
b/drivers/staging/lustre/lustre/lov/lov_request.c
index ce830e4..53a4575 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -140,16 +140,18 @@ void lov_set_add_req(struct lov_request *req,
struct lov_request_set *set)
 
 static int lov_check_set(struct lov_obd *lov, int idx)
 {
-	int rc = 0;
+	int rc;
+	struct lmv_tgt_desc *tgt;
+
 	mutex_lock(&lov->lov_lock);
 
-	if (lov->lov_tgts[idx] == NULL ||
-	    lov->lov_tgts[idx]->ltd_active ||
-	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
-	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
-		rc = 1;
+	tgt = lov->lov_tgts[idx];
+	rc = (!tgt || tgt->ltd_active ||
+	      (tgt->ltd_exp &&
+	       class_exp2cliimp(tgt->ltd_exp)->imp_connect_tried));
 
 	mutex_unlock(&lov->lov_lock);
+
 	return rc;
 }
 


