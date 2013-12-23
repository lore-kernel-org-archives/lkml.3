Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3LWLnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:43:47 -0500
Received: from canardo.mork.no ([148.122.252.1]:56181 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab3LWLnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:43:42 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed to come back after resume
Organization: m
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<1651441.C2UQleWVoy@vostro.rjw.lan> <871u14i00j.fsf@nemi.mork.no>
	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
	<87d2kokqdl.fsf@nemi.mork.no> <52B7EC81.6060202@linaro.org>
	<877gavgbuv.fsf@nemi.mork.no>
	<CAKohpo=0HRihdTiQLk+mKiarUdXOPO3n7GCJ9CUoi=4xJ_AYcg@mail.gmail.com>
	<87txdzx2bb.fsf@nemi.mork.no>
	<CAKohpon7nn5cpJVNZzzXxbYUkACEsFgyPR20kSSMMsShw0=HVA@mail.gmail.com>
Date: Mon, 23 Dec 2013 12:42:31 +0100
In-Reply-To: <CAKohpon7nn5cpJVNZzzXxbYUkACEsFgyPR20kSSMMsShw0=HVA@mail.gmail.com>
	(Viresh Kumar's message of "Mon, 23 Dec 2013 16:43:26 +0530")
Message-ID: <87pponx07s.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:
> On 23 December 2013 16:27, Bjørn Mork <bjorn@mork.no> wrote:
>> I could be missing something, but I haven't noticed any attempt to
>> preserve anything except the sysfs files.
>
> What do you mean by sysfs here? Doesn't the below files mentioned
> by you also come in sysfs?

My apologies here.  I see that you *do* try to preserve the policy over
the suspend.  So I guess it should have worked...

>> I tried modifying the max frequency, using
>>
>>  echo 800000 >/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
>>  echo 800000 >/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
>>
>> After supend + resume the boot CPU still had the modifed maximum, while
>> the non-boot core was reset to the default value.
>
> This is all we were doing. i.e. not removing or putting the kobject which has
> all these files and so shouldn't get reallocated at all..
>
> So, has resumed passed on the first go only? As it was failing for the first
> time in your case and hence this thread. In that case we are going to get
> new files and so all values will be restored to default values.
>
> Otherwise I don't see why we should loose any values here..

Looking at the code I don't see it either.  But the value is reset.
This is with both your patches:

  cpufreq: remove sysfs files for CPUs which failed to come back after resume
  cpufreq: try to resume policies which failed on last resume

applied on top of v3.13-rc5.  I.e. also including Jason's

  cpufreq: Use CONFIG_CPU_FREQ_DEFAULT_* to set initial policy for setpolicy drivers

since -rc4.  I don't know if that confuses the picture or not.  But
these are the results:

 nemi:/tmp# ls -l /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
 -rw-rw-r-- 1 root bjorn 4096 Dec 23 12:00 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
 -rw-rw-r-- 1 root bjorn 4096 Dec 23 11:59 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
 nemi:/tmp# grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:1401000
 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq:1401000
 nemi:/tmp# echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
 nemi:/tmp# echo 800000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
 nemi:/tmp# grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq:800000
 nemi:/tmp# s2ram 
 KMS graphics driver is in use, skipping quirks.

 ### resume, and then:

 nemi:/tmp# ls -l /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
 -rw-rw-r-- 1 root bjorn 4096 Dec 23 12:33 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
 -rw-rw-r-- 1 root bjorn 4096 Dec 23 12:33 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
 nemi:/tmp# grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
 /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq:1401000


The driver and governor is

 nemi:/tmp# grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_{driver,governor}
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
 /sys/devices/system/cpu/cpu1/cpufreq/scaling_driver:acpi-cpufreq
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:ondemand
 /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor:ondemand


>>  I changed the gid of
>> both files too, verifying that they were saved and restored as expected.
>> But the value will change to default.
>
> For both boot and non-boot CPUs? I am asking because things should
> be very plain for boot CPU atleast as that is never hot unplugged..
>
> Have you tested this with the latest patches I gave?

See above.  Yes, this is tested with both the two patches in flight and
without any failures on suspend. The non-boot CPU have its settings
reset to default.  The boot CPU keeps the modified values.

>> IMHO it would still be a lot better if this was handled as a true
>> hotplug event, allowing userspace to reset values/modes/owners on
>> resume. Hiding the hotplug event and saving part of the userspace
>> controlled environment is worse than not doing anything at all.
>
> We should be saving everything correctly with the current code,
> with the patches I have sent.. And so things should work as far
> as I can comment.
>
> If you can confirm that these happened despite of latest patches
> then probably I need to test that again on my thinkpad.

That would be great.  This could be just me.  I am quite good at
breaking stuff.


> But I was quite sure this worked :)

Sorry for breaking the illusion :-)



Bjørn
