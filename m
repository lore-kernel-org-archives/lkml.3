Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaA2I26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:28:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:40722 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaA2I25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="466470255"
Date: Wed, 29 Jan 2014 10:35:48 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        yanmin_zhang@linux.intel.com, bo.he@intel.com
Subject: Re: [PATCH] i2c-designware-pcidrv: fix the incorrect return of idle
 callback
Message-ID: <20140129083548.GG18029@intel.com>
References: <52E744AC.2050606@intel.com>
 <20140128183035.GC20789@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128183035.GC20789@katana>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 07:30:35PM +0100, Wolfram Sang wrote:
> On Tue, Jan 28, 2014 at 01:48:28PM +0800, xinhui.pan wrote:
> > From: "xinhui.pan" <xinhuix.pan@intel.com>
> > 
> > i2c_dw_pci_runtime_idle should return -EBUSY rather than zero if it do success.
> 
> I don't understand...
> 
> > Otherwise rpm_idle will call pm_suspend again and that may cause pm_schedule_suspend delay invalidate.
> > 	
> > Signed-off-by: bo.he <bo.he@intel.com>
> > Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
> > ---
> >  drivers/i2c/busses/i2c-designware-pcidrv.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > index f6ed06c..96e81f6 100644
> > --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> > @@ -190,8 +190,8 @@ static int i2c_dw_pci_runtime_idle(struct device *dev)
> >  	int err = pm_schedule_suspend(dev, 500);
> >  	dev_dbg(dev, "runtime_idle called\n");
> >  
> > -	if (err != 0)
> > -		return 0;
> > +	if (err)
> > +		return err;
> >  	return -EBUSY;
> 
> ... it does return EBUSY when pm_schedule_suspend() succeeds? It only
> returns 0 if it does not succeed (for which I don't know if this is an
> apropriate behaviour). Mika?

If I understand correctly, pm_schedule_suspend(dev, 500) is there because
we want to runtime suspend in 500 ms. It then returns -EBUSY to prevent PM
runtime from carrying on suspend on it's own. However, I have no idea where
this magical 500 ms requirement comes from.

If we fail to schedule suspend we let the PM core to do whatever it thinks
suitable (in this case I suppose it suspends the device).

I think the whole idle dance could be replaced with a use of runtime PM
autosuspend, just like we do in the platform version of the driver.

Xinghui,

Is this a real problem that you are trying to solve?
