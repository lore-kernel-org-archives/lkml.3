Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3AOBUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:20:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:52169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757043Ab3AOBUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:20:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,469,1355126400"; 
   d="scan'208";a="273751024"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PM / Runtime: Fix the twice judgement in
 rpm_suspend/resume()
Thread-Topic: [PATCH] PM / Runtime: Fix the twice judgement in
 rpm_suspend/resume()
Thread-Index: AQHN8lJieUVG+2Dfu0GWMeDBWvwC/JhIbU+AgAElWYA=
Date: Tue, 15 Jan 2013 01:20:05 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A20400F@SHSMSX101.ccr.corp.intel.com>
References: <2969423.iZ1VgpHf54@vostro.rjw.lan>
 <Pine.LNX.4.44L0.1301141027290.1782-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301141027290.1782-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Monday, January 14, 2013 11:30 PM
> To: Rafael J. Wysocki
> Cc: Liu, Chuansheng; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] PM / Runtime: Fix the twice judgement in
> rpm_suspend/resume()
> 
> On Mon, 14 Jan 2013, Rafael J. Wysocki wrote:
> 
> > On Tuesday, January 15, 2013 01:48:18 AM Chuansheng Liu wrote:
> > >
> > > In function rpm_suspend/resume(), when going into the for(;;),
> > > the pre-condition judgement has been done, and the variable
> runtime_status
> > > are always protected by &power.lock, so it is not necessary to judge
> > > them again before unlock_irq &power.lock in for(;;).
> > >
> > > This patch clean them up.
> >
> > Well, I don't really think this fixes anything.  Yes, we may save one check
> > here and there, but the current code follows the wait_event() convention.
OK, thanks.

> 
> Indeed, this patch introduces a race.  If runtime_status changes from
> RPM_SUSPENDING and power.wait_queue is signalled in between the test at
> the end of the loop and the prepare_to_wait() call, the loop will never
> end.
Checking the race case, it should not happen?
Updating runtime_status and wake_up wait_queue are protected by power.lock.
spin_lock(&power.lock)
...
__update_runtime_status()
...
wake_up_all(&dev->power.wait_queue)
...
spin_unlock(&power.lock)


> 
> Alan Stern
> 
> > Thanks,
> > Rafael
> >
> >
> > > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > > ---
> > >  drivers/base/power/runtime.c |   18 +++++++++---------
> > >  1 files changed, 9 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > > index 3148b10..32d6497 100644
> > > --- a/drivers/base/power/runtime.c
> > > +++ b/drivers/base/power/runtime.c
> > > @@ -377,14 +377,14 @@ static int rpm_suspend(struct device *dev, int
> rpmflags)
> > >  		for (;;) {
> > >  			prepare_to_wait(&dev->power.wait_queue, &wait,
> > >  					TASK_UNINTERRUPTIBLE);
> > > -			if (dev->power.runtime_status != RPM_SUSPENDING)
> > > -				break;
> > >
> > >  			spin_unlock_irq(&dev->power.lock);
> > >
> > >  			schedule();
> > >
> > >  			spin_lock_irq(&dev->power.lock);
> > > +			if (dev->power.runtime_status != RPM_SUSPENDING)
> > > +				break;
> > >  		}

