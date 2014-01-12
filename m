Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaALPrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:47:06 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33466 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaALPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:47:03 -0500
Message-ID: <52D2B8F2.7000601@gmail.com>
Date: Sun, 12 Jan 2014 08:46:58 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <20131223131051.GB585@localhost.localdomain> <52B84C49.70001@gmail.com> <20131226151429.GA15303@localhost.localdomain> <52BC4A13.1090508@gmail.com> <20131226153033.GC15303@localhost.localdomain> <52C46083.9070605@gmail.com> <20140103220745.GB11061@localhost.localdomain> <52C73D90.3020904@gmail.com> <20140104150539.GA17617@localhost.localdomain> <52CDC7B5.6060704@gmail.com> <20140109151955.GA9866@localhost.localdomain>
In-Reply-To: <20140109151955.GA9866@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/14, 8:19 AM, Frederic Weisbecker wrote:
> On Wed, Jan 08, 2014 at 02:48:37PM -0700, David Ahern wrote:
>> The existing code does not work. Your unstable tsc patch did not
>> work. I have not tried Joseph's patch. Are you proposing that one or
>> do you have something else in mind?
>
> I think we should integrate Joseph's patch (or mine, or some mixup, I mean
> they do about the same IIRC) as it solves known and understood bugs in any case.
>
> Then we need to check what is the real issue in your case.
>
>>
>>> Now there is still the problem of:
>>>
>>> 1) local timestamps not moving forward (could it happen when events happen in storm,
>>> when they overflow multiple times in once for example, and clock is not granular
>>> enough?)
>>
>> Even at 650k events/sec I am not seeing this problem.
>
> Yeah it happens mostly when a single event, supposed to overflow on period of 1, trigger
> with a higher period. This is the case of sched stat runtime tracepoints for example
> because it is a weighted tracepoint (see perf_count). So it demux into gazillions of
> events all having very close timestamps. But normal tracepoints shouldn't have this problem.
>
>>
>>> Anyway this should be solved with the patch that takes the earliest last event on all
>>> CPU buffer instead of the maximum of a round as a barrier.
>>>
>>> 2) local timestamps not monotonic due to interrupting events. This could be fixed
>>> in the kernel with moving perf_clock() snapshot in perf_output_sample().
>>>
>>
>> For perf-kvm the events are all tracepoints, so there should not be
>> a problem of overlap due to interruption.
>
> Nope, I'm curious what kind of issue happens with kvm events. Could you send me a perf.data
> that has this ordering problem?

There's no data file in this case; it's perf kvm stat live. For this use 
case the flush code in session.c causes the 'timestamp below last flush 
error' really quick. That's what led me down the road of tweaking the 
flush time in builtin-kvm.c. With the existing tweaks perf-kvm-stat-live 
runs for a lot longer between timeslice failures. With my perf_clock 
based flush time I have yet to the 'Timestamp below last timeslice 
flush' error.

David


