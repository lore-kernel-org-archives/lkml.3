Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3ITD2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:28:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39691 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ITD2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130918113124.GI9326@twins.programming.kicks-ass.net>
References: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com> <20130918113124.GI9326@twins.programming.kicks-ass.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Sep 2013 22:27:50 -0500
Message-ID: <CAErSpo725S_FCpHRcM3KPnmz6+-rYQiAfnPuwiY5-gxDtWbqsw@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel/uncore: don't use smp_processor_id() in validate_group()
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 5:31 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 17, 2013 at 02:48:13PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> uncore_validate_group() can't call smp_processor_id() because it is
>> in preemptible context. Pass NUMA_NO_NODE to the allocator instead.
>>
>> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index fd8011e..11b1582 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>>       struct intel_uncore_box *fake_box;
>>       int ret = -EINVAL, n;
>>
>> -     fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
>> +     fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);
>
> Doesn't work since you're passing cpu, not node.
>
> I changed it to the below. However upon doing so I noticed you
> hard coded PCI devices live on Node0, this is not true in general
> (although likely true for tiny systems).
>
> I've absolutely no clue about the entire PCI layer, but it would be nice
> if there's a method to extract the local node of a pci device.
>
> Bjorn is there such a thing?

dev_to_node(&pdev->dev), as in pci_call_probe()?
