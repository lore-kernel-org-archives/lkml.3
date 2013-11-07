Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3KGArG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:47:06 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49387 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3KGArF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:47:05 -0500
Date: Wed, 6 Nov 2013 16:46:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "tj@kernel.org" <tj@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
Message-ID: <20131107004659.GA3312@core.coreip.homeip.net>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
 <20131107002959.GA32200@mtj.dyndns.org>
 <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B866C7@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 12:36:56AM +0000, Liu, Chuansheng wrote:
> 
> 
> > -----Original Message-----
> > From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of tj@kernel.org
> > Sent: Thursday, November 07, 2013 8:30 AM
> > To: Liu, Chuansheng
> > Cc: Greg KH; dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
> > 
> > Hello, Liu.
> > 
> > On Thu, Nov 07, 2013 at 12:27:56AM +0000, Liu, Chuansheng wrote:
> > > The driver code is as below:
> > > _INIT() {
> > >
> > > A = devm_kzalloc();
> > > B= devm_request_threaded_irq(isr_handler);
> > > C = devm_kzalloc();
> > > }
> > >
> > > When driver _EXIT, the devres_release_all () will be called.
> > > The C will be kfreed before B, but when freeing irq B, the pending isr_handler()
> > possibly
> > > will access the memory B which has been freed.
> > > Then the memory corruption occurred.
> > >
> > > This patch can solve this scenario.
> > 
> > Isn't the bug there IRQ being requested before all its resources are
> > allocated?  The proposed change just masks the underlying issue or
> > incorrectly ordered operations.
> Yes, I knew I can put the code always like below:
> A = devm_kzalloc();
> C = devm_kzalloc();
> ...
> B= devm_request_threaded_irq(isr_handler);
> 
> But, the above is just one simple coding prototype, if there are many calling:
> E -- > F -- > D -- >... then to devm_kzalloc().
> 
> To be honest, it will make code too hard to always adapt the rule?
> And I trying to find out every potential devm_kzalloc() before irq requesting.

Such code is already broken anyway and has to be fixed - if your IRQ
handler accesses data allocated by devm_kzalloc that you call only
_after_ you called devm_request_irq() then interrupt arriving at
unfortunate moment will crash your driver at the probing stage.

Thanks. 

-- 
Dmitry
