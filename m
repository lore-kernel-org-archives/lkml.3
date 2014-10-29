Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbaJ2PNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:13:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:57818 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381AbaJ2PN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,810,1406617200"; 
   d="scan'208";a="622822896"
Message-ID: <5451033A.8070204@linux.intel.com>
Date: Wed, 29 Oct 2014 23:09:46 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027072816.GD10501@worktop.programming.kicks-ass.net> <544F1C50.8010505@linux.intel.com> <20141028082900.GP3337@twins.programming.kicks-ass.net> <54501CAB.8040503@linux.intel.com> <20141029082150.GU3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141029082150.GU3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/29 16:21, Peter Zijlstra wrote:
> On Wed, Oct 29, 2014 at 06:46:03AM +0800, Li, Aubrey wrote:
>> On 2014/10/28 16:29, Peter Zijlstra wrote:
>>> On Tue, Oct 28, 2014 at 12:32:16PM +0800, Li, Aubrey wrote:
>>>> On 2014/10/27 15:28, Peter Zijlstra wrote:
>>>>> On Mon, Oct 27, 2014 at 02:27:27PM +0800, Li, Aubrey wrote:
>>>>>>> Now I suppose the problem is with cpu_pause() which needs IPIs to
>>>>>>> complete? Do we really need cpuidle_pause() there?
>>>>>>> cpuidle_uninstall_handlers() seems like a daft thing to call just about
>>>>>>> there.
>>>>>>
>>>>>> Please check the log of 8651f97bd951d0bb1c10fa24e3fa3455193f3548.
>>>>>> Rafael should know more this question than me.
>>>>>
>>>>> That changelog explains its complete bollocks to do it here. We _want_
>>>>> to enter and/or remain in deep idle states.
>>>>
>>>> cpuidle_resume() will be called at the end of dpm_resume_noirq(). So we
>>>> still are able to enter deep idle states after resume.
>>>
>>> cpuidle_resume is absolute crap, as is cpuidle_suspend for that matter
>>> -- in this case.
>>>
>>> The only reason we needed cpuidle_suspend is because some BIOS shat its
>>> pants when some CPUs were in higher C states while trying to do the S3
>>> thing. We're not going to use S states or BIOS calls _at_all_, so no
>>> point in kicking CPUs out of their deep C states.
>>
>> We already kicked CPUs out of their deep C states in dpm_suspend_noirq().
>>
>> We pause cpuidle in dpm_suspend_noirq() and resume cpuidle in
>> dpm_resume_noirq(), so currently we can't enter deep c-state during S
>> states. That's an intention for some buggy BIOS.
> 
> And work arounds for buggy crap hardware should not be in generic code.
> They should be in the platform drivers associated with said crap bugs.
> 
> But I think I see what you're saying, we're going through this dpm_ crap
> even for suspend to idle, which is wrong too.
> 
>> However, for freeze state, there is another intention that we want
>> always to enter the *deepest* c-state every time we enter freeze.
>> So we need cpuidle_resume() to make sure we have deep cstate  in freeze.
>>
>> So back to your question in another email,
>>
>>> I think you can simply remove them altogether, they're nonsense.
>>
>> We need them to resume cpuidle in freeze.
> 
> So you can do cpuidle_resume() before we do the stop machine dance,

I agree, this can leave the current behavior unchanged. I'll send out a
refined version soon.

> but ideally it'd all be ripped out from generic code and stuffed into
> the platform drivers where it belongs. But at the very least it should
> be isolated to the S3 path, I bet suspend to disk doesn't care either.
> 
I think this is a good question to Rafael, which I ever asked before.

Thanks,
-Aubrey
