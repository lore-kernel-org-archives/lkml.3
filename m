Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaCNRHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:07:33 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41891 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaCNRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <53231BF4.2000308@intel.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
	<CAOh2x==at2PtHRpa=-_V6O5Z9aSog4r9BDb7ixJgBZk_+vfPtg@mail.gmail.com>
	<53231BF4.2000308@intel.com>
Date: Fri, 14 Mar 2014 22:37:27 +0530
Message-ID: <CAKohponGN4JNwLKLjvFOPkru0=6JajOKKH=oJneDkKp=PyAmRA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2014 20:40, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> Are you proposing adding cpufreq_generic_suspend() to the core I can not
> find
> it in the mainline code.

Its already there in linux-next. I am suggesting to reuse that
infrastructure with
some necessary modification to support both suspend and hotplug.

>> Over that I don't think Dirk's solution is going to work if we twist
>> the systems a bit.
>
> Could you explain what "twist the systems a bit" means?

The one I explained in the below paragraph.

>> For example, Dirk probably wanted to set P-STATE of every core to MIN
>> when it goes down. But his solution probably doesn't do that right now.
>>
>
> No, I wanted to set the core that was being off-lined to min P state.

Sorry, probably my words were a bit confusing. I meant exactly what
you just wrote. Core going down will set its freq to min.

>> As exit() is called only when the policy expires or all the CPUs of that
>> policy
>> are down. Suppose only one CPU out of 4 goes down from a policy, then
>> pstate driver would never know that happened. And that core wouldn't go
>> to min state.
>
> My patch does not change the semantics of exit() or when it is called.  For
> intel_pstate their is one cpu per policy so I moved all the cleanup to

I didn't knew that its guaranteed by pstate driver. I thought it would still be
hardware dependent as some cores might share clock line.

> exit_prepare() if there were work I needed to do at CPU_POST_DEAD I would
> have
> continued to export the *optional* exit callback.
>
> The callback name exit_prepare() was probably unfortunate and might be
> causing
> some confusion.  I will be changing the name per Rafael's feedback.

Don't know.. There is another problem here that exit_prepare() would be called
for each CPU whereas exit() would be called for each policy.

And I strongly feel that we shouldn't give another callback here but instead
just set core to a specific freq as mentioned by driver with some other field.

>> I think we have two solutions here:
>> - If its just about setting core a particular freq when it goes down, I
>> think it
>> looks a generic enough problem and so better fix core for that. Probably
>> with
>> help of flags field/suspend-freq (maybe renamed) and without calling
>> drivers
>> exit() at all..
>
>
> ATM the only thing that needs to be done in this case is to allow
> intel_pstate
> to set the P state on the core when it is going done.  My solution from the
> cores point of view is more generic, it allows any driver that needs to do
> work
> during CPU_DOWN_PREPARE to do it without adding any new logic to the core.

Yeah, do we really need to give that freedom right now? Would be better
to get this into core as that would be more generic and people looking to set
core to some freq at shutdown wouldn't be replicating that code.
