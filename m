Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaFCFu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:50:59 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50233 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaFCFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:50:57 -0400
Message-ID: <538D61EF.4070404@linux.vnet.ibm.com>
Date: Tue, 03 Jun 2014 11:19:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: rjw@rjwysocki.net, viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com> <20140602073306.GA5220@in.ibm.com> <538C32AA.5020401@linux.vnet.ibm.com> <20140603051605.GA30422@in.ibm.com>
In-Reply-To: <20140603051605.GA30422@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060305-2674-0000-0000-0000003568D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 10:46 AM, Gautham R Shenoy wrote:
> On Mon, Jun 02, 2014 at 01:45:38PM +0530, Srivatsa S. Bhat wrote:
>> On 06/02/2014 01:03 PM, Gautham R Shenoy wrote:
>>> Hi,
>>>
>>> On Tue, May 27, 2014 at 02:23:38AM +0530, Srivatsa S. Bhat wrote:
>>>
>>> [..snip..]
>>>>
>>>> Experimental results:
>>>> ====================
>>>>
>>>> I ran a modified version of ebizzy (called 'sleeping-ebizzy') that sleeps in
>>>> between its execution such that its total utilization can be a user-defined
>>>> value, say 10% or 20% (higher the utilization specified, lesser the amount of
>>>> sleeps injected). This ebizzy was run with a single-thread, tied to CPU 8.
>>>>
>>>> Behavior observed with tracing (sample taken from 40% utilization runs):
>>>> ------------------------------------------------------------------------
>>>>
>>>> Without patch:
>>>> ~~~~~~~~~~~~~~
>>>> kworker/8:2-12137  416.335742: cpu_frequency: state=2061000 cpu_id=8
>>>> kworker/8:2-12137  416.335744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40753  416.345741: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-12137  416.345744: cpu_frequency: state=4123000 cpu_id=8
>>>> kworker/8:2-12137  416.345746: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40753  416.355738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> <snip>  ---------------------------------------------------------------------  <snip>
>>>>       <...>-40753  416.402202: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>>>>      <idle>-0      416.502130: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>>>>       <...>-40753  416.505738: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8
>>>> kworker/8:2-12137  416.505741: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40753  416.515739: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-12137  416.515742: cpu_frequency: state=4123000 cpu_id=8
>>>> kworker/8:2-12137  416.515744: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>
>>>> Observation: Ebizzy went idle at 416.402202, and started running again at
>>>> 416.502130. But cpufreq noticed the long idle period, and dropped the frequency
>>>> at 416.505739, only to increase it back again at 416.515742, realizing that the
>>>> workload is in-fact CPU bound. Thus ebizzy needlessly ran at the lowest frequency
>>>> for almost 13 milliseconds (almost 1 full sample period), and this pattern
>>>> repeats on every sleep-wakeup. This could hurt latency-sensitive workloads quite
>>>> a lot.
>>>>
>>>> With patch:
>>>> ~~~~~~~~~~~
>>>>
>>>> kworker/8:2-29802  464.832535: cpu_frequency: state=2061000 cpu_id=8
>>>> <snip>  ---------------------------------------------------------------------  <snip>
>>>> kworker/8:2-29802  464.962538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40738  464.972533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-29802  464.972536: cpu_frequency: state=4123000 cpu_id=8
>>>> kworker/8:2-29802  464.972538: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40738  464.982531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> <snip>  ---------------------------------------------------------------------  <snip>
>>>> kworker/8:2-29802  465.022533: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40738  465.032531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-29802  465.032532: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40738  465.035797: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
>>>>      <idle>-0      465.240178: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
>>>>       <...>-40738  465.242533: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>> kworker/8:2-29802  465.242535: sched_switch: prev_comm=kworker/8:2 ==> next_comm=ebizzy
>>>>       <...>-40738  465.252531: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:2
>>>>
>>>
>>> Have the log entries emmitted by kworker/8 to report about the
>>> cpu_frequency states been snipped out in the entries post the
>>> "465.032531" mark ?
>>>
>>
>> No, why? Anything looks odd at that point?
> 
> I was expecting to see log messages of the following kind after a
> kworker thread is scheduled in.
> 
>   "kworker/8:2-12137  416.505739: cpu_frequency: state=2061000 cpu_id=8"
>

But this gets printed only if the frequency is changed. If the frequency is left at the
same value as it was previously set at (that's the point of this patch), then we won't
get this print. [Note that these logs are with the patch applied.]
 
>>
>> Note that the CPU went idle from 465.035797 to 465.240178, and hence cpufreq's
>> deferrable timer didn't fire (and hence kworker didn't run). But once the CPU
>> became busy again at 465.240178, the kworker got scheduled on the CPU within
>> 2 ms (at 465.242533).
> 
> Yes, but the logs don't show the frequency that the kworker thread
> would have set on that cpu.
> 

Yes, and that's expected, because we copy the previous load to the present interval,
and hence kworker won't change the frequency (in most cases), because it finds that
the frequency is already set suitably for the perceived load in this interval.
Hence we don't see any prints in the logs indicating a change in frequency.

Regards,
Srivatsa S. Bhat

