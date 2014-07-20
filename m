Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaGTPa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 11:30:28 -0400
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:49029 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751717AbaGTPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 11:30:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3353:3622:3653:3654:3865:3866:3867:3868:3870:3871:4321:4384:4605:5007:6119:7514:7522:7652:7875:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12517:12519:12555:12663:12740:13095:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainC
X-HE-Tag: lake27_20ab9671a0813
X-Filterd-Recvd-Size: 4174
Message-ID: <1405870223.5135.6.camel@joe-AO725>
Subject: Re: [PATCH v2 1/3] staging: lustre: lov: Cleanup lov_check_set() in
 lov_request.c
From: Joe Perches <joe@perches.com>
To: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Cc: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        oleg.drokin@intel.com, josh@joshtriplett.org, dmitry.eremin@intel.com,
        john.hammond@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Sun, 20 Jul 2014 08:30:23 -0700
In-Reply-To: <1405862550-16694-2-git-send-email-riccardo.lucchese@gmail.com>
References: <20140720113747.GG18338@mwanda>
	 <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
	 <1405862550-16694-2-git-send-email-riccardo.lucchese@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 15:22 +0200, Riccardo Lucchese wrote:
> Make the code clearer by introducing a local variable and removing the
> unnecessary 'if' statement.
> 
> Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Changes in v2:
>  - Improved the commit message:
>     - changed the subject line to follow the same convention used by
>       previous commits to the same file.
>     - rewrote the message body using a more formal language.
>  - Introduced a local variable to make the code clearer.
>  - Added Acked-by - Julia.
> 
>  drivers/staging/lustre/lustre/lov/lov_request.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
> index ce830e4..ae670bb 100644
> --- a/drivers/staging/lustre/lustre/lov/lov_request.c
> +++ b/drivers/staging/lustre/lustre/lov/lov_request.c
> @@ -140,14 +140,14 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
>  
>  static int lov_check_set(struct lov_obd *lov, int idx)
>  {
> -	int rc = 0;
> +	int rc;
> +	struct lov_tgt_desc *desc;
>  	mutex_lock(&lov->lov_lock);
>  
> -	if (lov->lov_tgts[idx] == NULL ||
> -	    lov->lov_tgts[idx]->ltd_active ||
> -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> -		rc = 1;
> +	desc = lov->lov_tgts[idx];
> +	rc = !desc || desc->ltd_active ||
> +		(desc->ltd_exp &&
> +		 class_exp2cliimp(desc->ltd_exp)->imp_connect_tried);
>  
>  	mutex_unlock(&lov->lov_lock);
>  	return rc;

desc is not a good temporary name here.

For consistency with the rest of the code
please use tgt

$ git grep "= lov->lov_tgts.*];"
drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[i];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[i];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[index];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[index];
drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[qctl->qc_idx];
drivers/staging/lustre/lustre/lov/lov_obd.c:                            tgt = lov->lov_tgts[i];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[info->idx];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[ost_idx];
drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[((struct obd_id_info *)val)->idx];
drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[i];
drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[i];
drivers/staging/lustre/lustre/lov/lov_request.c:        tgt = lov->lov_tgts[ost_idx];
drivers/staging/lustre/lustre/lov/lov_request.c:        tgt = lov->lov_tgts[lovreq->rq_idx];


