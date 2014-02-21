Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBULBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:01:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:36730 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbaBULBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:01:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,518,1389772800"; 
   d="scan'208";a="487137973"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Topic: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Index: AQHPLvBu4Oxc13UXJE2Bpln7jg8WpZq/iRHg
Date: Fri, 21 Feb 2014 11:01:34 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C287C7@SHSMSX101.ccr.corp.intel.com>
References: <y> <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
 <alpine.DEB.2.02.1402100951290.21991@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C269E8@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402201218310.4468@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C27CF7@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402211006130.4468@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402211006130.4468@ionos.tec.linutronix.de>
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

Hello Thomas,

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, February 21, 2014 6:34 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Wang, Xiaoming
> Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq() wait-forever
> 
> On Fri, 21 Feb 2014, Liu, Chuansheng wrote:
> > But feels there is another case which the synchronize_irq waited there
> forever,
> > it is no waking up action from irq_thread().
> >
> > CPU0                                  CPU1
> > disable_irq()                         irq_thread()
> >   synchronize_irq()
> >     wait_event()
> >      adding the __wait into the queue  wake_threads_waitq
> >        test threads_active==0
> > 					 atomic_dec_and_test(threads_active) 1 -- > 0
> >
> waitqueue_active(&desc->wait_for_threads)
> >                                   <== Here without smp_mb(), CPU1
> maybe detect
> >                                       the queue is still empty??
> >      schedule()
> >
> > It will cause although the threads_active is 0, but irq_thread() didn't do the
> waking up action.
> > Is it reasonable? Then maybe we can add one smp_mb() before
> waitqueue_active.
> 
> I think you have a point there, but not on x86 wherre the atomic_dec
> and the spinlock on the queueing side are full barriers. For non-x86
> there is definitely a potential issue.
> 
But even on X86, spin_unlock has no full barrier, the following scenario:
CPU0                   CPU1
spin_lock               
                       atomic_dec_and_test 
insert into queue         
spin_unlock
                       checking waitqueue_active

Here after inserting into the queue, before waitqueue_active,
there is no mb.

So is it still the case? Thanks.


