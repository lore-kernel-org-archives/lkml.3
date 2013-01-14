Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3ANPaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:30:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59063 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755512Ab3ANPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:30:08 -0500
Date: Mon, 14 Jan 2013 10:30:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Chuansheng Liu <chuansheng.liu@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Runtime: Fix the twice judgement in rpm_suspend/resume()
In-Reply-To: <2969423.iZ1VgpHf54@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1301141027290.1782-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Rafael J. Wysocki wrote:

> On Tuesday, January 15, 2013 01:48:18 AM Chuansheng Liu wrote:
> > 
> > In function rpm_suspend/resume(), when going into the for(;;),
> > the pre-condition judgement has been done, and the variable runtime_status
> > are always protected by &power.lock, so it is not necessary to judge
> > them again before unlock_irq &power.lock in for(;;).
> > 
> > This patch clean them up.
> 
> Well, I don't really think this fixes anything.  Yes, we may save one check
> here and there, but the current code follows the wait_event() convention.

Indeed, this patch introduces a race.  If runtime_status changes from
RPM_SUSPENDING and power.wait_queue is signalled in between the test at
the end of the loop and the prepare_to_wait() call, the loop will never
end.

Alan Stern

> Thanks,
> Rafael
> 
> 
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  drivers/base/power/runtime.c |   18 +++++++++---------
> >  1 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > index 3148b10..32d6497 100644
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -377,14 +377,14 @@ static int rpm_suspend(struct device *dev, int rpmflags)
> >  		for (;;) {
> >  			prepare_to_wait(&dev->power.wait_queue, &wait,
> >  					TASK_UNINTERRUPTIBLE);
> > -			if (dev->power.runtime_status != RPM_SUSPENDING)
> > -				break;
> >  
> >  			spin_unlock_irq(&dev->power.lock);
> >  
> >  			schedule();
> >  
> >  			spin_lock_irq(&dev->power.lock);
> > +			if (dev->power.runtime_status != RPM_SUSPENDING)
> > +				break;
> >  		}

