Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbaBUAxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:53:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:56216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbaBUAx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:53:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,515,1389772800"; 
   d="scan'208";a="485186486"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Topic: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
Thread-Index: AQHPLjqzdiKGGHRTJECarwEX3016Y5q+32JA
Date: Fri, 21 Feb 2014 00:53:23 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C27CF7@SHSMSX101.ccr.corp.intel.com>
References: <y> <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
 <alpine.DEB.2.02.1402100951290.21991@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C269E8@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1402201218310.4468@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402201218310.4468@ionos.tec.linutronix.de>
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
> Sent: Thursday, February 20, 2014 8:53 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Wang, Xiaoming
> Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq() wait-forever
> 
> On Thu, 20 Feb 2014, Liu, Chuansheng wrote:
> > Hello Thomas,
> >
> > > -----Original Message-----
> > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > Sent: Monday, February 10, 2014 4:58 PM
> > > To: Liu, Chuansheng
> > > Cc: linux-kernel@vger.kernel.org; Wang, Xiaoming
> > > Subject: Re: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
> wait-forever
> > >
> > > On Mon, 10 Feb 2014, Chuansheng Liu wrote:
> > > > There is below race between irq handler and irq thread:
> > > > irq handler                             irq thread
> > > >
> > > > irq_wake_thread()                       irq_thread()
> > > >   set bit RUNTHREAD
> > > >   ...                                    clear bit RUNTHREAD
> > > >                                          thread_fn()
> > > >                                          [A]test_and_decrease
> > > >                                                thread_active
> > > >   [B]increase thread_active
> > > >
> > > > If action A is before action B, after that the thread_active
> > > > will be always > 0, and for synchronize_irq() calling, which
> > > > will be waiting there forever.
> > >
> > > No. thread_active is 0, simply because after the atomic_dec_and_test()
> > > it is -1 and the atomic_inc on the other side will bring it back to 0.
> > >
> > Yes, you are right. The thread_active is back to 0 at last.
> >
> > The case we meet is:
> > 1/ T1: blocking at disable_irq() -- > sync_irq() -- > wait_event()
> > [  142.678681]  [<c1a5b353>] schedule+0x23/0x60
> > [  142.683466]  [<c12b24c5>] synchronize_irq+0x75/0xb0
> > [  142.688931]  [<c125fad0>] ? wake_up_bit+0x30/0x30
> > [  142.694201]  [<c12b33ab>] disable_irq+0x1b/0x20
> > [  142.699278]  [<c17a79bc>] smb347_shutdown+0x2c/0x50
> > [  142.704744]  [<c1789f7d>] i2c_device_shutdown+0x2d/0x40
> > [  142.710597]  [<c1601734>] device_shutdown+0x14/0x140
> > [  142.716161]  [<c12535f2>] kernel_restart_prepare+0x32/0x40
> > [  142.722307]  [<c1253613>] kernel_restart+0x13/0x60
> >
> > 2/ The corresponding irq thread is at sleep state:
> > [  587.552408] irq/388-SMB0349 S f1c47620  7276   119      2
> 0x00000000
> > [  587.552439]  f1d6bf20 00000046 f1c47a48 f1c47620 f1d6bec4 9e91731c
> 00000001 c1a5f3a5
> > [  587.552468]  c20469c0 00000001 c20469c0 f36559c0 f1c47620 f307bde0
> c20469c0 f1d6bef0
> > [  587.552497]  00000296 00000000 00000296 f1d6bef0 c1a5bfa6
> f1c47620 f1d6bf14 c126e329
> > [  587.552501] Call Trace:
> > [  587.552519]  [<c1a5f3a5>] ? sub_preempt_count+0x55/0xe0
> > [  587.552535]  [<c1a5bfa6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
> > [  587.552548]  [<c126e329>] ? set_cpus_allowed_ptr+0x59/0xe0
> > [  587.552563]  [<c1a5b093>] schedule+0x23/0x60
> > [  587.552576]  [<c12b2ae1>] irq_thread+0xa1/0x130
> > [  587.552588]  [<c12b27f0>] ? irq_thread_dtor+0xa0/0xa0
> >
> > 3/ All the cpus are in the idle task;
> 
> Lets look at it again:
> 
> CPU 0                          CPU1
> 
> irq handler                    irq thread
>   set IRQS_INPROGRESS
>   ...
>   irq_wake_thread()            irq_thread()
>     set bit RUNTHREAD
>     ...                          clear bit RUNTHREAD
>                                  thread_fn()
>   				 atomic_dec_and_test(threads_active) ( 0 -> -1)
> 
>     atomic_inc(threads_active) ( -1 -> 0)
>   clr IRQS_INPROGRESS
> 
> Now synchronize_irq comes into play, that's what caused you to look
> into this.
> 
> synchronize_irq() can never observe the -1 state because it is
> serialized against IRQS_INPROGESS. And when IRQS_INPROGRESS is
> cleared, the threads_active state is back to 0.
> 
> I'm really not seing how this can happen. Any chance you can reproduce
> this by executing the situation which led to this in a loop?
We can have a try to forcedly reproduce the case of threads_active -1/0.

But feels there is another case which the synchronize_irq waited there forever,
it is no waking up action from irq_thread().

CPU0                                         CPU1
disable_irq()                                      irq_thread()
  synchronize_irq()
    wait_event()
     adding the __wait into the queue                wake_threads_waitq
       test threads_active==0                      
												 atomic_dec_and_test(threads_active) 1 -- > 0
                                                 waitqueue_active(&desc->wait_for_threads)
                                                   <== Here without smp_mb(), CPU1 maybe detect
                                                       the queue is still empty??
     schedule()

It will cause although the threads_active is 0, but irq_thread() didn't do the waking up action.
Is it reasonable? Then maybe we can add one smp_mb() before waitqueue_active.

Thanks.








