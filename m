Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3BRDTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:19:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:4625 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab3BRDTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:19:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,683,1355126400"; 
   d="scan'208";a="258183699"
Date: Mon, 18 Feb 2013 11:20:39 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v9 4/4] sd: change to auto suspend mode
Message-ID: <20130218032039.GA25348@aaronlu.sh.intel.com>
References: <5111BBA1.4010200@intel.com>
 <Pine.LNX.4.44L0.1302061048180.1893-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1302061048180.1893-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 10:51:19AM -0500, Alan Stern wrote:
> On Wed, 6 Feb 2013, Aaron Lu wrote:
> 
> > > The "if (err == -EAGAIN)" test and the call to pm_schedule_suspend seem
> > > to have been dropped since v8 of this series.  It looks like they ought
> > > to be moved into sdev_runtime_suspend.
> > 
> > I thought they were no longer needed...
> 
> You did not mention this in the patch description.

Sorry about that.

> 
> > For sd, we have request based rutime PM and the PM core will always try
> > to autosuspend the device with the timer; and for sr, the poll will
> > trigger suspend constantly.
> 
> What if the poll has been disabled?
> 
> > And for both, we don't return -EAGAIN anyway.
> > So I suppose that code is not necessary?
> 
> You could replace it with WARN_ON(err == -EAGAIN).  That way if some 
> SCSI driver does return -EAGAIN in the future, people will know 
> something is wrong.

Placing a WARN_ON there seems to suggest drivers should not return
-EAGAIN, so I think I'll just add back those dropped code to
sdev_runtime_suspend as you have suggested like this:

static int sdev_runtime_suspend(struct device *dev)
{
	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
	int (*cb)(struct device *) = pm ? pm->runtime_suspend : NULL;
	struct scsi_device *sdev = to_scsi_device(dev);
	int ret;

	if (sdev->request_queue->dev)
		return sdev_blk_runtime_suspend(sdev, cb);

	ret = scsi_dev_type_suspend(dev, cb);
	if (ret == -EAGAIN)
		pm_schedule_suspend(dev, jiffies_to_msecs(
					round_jiffies_up_relative(HZ/10)));
	return ret;
}

Does this look OK?

> 
> > BTW, I'll be on vocation till 02/17, and I don't have access to the
> > internet in my hometown, but please feel free to drop any comments and
> > I'll check them when I get back.
> 
> I'm going on vacation next week too.  Enjoy your trip.

Thanks, the trip was great.

-Aaron

