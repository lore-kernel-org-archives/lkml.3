Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaGTQBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 12:01:54 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33219 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGTQBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 12:01:52 -0400
Date: Sun, 20 Jul 2014 18:01:43 +0200
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        oleg.drokin@intel.com, josh@joshtriplett.org, dmitry.eremin@intel.com,
        john.hammond@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH v2 1/3] staging: lustre: lov: Cleanup lov_check_set() in
 lov_request.c
Message-ID: <20140720160143.GB13589@rlp>
References: <20140720113747.GG18338@mwanda>
 <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
 <1405862550-16694-2-git-send-email-riccardo.lucchese@gmail.com>
 <1405870223.5135.6.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405870223.5135.6.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 08:30:23AM -0700, Joe Perches wrote:
> On Sun, 2014-07-20 at 15:22 +0200, Riccardo Lucchese wrote:
> > Make the code clearer by introducing a local variable and removing the
> > unnecessary 'if' statement.
> > 
> > Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > ---
> > Changes in v2:
> >  - Improved the commit message:
> >     - changed the subject line to follow the same convention used by
> >       previous commits to the same file.
> >     - rewrote the message body using a more formal language.
> >  - Introduced a local variable to make the code clearer.
> >  - Added Acked-by - Julia.
> > 
> >  drivers/staging/lustre/lustre/lov/lov_request.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
> > index ce830e4..ae670bb 100644
> > --- a/drivers/staging/lustre/lustre/lov/lov_request.c
> > +++ b/drivers/staging/lustre/lustre/lov/lov_request.c
> > @@ -140,14 +140,14 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
> >  
> >  static int lov_check_set(struct lov_obd *lov, int idx)
> >  {
> > -	int rc = 0;
> > +	int rc;
> > +	struct lov_tgt_desc *desc;
> >  	mutex_lock(&lov->lov_lock);
> >  
> > -	if (lov->lov_tgts[idx] == NULL ||
> > -	    lov->lov_tgts[idx]->ltd_active ||
> > -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> > -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> > -		rc = 1;
> > +	desc = lov->lov_tgts[idx];
> > +	rc = !desc || desc->ltd_active ||
> > +		(desc->ltd_exp &&
> > +		 class_exp2cliimp(desc->ltd_exp)->imp_connect_tried);
> >  
> >  	mutex_unlock(&lov->lov_lock);
> >  	return rc;
> 
> desc is not a good temporary name here.
> 
> For consistency with the rest of the code
> please use tgt
> 
> $ git grep "= lov->lov_tgts.*];"
> drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[i];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[i];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[index];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[index];
> drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[qctl->qc_idx];
> drivers/staging/lustre/lustre/lov/lov_obd.c:                            tgt = lov->lov_tgts[i];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[info->idx];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[ost_idx];
> drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[((struct obd_id_info *)val)->idx];
> drivers/staging/lustre/lustre/lov/lov_obd.c:                    tgt = lov->lov_tgts[i];
> drivers/staging/lustre/lustre/lov/lov_obd.c:            tgt = lov->lov_tgts[i];
> drivers/staging/lustre/lustre/lov/lov_request.c:        tgt = lov->lov_tgts[ost_idx];
> drivers/staging/lustre/lustre/lov/lov_request.c:        tgt = lov->lov_tgts[lovreq->rq_idx];
> 

Thank you for noticing this. I will send a v3.

riccardo
