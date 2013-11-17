Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3KQQ5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:57:51 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54165 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3KQQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:57:43 -0500
MIME-Version: 1.0
In-Reply-To: <5974906.WAPp3f3eVY@vostro.rjw.lan>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<6050176.zVNbf5pomE@vostro.rjw.lan>
	<52887CB7.4000108@linaro.org>
	<5974906.WAPp3f3eVY@vostro.rjw.lan>
Date: Sun, 17 Nov 2013 22:27:43 +0530
Message-ID: <CAKohpo=PoAaYgLNEVkkTC6tzAH=5hKw4VWTsrjt2jQnr7+6Q_w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 November 2013 20:39, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Sunday, November 17, 2013 01:52:15 PM viresh kumar wrote:

>> Do you see anything extra that might stop working?
>
> Well, the code would be racy with the patch as is.  User space might manipulate
> the sysfs knobs in parallel with your PM notifiers, for example, and I'm not
> entirely sure what can happen then.  And the lock in there is pointless,
> because it doesn't prevent any races from happening.

Hmm..

>> A unrelated question here. Why are we offlining CPUs after suspending all the
>> devices? Because the problem Nishanth mentioned was that he required few
>> devices, i2c, to be available when CPUs are getting down. And there might be
>> similar requirements at other places too. Was there any specific bottleneck due
>> to which it is implemented this way?
>
> No, this is because the ACPI spec mandates powering down devices before CPUs
> during system suspend.  The way it is done today, however, I think we don't
> need to keep that ordering so strictly any more.  We definitely don't need to
> do that on non-ACPI systems.

Okay.. But different behavior for acpi and non-acpi at such core code doesn't
look great to me.. Lets see if we can work with existing code

> So while I hate the PM notifiers idea (sorry, but that's how it goes), I think
> it would be OK to suspend *some* devices after disabling CPUs (not all of them,
> of course).

Hmm...

> And as I said, I think it would be OK to introduce suspend/resume callbacks for
> CPU devices and use those callbacks to work around the ordering issues, when
> necessary.  The main point is that the changes made for this purpose should
> only affect systems where they are necessary and not everyone.  I don't want
> to change the way things work today in general in cpufreq too much unless they
> are plain bugs that affect everyone.
>
>> > We may introduce suspend_noirq and resume_noirq for cpu_subsys, for example,
>> > and handle things from there.  Or something similar.  But slapping PM notifiers
>> > on top of the existing code just because it appears to be easy (and making that
>> > code even more overdesigned than it already is this way) doesn't seem quite
>> > right.

Okay.. Even these notifiers would be fine for me. To make things more clear
before I start implementing them:
- What about implementing syscore's suspend_prepare and post_suspend?
- Or you want to extend only CPU subsystems notifiers? What notifiers exactly?
And at which places we want to issue them from?

>> - I have concerns with Tianyu's patch as policies should be better taken care of
>> in cpufreq core instead of passing them over to governors.
>
> Well, this is all too tangled anyway, but quite frankly I'm not sure if it is
> worth untangling at this point.  We're deprecating cpufreq anyway.

I don't really think cpufreq is going anywhere even after we move bits
into scheduler. All the backend CPUFreq stuff will probably stay as is,
as they can't go anywhere.

One thing that will surely go away is the governor's layer, which would
be directly embedded into scheduler.

Lets see how that goes..

>> - Not all platforms have problem with changing frequency during suspend/resume
>> and so we may not require disabling of governors for all of them. Probably can
>> add another field based on which we may/may-not disable governors from PM or
>> syscore notifiers.
>
> What exactly is wrong with adding suspend/resume callbacks to cpu_subsys?

Okay, so you were asking about extending following list: CPU_ONLINE,
CPU_UP_PREPARE, CPU_UP_CANCELED, CPU_DOWN_PREPARE, etc.. to
include suspend/resume ones as well?

Logically speaking, all existing ones does look correct as they are more or
less cpu related. But suspend/resume doesn't look any similar, Atleast to me.

Suspend/resume are system's state rather than CPU's.. We aren't suspending
or resuming CPUs, we are shutting them off.. So I thought maybe syscore ops
is a better place (which is already used by cpufreq)..
