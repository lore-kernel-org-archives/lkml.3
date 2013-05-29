Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3E2FXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:23:22 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34099 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3E2FXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <76114024.UaPHgm94jK@vostro.rjw.lan>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
	<2272781.tC3OqoQmKI@vostro.rjw.lan>
	<20130528152625.1b7833e5@amdc308.digital.local>
	<76114024.UaPHgm94jK@vostro.rjw.lan>
Date: Wed, 29 May 2013 10:53:19 +0530
Message-ID: <CAKohpon8CScv_GgXL4eTvKqPo1oC67TujMH4WdOQCit7jz+FeQ@mail.gmail.com>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2013 03:18, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, May 28, 2013 03:26:25 PM Lukasz Majewski wrote:
>> Hi Viresh, Rafael,
>>
>> > On Tuesday, May 28, 2013 03:14:26 PM Viresh Kumar wrote:

>> > I'm not sure about that.  On x86 boost will be used with all
>> > governors if enabled (as currently defined in acpi-cpufreq).
>>
>> All governors can benefit from the overclocking code.

Yeah.

>> > Also it looks like this depends on the driver too, because if the
>> > driver doesn't have "turbo" frequencies, the governor won't be able
>> > use "turbo" anyway.

Yes.

>> > So first, it would make sense to use a per-driver "boost" attribute
>> > indicating whether or not the given driver should present any "turbo"
>> > frequencies to the governor.

@Lukasz: So, you need to add another field in struct cpufreq_driver,
which will be called "turbo_mode" or something better.

>> Now I'm using a device tree's cpufreq section (defined at
>> exynos4412-redwood.dts) with overclocking = "okay" attribute defined.
>> Then, on this basis, we could decide at cpufreq init time if we will
>> export any overclocking related sysfs entries (or init overclocking at
>> all). It would assure clearer code.
>
> Well, what about users?  Don't you want them to be able to decide whether
> or not to use "turbo"?

I believe Lukasz was saying that we can have two levels of enabling it..
Firstly the driver can say if it supports turbo_mode or not and so will
register cpufreq_driver with appropriate parameters..

Now if turbo_mode == true, then sysfs entry will be created by cpufreq
core which users can enable/disable...

And this is what I had in mind too.

>> I think that global cpufreq device tree attribute shall be defined.
>
> What do you mean by "device tree attribute"?  If you mean FDTs as used by
> ARM for system configuration description, that wouldn't be portable, because
> DTs aren't used for that on the (majority of) x86 systems.

So, drivers should pass correct value in boost_mode in struct cpufreq_driver.
They get it from DT or is hard coded doesn't matter at all to the core. But
yes getting a single name for DT bindings would be good. We should use
the same name at that place too: turbo_mode

>> The overclocking will be an integral part of the cpufreq framework.
>
> Well, to be precise, I was thinking about moving the management of the
> /sys/devices/system/cpu/cpufreq/boost attribute from acpi-cpufreq to the
> code so that other drivers may use it too.  Does that make sense to you?

Obviously yes. The sysfs related code from acpi-cpufreq should be moved
to cpufreq.c and will be functional once cpufreq_driver has boost_mode set
as true.

>> > Second, I'm not sure if an additional knob for the governor is
>> > necessary.  It may just use the turbo frequencies if available (and
>> > if the governor cannot use them, it simply won't use them).
>>
>> I cannot agree. It is welcome to be able to enable/disable the feature
>> when needed. Turbo frequencies shall not be "available" for use all the
>> time.

Yes, you can disable that from userspace once your driver said: "I support
turbo mode"..
