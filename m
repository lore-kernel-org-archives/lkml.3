Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbaD2NXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:23:43 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37743 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbaD2NXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:23:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140429130506.7052.54268.stgit@srivatsabhat.in.ibm.com>
References: <20140429130506.7052.54268.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 29 Apr 2014 18:53:40 +0530
Message-ID: <CAKohpo=UYR3sgtutEBRcvRtXjvNpph9wu2TgoM1168HXQrWjLA@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 18:36, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Some cpufreq drivers were redundantly invoking the _begin() and _end()
> APIs around frequency transitions, and this double invocation (one from
> the cpufreq core and the other from the cpufreq driver) used to result
> in a self-deadlock, leading to system hangs during boot. (The _begin()
> API makes contending callers wait until the previous invocation is
> complete. Hence, the cpufreq driver would end up waiting on itself!).
>
> Now all such drivers have been fixed, but debugging this issue was not
> very straight-forward (even lockdep didn't catch this). So let us add a
> debug infrastructure to the cpufreq core to catch such issues more easily
> in the future.
>
> We add a new field called 'transition_task' to the policy structure, to keep
> track of the task which is performing the frequency transition. Using this
> field, we make note of this task during _begin() and print a warning if we
> find a case where the same task is calling _begin() again, before completing
> the previous frequency transition using the corresponding _end().
>
> We have left out ASYNC_NOTIFICATION drivers from this debug infrastructure
> for 2 reasons:
>
> 1. At the moment, we have no way to avoid a particular scenario where this
>    debug infrastructure can emit false-positive warnings for such drivers.
>    The scenario is depicted below:
>
>
>          Task A                                         Task B
>
>     /* 1st freq transition */
>     Invoke _begin() {
>             ...
>             ...
>     }
>
>     Change the frequency
>
>     /* 2nd freq transition */
>     Invoke _begin() {
>             ... //waiting for B to
>             ... //finish _end() for
>             ... //the 1st transition
>             ...       |                         Got interrupt for successful
>             ...       |                         change of frequency (1st one).
>             ...       |
>             ...       |                         /* 1st freq transition */
>             ...       |                         Invoke _end() {
>             ...       |                                 ...
>             ...       V                         }
>             ...
>             ...
>     }
>
>    This scenario is actually deadlock-free because, once Task A changes the
>    frequency, it is Task B's responsibility to invoke the corresponding
>    _end() for the 1st frequency transition. Hence it is perfectly legal for
>    Task A to go ahead and attempt another frequency transition in the meantime.
>    (Of course it won't be able to proceed until Task B finishes the 1st _end(),
>    but this doesn't cause a deadlock or a hang).
>
>    The debug infrastructure cannot handle this scenario and will treat it as
>    a deadlock and print a warning. To avoid this, we exclude such drivers
>    from the purview of this code.
>
> 2. Luckily, we don't _need_ this infrastructure for ASYNC_NOTIFICATION drivers
>    at all! The cpufreq core does not automatically invoke the _begin() and
>    _end() APIs during frequency transitions in such drivers. Thus, the driver
>    alone is responsible for invoking _begin()/_end() and hence there shouldn't
>    be any conflicts which lead to double invocations. So, we can skip these
>    drivers, since the probability that such drivers will hit this problem is
>    extremely low, as outlined above.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
> v2: Removed the coverage of ASYNC_NOTIFICATION drivers, in order to avoid
> false-positives.
>
>  drivers/cpufreq/cpufreq.c |    7 +++++++
>  include/linux/cpufreq.h   |    1 +
>  2 files changed, 8 insertions(+)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
