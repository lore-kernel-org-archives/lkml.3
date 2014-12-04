Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaLDSy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:54:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:9959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaLDSy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:54:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493732637"
Date: Thu, 4 Dec 2014 10:49:47 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de,
        maxime.ripard@free-electrons.com, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, andrew@lunn.ch, sjg@chromium.org,
        markus.mayer@linaro.org, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, skuribay@pobox.com, Romain.Baeriswyl@abilis.com,
        wenkai.du@intel.com, chiau.ee.chew@intel.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V3 1/2] i2c-designware: Add i2c bus locking support
Message-ID: <20141204184947.GB1530@pathfinder>
References: <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
 <1417478973-25522-2-git-send-email-david.e.box@linux.intel.com>
 <20141203160125.GB28857@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203160125.GB28857@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 06:01:25PM +0200, Mika Westerberg wrote:
> On Mon, Dec 01, 2014 at 04:09:32PM -0800, David E. Box wrote:
> > Adds support for acquiring and releasing a hardware bus lock in the i2c
> > designware core transfer function. This is needed for i2c bus controllers
> > that are shared with but not controlled by the kernel.
> > 
> > Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-core.c    | 11 +++++++++++
> >  drivers/i2c/busses/i2c-designware-core.h    |  6 ++++++
> >  drivers/i2c/busses/i2c-designware-platdrv.c | 18 +++++++++++++-----
> >  3 files changed, 30 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> > index 3c20e4b..377deeb 100644
> > --- a/drivers/i2c/busses/i2c-designware-core.c
> > +++ b/drivers/i2c/busses/i2c-designware-core.c
> > @@ -631,6 +631,14 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> >  	dev->abort_source = 0;
> >  	dev->rx_outstanding = 0;
> >  
> > +	if (dev->acquire_lock) {
> > +		ret = dev->acquire_lock(dev);
> > +		if (ret) {
> > +			dev_err(dev->dev, "couldn't acquire bus ownership\n");
> > +			goto done;
> 
> I wonder what happens now since you failed to acquire the lock...
> 
> > +		}
> > +	}
> > +
> >  	ret = i2c_dw_wait_bus_not_busy(dev);
> >  	if (ret < 0)
> >  		goto done;
> > @@ -676,6 +684,9 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> >  	ret = -EIO;
> >  
> >  done:
> > +	if (dev->release_lock)
> > +		dev->release_lock(dev);
> 
> ... but here you unconditionally release it?
> 

Releasing the lock unconditionally isn't a problem, but it is an unnecessary
path should we fail to acquire the lock. I'll add another label to skip it.

Dave


