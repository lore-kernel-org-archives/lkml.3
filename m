Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbaJaNN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:13:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:31096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738AbaJaNNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:13:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,294,1413270000"; 
   d="scan'208";a="614738011"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141022143241.GT12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022143241.GT12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Oct 2014 15:13:35 +0200
Message-ID: <8738a4crgg.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
>> +
>> +enum cpuid_regs {
>> +	CR_EAX = 0,
>> +	CR_ECX,
>> +	CR_EDX,
>> +	CR_EBX
>> +};
>> +
>> +/*
>> + * Capabilities of Intel PT hardware, such as number of address bits or
>> + * supported output schemes, are cached and exported to userspace as "caps"
>> + * attribute group of pt pmu device
>> + * (/sys/bus/event_source/devices/intel_pt/caps/) so that userspace can store
>> + * relevant bits together with intel_pt traces.
>> + */
>> +#define PT_CAP(_n, _l, _r, _m)						\
>> +	[PT_CAP_ ## _n] = { .name = __stringify(_n), .leaf = _l,	\
>> +			    .reg = _r, .mask = _m }
>> +
>> +static struct pt_cap_desc {
>> +	const char	*name;
>> +	u32		leaf;
>> +	u8		reg;
>> +	u32		mask;
>> +} pt_caps[] = {
>> +	PT_CAP(max_subleaf,		0, CR_EAX, 0xffffffff),
>> +	PT_CAP(cr3_filtering,		0, CR_EBX, BIT(0)),
>> +	PT_CAP(topa_output,		0, CR_ECX, BIT(0)),
>> +	PT_CAP(topa_multiple_entries,	0, CR_ECX, BIT(1)),
>> +	PT_CAP(payloads_lip,		0, CR_ECX, BIT(31)),
>> +};
>> +
>> +static u32 pt_cap_get(enum pt_capabilities cap)
>> +{
>> +	struct pt_cap_desc *cd = &pt_caps[cap];
>> +	u32 c = pt_pmu.caps[cd->leaf * 4 + cd->reg];
>> +	unsigned int shift = __ffs(cd->mask);
>> +
>> +	return (c & cd->mask) >> shift;
>> +}
>
>> +	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_INTEL_PT)) {
>> +		for (i = 0; i < PT_CPUID_LEAVES; i++)
>> +			cpuid_count(20, i,
>> +				    &pt_pmu.caps[CR_EAX + i * 4],
>> +				    &pt_pmu.caps[CR_EBX + i * 4],
>> +				    &pt_pmu.caps[CR_ECX + i * 4],
>> +				    &pt_pmu.caps[CR_EDX + i * 4]);
>> +	} else
>> +		return -ENODEV;
>
> I would really rather you use bitfield unions for cpuid stuff, have a
> look at union cpuid10_e[abd]x as used in
> perf_event_intel.c:intel_pmu_init().

It looks like it would only work for the first cpuid leaf, but we'll
need more than that. And the array makes it easier to allocate
attributes for sysfs en masse.

I guess it doesn't really matter if we use unions unless these bits need
to be exported to other parts of the kernel? But *that* is hardly a good
idea. What do you think?

Regards,
--
Alex
