Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3IJIvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:51:33 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58134 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3IJIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:51:29 -0400
Message-ID: <522EDC93.2060500@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 14:17:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org> <5225E205.7080008@linux.vnet.ibm.com> <CAKohpom-UFkvORuuzAEUj1jVofHTEkDMhSmMUo4_0Xxfj605-g@mail.gmail.com>
In-Reply-To: <CAKohpom-UFkvORuuzAEUj1jVofHTEkDMhSmMUo4_0Xxfj605-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091008-9264-0000-0000-0000047FB4CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:22 PM, Viresh Kumar wrote:
> Back finally and I see lots of mails over cpufreq stuff.. :)
> 
> On 3 September 2013 18:50, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> This doesn't solve the problem completely: it prevents the store_*() task
>> from continuing *only* when it concurrently executes the __cpufreq_governor()
>> function along with the CPU offline task. But if the two calls don't overlap,
>> we will still have the possibility where the store_*() task tries to acquire
>> the timer mutex after the CPU offline task has just finished destroying it.
> 
> How exactly? My brain is still on vacations :)
>

The race window is not limited to __cpufreq_governor() alone. It just starts there,
but doesn't end there; it extends beyond that point. That's the main problem. And
that's why serializing __cpufreq_governor() won't completely solve the issue.

CPU_DOWN:

__cpufreq_governor(STOP)  ----+
  ...                         |
  ...                         | RACE
  ...                         | WINDOW
  ...                         |
sysfs teardown            ----+
 
In the STOP call, we destroy the timer mutex and set cur_policy = NULL. So the
incorrect access to timer mutex can occur from that point until we finally unlink
or teardown the sysfs files and prevent userspace from writing to those files.
Thus, this window involves stuff other than the call to __cpufreq_governor() as
well. So serializing __cpufreq_governor() alone is not enough.

> Anyway, this was one of the problem that I tried to solve with my patch.
> But there can be other race conditions where things can go wrong and so
> that patch may still be useful.
>

I agree, but see below (its the "may be useful" part that I'm not convinced
about).
 
> Call to __cpufreq_governor() must be serialized I believe.
> 

Sure, its a good idea to serialize __cpufreq_governor(). However, we need
specific justification for that. Just a hunch that something will go wrong is
not enough, IMHO. We have to *prove* that something is indeed wrong, and only
then add appropriate synchronization to fix it.

Besides, even the commit message appeared a bit odd. It mentions something about
problems with recursive calls. What cases are those? When do we end up recursively
calling __cpufreq_governor()?  And hence, why can't we use plain locks and must
instead use yet another quick-and-dirty variable to protect that function?
[Using variables like that is bad from a lockdep perspective as well (apart from
other things) : lockdep can't catch any resulting locking issues.]

Other related questions that are worth answering would be: why should we add the
synchronization *inside* __cpufreq_governor()? Why not add it at its call-sites?

IOW, I'm all in for fixing problems, just that I'd be comfortable with the
changes only when we completely understand what problem we are fixing and why
that patch is the right fix for that problem.

Regards,
Srivatsa S. Bhat

