Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaEPVCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaEPVCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:02:36 -0400
Message-ID: <53767CBD.5010503@redhat.com>
Date: Fri, 16 May 2014 23:01:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org
CC: dave.hansen@linux.intel.com, tglx@linutronix.de, x86@kernel.org,
        peterz@infradead.org, gleb@redhat.com, kvm@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH] x86: fix page fault tracing when KVM guest support enabled
References: <20140516194515.D859CC11@viggo.jf.intel.com> <53767AE6.5020202@zytor.com>
In-Reply-To: <53767AE6.5020202@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/05/2014 22:53, H. Peter Anvin ha scritto:
> On 05/16/2014 12:45 PM, Dave Hansen wrote:
>> From: Dave Hansen <dave.hansen@linux.intel.com>
>>
>> I noticed on some of my systems that page fault tracing doesn't
>> work:
>>
>> 	cd /sys/kernel/debug/tracing
>> 	echo 1 > events/exceptions/enable
>> 	cat trace;
>> 	# nothing shows up
>>
>> I eventually traced it down to CONFIG_KVM_GUEST.  At least in a
>> KVM VM, enabling that option breaks page fault tracing, and
>> disabling fixes it.  I tried on some old kernels and this does
>> not appear to be a regression: it never worked.
>>
>> There are two page-fault entry functions today.  One when tracing
>> is on and another when it is off.  The KVM code calls do_page_fault()
>> directly instead of calling the traced version:
>>
>>> dotraplinkage void __kprobes
>>> do_async_page_fault(struct pt_regs *regs, unsigned long
>>> error_code)
>>> {
>>>         enum ctx_state prev_state;
>>>
>>>         switch (kvm_read_and_reset_pf_reason()) {
>>>         default:
>>>                 do_page_fault(regs, error_code);
>>>                 break;
>>>         case KVM_PV_REASON_PAGE_NOT_PRESENT:
>>
>> I'm also having problems with the page fault tracing on bare
>> metal (same symptom of no trace output).  I'm unsure if it's
>> related.
>>
>> Steven had an alternative to this which has zero overhead when
>> tracing is off where this includes the standard noops even when
>> tracing is disabled.  I'm unconvinced that the extra complexity
>> of his apporach:
>>
>> 	http://lkml.kernel.org/r/20140508194508.561ed220@gandalf.local.home
>>
>> is worth it, expecially considering that the KVM code is already
>> making page fault entry slower here.  This solution is
>> dirt-simple.
>>
>> Gleb, please apply.
>>
>> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: x86@kernel.org
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: kvm@vger.kernel.org
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
>
> If Gleb and Paolo are okay with it, I am.

Yes, of course.  Dave, ok to only have it in 3.16?

Paolo

