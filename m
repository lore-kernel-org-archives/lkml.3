Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaJIKDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:03:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46284 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaJIKD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:03:27 -0400
Message-ID: <54365D64.5060702@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 15:33:16 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/3] powerpc/kvm/book3s_hv: Enable CPUs to run guest
 after waking up from fast-sleep
References: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com> <1412149560-2953-3-git-send-email-shreyas@linux.vnet.ibm.com> <1412658682.30859.137.camel@pasglop>
In-Reply-To: <1412658682.30859.137.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100910-0025-0000-0000-000000B4B655
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 10:41 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2014-10-01 at 13:15 +0530, Shreyas B. Prabhu wrote:
>>
>> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
>> index 050f79a..c64f3cc0 100644
>> --- a/arch/powerpc/kernel/exceptions-64s.S
>> +++ b/arch/powerpc/kernel/exceptions-64s.S
>> @@ -100,25 +100,8 @@ system_reset_pSeries:
>>  	SET_SCRATCH0(r13)
>>  #ifdef CONFIG_PPC_P7_NAP
>>  BEGIN_FTR_SECTION
>> -	/* Running native on arch 2.06 or later, check if we are
>> -	 * waking up from nap. We only handle no state loss and
>> -	 * supervisor state loss. We do -not- handle hypervisor
>> -	 * state loss at this time.
>> -	 */
>> -	mfspr	r13,SPRN_SRR1
>> -	rlwinm.	r13,r13,47-31,30,31
>> -	beq	9f
>>  
>> -	/* waking up from powersave (nap) state */
>> -	cmpwi	cr1,r13,2
>> -	/* Total loss of HV state is fatal, we could try to use the
>> -	 * PIR to locate a PACA, then use an emergency stack etc...
>> -	 * OPAL v3 based powernv platforms have new idle states
>> -	 * which fall in this catagory.
>> -	 */
>> -	bgt	cr1,8f
>>  	GET_PACA(r13)
>> -
>>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>>  	li	r0,KVM_HWTHREAD_IN_KERNEL
>>  	stb	r0,HSTATE_HWTHREAD_STATE(r13)
>> @@ -131,13 +114,27 @@ BEGIN_FTR_SECTION
>>  1:
>>  #endif
> 
> So you moved the state loss check to after the KVM check ? Was this
> reviewed by Paul ? Is that ok ? (Does this match what we have in
> PowerKVM ?). Is it possible that we end up calling kvm_start_guest
> after a HV state loss or do we know for sure that this won't happen
> for a reason or another ? If that's the case, then that reason needs
> to be clearly documented here in a comment.

This wont happen because the first thread in the core which comes out of
an idle state which has a state loss will not enter into KVM since the
HSTATE_HWTHREAD_STATE is not yet set. It continues on to restore the
lost state.

This thread sets the HSTATE_HWTHREAD_STATE and wakes up the remaining
threads in the core. These sibling threads enter kvm directly not
requiring to restore lost state since the first thread has restored it
anyway. So we are safe. We will certainly add a comment there.

Thanks

Regards
Preeti U Murthy

