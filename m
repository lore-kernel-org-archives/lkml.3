Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbaGYMZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:25:32 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45434 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaGYMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:25:31 -0400
X-Originating-IP: 78.210.48.61
Date: Fri, 25 Jul 2014 14:25:06 +0200
From: Guillaume =?iso-8859-1?Q?CL=C9MENT?= <gclement@baobob.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Guillaume Clement <gclement@baobob.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: tag data as __user in struct
 tagSCmdRequest
Message-ID: <20140725122504.GA10945@pleinair.baobob.org>
References: <1406243260-13490-1-git-send-email-gclement@baobob.org>
 <20140725115234.GZ25880@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725115234.GZ25880@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:52:34PM +0300, Dan Carpenter wrote:
> On Fri, Jul 25, 2014 at 01:07:40AM +0200, Guillaume Clement wrote:
> > diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> > index 501cd64..9291259 100644
> > --- a/drivers/staging/vt6655/iwctl.c
> > +++ b/drivers/staging/vt6655/iwctl.c
> > @@ -1621,14 +1621,17 @@ int iwctl_giwauth(struct net_device *dev,
> >  int iwctl_siwgenie(struct net_device *dev,
> >  		   struct iw_request_info *info,
> >  		   struct iw_point *wrq,
> > -		   char *extra)
> > +		   char __user *extra)
> >  {
> >  	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
> >  	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
> >  	int ret = 0;
> > +	char length;
> >
> >  	if (wrq->length) {
> > -		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
> > +		if (get_user(length, extra + 1))
> > +			return -EFAULT;
> > +		if ((wrq->length < 2) || (length != wrq->length)) {
> >  			ret = -EINVAL;
> >  			goto out;
> >  		}
>
> Wow, this is confusing code.  The patch description isn't clear enough
> that this is a bugfix patch and not just a "tag data" patch.
>
> I don't think this is correct.  We need to check the length of the input
> buffer before we call get_user().  Can we return directly or do we
> *need* to go to the mysteriously named "out"?  Also the + 2 is lost,
> this would break everything if the current code works (not necessarily a
> valid assumption).  Delete all my comments in the final code.

In this case, the "out" label just does "return ret;". But I agree this
is better practice to jump to out, in case this changes at a later time,
and to keep the code consistent.

About the missing + 2, and modifying the order of sorry about that, I
sent the patch too fast.

Thank you for your review, I will be submitting an updated patch with
your remarks.
