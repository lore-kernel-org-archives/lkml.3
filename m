Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaCNE7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 00:59:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65109 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaCNE7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 00:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
Date: Fri, 14 Mar 2014 10:29:08 +0530
X-Google-Sender-Auth: tSF1QROfDhyG9GKkSPCnGkuYP8I
Message-ID: <CAOh2x==at2PtHRpa=-_V6O5Z9aSog4r9BDb7ixJgBZk_+vfPtg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, patrick.marlier@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 11:06 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Some drivers (intel_pstate) need to modify state on a core before it
> is completely offline.  The ->exit() callback is executed during the
> CPU_POST_DEAD phase of the cpu offline process which is too late to
> change the state of the core.
>
> Patch 1 adds an optional callback function to the cpufreq_driver
> interface which is called by the core during the CPU_DOWN_PREPARE
> phase of cpu offline in __cpufreq_remove_dev_prepare().
>
> Patch 2 changes intel_pstate to use the ->exit_prepare callback to do
> its cleanup during cpu offline.

Copying stuff from other mail thread here so that we can discuss on a
single mail chain.

On 14 March 2014 03:09, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, March 13, 2014 12:56:02 PM Viresh Kumar wrote:
>> On 13 March 2014 08:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Wednesday, March 12, 2014 02:27:07 PM Dirk Brandewie wrote:
>>
>> >> > I see two possibilities:
>> >> >   1. Move the exit() callback to __cpufreq_remove_dev_prepare().  I don't
>> >> >      have a good understanding of what carnage this would cause in the core
>> >> >      or other scaling drivers.
>> >> >
>> >> >   2. Add another callback to the cpufreq_driver interface that would be call
>> >> >      from __cpufreq_remove_dev_prepare() if the callback was set.
>> >
>> > I prefer 2, the reason being that it pretty much is guaranteed not to break
>> > anything.  For the record, I'm not a fan of adding new cpufreq driver callbacks,
>> > but in this particular case it seems we can't really do anything better.
>>
>> I haven't thought a lot about which one of these two looks better, probably
>> Rafael might be correct. But I can see another way out here as this is very
>> much driver specific. Why can't we do a register_hotcpu_notifier() from
>> pstate driver alone?
>
> Why would that be better than adding a new callback?

Because its becoming more and more confusing. Probably we got the problem
right but have wrong solutions for it.

But having considered this issue in detail now, I have more inputs. All Dirk and
Patrick wanted is to set core to min P-state before it gets offlined. We already
have some infrastructure in core which is called this today:
cpufreq_generic_suspend(). We can rework on that to get a more ideal solution
for both the problems.

Over that I don't think Dirk's solution is going to work if we twist
the systems a
bit. For example, Dirk probably wanted to set P-STATE of every core to MIN
when it goes down. But his solution probably doesn't do that right now.

As exit() is called only when the policy expires or all the CPUs of that policy
are down. Suppose only one CPU out of 4 goes down from a policy, then
pstate driver would never know that happened. And that core wouldn't go
to min state.

I think we have two solutions here:
- If its just about setting core a particular freq when it goes down, I think it
looks a generic enough problem and so better fix core for that. Probably with
help of flags field/suspend-freq (maybe renamed) and without calling drivers
exit() at all..

- If this is highly driver specific (which doesn't look like if all we
have to do
is setting freq to MIN), then better have something like
register_hotcpu_notifier() with priority set to -1, so that it gets called after
cpufreq.

--
viresh
