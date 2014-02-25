Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaBYF7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:59:46 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42869 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBYF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:59:43 -0500
Message-ID: <530C2FD7.4000105@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 11:23:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com> <5301CE86.9020105@linux.vnet.ibm.com>	<1489022.1IbaesBAQQ@vostro.rjw.lan> <CAKohpokGtcJbdzt0FPZnKjSFi54Np+Ss7--Z83UEZp8FMY94pQ@mail.gmail.com> <CAKohpokk5-6vGV93fZDob8Q=xZXsd7E4OkMUAC1M6Z71G=d1Ow@mail.gmail.com>
In-Reply-To: <CAKohpokk5-6vGV93fZDob8Q=xZXsd7E4OkMUAC1M6Z71G=d1Ow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022505-6102-0000-0000-00000503D664
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 10:11 AM, Viresh Kumar wrote:
> On 18 February 2014 07:49, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 18 February 2014 03:30, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>> On Monday, February 17, 2014 02:25:34 PM Srivatsa S. Bhat wrote:
>>>> Why go to no_policy when we can actually set things right?
>>>>
>>>> Anyway, I am not arguing against this strongly. I just wanted to share my
>>>> thoughts, since this is the approach that made more sense to me.
>>>
>>> And I agree with that.  In particular, since we're going to set the new
>>> policy *anyway* at this point, we can adjust the current frequency just fine
>>> in the process, can't we?
>>
>> Though I still feel that it wouldn't be the right thing to do as get()
>> just can't
>> return zero. Actually I was planning to place a WARN() over its return value
>> of zero.

A WARN() would definitely be good.

>>
>> Anyway, as two of the three are in favor of this we can get that in.. But how
>> would that work?
>>
>> - What frequency should we call cpufreq_driver_target ?
>> - Remember that it wouldn't do anything if policy->cur is same as new freq.
>> - Also remember that drivers need special attention if new freq is > old
>> freq or vice versa. As they will change voltage before or after change here.
>> And because we actually don't know what frequency we are at currently, how
>> will we decide that?
> 

Hmm, that's a good point. However, lets first think about the simple scenario
that the driver _is_ able to detect the current frequency from the hardware
(a non-zero, sane value) say X KHz, and that frequency is different from what
the cpufreq subsystem thinks it is (Y KHz).

In the current code, when we observe this, we send out a notification and try
to adjust to X KHz. Instead, what I'm suggesting is to invoke the driver to
set the frequency to Y KHz, since that's what the cpufreq subsystems wants the
frequency to be at.

As for the case where the driver reports the frequency to be 0 KHz, we can
print a WARN() and try to force set the frequency to Y KHz. But if that turns
out to be too tricky to handle, we can just put a WARN() and error out, as you
proposed earlier.
 
Regards,
Srivatsa S. Bhat

