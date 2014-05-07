Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaEGOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:10:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61240 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaEGOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:10:53 -0400
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <536A3EE9.5050409@intel.com>
Date: Wed, 07 May 2014 07:10:49 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Johan Hovold <jhovold@gmail.com>
CC: dirk.j.brandewie@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression in v3.14
References: <20140506163559.GA5308@localhost> <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
In-Reply-To: <CAKohpokYEvazxm0-JJXPzq-4OgLXmROfaCMcgHDZwugChOxtsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 10:40 PM, Viresh Kumar wrote:
> Cc'ing Dirk who is taking care of intel-pstate driver.
>

Thanks Viresh I had seen this thread.

I am looking into it

--Dirk
> On 6 May 2014 22:05, Johan Hovold <jhovold@gmail.com> wrote:
>> After updating my main system from v3.13 to v3.14.2, I found that the
>> git bash-completion was extremely sluggish. Completing a file name would
>> take roughly six rather than one second on this Haswell machine
>> (i7-4770). (Other things, such as git rebase, also felt slower, but
>> the completion issue was much more obvious and easy to measure).
>>
>> I managed to reproduce the problem using the following minimal construct
>>
>>          cat dmesg.repeat | while read x; do true; done
>>
>> where dmesg.repeat is simply dmesg concatenated together to an
>> equivalent number of lines as produced by git ls-files in the
>> kernel-source tree root (45k), and where the actual processing of each
>> line has been removed.
>>
>> Most of the time I get:
>>
>>          $ time cat dmesg.repeat | while read x; do true; done
>>
>>          real    0m6.091s
>>          user    0m3.674s
>>          sys     0m2.447s
>>
>> but sometimes it only takes one second.
>>
>>          $ time cat dmesg.repeat | while read x; do true; done
>>
>>          real    0m1.100s
>>          user    0m0.544s
>>          sys     0m0.570s
>>
>> I don't seem to be able to reproduce the problem on 3.13 where the pipe
>> always takes about one second to finish.
>>
>> Taking all but one core offline seems to make the problem go away, and so
>> does using the performance rather than powersave governor of the
>> intel_pstate cpufreq driver (on at least one of two online cores).
>>
>> Moving the mouse cursor makes to loop finish faster, and so does
>> switching to a another terminal to print cpufreq/cpuinfo_cur_freq which
>> was around cpuinfo_min_freq several times (when tracing, see below).
>>
>> I could not reproduce the problem when using perf record, but I can get
>> function-profile traces using ftrace (in which case the loop takes about
>> 60 seconds instead of six seconds to finish).
>>
>> Comparing the traces I see a lot of functions taking ten times longer to
>> finish, but I guess that's expected if this is indeed a cpufreq issue.
>>
>> Since this is my main machine (and only multi-core machine at the
>> moment) I'm not able to bisect this myself. And for the same reason I
>> have not verified that the problem persists in v3.15-rc.
>>
>> I don't see any cpufreq patches in the v3.14.3 stable queue nor anything
>> obviously related and marked for stable in v3.15-rc.
>>
>> Any ideas about what might be going on?
>
> I tried to take a look at the diff for cpufreq between 3.13 and 3.14.2 and
> couldn't pin point on any change which might cause it. Don't have a clue
> of what's going on. I don't know how to help you on this.
>
> Normally I test my stuff on a ARM board and I don't remember facing
> any such behavior there. There might be something wrong with intel-pstate
> as well..
>
> Also, can you try to use acpi-cpufreq instead? And see how that is behaving?
>
> --
> viresh
>

