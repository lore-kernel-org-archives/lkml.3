Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaAWAMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:12:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56515 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaAWAL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:11:59 -0500
Message-ID: <52E05E49.3010903@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 16:11:53 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/8] Add support for PowerPC Hypervisor supplied performance
 counters
References: <1389916434-2288-1-git-send-email-cody@linux.vnet.ibm.com> <1390354379.11104.3.camel@concordia>
In-Reply-To: <1390354379.11104.3.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012300-6688-0000-0000-000005C5E6F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 05:32 PM, Michael Ellerman wrote:
> On Thu, 2014-01-16 at 15:53 -0800, Cody P Schafer wrote:
>> These patches add basic pmus for 2 powerpc hypervisor interfaces to obtain
>> performance counters: gpci ("get performance counter info") and 24x7.
>>
>> The counters supplied by these interfaces are continually counting and never
>> need to be (and cannot be) disabled or enabled. They additionally do not
>> generate any interrupts. This makes them in some regards similar to software
>> counters, and as a result their implimentation shares some common code (which
>> an initial patch exposes) with the sw counters.
> 
> Hi Cody,
> 
> Can you please add some more explanation of this series.
Sure
 > In particular why do we need two new PMUs, and how do they relate to each
> other?
These 2 PMUs end up providing access to some cpu, core, and chip level counters not
exposed via other interfaces, and additionally allow monitoring the performance of
other lpars (guests) on the same host system. Because it provides access to core and
chip level counters, this pair of PMUs could be thought of as powerpc's counterpart
to x86's uncore events.

As an example, "processor_bus_utilization_abc" and "processor_bus_utilization_wxyz"
(in hv_gpci.h) allow retreval of total cycles and idle cycles for various inter-chip buses.

GPCI is an interface that already exists on some power7 machines (depending on the fw
version), but is rather in-flexible and code intensive to add additional counters to.
The 24x7 interfaces currently are designed to co-exist with the gpci interface while
replacing most of gpci's functionality on newer systems. Right now, the 24x7 code I've
submitted uses the gpci calls to check if it has permission to access certain classes
of counters.

> And can you add an example of how I'd actually use them using perf.

# For gpci (formed from reading hv_gpci.h), gets "processor_time_in_timebase_cycles"
perf stat -e 'hv_gpci/counter_info_version=3,offset=0,length=8,secondary_index=0,starting_index=0xffffffff,request=0x10/' -r 0 -a -x ' ' sleep 0.1

# For 24x7, assuming access to hw+fw that supports it, gets a yet-to-be identified counter:
perf stat -e 'hv_24x7/domain=2,offset=8,starting_index=0,lpar=0xffffffff/' -r 0 -C 0 -x ' ' sleep 0.1

