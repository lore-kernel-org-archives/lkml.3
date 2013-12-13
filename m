Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3LMAc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:32:29 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36450 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3LMAc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:32:28 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bsd@redhat.com, laijs@cn.fujitsu.com
Subject: Re: [Query] Ticks happen in pair for NO_HZ_FULL cores ?
References: <CAKohponch=o3nBKTmakA87OiN=HbgnEwJUL23mGkjQiNoJWjWw@mail.gmail.com>
	<20131211132212.GA7862@localhost.localdomain>
	<20131211211400.GB7683@mtj.dyndns.org>
Date: Thu, 12 Dec 2013 16:32:25 -0800
In-Reply-To: <20131211211400.GB7683@mtj.dyndns.org> (Tejun Heo's message of
	"Wed, 11 Dec 2013 16:14:00 -0500")
Message-ID: <87iout615y.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hey, guys.
>
> On Wed, Dec 11, 2013 at 02:22:14PM +0100, Frederic Weisbecker wrote:
>> I fear I don't understand your question. Do you mean why don't we prevent from
>> that bdi writeback work to run when we are in full dynticks mode?
>> 
>> We can't just ignore workqueues and timers callback when they are scheduled
>> otherwise the kernel is going to behave randomly.
>> 
>> OTOH what we can do is to work on these per cpu workqueues and timers and do
>> what's necessary to avoid them to fire, as explained in detail there Documentation/kernel-per-CPU-kthreads.txt
>
> Hmmm... some per-cpu workqueues can be turned into unbound ones and
> the writeback is one of those.  

Ah, looks like the writeback one is already unbound, and configurable
from sysfs.

Viresh, add this to your test script, and it should get this workqueue
out of the way:

   # pin the writeback workqueue to CPU0
   echo 1 > /sys/bus/workqueue/devices/writeback/cpumask

Kevin

> Currently, this is used for
> powersaving on mobile but could also be useful for jitter control.  In
> the long term, it could be beneficial to strictly distinguish the
> workqueues which really need per-cpu behavior and the ones which are
> per-cpu just for optimization.
>
>> There is also the problem of unbound workqueues for which we don't
>> have a solution yet. But the idea is that we could tweak their
>> affinity from sysfs.
>
> Yes, this is a long term todo item but I'm currently a bit too swamped
> to tackle it myself.  cc'ing Lai, who has pretty good knowledge of
> workqueue internals, and Bandan, who seemed interested in working on
> implementing default attrs.
>
> Thanks.
