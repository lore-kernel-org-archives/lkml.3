Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaK1Jth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:49:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:29330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaK1Jte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,475,1413270000"; 
   d="scan'208";a="629573504"
Message-ID: <1417168170.17201.4.camel@linux.intel.com>
Subject: Re: [PATCH v4 2/3] x86: pmc_atom: don't check for NULL twice
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H . Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Nov 2014 11:49:30 +0200
In-Reply-To: <alpine.DEB.2.11.1411191224220.3909@nanos>
References: <1415812689-17326-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1415812689-17326-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <alpine.DEB.2.11.1411191224220.3909@nanos>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 12:36 +0100, Thomas Gleixner wrote:
> On Wed, 12 Nov 2014, Andy Shevchenko wrote:
> 
> > debugfs_remove_recursive() is NULL-aware, thus, we may safely remove the check
> > here. There is no need to assing NULL to variable since it will be not used
> > anywhere.

Thanks for review, my comments below.

> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
> > ---
> >  arch/x86/kernel/pmc_atom.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> > index 19b8efa..bcc91ea 100644
> > --- a/arch/x86/kernel/pmc_atom.c
> > +++ b/arch/x86/kernel/pmc_atom.c
> > @@ -202,11 +202,7 @@ static const struct file_operations pmc_sleep_tmr_ops = {
> >  
> >  static void pmc_dbgfs_unregister(struct pmc_dev *pmc)
> >  {
> > -	if (!pmc->dbgfs_dir)
> > -		return;
> > -
> >  	debugfs_remove_recursive(pmc->dbgfs_dir);
> > -	pmc->dbgfs_dir = NULL;
> >  }
> 
> So while the patch is correct per se, the whole function is useless.
> 
> pmc_dbgfs_register()
> 
> 	dir = debugfs_create_dir("pmc_atom", NULL);
> 
> 	....
> 	if (!f)
> 		goto err;
> 
> 	pmc->dbgfs_dir = dir;
> 	return 0;
> err:
> 	pmc_dbgfs_unregister(pmc);
> 
> So pmc->dbgfs_dir is always NULL when this is called....

Good catch, I add a new patch to address this.


> Aside of that, if DEBUGFS=n the code keeps pmc->regmap ioremapped for
> no reason.

pmc_hw_reg_setup() uses it. Aubrey, is it intended behaviour?

> Looking deeper:
> 
> The pmc_power_off function is installed _BEFORE_ pmc_hw_reg_setup() is
> called, which might not be called if the ioremap fails ....

I don't see any problem here (pmc_power_off uses acpi_base_addr which is
independent to IO mapped space), though Aubrey may shed a light on this.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

