Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaGTLiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:38:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29478 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaGTLiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:38:11 -0400
Date: Sun, 20 Jul 2014 14:37:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Cc: gregkh@linuxfoundation.org, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: lustre/lustre/lov: Remove unneeded 'if'
 statement in lov_request.c/lov_check_set()
Message-ID: <20140720113747.GG18338@mwanda>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
 <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
 <20140720045253.GK25880@mwanda>
 <20140720110836.GC12613@rlp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720110836.GC12613@rlp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 01:08:36PM +0200, Riccardo Lucchese wrote:
> Dan,
> 
> On Sun, Jul 20, 2014 at 07:52:53AM +0300, Dan Carpenter wrote:
> > On Sat, Jul 19, 2014 at 09:34:56PM +0200, Riccardo Lucchese wrote:
> > > It is silly to go through an if statement to set a single boolean
> > > value in function of a single boolean expression. In the function
> > > lov_check_set, assign the return value directly.
> > > 
> > > Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
> > > ---
> > >  drivers/staging/lustre/lustre/lov/lov_request.c | 11 +++++------
> > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
> > > index ce830e4..90fc66a 100644
> > > --- a/drivers/staging/lustre/lustre/lov/lov_request.c
> > > +++ b/drivers/staging/lustre/lustre/lov/lov_request.c
> > > @@ -140,14 +140,13 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
> > >  
> > >  static int lov_check_set(struct lov_obd *lov, int idx)
> > >  {
> > > -	int rc = 0;
> > > +	int rc;
> > >  	mutex_lock(&lov->lov_lock);
> > >  
> > > -	if (lov->lov_tgts[idx] == NULL ||
> > > -	    lov->lov_tgts[idx]->ltd_active ||
> > > -	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
> > > -	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
> > > -		rc = 1;
> > > +	rc = lov->lov_tgts[idx] == NULL ||
> > > +		lov->lov_tgts[idx]->ltd_active ||
> > > +		(lov->lov_tgts[idx]->ltd_exp != NULL &&
> > > +		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);
> > 
> > I don't see how this makes the code more readable at all.
> 
> Thank you for the comment. Would you consider something like the
> following diff instead ? Otherwise, I will resend the series for
> review without this change.
> 
> riccardo
> 
> ---
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

Sure, I suppose.  Using "desc" is a clean up.  Otherwise the original
code was not "silly".  It was fine.

I'm curious why you think if statements are less readable than other
statements.  That seems like nonsense.

regards,
dan carpenter


