Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaIBSzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:55:04 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54189 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBSzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:55:02 -0400
Date: Wed, 3 Sep 2014 00:24:38 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140902185438.GA1688@fool>
References: <1409681795-23262-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140902182402.GA12744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902182402.GA12744@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:24:02AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Sep 02, 2014 at 11:46:35PM +0530, Sudip Mukherjee wrote:
> > From: Sudip Mukherjee <sudip@vectorindia.org>
> > 
> > removed unused variables
> > fixed sparse warning of context imbalance in 'do_locked_client_insert'
> >                          different lock contexts for basic block
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > 
> > v1 of the patch of the patch just fixed the sparse warning.
> > On suggestion of Dan Carpenter v2 is the total rewrite of the function.
> > Two of the function arguments (interruptHandle,channelId) are also not used. Wanted to remove them as well , 
> > but then thought maybe the original author have planned for some use of those variables.
> > 
> >  drivers/staging/unisys/uislib/uisqueue.c | 37 ++++++++------------------------
> >  1 file changed, 9 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
> > index 63dbe7c..acfa46d 100644
> > --- a/drivers/staging/unisys/uislib/uisqueue.c
> > +++ b/drivers/staging/unisys/uislib/uisqueue.c
> > @@ -78,39 +78,20 @@ do_locked_client_insert(struct uisqueue_info *queueinfo,
> >  			u64 interruptHandle, u8 *channelId)
> >  {
> >  	unsigned long flags;
> > -	unsigned char queueWasEmpty;
> > -	unsigned int locked = 0;
> > -	unsigned int acquired = 0;
> >  	u8 rc = 0;
> >  
> >  	spin_lock_irqsave(lock, flags);
> > -	locked = 1;
> > -
> >  	if (!ULTRA_CHANNEL_CLIENT_ACQUIRE_OS(queueinfo->chan, channelId, NULL))
> > -		goto Away;
> > -
> > -	acquired = 1;
> > -
> > -	queueWasEmpty = visor_signalqueue_empty(queueinfo->chan, whichqueue);
> > -	if (!visor_signal_insert(queueinfo->chan, whichqueue, pSignal))
> > -		goto Away;
> > -	ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
> > -	acquired = 0;
> > -
> > -	queueinfo->packets_sent++;
> > -
> > -	rc = 1;
> > -Away:
> > -	if (acquired) {
> > -		ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId,
> > -						NULL);
> > -		acquired = 0;
> > -	}
> > -	if (locked) {
> > -		spin_unlock_irqrestore((spinlock_t *) lock, flags);
> > -		locked = 0;
> > +		goto unlock;
> > +	visor_signalqueue_empty(queueinfo->chan, whichqueue);
> > +	/*visor_signal_insert() only return 0 or 1 */
> 
> Odd comment style (hint, you need a ' ' at the beginning...)
> 
> And why comment this at all?
> 
> thanks,
> 
> greg k-h

comment is actually not required. thought it will be easier to understant the code if the return values can be see.
I will delete the comment and send it again.

thanks
sudip
