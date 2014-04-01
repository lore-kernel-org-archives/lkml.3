Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaDAFeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:34:04 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47825 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAFeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:34:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140331213032.GA5866@amt.cnet>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
 <5339AB59.4050906@mit.edu> <20140331213032.GA5866@amt.cnet>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 31 Mar 2014 22:33:41 -0700
Message-ID: <CALCETrW9sBUSg8gRBEpDNC_Vcqq2oDRkVNPxTBGmehpMay9=5Q@mail.gmail.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a problem?
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhang yanying <zhuangyanying@huawei.com>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 31, 2014 8:45 PM, "Marcelo Tosatti" <mtosatti@redhat.com> wrote:
>
> On Mon, Mar 31, 2014 at 10:52:25AM -0700, Andy Lutomirski wrote:
> > On 03/29/2014 01:47 AM, Zhanghailiang wrote:
> > > Hi,
> > > I found when Guest is idle, VDSO pvclock may increase host consumption.
> > > We can calcutate as follow, Correct me if I am wrong.
> > >       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest)
> > > In Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250 Hz, it may consume 225,000 cycles per second, even no VM is created.
> > > In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per call. The feature decrease 150 cycles consumption per call.
> > > When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the host consumption.
> > > Both Host and Guest is linux-3.13.6.
> > > So, whether the host cpu consumption is a problem?
> >
> > Does pvclock serve any real purpose on systems with fully-functional
> > TSCs?  The x86 guest implementation is awful, so it's about 2x slower
> > than TSC.  It could be improved a lot, but I'm not sure I understand why
> > it exists in the first place.
>
> VM migration.

Why does that need percpu stuff?  Wouldn't it be sufficient to
interrupt all CPUs (or at least all cpus running in userspace) on
migration and update the normal timing data structures?

Even better: have the VM offer to invalidate the physical page
containing the kernel's clock data on migration and interrupt one CPU.
 If another CPU races, it'll fault and wait for the guest kernel to
update its timing.

Does the current kvmclock stuff track CLOCK_MONOTONIC and
CLOCK_REALTIME separately?

>
> Can you explain why you consider it so bad ? How you think it could be
> improved ?

The second rdtsc_barrier looks unnecessary.  Even better, if rdtscp is
available, then rdtscp can replace rdtsc_barrier, rdtsc, and the
getcpu call.

It would also be nice to avoid having two sets of rescalings of the timing data.


>
> > I certainly understand the goal of keeping the guest CLOCK_REALTIME is
> > sync with the host, but pvclock seems like overkill for that.
>
> VM migration.
>
