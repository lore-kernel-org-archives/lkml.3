Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbaGYMdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:33:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25093 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbaGYMdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:33:45 -0400
Date: Fri, 25 Jul 2014 15:33:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guillaume =?iso-8859-1?Q?CL=C9MENT?= <gclement@baobob.org>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: tag data as __user in struct
 tagSCmdRequest
Message-ID: <20140725123301.GZ13737@mwanda>
References: <1406243260-13490-1-git-send-email-gclement@baobob.org>
 <20140725115234.GZ25880@mwanda>
 <20140725122504.GA10945@pleinair.baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140725122504.GA10945@pleinair.baobob.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 02:25:06PM +0200, Guillaume CLÉMENT wrote:
> On Fri, Jul 25, 2014 at 02:52:34PM +0300, Dan Carpenter wrote:
> > On Fri, Jul 25, 2014 at 01:07:40AM +0200, Guillaume Clement wrote:
> > > diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> > > index 501cd64..9291259 100644
> > > --- a/drivers/staging/vt6655/iwctl.c
> > > +++ b/drivers/staging/vt6655/iwctl.c
> > > @@ -1621,14 +1621,17 @@ int iwctl_giwauth(struct net_device *dev,
> > >  int iwctl_siwgenie(struct net_device *dev,
> > >  		   struct iw_request_info *info,
> > >  		   struct iw_point *wrq,
> > > -		   char *extra)
> > > +		   char __user *extra)
> > >  {
> > >  	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
> > >  	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
> > >  	int ret = 0;
> > > +	char length;
> > >
> > >  	if (wrq->length) {
> > > -		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
> > > +		if (get_user(length, extra + 1))
> > > +			return -EFAULT;
> > > +		if ((wrq->length < 2) || (length != wrq->length)) {
> > >  			ret = -EINVAL;
> > >  			goto out;
> > >  		}
> >
> > Wow, this is confusing code.  The patch description isn't clear enough
> > that this is a bugfix patch and not just a "tag data" patch.
> >
> > I don't think this is correct.  We need to check the length of the input
> > buffer before we call get_user().  Can we return directly or do we
> > *need* to go to the mysteriously named "out"?  Also the + 2 is lost,
> > this would break everything if the current code works (not necessarily a
> > valid assumption).  Delete all my comments in the final code.
> 
> In this case, the "out" label just does "return ret;". But I agree this
> is better practice to jump to out, in case this changes at a later time,
> and to keep the code consistent.
>

No, absolutely not.  "out" labels are the worst.  We shouldn't make the
code unreadable and mysterious *now* just because of something which
is possible but frankly unlikely "at some later time".

Feel free to return directly if you want.

regards,
dan carpenter

