Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3ENNZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:25:13 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:37475 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3ENNZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:25:11 -0400
Date: Tue, 14 May 2013 15:25:10 +0200
From: "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "'Philipp Reisner'" <philipp.reisner@linbit.com>
Subject: Re: [PATCH 3.9-stable ]drbd: fix for deadlock when using automatic
 split-brain-recovery
Message-ID: <20130514132510.GH21623@soda.linbit>
References: <003801ce4c41$d52a0890$7f7e19b0$%choi@samsung.com>
 <20130514125655.GG5196@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514125655.GG5196@hercules>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 01:56:55PM +0100, Luis Henriques wrote:
> On Thu, May 09, 2013 at 08:14:47AM +0900, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.9-stable tree, should we apply
> > it?
> 
> This seems to be applicable to older kernels as well (starting with
> 3.0 at least).

Ack.

> I'm queuing it for 3.5.
> 
> Cheers,
> --
> Luis
> 
> > 
> > ------------------
> > 
> > From: "Philipp Reisner <philipp.reisner@linbit.com>"
> > 
> > commit 7c689e63a847316c1b2500f86891b0a574ce7e69 upstream
> > 
> > With an automatic after split-brain recovery policy of
> > "after-sb-1pri call-pri-lost-after-sb",
> > when trying to drbd_set_role() to R_SECONDARY,
> > we run into a deadlock.
> > 
> > This was first recognized and supposedly fixed by
> > 2009-06-10 "Fixed a deadlock when using automatic split brain recovery when
> > both nodes are"
> > replacing drbd_set_role() with drbd_change_state() in that code-path,
> > but the first hunk of that patch forgets to remove the drbd_set_role().
> > 
> > We apparently only ever tested the "two primaries" case.
> > 
> > Cc: <stable@vger.kernel.org> # 3.9.x: ef57f9e6: drbd: Fix build error
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > ---
> >  drivers/block/drbd/drbd_receiver.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_receiver.c
> > b/drivers/block/drbd/drbd_receiver.c
> > index a9eccfc..5105f43 100644
> > --- a/drivers/block/drbd/drbd_receiver.c
> > +++ b/drivers/block/drbd/drbd_receiver.c
> > @@ -2661,7 +2661,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev)
> > __must_hold(local)
> >  		if (hg == -1 && mdev->state.role == R_PRIMARY) {
> >  			enum drbd_state_rv rv2;
> >  
> > -			drbd_set_role(mdev, R_SECONDARY, 0);
> >  			 /* drbd_change_state() does not sleep while in
> > SS_IN_TRANSIENT_STATE,
> >  			  * we might be here in C_WF_REPORT_PARAMS which is
> > transient.
> >  			  * we do not need to wait for the after state
> > change work either. */
