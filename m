Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaF3JY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:24:28 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:56895 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaF3JY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:24:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Message-ID: <53B12CB3.5050508@jp.fujitsu.com>
Date: Mon, 30 Jun 2014 18:24:03 +0900
From: "HATAYAMA, Daisuke" <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: hpa@zytor.com, ak@linux.intel.com
CC: Don Zickus <dzickus@redhat.com>, matt@console-pimps.org,
        peterz@infradead.org, acme@kernel.org, mingo@redhat.com,
        paulus@samba.org, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
References: <20140613084437.12424.62294.stgit@localhost6.localdomain6> <20140616153047.GJ177152@redhat.com>
In-Reply-To: <20140616153047.GJ177152@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2014/06/17 0:30), Don Zickus wrote:
> On Fri, Jun 13, 2014 at 05:44:37PM +0900, HATAYAMA Daisuke wrote:
>> Currently, a NMI handler for NMI watchdog may falsely handle any NMI
>> signaled for different purpose if CondChgd bit in
>> MSR_CORE_PERF_GLOBAL_STATUS MSR is set.
>>
>> This commit deals with the issue simply by ignoring CondChgd bit.
>>
>> Here is explanation in detail.
>>
>> On x86 NMI watchdog uses performance monitoring feature to
>> periodically signal NMI each time performance counter gets overflowed.
>>
>> intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
>> handler of NMI watchdog, perf_event_nmi_handler(). It identifies an
>> owner of a given NMI by looking at overflow status bits in
>> MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
>> handles the given NMI as its own NMI.
>>
>> The problem is that the intel_pmu_handle_irq() doesn't distinguish
>> CondChgd bit from other bits. Unlike the other status bits, CondChgd
>> bit doesn't represent overflow status for performance counters. Thus,
>> CondChgd bit cannot be thought of as a mark indicating a given NMI is
>> NMI watchdog's. As a result, if CondChgd bit is set, any NMI is
>> falsely handled by the NMI handler of NMI watchdog. Also, if type of
>> the falsely handled NMI is either NMI_UNKNOWN, NMI_SERR or
>> NMI_IO_CHECK, the corresponding action is never performed until
>> CondChgd bit is cleared.
>>
>> I noticed this behavior on systems with Ivy Bridge processors: Intel
>> Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
>> CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
>> in the beginning at boot. Then the CondChgd bit is immediately cleared
>> by next wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain
>> 0.
>>
>> On the other hand, on older processors such as Nehalem, Xeon E7540,
>> CondChgd bit is not set in the beginning at boot.
>>
>> I'm not sure about exact behavior of CondChgd bit, in particular when
>> this bit is set. Although I read Intel System Programmer's Manual to
>> figure out that, the descriptions I found are:
>>
>>    In 18.9.1:
>>
>>    "The MSR_PERF_GLOBAL_STATUS MSR also provides a ‘sticky bit’ to
>>     indicate changes to the state of performancmonitoring hardware"
>>
>>    In Table 35-2 IA-32 Architectural MSRs
>>
>>    63 CondChg: status bits of this register has changed.
>>
>> These are different from the bahviour I see on the actual system as I
>> explained above.
>>
>> At least, I think ignoring CondChgd bit should be enough for NMI
>> watchdog perspective.
>
> As I said in a previous email, I ran into a similar problem and was going
> to solve it by zeroing out all the registers on init (which probably would
> have upset Peter :-) ).  This is a smaller solution and seems ok.  The
> only downside is it is called in the nmi handler.
>
>
> I am working with our customer to try and talk with Intel why this bit is
> set to begin with.  Our customer says their BIOS doesn't use the PMU
> during boot so it wasn't clear why this is now set on IVBs (though I don't
> see them on Intel whitebox IVBs).
>

I'm also interested in the behaviour of CondChgd bit on Ivy Bridge processors.

Do you know something about this behaviour?

-- 
Thanks.
HATAYAMA, Daisuke

