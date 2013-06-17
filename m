Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab3FQIaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:30:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:52751 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab3FQIaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:30:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,879,1363158000"; 
   d="scan'208";a="354767814"
Date: Mon, 17 Jun 2013 11:34:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130617083420.GK11878@intel.com>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370595083-801-1-git-send-email-christian.ruppert@abilis.com>
 <20130614143740.GD2929@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614143740.GD2929@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 04:37:41PM +0200, Wolfram Sang wrote:
> On Fri, Jun 07, 2013 at 10:51:23AM +0200, Christian Ruppert wrote:
> > The designware block is not always properly disabled in the case of
> > transfer errors. Interrupts from aborted transfers might be handled
> > after the data structures for the following transfer are initialised but
> > before the hardware is set up. This can corrupt the data structures to
> > the point that the system is stuck in an infinite interrupt loop (where
> > FIFOs are never emptied because dev->msg_read_idx == dev->msgs_num).
> > 
> > This patch cleanly disables the designware-i2c hardware at the end of
> > every transfer, be it successful or not.
> > 
> > This patch requires https://patchwork.kernel.org/patch/2601241/ to be
> > applied first.
> 
> These last two lines should be below "---".
> 
> > 
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-core.c |   10 ++++++++--
> >  1 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> > index b75d292..55a9991 100644
> > --- a/drivers/i2c/busses/i2c-designware-core.c
> > +++ b/drivers/i2c/busses/i2c-designware-core.c
> > @@ -588,11 +588,19 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> >  	ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);
> >  	if (ret == 0) {
> >  		dev_err(dev->dev, "controller timed out\n");
> > +		/* i2c_dw_init implicitly disables the adapter */
> >  		i2c_dw_init(dev);
> >  		ret = -ETIMEDOUT;
> >  		goto done;
> >  	}
> >  
> > +	/*
> > +	 * We must disable the adapter before unlocking the &dev->lock mutex
> > +	 * below. Otherwise the hardware might continue generating interrupts
> > +	 * which in turn causes a race condition with the following transfer.
> 
> I added "Needs some more investigation if the additional interrupts are
> a hardware bug or this driver doesn't handle them correctly yet." to the
> comment and
> 
> Applied to for-next, thanks!

Sorry for the late response (was on vacation). This patch looks good to me
as well. Thanks for applying it!
