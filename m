Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3BADS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:18:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:2720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3BADSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:18:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="281281387"
Date: Fri, 1 Feb 2013 11:19:44 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v8 4/4] sd: change to auto suspend mode
Message-ID: <20130201031944.GA6960@aaronlu.sh.intel.com>
References: <20130131054324.GB14627@aaronlu.sh.intel.com>
 <Pine.LNX.4.44L0.1301311010200.1876-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301311010200.1876-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:13:05AM -0500, Alan Stern wrote:
> On Thu, 31 Jan 2013, Aaron Lu wrote:
> 
> > > > +static int scsi_blk_runtime_suspend(struct device *dev)
> > > > +{
> > > > +	struct scsi_device *sdev = to_scsi_device(dev);
> > > 
> > > For this routine and the other new ones, it may be slightly more
> > > efficient to pass both dev and sdev as arguments (this depends on how
> > > smart the compiler's optimizer is).  The caller already knows both of
> > > them, after all.
> > 
> > What about passing only scsi_device? When device is needed, I can use
> > &sdev->sdev_gendev. Is this equally efficient?
> 
> I don't know...  The difference is very small in any case.  The 
> routines will probably be inlined automatically.

Indeed, I just checked the .s output of the three cases, they are all
the same. So we just need to care about readability and less of code,
passing only scsi_device seems to be the simplest, are you OK with this?

BTW, the compiler I used is gcc-4.7.2.

> 
> > > > +		if (sdev->request_queue->dev) {
> > > > +			pm_runtime_mark_last_busy(dev);
> > > > +			err = pm_runtime_autosuspend(dev);
> > > > +		} else {
> > > > +			err = pm_schedule_suspend(dev, 100);
> > > > +		}
> > > > +	} else {
> > > >  		err = pm_runtime_suspend(dev);
> > > > +	}
> > > >  	return err;
> > 
> > Shall we ignore the return value for these pm_xxx_suspend functions?
> > I mean we do not need to record the return value for them and return it,
> > since pm core doesn't care the return value of idle callback.
> 
> Maybe it will care in a future kernel version.  You might as well store 
> the return code and pass it back.

OK.

Thanks,
Aaron

