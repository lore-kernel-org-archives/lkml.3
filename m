Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3CEKhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:37:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:23869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3CEKhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:37:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,787,1355126400"; 
   d="scan'208";a="294992455"
Message-ID: <1362479804.28241.114.camel@smile>
Subject: Re: [PATCH 06/10] dmatest: run test via debugfs
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 05 Mar 2013 12:36:44 +0200
In-Reply-To: <20130305092649.GD28136@intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1362388174-3435-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130305092649.GD28136@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 14:56 +0530, Vinod Koul wrote: 
> On Mon, Mar 04, 2013 at 11:09:30AM +0200, Andy Shevchenko wrote:
> > @@ -0,0 +1,48 @@
> > +				DMA Test Guide
> > +				==============
> > +
> > +		Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > +
> > +This small document introduces how to test DMA drivers using dmatest module.
> > +
> > +	Part 1 - How to build the test module
> > +
> > +The menuconfig contains an option that could be found by following path:
> > +	Device Drivers -> DMA Engine support -> DMA Test client
> > +
> > +In the configuration file the option called CONFIG_DMATEST. The dmatest could
> > +be built as module or inside kernel. Let's consider those cases.
> > +
> > +	Part 2 - When dmatest is built as a module...
> > +
> > +After mounting debugfs and loading the module, the /sys/kernel/debug/dmatest
> > +folder with nodes will be created. They are the same as module parameters with
> > +addition of the 'run' node that controls run and stop phases of the test.
> > +
> > +Note that in this case test will not run on load automatically.
> > +
> > +Example of usage:
> > +	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
> > +	% echo 2000 > /sys/kernel/debug/dmatest/timeout
> > +	% echo 1 > /sys/kernel/debug/dmatest/iterations
> > +	% echo 1 > /sys/kernel/debug/dmatest/run
> How do you terminate a test? Esp if you have started bunch of concurent tests
> and want to terminate one of them...

There is only one test in progress is possible.

To stop the test simple echo 0 > run (Probable that should be in
documentation as well)

> >  static struct dmatest_info test_info;
> > @@ -718,7 +729,7 @@ static bool filter(struct dma_chan *chan, void *param)
> >  		return true;
> >  }
> >  
> > -static int run_threaded_test(struct dmatest_info *info)
> > +static int __run_threaded_test(struct dmatest_info *info)
> >  {
> >  	dma_cap_mask_t mask;
> >  	struct dma_chan *chan;
> > @@ -744,7 +755,19 @@ static int run_threaded_test(struct dmatest_info *info)
> >  	return err;
> >  }
> >  
> > -static void stop_threaded_test(struct dmatest_info *info)
> > +#ifndef MODULE
> > +static int run_threaded_test(struct dmatest_info *info)
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&info->lock);
> > +	ret = __run_threaded_test(info);
> > +	mutex_unlock(&info->lock);
> > +	return ret;
> > +}
> > +#endif
> > +
> > +static void __stop_threaded_test(struct dmatest_info *info)
> >  {
> >  	struct dmatest_chan *dtc, *_dtc;
> >  	struct dma_chan *chan;
> > @@ -760,13 +783,234 @@ static void stop_threaded_test(struct dmatest_info *info)
> >  	info->nr_channels = 0;
> >  }
> >  
> > +static void stop_threaded_test(struct dmatest_info *info)
> > +{
> > +	mutex_lock(&info->lock);
> > +	__stop_threaded_test(info);
> > +	mutex_unlock(&info->lock);
> > +}
> > +
> > +static int __restart_threaded_test(struct dmatest_info *info, bool run)
> > +{
> > +	struct dmatest_params *params = &info->params;
> > +	int ret;
> > +
> > +	/* Stop any running test first */
> > +	__stop_threaded_test(info);
> > +
> > +	if (run == false)
> > +		return 0;
> > +
> > +	/* Copy test parameters */
> > +	memcpy(params, &info->dbgfs_params, sizeof(*params));
> what if the params are not yet filled by user... for module case?

Defaults are provided by constants in the top of file. They are copied
when module_init is called.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
