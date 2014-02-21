Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaBUM3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:29:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:60910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbaBUM3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,518,1389772800"; 
   d="scan'208";a="485454500"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Topic: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Index: AQHPLvt0nHRl5SyBG0mLPlLL2F8KX5q/n6EQ
Date: Fri, 21 Feb 2014 12:29:44 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C28A3B@SHSMSX101.ccr.corp.intel.com>
References: <y> <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
 <alpine.DEB.2.02.1402100951290.21991@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C269E8@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402201218310.4468@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C27CF7@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402211006130.4468@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C287C7@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402211209500.21251@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C2886B@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402211230100.21251@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402211230100.21251@ionos.tec.linutronix.de>
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
> Sent: Friday, February 21, 2014 7:53 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Wang, Xiaoming
> Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq() wait-forever
> 
> On Fri, 21 Feb 2014, Liu, Chuansheng wrote:
> > > > > I think you have a point there, but not on x86 wherre the atomic_dec
> > > > > and the spinlock on the queueing side are full barriers. For non-x86
> > > > > there is definitely a potential issue.
> > > > >
> > > > But even on X86, spin_unlock has no full barrier, the following scenario:
> > > > CPU0                   CPU1
> > > > spin_lock
> > > >                        atomic_dec_and_test
> > > > insert into queue
> > > > spin_unlock
> > > >                        checking waitqueue_active
> > >
> > > But CPU0 sees the 0, right?
> > Not be clear here:)
> > The atomic_read has no barrier.
> >
> > Found commit 6cb2a21049b89 has one similar smp_mb() calling before
> > waitqueue_active() on one X86 CPU.
> 
> Indeed, you are completely right. Great detective work!
Thanks your encouraging.

> 
> I'm inclined to remove the waitqueue_active() alltogether. It's
> creating more headache than it's worth.
If I am understanding well, removing the checking of waitqueue_active(),
and call wakeup() directly which will check list with spinlock protection.

If so, I can prepare one patch for it:)
