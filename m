Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaAHFvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 00:51:11 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46958 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaAHFvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 00:51:03 -0500
MIME-Version: 1.0
In-Reply-To: <8738l15pht.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
	<878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	<87wqihmg9a.fsf@nemi.mork.no>
	<CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
	<87iotx32mx.fsf@nemi.mork.no>
	<CAKohpo=KgHqz0KYv7h0EYP3=8h7T3ZfPpFTMS6qVoEb6dXGnSQ@mail.gmail.com>
	<87a9f92xnn.fsf@nemi.mork.no>
	<CAKohpon7u_1h+9rKQeC8J4Pqd_6bSajn7Ag8=COqczhbSPEgMA@mail.gmail.com>
	<8738l15pht.fsf@nemi.mork.no>
Date: Wed, 8 Jan 2014 11:21:00 +0530
Message-ID: <CAKohpomEr_caoDGeUWWMeJ1_siEQguUTaPF6zgD62YqT=4F7og@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 16:47, Bjørn Mork <bjorn@mork.no> wrote:
> Viresh Kumar <viresh.kumar@linaro.org> writes:
>
>> On 6 January 2014 16:19, Bjørn Mork <bjorn@mork.no> wrote:
>>> I cancelled by pressing backspace while the image was being written.
>>
>> I will answer other queries on next mail, but a quick question:
>> Do you get these warnings even if you don't cancel hibernation?
>
> Yes.

Hmm.. I see. Now, I really don't believe that you wouldn't get these
warnings on a suspend/resume but only on hibernation.

> I believe the photo shows that you are right: This warning happens when
> the failure path is entered, even if both the hibernation and following
> resume is successful.  We see __cpufreq_add_dev calling
> cpufreq_policy_put_kobj here as well.

@Rafael: I need your expert opinion here, I am not so good with these
concepts :)

Here is my theory about these warnings:
- Bjorn gets these only when CONFIG_PROVE_LOCKING=y.
- This feature enables the kernel to report locking related deadlocks
before they actually occur. (lib/Kconfig.debug)
- So, no locking issue has happened here but its just an warning that
you might end up getting into such issue later.
- Contention is between sysfs and cpu-hotplug lock.
- While changing stuff from sysfs we do this:
   sysfs-lock (by kernel)
   cpu-hotplug lock (by cpufreq)
- And while doing hibernation if add_dev fails then we do this
   cpu-hotplug lock (by kernel while adding CPUs)
   sysfs-lock (by cpufreq while removing sysfs directories)

And kernel is recording all these sequences all the time. Because
we first tried changing values from sysfs, kernel recorded that
sequence. And as soon as it found another one it WARNed us?

While on a suspend/resume, we will get into add-dev failure only
in resume and probably by that time these recordings are refreshed?
And that's why Bjorn isn't facing any issue there ? Just an wild guess.

And if all above "virtual" theory is correct, then I don't know if we
can/want to fix that..

> Thinking about this: This failure will always happen, regardless of
> cancelling or not, won't it?

Yeah.

> But it happens *after* the freeze so it
> doesn't matter if we resume from the frozen image.

yeah..

So, even tests like this should give you this warning:

Documentation/power/basic-pm-debugging.txt
core
- test the freezing of processes, suspending of devices, platform global
  control methods(*), the disabling of nonboot CPUs and suspending of
  platform/system devices

> So you are probably right as usual:

Really? Ask Rafael, he doesn't agree :)

> This warning is related to the
> acpi-cpufreq driver failing, and you cannot reproduce it without
> simulating such a failure (or using that driver yourself).  Which means
> that the warning disappears with my patch in
> http://www.spinics.net/lists/cpufreq/msg08714.html
> which explains why I don't normally see it.  I depend on being able to
> cancel hibernation, so I use that patch most of the time. Except when
> I'm testing one of your branches.

Correct.
