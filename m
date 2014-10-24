Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaJXIW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:22:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:42376 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaJXIWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:22:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="595080788"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
In-Reply-To: <20141022144543.GV12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com> <20141022144543.GV12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 11:22:20 +0300
Message-ID: <87tx2t27yb.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
>> +static int pt_config(struct perf_event *event)
>> +{
>> +	u64 reg;
>> +
>> +	reg = RTIT_CTL_TOPA | RTIT_CTL_BRANCH_EN;
>> +
>> +	if (!event->attr.exclude_kernel)
>> +		reg |= RTIT_CTL_OS;
>> +	if (!event->attr.exclude_user)
>> +		reg |= RTIT_CTL_USR;
>> +
>> +	reg |= (event->attr.config & PT_CONFIG_MASK);
>> +
>> +	/*
>> +	 * User can try to set bits in RTIT_CTL through PT_BYPASS_MASK,
>> +	 * that aren't supported by the hardware. Weather or not a
>> +	 * particular bitmask is supported by a cpu can't be determined
>> +	 * via cpuid or otherwise, so we have to rely on #GP handling
>> +	 * to catch these cases.
>> +	 */
>> +	return wrmsrl_safe(MSR_IA32_RTIT_CTL, reg);
>> +}
>
> Whether the weather is nice or not :-)
>
> But no, this cannot be, once we've accepted the event is must be
> programmable. Failing at the time of programming is vile; pmu::start()
> is a void return, failure is not an option there.

This is called from pmu::add(), which can fail. If this wrmsrl throws a
gp, pmu::add() will fail and we won't even get to pmu::start(). Of
course, the problem with such event faulting every time it is added is
still there. Maybe we can simply disable such events after the first
fault. Good news is, only a CAP_SYS_ADMIN can set arbitrary bits, so the
damage is limited.

> The fact that the hardware cannot even tell you the supported mask is
> further fail.
>
> IIRC I think Andi once suggested probing each of the 64 bits in that MSR
> to determine the supported mask at device init time.

The problem with this is that some bits go in groups, there'd be 2..3..4
bit fields encoding desired packet frequency, for example.

Regards,
--
Alex
