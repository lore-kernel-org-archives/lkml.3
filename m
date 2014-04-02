Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaDBAMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbaDBAMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:12:50 -0400
Date: Tue, 1 Apr 2014 21:12:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhang yanying <zhuangyanying@huawei.com>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Message-ID: <20140402001213.GB29864@amt.cnet>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
 <5339AB59.4050906@mit.edu>
 <20140331213032.GA5866@amt.cnet>
 <CALCETrW9sBUSg8gRBEpDNC_Vcqq2oDRkVNPxTBGmehpMay9=5Q@mail.gmail.com>
 <20140401180134.GA17963@amt.cnet>
 <CALCETrVFv4dHH1_D1KR43-UsVCPcXDXhwAuUWNUF5_Wgm+kw1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVFv4dHH1_D1KR43-UsVCPcXDXhwAuUWNUF5_Wgm+kw1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 12:17:16PM -0700, Andy Lutomirski wrote:
> On Tue, Apr 1, 2014 at 11:01 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Mon, Mar 31, 2014 at 10:33:41PM -0700, Andy Lutomirski wrote:
> >> On Mar 31, 2014 8:45 PM, "Marcelo Tosatti" <mtosatti@redhat.com> wrote:
> >> >
> >> > On Mon, Mar 31, 2014 at 10:52:25AM -0700, Andy Lutomirski wrote:
> >> > > On 03/29/2014 01:47 AM, Zhanghailiang wrote:
> >> > > > Hi,
> >> > > > I found when Guest is idle, VDSO pvclock may increase host consumption.
> >> > > > We can calcutate as follow, Correct me if I am wrong.
> >> > > >       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> >> > > > In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> >> > > > In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call.
> >> > > > When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> >> > > > Both Host and Guest is linux-3.13.6.
> >> > > > So, whether the host cpu consumption is a problem?
> >> > >
> >> > > Does pvclock serve any real purpose on systems with fully-functional
> >> > > TSCs?  The x86 guest implementation is awful, so it's about 2x slower
> >> > > than TSC.  It could be improved a lot, but I'm not sure I understand why
> >> > > it exists in the first place.
> >> >
> >> > VM migration.
> >>
> >> Why does that need percpu stuff?  Wouldn't it be sufficient to
> >> interrupt all CPUs (or at least all cpus running in userspace) on
> >> migration and update the normal timing data structures?
> >
> > Are you suggesting to allow interruption of the timekeeping code
> > at any time to update frequency information ?
> 
> I'm not sure what you mean by "interruption of the timekeeping code".
> I'm suggesting sending an interrupt to the guest (via a virtio device,
> presumably) to tell it that it has been paused and resumed.

code:

1) disable interrupts
2) A = RDTSC
3) B = SCALE(A, TSC.FREQ)

If migration happens between 2 and 3, you've got an incorrect value.

